import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';

/// Contract for the Feed data layer.
/// The domain layer depends on this abstract — never on the impl.
abstract class FeedRepository {
  /// Fetch paginated feed posts.
  Future<Either<Failure, List<PostEntity>>> getFeed({
    int page = 1,
    int limit = 10,
  });

  /// Like or unlike a post. Returns updated post.
  Future<Either<Failure, PostEntity>> toggleLike(String postId);

  /// Report a post.
  Future<Either<Failure, void>> reportPost(String postId, String reason);

  /// Fetch a single post by ID.
  Future<Either<Failure, PostEntity>> getPost(String postId);

  /// Create a new post.
  Future<Either<Failure, PostEntity>> createPost(
    PostEntity post, {
    String folderName = 'public_posts',
    String privacy = 'public',
    String customRole = '',
    bool isPublicFeed = true,
    bool allowComments = true,
    bool shareToStatus = false,
  });

  /// Fetch posts customized by user logic (e.g. for profile tabs).
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
    String userId, {
    bool? isVideo,
    bool? isAudio,
    String? folderName,
    int page = 1,
    int limit = 12,
  });

  Future<Either<Failure, List<String>>> getUserPostFolders(
    String userId, {
    bool? isVideo,
    bool? isAudio,
  });

  /// Fetch paginated posts for a specific channel.
  Future<Either<Failure, List<PostEntity>>> getChannelPosts(
    String channelId, {
    int page = 1,
    int limit = 15,
  });

  /// 🛰️ DELTA INJECTION: Emits ONE new PostEntity per INSERT event.
  /// The notifier surgically prepends it — no full-list re-fetch needed.
  Stream<PostEntity> watchChannelPosts(String channelId);

  /// 👑 THREADED DISCUSSION: Fetch comments for a specific manifesto
  Future<Either<Failure, List<PostEntity>>> getManifestoComments(String manifestoId);
}
