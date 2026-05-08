import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tag_entity.dart';

abstract class TagRepository {
  /// Create a new tag for a post to a target channel.
  Future<Either<Failure, TagEntity>> createTag({
    required String postId,
    required String sourceChannelId,
    required String targetChannelId,
    required List<String> linkChain,
  });

  /// Remove an existing tag.
  Future<Either<Failure, void>> removeTag(String tagId);

  /// Check if a post has already been tagged by the user to a specific channel.
  Future<bool> isPostTagged({
    required String postId,
    required String targetChannelId,
  });
}
