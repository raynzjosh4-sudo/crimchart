import 'package:crown/core/network/api_client.dart';
import 'package:crown/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:crown/features/feed/data/sources/feed_local_source.dart';
import 'package:crown/features/feed/data/sources/feed_remote_source.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:crown/features/feed/domain/repositories/feed_repository.dart';
import 'package:crown/features/feed/domain/use_cases/fetch_feed.dart';
import 'package:crown/features/feed/domain/use_cases/toggle_like.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/core/db/chart_native_db.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final chartNativeDbProvider = Provider<ChartNativeDB>((ref) => ChartNativeDB.instance);

final feedRemoteSourceProvider = Provider<FeedRemoteSource>(
  (ref) => FeedRemoteSource(ref.read(apiClientProvider)),
);

final feedLocalSourceProvider = Provider<FeedLocalSource>(
  (ref) => FeedLocalSource(ref.read(chartNativeDbProvider)),
);

final feedRepositoryProvider = Provider<FeedRepository>(
  (ref) => FeedRepositoryImpl(
    ref.read(feedRemoteSourceProvider),
    ref.read(feedLocalSourceProvider),
  ),
);

final fetchFeedUseCaseProvider = Provider<FetchFeed>(
  (ref) => FetchFeed(ref.read(feedRepositoryProvider)),
);

final toggleLikeUseCaseProvider = Provider<ToggleLike>(
  (ref) => ToggleLike(ref.read(feedRepositoryProvider)),
);

// ── Feed State ────────────────────────────────────────────────────────────────

class FeedState {
  final List<PostEntity> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedEnd;

  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedEnd = false,
  });

  FeedState copyWith({
    List<PostEntity>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedEnd,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

// ── Feed Controller ────────────────────────────────────────────────────────────

final feedControllerProvider = StateNotifierProvider<FeedController, FeedState>(
  (ref) {
    return FeedController(
      fetchFeed: ref.read(fetchFeedUseCaseProvider),
      toggleLike: ref.read(toggleLikeUseCaseProvider),
    );
  },
);

class FeedController extends StateNotifier<FeedState> {
  final FetchFeed _fetchFeed;
  final ToggleLike _toggleLike;

  FeedController({required FetchFeed fetchFeed, required ToggleLike toggleLike})
    : _fetchFeed = fetchFeed,
      _toggleLike = toggleLike,
      super(const FeedState()) {
    // Auto-load feed on controller creation
    loadFeed();
  }

  /// Initial / refresh load
  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true, errorMessage: null, currentPage: 1);

    final result = await _fetchFeed(1);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (posts) => state = state.copyWith(
        isLoading: false,
        posts: posts,
        currentPage: 1,
        hasReachedEnd: posts.isEmpty,
      ),
    );
  }

  /// Load next page (infinite scroll)
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;

    final result = await _fetchFeed(nextPage);

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.message,
      ),
      (newPosts) => state = state.copyWith(
        isLoadingMore: false,
        posts: [...state.posts, ...newPosts],
        currentPage: nextPage,
        hasReachedEnd: newPosts.isEmpty,
      ),
    );
  }

  /// Optimistically toggle like on a post
  Future<void> toggleLike(String postId) async {
    // 1. Optimistic update in UI immediately
    final idx = state.posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = state.posts[idx];
    final optimisticPost = post.copyWith(
      isLiked: !post.isLiked,
      likes: post.isLiked ? post.likes - 1 : post.likes + 1,
    );

    final updatedOptimistic = List<PostEntity>.from(state.posts)
      ..[idx] = optimisticPost;
    state = state.copyWith(posts: updatedOptimistic);

    // 2. Call API in background
    final result = await _toggleLike(postId);

    result.fold(
      (failure) {
        // Revert on error
        final reverted = List<PostEntity>.from(state.posts)..[idx] = post;
        state = state.copyWith(posts: reverted, errorMessage: failure.message);
      },
      (updatedPost) {
        // Confirm with server response
        final confirmed = List<PostEntity>.from(state.posts)
          ..[idx] = updatedPost;
        state = state.copyWith(posts: confirmed);
      },
    );
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}











