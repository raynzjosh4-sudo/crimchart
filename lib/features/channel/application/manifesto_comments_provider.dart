import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/core/di/injection.dart';
import 'package:crown/features/feed/domain/repositories/feed_repository.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';

/// Provider that fetches and caches comments specifically for a single Manifesto.
/// Targets the 'manifesto_comments_view' in Supabase for a clean, threaded experience.
final manifestoCommentsProvider = StateNotifierProvider.family<ManifestoCommentsNotifier, AsyncValue<List<PostEntity>>, String>((ref, manifestoId) {
  final repo = getIt<FeedRepository>();
  return ManifestoCommentsNotifier(repo, manifestoId);
});

class ManifestoCommentsNotifier extends StateNotifier<AsyncValue<List<PostEntity>>> {
  final FeedRepository _repo;
  final String _manifestoId;

  ManifestoCommentsNotifier(this._repo, this._manifestoId) : super(const AsyncValue.loading()) {
    fetchComments();
  }

  Future<void> fetchComments() async {
    state = const AsyncValue.loading();
    final result = await _repo.getManifestoComments(_manifestoId);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (posts) => state = AsyncValue.data(posts),
    );
  }

  /// Manually inject a newly created comment to UI (Optimistic/Realtime)
  void addComment(PostEntity comment) {
    state.whenData((current) {
      if (!current.any((p) => p.id == comment.id)) {
        state = AsyncValue.data([...current, comment]);
      }
    });
  }
}
