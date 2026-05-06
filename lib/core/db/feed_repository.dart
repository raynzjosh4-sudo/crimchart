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
    final rows = await _db.getPosts(authorId: authorId);
    return rows.map((row) => PostEntity.fromMap(row)).toList();
  }

  /// Sync data to the local C++ cache
  Future<void> syncPosts(List<Map<String, dynamic>> posts) async {
    await _db.cachePosts(posts);
    print("Native Feed: Synced ${posts.length} items to C++ DB.");
  }

  /// Search local database (Lightning fast index search)
  Future<List<PostEntity>> searchPosts(String query) async {
    final rows = await _db.searchPosts(query);
    return rows.map((row) => PostEntity.fromMap(row)).toList();
  }

  /// 👑 High-performance unified feed fetch utilizing C++ and strict Dart models.
  Future<List<ChannelItem>> getUnifiedChannelFeed(String channelId) async {
    // 1. Fetch raw maps from SQLite (Drift Engine)
    final rawChannelPosts = await _db.getChannelPosts(channelId);
    final rawChannelComments = await _db.getChannelPostComments(channelId);

    // 2. Map them to our strict Dart objects with legacy bridge synthesized
    final List<ChannelItem> unsortedItems = [
      ...rawChannelPosts.map((m) {
        final legacyMap = {
          'id': m['id'],
          'authorId': m['authorId'],
          'username': m['username'],
          'userProfileImageUrl': m['profileImageUrl'],
          'channelId': m['channelId'],
          'caption': m['caption'],
          'videoUrl': m['videoUrl'],
          'videoUrls': m['videoUrls'],
          'imageUrls': m['imageUrls'],
          'thumbnailUrls': m['thumbnailUrls'],
          'likes': m['likes'],
          'comments': m['comments'],
          'createdAt': m['createdAt'],
          'post_type': 'manifesto',
        };
        return ManifestoItem.fromMap(m, originalPost: PostEntity.fromMap(legacyMap));
      }),
      ...rawChannelComments.map((c) {
        final legacyMap = {
          'id': c['id'],
          'authorId': c['authorId'],
          'username': c['username'],
          'userProfileImageUrl': c['profileImageUrl'],
          'channelId': c['channelId'],
          'caption': c['message'], // 👑 Map 'message' back to 'caption'
          'imageUrls': c['imageUrls'],
          'likes': c['likes'],
          'createdAt': c['createdAt'],
          'linkedPostId': c['postId'], // 👑 The link
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





























