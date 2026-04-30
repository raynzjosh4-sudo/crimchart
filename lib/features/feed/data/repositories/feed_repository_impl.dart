import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../sources/feed_remote_source.dart';
import '../sources/feed_local_source.dart';
import '../../../../core/db/chart_native_db.dart';

/// Concrete implementation of [FeedRepository].
/// Orchestrates between remote API and local cache.
/// Registered with get_it via @injectable.
@Injectable(as: FeedRepository)
class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteSource _remote;
  final FeedLocalSource _local;

  const FeedRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, List<PostEntity>>> getFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final offset = (page - 1) * limit;
      // 1. Always check Local SQLite first
      final cached = await _local.getCachedFeed(offset: offset, limit: limit);

      if (cached.isNotEmpty) {
        // 🚀 KICK OFF BACKGROUND SYNC (Don't await)
        _syncRemoteFeed(page: page, limit: limit);
        return Right(cached);
      }

      // 2. Local is empty/missing, fetch from Remote synchronously
      final posts = await _remote.getFeed(page: page, limit: limit);
      await _local.cacheFeed(posts);
      return Right(posts);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Internal helper to sync remote data into local DB in background
  void _syncRemoteFeed({required int page, required int limit}) async {
    try {
      final posts = await _remote.getFeed(page: page, limit: limit);
      await _local.cacheFeed(posts);
      debugPrint(
        '♻️ [Repository] Background sync complete for feed page $page',
      );
    } catch (e) {
      debugPrint('⚠️ [Repository] Background sync failed: $e');
    }
  }

  @override
  Future<Either<Failure, PostEntity>> toggleLike(String postId) async {
    try {
      final updated = await _remote.toggleLike(postId);
      // Update local cache too if needed
      await _local.cacheFeed([updated]);
      return Right(updated);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportPost(String postId, String reason) async {
    try {
      await _remote.reportPost(postId, reason);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPost(String postId) async {
    try {
      // 1. Try local
      final db = await ChartNativeDB.instance.database;
      final rows = await db.query(
        'posts',
        where: 'id = ?',
        whereArgs: [postId],
      );
      if (rows.isNotEmpty) {
        final post = PostEntity.fromMap(rows.first);
        // Sync in bg
        _syncSinglePost(postId);
        return Right(post);
      }

      final post = await _remote.getPost(postId);
      await _local.cacheFeed([post]);
      return Right(post);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  void _syncSinglePost(String postId) async {
    try {
      final post = await _remote.getPost(postId);
      await _local.cacheFeed([post]);
    } catch (_) {}
  }

  @override
  Future<Either<Failure, PostEntity>> createPost(
    PostEntity post, {
    String folderName = 'public_posts',
    String privacy = 'public',
    String customRole = '',
    bool isPublicFeed = true,
    bool allowComments = true,
    bool shareToStatus = false,
  }) async {
    try {
      final created = await _remote.createPost(
        post,
        folderName: folderName,
        privacy: privacy,
        customRole: customRole,
        isPublicFeed: isPublicFeed,
        allowComments: allowComments,
        shareToStatus: shareToStatus,
      );
      // Local sync happens in PostingService after background process completes,
      // but we can update local here too to be safe.
      await _local.cacheFeed([created]);
      return Right(created);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
    String userId, {
    bool? isVideo,
    bool? isAudio,
    String? folderName,
    int page = 1,
    int limit = 12,
  }) async {
    try {
      final offset = (page - 1) * limit;
      // 1. Serve from Local
      final cached = await _local.getCachedFeed(
        authorId: userId,
        offset: offset,
        limit: limit,
      );

      if (cached.isNotEmpty) {
        _syncRemoteUserPosts(userId, isVideo, isAudio, folderName, page, limit);
        return Right(cached);
      }

      // 2. Fetch Remote if Local empty
      final remotePosts = await _remote.getUserPosts(
        userId,
        isVideo: isVideo,
        isAudio: isAudio,
        folderName: folderName,
        page: page,
        limit: limit,
      );
      await _local.cacheFeed(remotePosts);
      return Right(remotePosts);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  void _syncRemoteUserPosts(
    String userId,
    bool? isVideo,
    bool? isAudio,
    String? folderName,
    int page,
    int limit,
  ) async {
    try {
      final remotePosts = await _remote.getUserPosts(
        userId,
        isVideo: isVideo,
        isAudio: isAudio,
        folderName: folderName,
        page: page,
        limit: limit,
      );
      await _local.cacheFeed(remotePosts);
    } catch (_) {}
  }

  @override
  Future<Either<Failure, List<String>>> getUserPostFolders(
    String userId, {
    bool? isVideo,
    bool? isAudio,
  }) async {
    try {
      final folders = await _remote.getUserPostFolders(
        userId,
        isVideo: isVideo,
        isAudio: isAudio,
      );
      return Right(folders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getChannelPosts(
    String channelId, {
    int page = 1,
    int limit = 15,
  }) async {
    try {
      final offset = (page - 1) * limit;
      final cached = await _local.getCachedFeed(
        channelId: channelId,
        offset: offset,
        limit: limit,
      );

      if (cached.isNotEmpty) {
        _syncRemoteChannelPosts(channelId, page, limit);
        return Right(cached);
      }

      final posts = await _remote.getChannelPosts(
        channelId,
        page: page,
        limit: limit,
      );
      await _local.cacheFeed(posts);
      return Right(posts);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  void _syncRemoteChannelPosts(String channelId, int page, int limit) async {
    try {
      final posts = await _remote.getChannelPosts(
        channelId,
        page: page,
        limit: limit,
      );
      await _local.cacheFeed(posts);
    } catch (_) {}
  }

  @override
  Stream<PostEntity> watchChannelPosts(String channelId) {
    return _remote.watchChannelPosts(channelId);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getManifestoComments(String manifestoId) async {
    try {
      // 1. Fetch from remote (threaded comments are generally dynamic)
      final posts = await _remote.getManifestoComments(manifestoId);
      
      // 2. Cache them locally for offline view
      await _local.cacheFeed(posts);
      
      return Right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
