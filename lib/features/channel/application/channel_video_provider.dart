import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../feed/domain/entities/post_entity.dart';
import '../../feed/domain/repositories/feed_repository.dart';
import '../../feed/application/feed_controller.dart';

class ChannelVideoState {
  final List<PostEntity> videos;
  final bool isLoading;
  final bool hasMore;
  final int offset;
  final String? errorMessage;

  ChannelVideoState({
    this.videos = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
    this.errorMessage,
  });

  ChannelVideoState copyWith({
    List<PostEntity>? videos,
    bool? isLoading,
    bool? hasMore,
    int? offset,
    String? errorMessage,
  }) {
    return ChannelVideoState(
      videos: videos ?? this.videos,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChannelVideoNotifier extends StateNotifier<ChannelVideoState> {
  final FeedRepository _repository;
  final String channelId;
  static const int _limit = 10;

  ChannelVideoNotifier(this._repository, this.channelId) : super(ChannelVideoState()) {
    loadVideos();
  }

  Future<void> loadVideos({bool refresh = false}) async {
    if (state.isLoading || (!state.hasMore && !refresh)) return;

    if (refresh) {
      state = state.copyWith(isLoading: true, videos: [], offset: 0, hasMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await _repository.getChannelVideos(
      channelId,
      limit: _limit,
      offset: state.offset,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        hasMore: false,
        errorMessage: failure.message,
      ),
      (newVideos) {
        state = state.copyWith(
          videos: [...state.videos, ...newVideos],
          isLoading: false,
          hasMore: newVideos.length >= _limit,
          offset: state.offset + newVideos.length,
          errorMessage: null,
        );
      },
    );
  }
}

final channelVideoProvider = StateNotifierProvider.autoDispose
    .family<ChannelVideoNotifier, ChannelVideoState, String>((ref, channelId) {
  final repo = ref.watch(feedRepositoryProvider);
  return ChannelVideoNotifier(repo, channelId);
});
