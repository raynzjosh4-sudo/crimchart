import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/channel_moment_entity.dart';
import '../domain/repositories/moment_repository.dart';
import '../../../../core/db/chart_native_db.dart';
import '../../../../core/di/injection.dart';
import '../application/channels_list_controller.dart';

final channelMomentsProvider = StateNotifierProvider.autoDispose
    .family<
      ChannelMomentsNotifier,
      AsyncValue<List<ChannelMomentEntity>>,
      String
    >((ref, channelId) => ChannelMomentsNotifier(channelId));

/// 👑 NEW: Watch all moments for all joined channels
final joinedMomentsProvider = StreamProvider.autoDispose<List<ChannelMomentEntity>>((ref) {
  // We watch joined channels to ensure they are being synced, 
  final channelsState = ref.watch(channelsListControllerProvider('joined'));
  final channelIds = channelsState.channels.map((c) => c.id).toList();

  if (channelIds.isNotEmpty) {
    // ☁️ BACKGROUND SYNC: Kick off a batch fetch for these channels
    getIt<MomentRepository>().syncJoinedMoments(channelIds);
  }
  
  return ChartNativeDB.instance.watchAllMoments().map((rows) {
    final now = DateTime.now();
    return rows
        .map(ChannelMomentEntity.fromMap)
        .where((m) => m.expiresAt == null || m.expiresAt!.isAfter(now))
        .toList();
  });
});

class ChannelMomentsNotifier
    extends StateNotifier<AsyncValue<List<ChannelMomentEntity>>> {
  final String channelId;
  final _repository = getIt<MomentRepository>();
  
  StreamSubscription? _localSub;
  RealtimeChannel? _realtimeChannel;
  int _currentLimit = 10;
  bool _isLoadingMore = false;

  ChannelMomentsNotifier(this.channelId) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    print('👑 [ChannelMomentsNotifier] Initializing for channel: $channelId');
    _repository.cleanupExpiredMoments(channelId); // Lazy cleanup
    _subscribeToLocal();
    _repository.syncMoments(channelId: channelId); // Initial sync
    _subscribeToRealtime();
  }

  void _subscribeToLocal() {
    _localSub?.cancel();
    _localSub = ChartNativeDB.instance
        .watchChannelMoments(channelId, limit: _currentLimit)
        .listen(
          (rows) {
            final now = DateTime.now();
            final entities = rows
                .map(ChannelMomentEntity.fromMap)
                .where((m) => m.expiresAt == null || m.expiresAt!.isAfter(now))
                .toList();

            print(
              '👑 [ChannelMomentsNotifier] Local DB emitted ${entities.length} active items',
            );
            state = AsyncValue.data(entities);
          },
          onError: (e, stack) {
            print('👑 [ChannelMomentsNotifier] Local DB error: $e');
            state = AsyncValue.error(e, stack);
          },
        );
  }



  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    final currentItems = state.valueOrNull ?? [];

    // 1. Increase local limit and re-subscribe
    _currentLimit += 10;
    _subscribeToLocal();

    // 2. Fetch next batch from Supabase via Repository
    await _repository.syncMoments(channelId: channelId, offset: currentItems.length);

    _isLoadingMore = false;
  }



  Future<void> shareMediaAsMoment({
    required String mediaUrl,
    required String mediaType,
    String? caption,
  }) async {
    await _repository.shareMoment(
      channelId: channelId,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      caption: caption,
    );
  }

  void _subscribeToRealtime() {
    final supabase = Supabase.instance.client;

    _realtimeChannel = supabase
        .channel('public:channel_moments:channel_id=eq.$channelId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'channel_moments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'channel_id',
            value: channelId,
          ),
          callback: (payload) async {
            if (payload.newRecord.isNotEmpty) {
              final Map<String, dynamic> record = Map.from(payload.newRecord);

              // ── Fetch Author Info for Realtime ──
              try {
                final authorId = record['author_id'] as String?;
                if (authorId != null) {
                  final profile = await supabase
                      .from('profiles')
                      .select('display_name, profile_image_url')
                      .eq('id', authorId)
                      .single();
                  record['author_name'] = profile['display_name'];
                  record['author_avatar_url'] = profile['profile_image_url'];
                }
              } catch (e) {
                print('⚠️ [ChannelMomentsNotifier] Realtime profile fetch failed: $e');
              }

              await ChartNativeDB.instance.upsertChannelMoment(record);
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _localSub?.cancel();
    if (_realtimeChannel != null) {
      Supabase.instance.client.removeChannel(_realtimeChannel!);
    }
    super.dispose();
  }
}
