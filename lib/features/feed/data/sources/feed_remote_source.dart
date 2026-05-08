import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/post_entity.dart';
import '../mappers/post_mapper.dart';

/// Fetches feed data from the remote API.
/// Throws typed exceptions — never returns Failure (that's the repo's job).
@injectable
class FeedRemoteSource {
  final ApiClient _client;

  const FeedRemoteSource(this._client);

  Future<List<PostEntity>> getFeed({int page = 1, int limit = 10}) async {
    final supabase = Supabase.instance.client;
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit - 1;

    try {
      final response = await supabase
          .from('posts')
          .select('*, author:profiles(*)')
          .eq('privacy', 'public')
          .order('created_at', ascending: false)
          .range(startIndex, endIndex);

      return _mapResponseToEntities(response as List);
    } catch (e) {
      debugPrint('🚨 [FeedRemoteSource] getFeed FAILED: $e');
      throw ServerException('Failed to get main feed: $e');
    }
  }

  Future<PostEntity> toggleLike(String postId) async {
    try {
      final response = await _client.dio.post('/posts/$postId/like');
      return PostMapper.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw NetworkExceptionMapper.fromDioException(e as dynamic);
    }
  }

  Future<void> reportPost(String postId, String reason) async {
    try {
      await _client.dio.post('/posts/$postId/report', data: {'reason': reason});
    } catch (e) {
      throw NetworkExceptionMapper.fromDioException(e as dynamic);
    }
  }

  Future<PostEntity> getPost(String postId) async {
    try {
      final response = await _client.dio.get('/posts/$postId');
      return PostMapper.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw NetworkExceptionMapper.fromDioException(e as dynamic);
    }
  }

  Future<List<PostEntity>> getChannelVideos(
    String channelId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('channel_posts')
          .select('*, author:profiles(*)')
          .eq('channel_id', channelId)
          .eq('is_video', true)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((row) => PostMapper.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    } catch (e) {
      debugPrint('❌ [FeedRemoteSource] Error fetching channel videos: $e');
      throw ServerException(e.toString());
    }
  }

  Future<PostEntity> createPost(
    PostEntity post, {
    String folderName = 'public_posts',
    String privacy = 'public',
    String customRole = '',
    bool isPublicFeed = true,
    bool allowComments = true,
    bool shareToStatus = false,
    bool shareToMoment = false, // 👑 ADDED
  }) async {
    final supabase = Supabase.instance.client;

    final payload = {
      'id': post.id,
      'author_id': supabase.auth.currentUser?.id ?? post.authorId,
      'channel_id': post.channelId.isEmpty || post.channelId == 'general'
          ? null
          : post.channelId,
      'channel_name': post.channelName.isEmpty || post.channelName == 'General'
          ? null
          : post.channelName,
      'caption': post.caption,
      'image_urls': post.imageUrls,
      'thumbnail_urls': post.thumbnailUrls,
      'video_url': post.videoUrl,
      'audio_url': post.audioUrl,
      'sd_video_url': post.sdVideoUrl,
      'is_video': post.isVideo,
      'is_audio': post.isAudio,
      'folder_name': folderName,
      'privacy': privacy,
      if (privacy == 'role') 'role_viewer': customRole,
      'aspect_ratio': post.aspectRatio,
      'post_type': post.postType,
      'parent_post_id': post.parentPostId,
      'linked_post_id': post.linkedPostId,
      'link_chain': jsonEncode(post.linkChain),
      'link_depth': post.linkDepth,
      'allow_comments': allowComments, // 👑 New flag
    };

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🌐 [SUPABASE] createPost() — context routing');
    debugPrint('   ├─ id          : ${post.id}');
    debugPrint('   ├─ post_type   : ${post.postType}');
    debugPrint('   ├─ is_public   : $isPublicFeed');
    debugPrint('   ├─ channel_id  : ${payload['channel_id']}');
    debugPrint('   ├─ allow_comm  : $allowComments');
    debugPrint('   ├─ shareStatus : $shareToStatus');
    debugPrint('   └─ shareMoment : $shareToMoment');

    try {
      final List<Future> operations = [];

      // 👑 STRICT MUTUALLY EXCLUSIVE ROUTING
      final bool isChannelContent =
          payload['channel_id'] != null && payload['channel_id'] != 'general';

      if (post.postType == 'moment') {
        final momentPayload = {
          'id': post.id,
          'channel_id': payload['channel_id'],
          'author_id': payload['author_id'],
          'media_url':
              payload['video_url'] ??
              (post.imageUrls.isNotEmpty ? post.imageUrls.first : ''),
          'media_type': post.isVideo ? 'video' : 'photo',
          'thumbnail_url': post.thumbnailUrls.isNotEmpty
              ? post.thumbnailUrls.first
              : null,
          'caption': post.caption,
          'created_at': DateTime.now().toIso8601String(),
        };
        operations.add(supabase.from('channel_moments').insert(momentPayload));
      } else if (post.postType == 'status') {
        // 🛣️ ROUTE: STATUSES ONLY
        if (isChannelContent) {
          final channelStatusPayload = {
            'id': post.id,
            'author_id': payload['author_id'],
            'channel_id': payload['channel_id'],
            'caption': payload['caption'],
            'image_urls': payload['image_urls'],
            'video_url': payload['video_url'],
            'audio_url': payload['audio_url'],
            'is_video': payload['is_video'],
            'is_audio': payload['is_audio'],
            'thumbnail_url': post.thumbnailUrls.isNotEmpty
                ? post.thumbnailUrls.first
                : null,
            'expires_at': DateTime.now()
                .add(const Duration(hours: 24))
                .toIso8601String(),
          };
          operations.add(
            supabase.from('channel_statuses').insert(channelStatusPayload),
          );
        } else {
          final personalStatusPayload = {
            'id': post.id,
            'author_id': payload['author_id'],
            'caption': payload['caption'],
            'image_urls': payload['image_urls'],
            'video_url': payload['video_url'],
            'audio_url': payload['audio_url'],
            'is_video': payload['is_video'],
            'is_audio': payload['is_audio'],
            'thumbnail_url': post.thumbnailUrls.isNotEmpty
                ? post.thumbnailUrls.first
                : null,
            'privacy': payload['privacy'],
            'allow_comments': payload['allow_comments'],
            'expires_at': DateTime.now()
                .add(const Duration(hours: 24))
                .toIso8601String(),
          };
          operations.add(
            supabase.from('statuses').insert(personalStatusPayload),
          );
        }
      } else if (isChannelContent) {
        // 🛣️ ROUTE A: CHANNEL TABLES ONLY
        if (post.postType == 'manifesto' ||
            post.postType == 'channel' ||
            post.linkedPostId == null) {
          final manifestoPayload = {
            'id': post.id,
            'author_id': payload['author_id'],
            'channel_id': payload['channel_id'],
            'caption': post.caption,
            'video_url': post.videoUrl,
            'video_urls': post.videoUrls,
            'image_urls': post.imageUrls,
            'thumbnail_urls': post.thumbnailUrls,
            'is_video': post.isVideo,
            'is_audio': post.isAudio,
            'audio_url': post.audioUrl,
            'aspect_ratio': post.aspectRatio ?? 1.0,
            'is_public': isPublicFeed,
            'allow_comments': allowComments,
          };
          operations.add(
            supabase.from('channel_posts').insert(manifestoPayload),
          );
        } else {
          final commentPayload = {
            'id': post.id,
            'author_id': payload['author_id'],
            'channel_id': payload['channel_id'],
            'post_id': post.linkedPostId,
            'message': post.caption,
            'image_urls': post.imageUrls,
          };
          operations.add(
            supabase.from('channel_post_comments').insert(commentPayload),
          );
        }
      } else {
        operations.add(supabase.from('posts').insert(payload));
      }

      // 👑 ADDITIONAL: Also Share to Moment if flag is on
      if (shareToMoment && isChannelContent) {
        final momentPayload = {
          'id': const Uuid().v4(), // Different ID for the moment
          'channel_id': payload['channel_id'],
          'author_id': payload['author_id'],
          'media_url':
              payload['video_url'] ??
              (post.imageUrls.isNotEmpty ? post.imageUrls.first : ''),
          'media_type': post.isVideo ? 'video' : 'photo',
          'thumbnail_url': post.thumbnailUrls.isNotEmpty
              ? post.thumbnailUrls.first
              : null,
          'caption': post.caption,
          'created_at': DateTime.now().toIso8601String(),
          'expires_at': DateTime.now()
              .add(const Duration(hours: 24))
              .toIso8601String(),
        };
        operations.add(supabase.from('channel_moments').insert(momentPayload));
      }

      // 👑 ADDITIONAL: Also Share to Status if flag is on
      // Skip if the primary post type is already status to avoid double-inserting
      if (shareToStatus && post.postType != 'status') {
        final personalStatusPayload = {
          'id': const Uuid().v4(), // Different ID
          'author_id': payload['author_id'],
          'caption': payload['caption'],
          'image_urls': payload['image_urls'],
          'video_url': payload['video_url'],
          'audio_url': payload['audio_url'],
          'is_video': payload['is_video'],
          'is_audio': payload['is_audio'],
          'thumbnail_url': post.thumbnailUrls.isNotEmpty
              ? post.thumbnailUrls.first
              : null,
          'privacy': payload['privacy'] ?? 'public',
          'allow_comments': payload['allow_comments'] ?? true,
          'expires_at': DateTime.now()
              .add(const Duration(hours: 24))
              .toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
        };
        operations.add(supabase.from('statuses').insert(personalStatusPayload));
      }

      await Future.wait(operations);

      debugPrint(
        '✅ [SUPABASE] Post routing SUCCESS! (Strict Separation applied)',
      );
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return post;
    } catch (e) {
      debugPrint('❌ [SUPABASE] Insert FAILED: $e');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      throw ServerException('Failed to route post in Supabase: $e');
    }
  }

  Future<List<PostEntity>> getUserPosts(
    String userId, {
    bool? isVideo,
    bool? isAudio,
    String? folderName,
    int page = 1,
    int limit = 10,
  }) async {
    final supabase = Supabase.instance.client;
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit - 1;

    print(
      "🌐 [FeedRemoteSource] Querying profile posts for $userId (excluding channel posts)",
    );

    try {
      var query = supabase
          .from('posts')
          .select('*, author:profiles(*)')
          .eq('author_id', userId)
          .isFilter(
            'channel_id',
            null,
          ); // 👑 THE PROFILE FILTER (Timeline only)

      if (isVideo == true) {
        query = query.eq('is_video', true);
      } else if (isVideo == false) {
        query = query.or('is_video.eq.false,is_video.is.null');
      }

      if (isAudio == true) {
        query = query.eq('is_audio', true);
      } else if (isAudio == false) {
        query = query.or('is_audio.eq.false,is_audio.is.null');
      }

      if (folderName != null && folderName.isNotEmpty) {
        query = query.eq('folder_name', folderName);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(startIndex, endIndex);

      return _mapResponseToEntities(response as List);
    } catch (e) {
      throw ServerException('Failed to get user posts: $e');
    }
  }

  /// Fetches paginated posts securely using the unified Channel View!
  Future<List<PostEntity>> getChannelPosts(
    String channelId, {
    int page = 1,
    int limit = 10,
  }) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit - 1;

    try {
      if (channelId == 'general' || channelId.isEmpty) {
        final response = await supabase
            .from('posts')
            .select('*, author:profiles(*)')
            .isFilter('channel_id', null)
            .order('created_at', ascending: false)
            .range(startIndex, endIndex);
        return _mapResponseToEntities(response as List);
      }

      // 1. Fetch posts from the view (plain select — views can't FK-join)
      final response = await supabase
          .from('channel_feed_view')
          .select()
          .eq('channel_id', channelId)
          .order('created_at', ascending: false)
          .range(startIndex, endIndex);

      final rawList = response as List;

      // 2. If logged in, fetch which of these posts the user has liked
      //    in a separate lightweight query — this is required because
      //    channel_feed_view is a VIEW with no FK relationships.
      Set<String> likedIds = {};
      if (userId != null && rawList.isNotEmpty) {
        final postIds = rawList
            .map((r) => r['id']?.toString())
            .where((id) => id != null)
            .toList();
        try {
          final likesResponse = await supabase
              .from('channel_post_likes')
              .select('post_id')
              .eq('user_id', userId)
              .inFilter('post_id', postIds);
          likedIds = (likesResponse as List)
              .map((r) => r['post_id']?.toString() ?? '')
              .toSet();
          debugPrint(
            '❤️ [FeedRemoteSource] User liked ${likedIds.length} posts in this page.',
          );
        } catch (e) {
          debugPrint('⚠️ [FeedRemoteSource] Could not fetch liked ids: $e');
        }
      }

      // 3. Stamp is_liked on each row before mapping to entities
      final stampedList = rawList.map((row) {
        final map = Map<String, dynamic>.from(row as Map);
        if (likedIds.contains(map['id']?.toString())) {
          map['is_liked'] = true;
        }
        return map;
      }).toList();

      return _mapResponseToEntities(stampedList);
    } catch (e) {
      debugPrint('❌ [FeedRemoteSource] Fetch Failed: $e');
      throw ServerException('Failed to get channel posts: $e');
    }
  }

  /// 👑 THREADED DISCUSSION: Fetches comments for a specific manifesto
  Future<List<PostEntity>> getManifestoComments(
    String manifestoId, {
    int limit = 10,
    int offset = 0,
  }) async {
    final supabase = Supabase.instance.client;
    try {
      debugPrint(
        '🌐 [FeedRemoteSource] Fetching comments for manifesto: $manifestoId (limit: $limit, offset: $offset)',
      );
      final response = await supabase
          .from('manifesto_comments_view')
          .select('*')
          .eq('manifesto_id', manifestoId)
          .order('created_at', ascending: true)
          .range(offset, offset + limit - 1);
      return _mapResponseToEntities(response as List);
    } catch (e) {
      debugPrint('❌ [FeedRemoteSource] Failed to get manifesto comments: $e');
      throw ServerException('Failed to get manifesto comments: $e');
    }
  }

  /// 🛰️ DELTA INJECTION: Listens to BOTH Manifestos and Comments!
  Stream<PostEntity> watchChannelPosts(String channelId) {
    final supabase = Supabase.instance.client;

    if (channelId == 'general' || channelId.isEmpty) {
      // ... existing general table logic ...
      return Stream.empty(); // Keep your old general logic if needed
    }

    final filterKey = 'public:channel_$channelId';
    late final RealtimeChannel realtimeChannel;

    final controller = StreamController<PostEntity>(
      onCancel: () {
        debugPrint('🛑 [DELTA] Unsubscribing from $filterKey');
        supabase.removeChannel(realtimeChannel);
      },
    );

    // 👑 Strictly Channel Posts: Listening to the real source table
    realtimeChannel = supabase
        .channel(filterKey)
        .onPostgresChanges(
          event: PostgresChangeEvent.all, // 👑 Listen to INSERT, UPDATE, DELETE
          schema: 'public',
          table: 'channel_posts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'channel_id',
            value: channelId,
          ),
          callback: (payload) {
            if (payload.eventType == PostgresChangeEvent.insert) {
              final newRecord = Map<String, dynamic>.from(payload.newRecord);
              debugPrint(
                '📡 [Network Realtime] New raw post row: ${newRecord['id']} (Type: ${newRecord['post_type']})',
              );
              if (!controller.isClosed)
                controller.add(PostMapper.fromJson(newRecord));
            } else if (payload.eventType == PostgresChangeEvent.update) {
              final updatedRecord = Map<String, dynamic>.from(
                payload.newRecord,
              );
              debugPrint(
                '📡 [Network Realtime] Post UPDATED: ${updatedRecord['id']} (Likes: ${updatedRecord['likes']})',
              );
              if (!controller.isClosed)
                controller.add(PostMapper.fromJson(updatedRecord));
            }
          },
        );

    realtimeChannel.subscribe((status, [error]) {
      debugPrint('📡 [DELTA] Subscription status for $filterKey: $status');
      if (error != null) {
        debugPrint('🚨 [Supabase Realtime Error] Subscription FAILED: $error');
      }
    });
    return controller.stream;
  }

  /// Helper to map Supabase joined response into PostEntities
  List<PostEntity> _mapResponseToEntities(List<dynamic> response) {
    if (response.isEmpty) return [];

    // 👑 DEDUP & GROUPING:
    // Sometimes DB views or unnest triggers return multiple rows for one post.
    // We group them by ID and merge their image lists to ensure one card per post.
    final Map<String, Map<String, dynamic>> deduped = {};

    for (final rawJson in response) {
      final json = Map<String, dynamic>.from(rawJson as Map);
      final id = json['id']?.toString();
      if (id == null) continue;

      if (!deduped.containsKey(id)) {
        // First time seeing this post
        if (json['author'] != null && json['author'] is Map) {
          final author = json['author'];
          json['username'] = author['username'];
          json['display_name'] =
              author['displayName'] ?? author['display_name'];
          json['profile_image_url'] =
              author['profileImageUrl'] ?? author['profile_image_url'];
          json['author_title'] = author['ChartTitle'] ?? author['Chart_title'];
        }

        // 👑 GRACEFUL MIGRATION: Auto-correct legacy URLs
        // If they still point to the wrong domain or were missing the /users/ fragment, fix them.
        if (json['image_urls'] != null) {
          final List<dynamic> rawList = json['image_urls'] is List
              ? json['image_urls']
              : (json['image_urls'] is String
                    ? jsonDecode(json['image_urls'])
                    : []);

          final List<String> corrected = [];
          for (final url in rawList) {
            var fixed = url.toString();

            // 👑 REBRAND: channel-profiles was the old folder, channel_avatars is working!
            fixed = fixed.replaceFirst(
              '/channel-profiles/',
              '/channel_avatars/',
            );

            // Re-add the /users/ prefix if it was missing
            if (fixed.contains('crown.nexassearch.com/') &&
                !fixed.contains('crown.nexassearch.com/users/')) {
              fixed = fixed.replaceFirst(
                'crown.nexassearch.com/',
                'crown.nexassearch.com/users/',
              );
            }

            corrected.add(fixed);
          }
          json['image_urls'] = corrected;
        }

        deduped[id] = json;
      } else {
        // Merge image_urls if they exist as separate rows
        final existing = deduped[id]!;
        final List<String> currentUrls = (existing['image_urls'] is List)
            ? (existing['image_urls'] as List).map((e) => e.toString()).toList()
            : [];

        final List<String> newUrls = (json['image_urls'] is List)
            ? (json['image_urls'] as List).map((e) => e.toString()).toList()
            : [];

        for (final url in newUrls) {
          if (!currentUrls.contains(url)) {
            currentUrls.add(url);
          }
        }
        existing['image_urls'] = currentUrls;
      }
    }

    debugPrint('🌐 [Step 1: Dedup] Processing ${response.length} raw rows...');

    // ... grouping logic ...

    debugPrint(
      '🌐 [Step 2: Mapping] Converting ${deduped.length} unique items to entities...',
    );
    final List<PostEntity> results = [];
    for (final entry in deduped.entries) {
      try {
        results.add(PostMapper.fromJson(entry.value));
      } catch (e) {
        debugPrint('🚨 [Mapper Crash] Failed on item ID: ${entry.key}');
        debugPrint('🚨 Error Detail: $e');
        debugPrint('🚨 Raw JSON: ${entry.value}');
        rethrow;
      }
    }

    debugPrint(
      '🌐 [Step 3: Complete] Successfully mapped ${results.length} entities.',
    );
    return results;
  }

  /// Fetches the unique folder names for a user's posts.
  Future<List<String>> getUserPostFolders(
    String userId, {
    bool? isVideo,
    bool? isAudio,
  }) async {
    final supabase = Supabase.instance.client;
    try {
      var query = supabase
          .from('posts')
          .select('folder_name')
          .eq('author_id', userId)
          .not('folder_name', 'is', null);

      if (isVideo == true) query = query.eq('is_video', true);
      if (isVideo == false)
        query = query.or('is_video.eq.false,is_video.is.null');
      if (isAudio == true) query = query.eq('is_audio', true);
      if (isAudio == false)
        query = query.or('is_audio.eq.false,is_audio.is.null');

      final response = await query.order('created_at', ascending: false);

      final folderSet = <String>{};
      for (final row in (response as List)) {
        final name = row['folder_name']?.toString();
        if (name != null && name.isNotEmpty) {
          folderSet.add(name);
        }
      }
      return folderSet.toList();
    } catch (e) {
      print('Failed to get user post folders: $e');
      return [];
    }
  }
}
