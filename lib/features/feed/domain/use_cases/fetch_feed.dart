import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

/// Fetches a paginated list of feed posts.
/// This is the only entry point for the feed data from the application layer.
class FetchFeed {
  final FeedRepository _repository;
  const FetchFeed(this._repository);

  Future<Either<Failure, List<PostEntity>>> call(int page) {
    return _repository.getFeed(page: page);
  }
}





























