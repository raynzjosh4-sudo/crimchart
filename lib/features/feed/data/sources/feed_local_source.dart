import 'dart:convert';
import 'package:flutter/material.dart';
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
        return {
          'id': post.id,
          'authorId': post.authorId,
          'username': post.authorUsername,
          'userProfileImageUrl': post.authorAvatarUrl ?? '',
          'channelName': post.channelName,
          'channelId': post.channelId,
          'caption': post.caption,
          'videoUrl': post.videoUrl ?? '',
          'videoUrls': jsonEncode(post.videoUrls),
          'sdVideoUrl': post.sdVideoUrl ?? '',
          'audioUrl': post.audioUrl ?? '',
          'imageUrls': post.imageUrls, // ChartNativeDB will encode this
          'thumbnailUrls': post.thumbnailUrls, // ChartNativeDB will encode this
          'isVideo': post.isVideo ? 1 : 0,
          'isAudio': post.isAudio ? 1 : 0,
          'folderName': post.folderName ?? 'public_posts',
          'aspectRatio': post.aspectRatio ?? 1.0,
          'likes': post.likes,
          'comments': post.comments,
          'shares': post.shares,
          'isLiked': post.isLiked ? 1 : 0,
          'timeAgo': post.timeAgo,
          'createdAt': post.createdAt.toIso8601String(),
          'isPending': 0,
          'postType': post.postType,
          'linkChain': jsonEncode(post.linkChain),
          'linkDepth': post.linkDepth,
          'isPublic': post.isPublic ? 1 : 0,
          'allowComments': post.allowComments ? 1 : 0,
        };
      }).toList();

      await _db.cachePosts(maps);
    } catch (e) {
      throw const CacheException('Failed to cache feed in SQLite');
    }
  }

  /// Caches a list of posts into the modular 'channel_posts' table.
  Future<void> cacheChannelPosts(List<PostEntity> posts) async {
    debugPrint('💾 [SQLite Save] Attempting to cache ${posts.length} channel posts...');
    try {
      final List<Map<String, dynamic>> maps = [];
      for (final post in posts) {
        try {
          maps.add({
            'id': post.id,
            'authorId': post.authorId,
            'username': post.authorUsername,
            'profileImageUrl': post.authorAvatarUrl ?? '',
            'channelId': post.channelId,
            'caption': post.caption,
            'videoUrl': post.videoUrl ?? '',
            'videoUrls': jsonEncode(post.videoUrls),
            'sdVideoUrl': post.sdVideoUrl ?? '',
            'audioUrl': post.audioUrl ?? '',
            'imageUrls': post.imageUrls,
            'thumbnailUrls': post.thumbnailUrls,
            'isVideo': post.isVideo ? 1 : 0,
            'isSponsored': 0,
            'likes': post.likes,
            'comments': post.comments,
            'shares': post.shares,
            'isPublic': post.isPublic ? 1 : 0,
            'allowComments': post.allowComments ? 1 : 0,
            'createdAt': post.createdAt.toIso8601String(),
            'isPending': 0,
            'postType': post.postType,
            'metadata': jsonEncode(post.metadata),
            'isLiked': post.isLiked ? 1 : 0,
          });
        } catch (e) {
          debugPrint('🚨 [SQLite Save Error] Mapping failed for post ${post.id}: $e');
          rethrow;
        }
      }

      await _db.cacheChannelPosts(maps);
      debugPrint('💾 [SQLite Save] Successfully cached ${maps.length} rows.');
    } catch (e) {
      debugPrint('🚨 [SQLite Save Error] Batch insert FAILED: $e');
      throw CacheException('Failed to cache channel posts in SQLite: $e');
    }
  }

  /// Retrieves cached posts from SQLite.
  /// Supports optional filtering by channel or author.
  Future<List<PostEntity>> getCachedFeed({
    String? channelId,
    String? authorId,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      if (channelId != null && channelId != 'global') {
        final rows = await _db.getChannelPosts(
          channelId,
          offset: offset,
          limit: limit,
        );
        debugPrint(
          '⚡ [SQLite Load] Found ${rows.length} rows for channel $channelId',
        );

        final List<PostEntity> entities = [];
        for (final row in rows) {
          try {
            entities.add(PostEntity.fromMap(row));
          } catch (e) {
            debugPrint('🚨 [SQLite Mapper Error] Failed on ID: ${row['id']}');
            debugPrint('🚨 Error: $e');
            debugPrint('🚨 Row Data: $row');
            rethrow;
          }
        }
        return entities;
      }

      final rows = await _db.getPosts(
        channelId: channelId,
        authorId: authorId,
        offset: offset,
        limit: limit,
      );
      debugPrint(
        '⚡ [SQLite Load] Found ${rows.length} rows from general posts',
      );

      return rows.map((row) {
        try {
          return PostEntity.fromMap(row);
        } catch (e) {
          debugPrint('🚨 [SQLite Mapper Error] General Feed Failed: $e');
          debugPrint('🚨 Row: $row');
          rethrow;
        }
      }).toList();
    } catch (e) {
      debugPrint('🚨 [LocalSource] getCachedFeed FAILED: $e');
      throw CacheException('Failed to read cached feed from SQLite: $e');
    }
  }

  Future<void> clearFeedCache() async {
    await _db.clearSyncedPosts();
  }
}
