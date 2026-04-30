import 'dart:async';
import 'package:flutter/material.dart';
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

  const ChannelsListState({
    required this.status,
    this.channels = const [],
    this.error,
  });

  ChannelsListState copyWith({
    ChannelsListStatus? status,
    List<ChannelEntity>? channels,
    String? error,
  }) {
    return ChannelsListState(
      status: status ?? this.status,
      channels: channels ?? this.channels,
      error: error ?? this.error,
    );
  }
}

// --- Provider (Family-indexed to support parallel paging of different filters) ---
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

    // 1. ⚡ Fetch Instant SQLite Data via strict repository
    final cachedChannels = await _repository.getOfflineFirstChannels(filter);
    
    if (cachedChannels.isNotEmpty) {
      debugPrint(
        '⚡ [Offline-First] Loaded ${cachedChannels.length} channels instantly from SQLite via Repository!',
      );
      state = state.copyWith(
        status: ChannelsListStatus.loaded,
        channels: cachedChannels,
      );
    }

    // 2. ☁️ BACKGROUND SYNC: Hook up the live Supabase stream silently
    _subscription = _repository
        .watchChannels(filter)
        .listen(
          (freshChannels) {
            // When Supabase finally connects and sends fresh data, update the UI!
            state = state.copyWith(
              status: ChannelsListStatus.loaded,
              channels: freshChannels,
            );
          },
          onError: (error) {
            debugPrint('📡 [Channels Stream] Error: $error');
            // Only show error if we have no data to show (e.g. first install + network fail)
            if (state.channels.isEmpty) {
              state = state.copyWith(
                status: ChannelsListStatus.error,
                error: error.toString(),
              );
            }
          },
        );
  }

  /// Manual pull-to-refresh — triggers a one-shot fetch on top of the live stream
  Future<void> loadChannels() async {
    final result = await _repository.getChannels(filter);
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
        state = state.copyWith(
          status: ChannelsListStatus.loaded,
          channels: freshChannels,
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel(); // 🛑 Clean up the real-time stream on dispose
    super.dispose();
  }
}
