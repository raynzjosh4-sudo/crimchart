import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

/// Toggles the like state on a post. Handles optimistic update logic.
class ToggleLike {
  final FeedRepository _repository;
  const ToggleLike(this._repository);

  Future<Either<Failure, PostEntity>> call(String postId) {
    return _repository.toggleLike(postId);
  }
}





























