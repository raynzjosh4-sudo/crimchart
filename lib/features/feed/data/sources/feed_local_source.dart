import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../core/db/chart_native_db.dart';
import '../../../../core/errors/exceptions.dart';

/// Handles local persistence of feed data for offline support using SQLite.
@injectable
class FeedLocalSource {
  final ChartNativeDB _db;

  const FeedLocalSource(this._db);

  /// Caches a list of posts into the SQLite 'posts' table.
  Future<void> cacheFeed(List<PostEntity> posts) async {
    try {
      final List<Map<String, dynamic>> maps = posts.map((post) {
        // We use the same map structure as ChartNativeDB expects
        return {
          'id': post.id,
          'author_id': post.authorId,
          'username': post.authorUsername,
          'userProfileImageUrl': post.authorAvatarUrl ?? '',
          'channelName': post.channelName,
          'channelId': post.channelId,
          'caption': post.caption,
          'videoUrl': post.videoUrl ?? '',
          'sdVideoUrl': post.sdVideoUrl ?? '',
          'audioUrl': post.audioUrl ?? '',
          'imageUrls': jsonEncode(post.imageUrls),
          'thumbnailUrls': jsonEncode(post.thumbnailUrls),
          'isVideo': post.isVideo ? 1 : 0,
          'isAudio': post.isAudio ? 1 : 0,
          'folder_name': post.folderName ?? 'public_posts',
          'aspectRatio': post.aspectRatio ?? 1.0,
          'likes': post.likes,
          'comments': post.comments,
          'shares': post.shares,
          'isLiked': post.isLiked ? 1 : 0,
          'timeAgo': post.timeAgo,
          'createdAt': post.createdAt.toIso8601String(),
          'isPending': 0, // remote fetched posts are not pending
        };
      }).toList();

      await _db.cachePosts(maps);
    } catch (e) {
      throw const CacheException('Failed to cache feed in SQLite');
    }
  }

  /// Retrieves cached posts from SQLite.
  /// Supports optional filtering by channel or author.
  Future<List<PostEntity>> getCachedFeed({String? channelId, String? authorId, int offset = 0, int limit = 10}) async {
    try {
      final db = await _db.database;
      
      String whereClause = '1=1';
      List<dynamic> whereArgs = [];

      if (channelId != null && channelId != 'global') {
        whereClause += ' AND channelId = ?';
        whereArgs.add(channelId);
      }
      if (authorId != null) {
        whereClause += ' AND author_id = ?';
        whereArgs.add(authorId);
      }

      final rows = await db.query(
        'posts',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'createdAt DESC',
        limit: limit,
        offset: offset,
      );

      return rows.map((row) => PostEntity.fromMap(row)).toList();
    } catch (e) {
      throw const CacheException('Failed to read cached feed from SQLite');
    }
  }

  Future<void> clearFeedCache() async {
    final db = await _db.database;
    await db.delete('posts', where: 'isPending = 0');
  }
}





























