import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection.dart';
import '../domain/entities/channel_entity.dart';
import '../domain/repositories/channel_repository.dart';

// --- State ---
enum ChannelsListStatus { idle, loading, loaded, error }

class ChannelsListState {
  final ChannelsListStatus status;
  final List<ChannelEntity> channels;
  final String? error;
  final int currentPage;
  final bool hasReachedMax;

  const ChannelsListState({
    required this.status,
    this.channels = const [],
    this.error,
    this.currentPage = 0,
    this.hasReachedMax = false,
  });

  ChannelsListState copyWith({
    ChannelsListStatus? status,
    List<ChannelEntity>? channels,
    String? error,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return ChannelsListState(
      status: status ?? this.status,
      channels: channels ?? this.channels,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

// --- Provider ---
final channelsListControllerProvider =
    StateNotifierProvider.family<
      ChannelsListController,
      ChannelsListState,
      String
    >((ref, filter) {
      final repo = getIt<ChannelRepository>();
      return ChannelsListController(repo, filter);
    });

// --- Controller ---
class ChannelsListController extends StateNotifier<ChannelsListState> {
  final ChannelRepository _repository;
  final String filter;
  StreamSubscription<List<ChannelEntity>>? _subscription;

  ChannelsListController(this._repository, this.filter)
    : super(const ChannelsListState(status: ChannelsListStatus.idle)) {
    _init();
  }

  Future<void> _init() async {
    if (state.channels.isEmpty) {
      state = state.copyWith(status: ChannelsListStatus.loading);
    }

    // 1. ⚡ Fetch Instant SQLite Data
    final cachedChannels = await _repository.getOfflineFirstChannels(filter);

    if (cachedChannels.isNotEmpty) {
      state = state.copyWith(
        status: ChannelsListStatus.loaded,
        channels: cachedChannels,
      );
    }

    // 2. ☁️ Load First Page from Cloud
    await loadChannels(refresh: true);

    // 3. 🛰️ Optional: Real-time stream (usually only for first page or status updates)
    _subscription = _repository.watchChannels(filter).listen((freshChannels) {
      // Only merge if we're on the first page to avoid confusion
      if (state.currentPage == 0) {
        // 👑 Preserve creator details from existing channels because Supabase .stream() does not perform foreign-key joins.
        final mergedChannels = freshChannels.map((fresh) {
          final existing = state.channels
              .where((c) => c.id == fresh.id)
              .firstOrNull;
          if (existing != null) {
            return ChannelEntity(
              id: fresh.id,
              name: fresh.name,
              description: fresh.description,
              avatarUrl: fresh.avatarUrl,
              creatorId: fresh.creatorId,
              createdAt: fresh.createdAt,
              creatorAvatarUrl:
                  fresh.creatorAvatarUrl ?? existing.creatorAvatarUrl,
              memberCount: fresh.memberCount,
              unreadCount: fresh.unreadCount,
              isCharted: fresh.isCharted,
              isPrivate: fresh.isPrivate,
              leaderAvatarUrl: fresh.leaderAvatarUrl,
              age_restriction: fresh.age_restriction,
              visible_to_other_channel_members:
                  fresh.visible_to_other_channel_members,
              visible_to_followed_users: fresh.visible_to_followed_users,
              join_method: fresh.join_method,
              prevent_leaving: fresh.prevent_leaving,
              country_restrictions: fresh.country_restrictions,
              allow_commenting_by: fresh.allow_commenting_by,
              allow_status_posting_by: fresh.allow_status_posting_by,
              allow_invitations_by: fresh.allow_invitations_by,
              followersCount: fresh.followersCount,
              tagsCount: fresh.tagsCount,
              likesCount: fresh.likesCount,
              postsCount: fresh.postsCount,
              is_discoverable: fresh.is_discoverable,
              creatorName: fresh.creatorName ?? existing.creatorName,
            );
          }
          return fresh;
        }).toList();

        state = state.copyWith(
          status: ChannelsListStatus.loaded,
          channels: mergedChannels,
        );
      }
    });
  }

  Future<void> loadChannels({bool refresh = false}) async {
    if (!refresh &&
        (state.status == ChannelsListStatus.loading || state.hasReachedMax))
      return;

    final targetPage = refresh ? 0 : state.currentPage + 1;

    if (!refresh) {
      state = state.copyWith(status: ChannelsListStatus.loading);
    }

    final result = await _repository.getChannels(filter, page: targetPage);

    result.fold(
      (failure) {
        if (state.channels.isEmpty) {
          state = state.copyWith(
            status: ChannelsListStatus.error,
            error: failure.message,
          );
        }
      },
      (freshChannels) {
        final newChannels = refresh
            ? freshChannels
            : [...state.channels, ...freshChannels];
        state = state.copyWith(
          status: ChannelsListStatus.loaded,
          channels: newChannels,
          currentPage: targetPage,
          hasReachedMax: freshChannels.length < 10,
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
