import 'chart_native_db.dart';

import '../../features/feed/domain/entities/post_entity.dart';
import '../../features/channel/domain/entities/channel_item.dart';

/// The elite level repository for managing Chart data persistence.
/// It uses the Native C++ DB engine to ensure data is always available instantly.
class FeedRepository {
  static final FeedRepository _instance = FeedRepository._internal();
  factory FeedRepository() => _instance;
  FeedRepository._internal();

  final _db = ChartNativeDB.instance;

  /// Fetch all cached posts from the C++ database (Fast O(1) path)
  Future<List<PostEntity>> getCachedPosts({String? authorId}) async {
    final db = await _db.database;
    final rows = await db.query(
      'posts',
      where: authorId != null ? 'author_id = ?' : null,
      whereArgs: authorId != null ? [authorId] : null,
      orderBy: 'createdAt DESC',
    );
    return rows.map((row) => PostEntity.fromMap(row)).toList();
  }

  /// Sync data to the local C++ cache
  Future<void> syncPosts(List<Map<String, dynamic>> posts) async {
    await _db.cachePosts(posts);
    print("Native Feed: Synced ${posts.length} items to C++ DB.");
  }

  /// Search local database (Lightning fast index search)
  Future<List<PostEntity>> searchPosts(String query) async {
    final db = await _db.database;
    final rows = await db.query(
      'posts',
      where: 'username LIKE ? OR caption LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return rows.map((row) => PostEntity.fromMap(row)).toList();
  }

  /// 👑 High-performance unified feed fetch utilizing C++ and strict Dart models.
  Future<List<ChannelItem>> getUnifiedChannelFeed(String channelId) async {
    final db = await _db.database;

    // 1. Fetch raw maps from SQLite
    final rawManifestos = await db.query(
      'manifestos', 
      where: 'channel_id = ?', 
      whereArgs: [channelId]
    );
    
    final rawComments = await db.query(
      'manifesto_comments', 
      where: 'channel_id = ?', 
      whereArgs: [channelId]
    );

    // 2. Map them to our strict Dart objects with legacy bridge synthesized
    final List<ChannelItem> unsortedItems = [
      ...rawManifestos.map((m) {
        final legacyMap = {
          'id': m['id'],
          'author_id': m['author_id'],
          'username': m['username'],
          'userProfileImageUrl': m['profile_image_url'],
          'channelId': m['channel_id'],
          'caption': m['caption'],
          'videoUrl': m['video_url'],
          'imageUrls': m['image_urls'],
          'thumbnailUrls': m['thumbnail_urls'],
          'likes': m['likes'],
          'comments': m['comments'],
          'createdAt': m['created_at'],
          'post_type': 'manifesto',
        };
        return ManifestoItem.fromMap(m, originalPost: PostEntity.fromMap(legacyMap));
      }),
      ...rawComments.map((c) {
        final legacyMap = {
          'id': c['id'],
          'author_id': c['author_id'],
          'username': c['username'],
          'userProfileImageUrl': c['profile_image_url'],
          'channelId': c['channel_id'],
          'caption': c['message'], // 👑 Map 'message' back to 'caption'
          'imageUrls': c['image_urls'],
          'likes': c['likes'],
          'createdAt': c['created_at'],
          'linked_post_id': c['manifesto_id'], // 👑 The link
          'post_type': 'post' // Default to normal post comment
        };
        return ChannelCommentItem.fromMap(c, originalPost: PostEntity.fromMap(legacyMap));
      }),
    ];

    // 3. Fallback Dart sort just in case:
    unsortedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return unsortedItems;
  }
}





























