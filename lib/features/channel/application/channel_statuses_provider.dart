import 'dart:convert';
import 'package:crown/features/channel/domain/entities/channel_status_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/db/chart_native_db.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

/// Provides a live list of [ChannelStatusEntity] for a given channel.
/// • Loads instantly from local Drift cache.
/// • Fetches fresh data from Supabase in the background.
/// • Automatically filters out expired statuses (> 24 hours old).
final channelStatusesProvider = StateNotifierProvider.autoDispose
    .family<
      ChannelStatusesNotifier,
      AsyncValue<List<ChannelStatusEntity>>,
      String
    >((ref, channelId) => ChannelStatusesNotifier(channelId));

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class ChannelStatusesNotifier
    extends StateNotifier<AsyncValue<List<ChannelStatusEntity>>> {
  final String channelId;

  ChannelStatusesNotifier(this.channelId) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    // 1. ⚡ INSTANT: Load from local Drift cache first
    await _loadFromLocal();

    // 2. 🌐 BACKGROUND: Sync fresh data from Supabase
    await _syncFromSupabase();
  }

  // ─── Local ────────────────────────────────────────────────────────────────

  Future<void> _loadFromLocal() async {
    try {
      final rows = await ChartNativeDB.instance.getChannelStatuses(channelId);
      final entities = rows
          .map(ChannelStatusEntity.fromMap)
          .where((s) => !s.isExpired)
          .toList();
      debugPrint(
        '⚡ [ChannelStatuses] Loaded ${entities.length} statuses from local DB for $channelId',
      );
      state = AsyncValue.data(entities);
    } catch (e, st) {
      debugPrint('⚠️ [ChannelStatuses] Local load failed: $e');
      state = AsyncValue.error(e, st);
    }
  }

  // ─── Remote ───────────────────────────────────────────────────────────────

  Future<void> _syncFromSupabase() async {
    try {
      final supabase = Supabase.instance.client;
      final now = DateTime.now().toIso8601String();

      // Fetch statuses joined with author profile
      final response = await supabase
          .from('channel_statuses')
          .select('*, author:profiles(username, profile_image_url)')
          .eq('channel_id', channelId)
          .gt('expires_at', now)
          .order('created_at', ascending: false)
          .limit(10);

      final List<ChannelStatusEntity> remoteStatuses = [];

      // 🧹 Wipe the old local statuses before saving the fresh top 5
      await ChartNativeDB.instance.deleteChannelStatuses(channelId);

      for (final raw in (response as List)) {
        final map = Map<String, dynamic>.from(raw as Map);

        // Flatten the joined author profile
        if (map['author'] != null && map['author'] is Map) {
          final author = map['author'] as Map;
          map['username'] = author['username'];
          map['profile_image_url'] = author['profile_image_url'];
        }

        final entity = ChannelStatusEntity.fromMap(map);
        remoteStatuses.add(entity);

        // Cache each status locally so it's available offline
        await _cacheLocally(map);
      }

      debugPrint(
        '🌐 [ChannelStatuses] Synced ${remoteStatuses.length} statuses from Supabase for $channelId',
      );
      state = AsyncValue.data(remoteStatuses);

      // 👑 ROLLING CACHE: Trim local DB to keep only the newest 10
      await ChartNativeDB.instance.trimChannelStatuses(channelId: channelId, keepCount: 10);
    } catch (e) {
      debugPrint('⚠️ [ChannelStatuses] Supabase sync failed: $e');
      // Don't override local data if network fails — keep existing state
    }
  }

  Future<void> _cacheLocally(Map<String, dynamic> map) async {
    try {
      // Convert Supabase snake_case to the camelCase keys upsertChannelStatus expects
      await ChartNativeDB.instance.upsertChannelStatus({
        'id': map['id'],
        'channelId': map['channel_id'],
        'authorId': map['author_id'],
        'caption': map['caption'],
        'imageUrls': map['image_urls'] is List
            ? jsonEncode(map['image_urls'])
            : (map['image_urls'] as String?),
        'videoUrl': map['video_url'],
        'audioUrl': map['audio_url'],
        'isVideo': map['is_video'] == true ? 1 : 0,
        'isAudio': map['is_audio'] == true ? 1 : 0,
        'commentsCount': map['comments_count'] ?? 0,
        'createdAt': map['created_at'],
        'expiresAt': map['expires_at'],
        'username': map['username'],
        'profileImageUrl': map['profile_image_url'],
      });
    } catch (e) {
      debugPrint(
        '⚠️ [ChannelStatuses] Cache write failed for ${map['id']}: $e',
      );
    }
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Called after successfully posting a new status to inject it instantly.
  void injectNewStatus(ChannelStatusEntity newStatus) {
    final current = state.valueOrNull ?? [];
    // Avoid duplicates
    if (current.any((s) => s.id == newStatus.id)) return;
    state = AsyncValue.data([newStatus, ...current]);
  }

  /// Force a full re-sync from Supabase (e.g. pull-to-refresh).
  Future<void> refresh() => _syncFromSupabase();
}
