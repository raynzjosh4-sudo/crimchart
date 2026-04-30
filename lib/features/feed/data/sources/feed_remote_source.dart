import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  Future<List<PostEntity>> getFeed({int page = 1, int limit = 15}) async {
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

  Future<PostEntity> createPost(
    PostEntity post, {
    String folderName = 'public_posts',
    String privacy = 'public',
    String customRole = '',
    bool isPublicFeed = true,
    bool allowComments = true,
    bool shareToStatus = false,
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
    debugPrint('   └─ shareStatus : $shareToStatus');

    try {
      final List<Future> operations = [];
      
      // 👑 STRICT MUTUALLY EXCLUSIVE ROUTING
      final bool isChannelContent = payload['channel_id'] != null && payload['channel_id'] != 'general';

      if (isChannelContent) {
        // 🛣️ ROUTE A: CHANNEL TABLES ONLY
        if (post.postType == 'manifesto' || post.postType == 'channel' || post.linkedPostId == null) {
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
              'is_public': isPublicFeed, 
              'allow_comments': allowComments,
           };
           operations.add(supabase.from('manifestos').insert(manifestoPayload));
        } else {
           final commentPayload = {
              'id': post.id,
              'author_id': payload['author_id'],
              'channel_id': payload['channel_id'],
              'manifesto_id': post.linkedPostId, 
              'message': post.caption,
              'image_urls': post.imageUrls,
           };
           operations.add(supabase.from('manifesto_comments').insert(commentPayload));
        }
      } else {
        // 🛣️ ROUTE B: GENERAL POSTS TABLE ONLY
        // Only hits this if there is NO channel_id attached
        operations.add(supabase.from('posts').insert(payload));
      }

      // 👑 Statuses Table (Independent Route)
      if (shareToStatus) {
        final statusPayload = {
          'id': post.id,
          'author_id': payload['author_id'],
          'caption': payload['caption'],
          'image_urls': payload['image_urls'],
          'video_url': payload['video_url'],
          'audio_url': payload['audio_url'],
          'is_video': payload['is_video'],
          'is_audio': payload['is_audio'],
          'privacy': payload['privacy'],
          'allow_comments': payload['allow_comments'],
          'expires_at': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
        };
        operations.add(supabase.from('statuses').insert(statusPayload));
      }

      await Future.wait(operations);

      debugPrint('✅ [SUPABASE] Post routing SUCCESS! (Strict Separation applied)');
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
    int limit = 12,
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
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit - 1;

    print("🌐 [FeedRemoteSource] Querying channel_feed_view for: $channelId");

    try {
      if (channelId == 'general' || channelId.isEmpty) {
        // Fallback for general feed
        final response = await supabase.from('posts')
            .select('*, author:profiles(*)')
            .isFilter('channel_id', null)
            .order('created_at', ascending: false)
            .range(startIndex, endIndex);
        return _mapResponseToEntities(response as List);
      }

      // 👑 PRO LEVEL: Query the View (Selective for Manifestos Only)
      // Restoring all columns as confirmed by the user. 
      // This includes profile data, audio urls, and link threading metadata.
      final response = await supabase
          .from('channel_feed_view')
          .select('''
            id, 
            author_id, 
            username, 
            display_name, 
            profile_image_url, 
            author_title, 
            channel_id, 
            caption, 
            video_url,
            video_urls,
            audio_url, 
            image_urls, 
            thumbnail_urls, 
            is_video, 
            is_audio, 
            likes, 
            comments, 
            created_at, 
            post_type, 
            linked_post_id
          ''')
          .eq('channel_id', channelId)
          .order('created_at', ascending: false)
          .range(startIndex, endIndex);

      return _mapResponseToEntities(response as List);
    } catch (e) {
      debugPrint('❌ [FeedRemoteSource] Network Fetch Failed: $e');
      throw ServerException('Failed to get channel posts: $e');
    }
  }

  /// 👑 THREADED DISCUSSION: Fetches comments for a specific manifesto
  Future<List<PostEntity>> getManifestoComments(String manifestoId) async {
    final supabase = Supabase.instance.client;
    try {
      debugPrint('🌐 [FeedRemoteSource] Fetching comments for manifesto: $manifestoId');
      final response = await supabase
          .from('manifesto_comments_view')
          .select('*')
          .eq('manifesto_id', manifestoId)
          .order('created_at', ascending: true);
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

    // 👑 Strictly Manifestos Only: Separating comments completely.
    realtimeChannel = supabase.channel(filterKey)
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'manifestos',
        filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'channel_id', value: channelId),
        callback: (payload) {
          final newRecord = Map<String, dynamic>.from(payload.newRecord);
          newRecord['post_type'] = 'manifesto'; // Force identification
          debugPrint('📡 [Network Realtime] New raw MANIFESTO row: ${newRecord['id']}');
          if (!controller.isClosed) controller.add(PostMapper.fromJson(newRecord));
        },
      );
      
    realtimeChannel.subscribe();
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
            fixed = fixed.replaceFirst('/channel-profiles/', '/channel_avatars/');

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

    return deduped.values.map((json) => PostMapper.fromJson(json)).toList();
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
