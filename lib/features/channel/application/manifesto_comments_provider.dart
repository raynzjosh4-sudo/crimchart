import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/core/di/injection.dart';
import 'package:crown/features/feed/domain/repositories/feed_repository.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';

/// Provider that fetches and caches comments specifically for a single Manifesto.
/// Targets the 'manifesto_comments_view' in Supabase for a clean, threaded experience.
final manifestoCommentsProvider =
    StateNotifierProvider.family<
      ManifestoCommentsNotifier,
      AsyncValue<List<PostEntity>>,
      String
    >((ref, manifestoId) {
      final repo = getIt<FeedRepository>();
      return ManifestoCommentsNotifier(repo, manifestoId);
    });

class ManifestoCommentsNotifier
    extends StateNotifier<AsyncValue<List<PostEntity>>> {
  final FeedRepository _repo;
  final String _manifestoId;

  ManifestoCommentsNotifier(this._repo, this._manifestoId)
    : super(const AsyncValue.data([]));

  int _offset = 0;
  bool _hasMore = true;
  final int _limit = 15;

  Future<void> fetchComments({bool isLoadMore = false}) async {
    if (isLoadMore && !_hasMore) return;
    if (state.isLoading) return;

    if (!isLoadMore) {
      _offset = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    final result = await _repo.getManifestoComments(
      _manifestoId,
      limit: _limit,
      offset: _offset,
    );

    // Increment for NEXT load
    if (result.isRight()) {
      _offset += _limit;
    }

    if (!mounted) return;

    result.fold(
      (failure) {
        debugPrint('🚨 [ManifestoCommentsNotifier] Fetch FAILED: $failure');
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (posts) {
        if (posts.length < _limit) {
          _hasMore = false;
        }

        if (isLoadMore) {
          final currentPosts = state.value ?? [];
          state = AsyncValue.data([...currentPosts, ...posts]);
        } else {
          state = AsyncValue.data(posts);
        }
      },
    );
  }

  Future<void> loadMore() => fetchComments(isLoadMore: true);

  /// Manually inject a newly created comment to UI (Optimistic/Realtime)
  void addComment(PostEntity comment) {
    state.whenData((current) {
      if (!current.any((p) => p.id == comment.id)) {
        state = AsyncValue.data([...current, comment]);
      }
    });
  }
}
