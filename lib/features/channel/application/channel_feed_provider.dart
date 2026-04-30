import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../feed/domain/entities/post_entity.dart';
import '../../feed/domain/repositories/feed_repository.dart';
import '../../feed/data/mappers/post_mapper.dart';
import '../../feed/application/feed_controller.dart';
import '../../../core/db/chart_native_db.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/entities/channel_item.dart';

/// The Feed State for a Channel
class ChannelFeedState {
  final List<ChannelItem> channelItems; // 👑 STRICT UI TYPE
  final List<PostEntity> remotePosts;
  final List<PostEntity> pendingPosts;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String? error;

  ChannelFeedState({
    this.channelItems = const [],
    this.remotePosts = const [],
    this.pendingPosts = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  List<PostEntity> get allPosts => [...pendingPosts, ...remotePosts];

  ChannelFeedState copyWith({
    List<ChannelItem>? channelItems,
    List<PostEntity>? remotePosts,
    List<PostEntity>? pendingPosts,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? error,
  }) {
    return ChannelFeedState(
      channelItems: channelItems ?? this.channelItems,
      remotePosts: remotePosts ?? this.remotePosts,
      pendingPosts: pendingPosts ?? this.pendingPosts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }
}

/// A provider that handles live real-time posts for a channel feed.
class ChannelFeedNotifier extends StateNotifier<ChannelFeedState> {
  final FeedRepository _repository;
  final String channelId;
  StreamSubscription<PostEntity>? _subscription;

  /// 👑 PRO: In-memory profile cache keyed by author_id.
  /// Populated from existing posts so we never fetch the same profile twice.
  final Map<String, PostEntity> _profileCache = {};

  ChannelFeedNotifier(this._repository, this.channelId)
    : super(ChannelFeedState()) {
    _initOfflineFirst();
  }
  // 👑 OPTIMISTIC UI: Instantly increment the comment count on screen!
  void incrementCommentCount(String postId) {
    debugPrint('💬 [UI] Incrementing comment count on Manifesto: $postId');
    // 1. Update the STRICT UI Items so the screen repaints instantly
    final updatedChannelItems = state.channelItems.map((item) {
      if (item is ManifestoItem && item.id == postId) {
        // Rebuild the Manifesto with +1 comments
        return ManifestoItem(
          id: item.id,
          authorUsername: item.authorUsername,
          authorAvatarUrl: item.authorAvatarUrl,
          createdAt: item.createdAt,
          likes: item.likes,
          originalPost: item.originalPost,
          caption: item.caption,
          imageUrls: item.imageUrls,
          videoUrl: item.videoUrl,
          commentCount: item.commentCount + 1, // 🚀 The Increment!
        );
      }
      return item;
    }).toList();

    // 2. Keep the legacy lists synced just in case
    final updatedRemote = state.remotePosts
        .map((p) => p.id == postId ? p.copyWith(comments: p.comments + 1) : p)
        .toList();
    final updatedPending = state.pendingPosts
        .map((p) => p.id == postId ? p.copyWith(comments: p.comments + 1) : p)
        .toList();

    state = state.copyWith(
      channelItems: updatedChannelItems, // 👑 This makes the UI change!
      remotePosts: updatedRemote,
      pendingPosts: updatedPending,
    );

    // 3. 💾 PERSIST LOCALLY: Update the manifesto row in local SQLite immediately
    // so the count survives a restart even if offline.
    ChartNativeDB.instance.incrementManifestoCommentCount(postId);
  }

  // 👑 HELPER: Bridges the gap between old entities and new UI items
  ChannelItem _mapPostToChannelItem(PostEntity post) {
    bool isManifesto =
        post.postType == 'manifesto' ||
        post.postType == 'channel' ||
        (post.postType == 'post' &&
            post.linkedPostId == null &&
            post.parentPostId == null &&
            post.linkDepth == 0);

    if (isManifesto) {
      return ManifestoItem.fromMap({
        'id': post.id,
        'author_id': post.authorId,
        'username': post.authorUsername,
        'profile_image_url': post.authorAvatarUrl,
        'caption': post.caption,
        'image_urls': post.imageUrls,
        'video_url': post.videoUrl,
        'likes': post.likes,
        'comments': post.comments,
        'created_at': post.createdAt.toIso8601String(),
      }, originalPost: post);
    } else {
      return ChannelCommentItem.fromMap({
        'id': post.id,
        'author_id': post.authorId,
        'username': post.authorUsername,
        'profile_image_url': post.authorAvatarUrl,
        'message': post.caption,
        'image_urls': post.imageUrls,
        'likes': post.likes,
        'manifesto_id': post.linkedPostId,
        'created_at': post.createdAt.toIso8601String(),
      }, originalPost: post);
    }
  }

  Future<void> _initOfflineFirst() async {
    // 1. Only show the spinner if we have absolutely 0 data in memory
    if (state.remotePosts.isEmpty) {
      debugPrint(
        '🕒 [ChannelFeedNotifier] _initOfflineFirst: setting isLoading=true (no remote posts yet)',
      );
      state = state.copyWith(isLoading: true);
    } else {
      debugPrint(
        '🕒 [ChannelFeedNotifier] _initOfflineFirst: NOT setting isLoading=true (we have ${state.remotePosts.length} posts in memory)',
      );
    }

    // 2. INSTANT LOCAL LOAD: Ask the repo for page 1.
    final localResult = await _repository.getChannelPosts(channelId, page: 1);

    localResult.fold(
      (failure) {
        debugPrint(
          '🕒 [ChannelFeedNotifier] _initOfflineFirst: local fetch FAILED. setting isLoading=false',
        );
        state = state.copyWith(isLoading: false); // 👈 Stop if local fails
      },
      (localPosts) {
        if (localPosts.isNotEmpty) {
          debugPrint(
            '⚡ [Offline-First] Loaded ${localPosts.length} posts from SQLite for channel $channelId.',
          );
          // 👑 Debug: Log the IDs to see if they are zombies
          for (var p in localPosts.take(3)) {
            final shortCaption = p.caption.length > 20 ? '${p.caption.substring(0, 20)}...' : p.caption;
            debugPrint('   ├─ Post: ${p.id} (Type: ${p.postType}, Caption: $shortCaption)');
          }

          debugPrint(
            '🕒 [ChannelFeedNotifier] _initOfflineFirst: local data found! setting isLoading=false',
          );
          state = state.copyWith(
            remotePosts: localPosts,
            isLoading: false, // 👑 STOP THE SPINNER NOW! Local data is here.
            hasMore: localPosts.length >= 10,
            page: 2,
          );
          _updateUIState(); // Push to channelItems
        } else {
          debugPrint(
            '🕒 [ChannelFeedNotifier] _initOfflineFirst: local was EMPTY. setting isLoading=true to wait for network',
          );
          // If local is empty, we keep isLoading true while we try network
          state = state.copyWith(isLoading: true);
        }
      },
    );

    _loadPending();

    // 3. RELIABLE SYNC: Fetch via HTTP immediately while the stream connects
    // This solves the "Infinite Shimmer" if Realtime is slow or disabled.
    refresh(isInitial: true);

    // 4. DELTA STREAM: Surgically inject ONE new post at a time.
    // No full-list refetch — the server pushes the row, we patch and prepend it.
    _subscription = _repository
        .watchChannelPosts(channelId)
        .listen(
          (newPost) async {
            debugPrint(
              '⚡ [DELTA INJECT] New post from ${newPost.authorId} in $channelId',
            );

            // 👑 PROFILE RECONCILIATION:
            // The Realtime payload has no author join. Look it up from our cache first.
            final patchedPost = await _reconcileProfile(newPost);

            // Guard: don't inject a true duplicate (already confirmed in remote)
            final alreadyInRemote = state.remotePosts.any((p) => p.id == patchedPost.id);
            if (alreadyInRemote) {
              debugPrint('⚠️ [DELTA] Skipping duplicate remote post ${patchedPost.id}');
              return;
            }

            // 👑 PENDING PROMOTION: If this is our own optimistic post coming back
            // from the server, move it from pendingPosts → remotePosts so the
            // pending overlay clears and the post stays in its correct position.
            final isPendingPromotion = state.pendingPosts.any((p) => p.id == patchedPost.id);

            if (isPendingPromotion) {
              debugPrint('✅ [DELTA] Promoting pending → confirmed: ${patchedPost.id}');
              final newPending = state.pendingPosts
                  .where((p) => p.id != patchedPost.id)
                  .toList();
              // Insert into remotePosts at the correct chronological position
              final newRemote = [patchedPost, ...state.remotePosts];
              // Rebuild channelItems from scratch so ordering is correct
              final remoteItems = newRemote.map(_mapPostToChannelItem).toList();
              final pendingItems = newPending.map(_mapPostToChannelItem).toList();
              final remoteIds = remoteItems.map((e) => e.id).toSet();
              final missingPending = pendingItems.where((p) => !remoteIds.contains(p.id)).toList();
              state = state.copyWith(
                pendingPosts: newPending,
                remotePosts: newRemote,
                channelItems: [...missingPending, ...remoteItems],
              );
              return;
            }

            // 🚀 SURGICAL INJECTION: Brand new post from another user
            debugPrint('🚀 [DELTA] Direct injection of MANIFESTO: ${patchedPost.id}');

            final newItem = ManifestoItem.fromMap({
              'id': patchedPost.id,
              'author_id': patchedPost.authorId,
              'username': patchedPost.authorUsername,
              'profile_image_url': patchedPost.authorAvatarUrl,
              'caption': patchedPost.caption,
              'image_urls': patchedPost.imageUrls,
              'video_url': patchedPost.videoUrl,
              'likes': patchedPost.likes,
              'comments': patchedPost.comments,
              'created_at': patchedPost.createdAt.toIso8601String(),
            }, originalPost: patchedPost);

            state = state.copyWith(
              remotePosts: [patchedPost, ...state.remotePosts],
              channelItems: [newItem, ...state.channelItems],
            );
          },
          onError: (err) {
            debugPrint('📡 [Delta Stream] Error: $err');
          },
        );
  }

  /// 👑 PROFILE RECONCILIATION:
  /// 1st: Check the in-memory cache for an author we have already seen.
  /// 2nd: Fall back to a one-time Supabase profile fetch — then remember it.
  Future<PostEntity> _reconcileProfile(PostEntity rawPost) async {
    // First, keep the cache warm from existing posts in state
    for (final p in state.remotePosts) {
      if (!_profileCache.containsKey(p.authorId) &&
          p.authorUsername.isNotEmpty &&
          p.authorUsername != 'unknown') {
        _profileCache[p.authorId] = p;
      }
    }

    // If we already know this author, patch instantly with zero network cost
    final cached = _profileCache[rawPost.authorId];
    if (cached != null &&
        cached.authorUsername.isNotEmpty &&
        cached.authorUsername != 'unknown') {
      debugPrint('🗃️ [PROFILE CACHE] Hit for ${rawPost.authorId}');
      return PostMapper.fromJson({
        // Merge the raw post fields with the cached profile fields
        'id': rawPost.id,
        'author_id': rawPost.authorId,
        'channel_id': rawPost.channelId,
        'channel_name': rawPost.channelName,
        'caption': rawPost.caption,
        'image_urls': rawPost.imageUrls,
        'thumbnail_urls': rawPost.thumbnailUrls,
        'video_url': rawPost.videoUrl,
        'audio_url': rawPost.audioUrl,
        'sd_video_url': rawPost.sdVideoUrl,
        'is_video': rawPost.isVideo,
        'is_audio': rawPost.isAudio,
        'aspect_ratio': rawPost.aspectRatio,
        'post_type': rawPost.postType,
        'parent_post_id': rawPost.parentPostId,
        'linked_post_id': rawPost.linkedPostId,
        'link_chain': rawPost.linkChain,
        'link_depth': rawPost.linkDepth,
        'created_at': rawPost.createdAt.toIso8601String(),
        // 👇 Profile data from cache — the reconciliation magic
        'username': cached.authorUsername,
        'display_name': cached.authorDisplayName,
        'profile_image_url': cached.authorAvatarUrl,
        'author_title': cached.authorTitle,
      });
    }

    // Cache MISS: fetch this profile exactly once from Supabase
    debugPrint(
      '🌐 [PROFILE CACHE] Miss — fetching profile for ${rawPost.authorId}',
    );
    try {
      final supabase = Supabase.instance.client;
      final rows = await supabase
          .from('profiles')
          .select('username, display_name, profile_image_url, ChartTitle')
          .eq('id', rawPost.authorId)
          .limit(1);

      if (rows.isNotEmpty) {
        final profile = Map<String, dynamic>.from(rows.first);
        final patched = PostMapper.fromJson({
          'id': rawPost.id,
          'author_id': rawPost.authorId,
          'channel_id': rawPost.channelId,
          'channel_name': rawPost.channelName,
          'caption': rawPost.caption,
          'image_urls': rawPost.imageUrls,
          'thumbnail_urls': rawPost.thumbnailUrls,
          'video_url': rawPost.videoUrl,
          'audio_url': rawPost.audioUrl,
          'is_video': rawPost.isVideo,
          'is_audio': rawPost.isAudio,
          'aspect_ratio': rawPost.aspectRatio,
          'post_type': rawPost.postType,
          'parent_post_id': rawPost.parentPostId,
          'linked_post_id': rawPost.linkedPostId,
          'link_chain': rawPost.linkChain,
          'link_depth': rawPost.linkDepth,
          'created_at': rawPost.createdAt.toIso8601String(),
          'username': profile['username'],
          'display_name': profile['display_name'],
          'profile_image_url': profile['profile_image_url'],
          'author_title': profile['ChartTitle'],
        });
        // 🗃️ Remember this profile for all future posts from this author
        _profileCache[patched.authorId] = patched;
        return patched;
      }
    } catch (e) {
      debugPrint('⚠️ [PROFILE CACHE] Fetch failed for ${rawPost.authorId}: $e');
    }

    // Ultimate fallback: return the raw post (will show empty avatar/username)
    return rawPost;
  }

  /// Initial Load or Pull-to-Refresh (fallback if stream fails)
  Future<void> refresh({bool isInitial = false}) async {
    // Only shimmer if we really have nothing to show
    if (state.channelItems.isEmpty) {
      debugPrint(
        '🕒 [ChannelFeedNotifier] refresh: setting isLoading=true (channelItems is empty)',
      );
      state = state.copyWith(isLoading: true);
    } else {
      debugPrint(
        '🕒 [ChannelFeedNotifier] refresh: silently refreshing (channelItems has ${state.channelItems.length} items)',
      );
    }

    try {
      final result = await _repository.getChannelPosts(channelId, page: 1);

      result.fold(
        (failure) {
          debugPrint('⚠️ [ChannelFeedNotifier] Network Sync Failed for $channelId: $failure');
          debugPrint(
            '🕒 [ChannelFeedNotifier] refresh: network failed. setting isLoading=false',
          );
          state = state.copyWith(isLoading: false); // 👑 KILL SPINNER
        },
        (posts) async { // 👑 Make sure this callback is async!
          // 👑 WARM THE PROFILE CACHE from fresh results.
          for (final p in posts) {
            if (p.authorUsername.isNotEmpty && p.authorUsername != 'unknown') {
              _profileCache[p.authorId] = p;
            }
          }

          debugPrint(
            '🕒 [ChannelFeedNotifier] refresh: network success. setting isLoading=false',
          );
          state = state.copyWith(
            remotePosts: posts,
            isLoading: false, // 👑 KILL SPINNER
            hasMore: posts.length >= 10,
            page: 2,
          );

          _updateUIState(); // 👑 Sync UI here so the network data appears!

          // 👑 THE ZOMBIE FIX: Wipe old synced data from this channel...
          await ChartNativeDB.instance.clearSyncedPosts(channelId: channelId);
          
          // 👑 ...then save the fresh Truth from the server!
          _persistToNativeDB(posts);
        },
      );
    } catch (e) {
      debugPrint('🚨 Critical Refresh Error: $e');
      state = state.copyWith(isLoading: false); // 👑 EMERGENCY STOP
    }

    _loadPending();
  }

  /// Fetch next page from Supabase (pagination still uses regular fetch)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    debugPrint(
      '🕒 [ChannelFeedNotifier] loadMore() triggered for page ${state.page}',
    );
    state = state.copyWith(isLoading: true);

    try {
      final result = await _repository.getChannelPosts(
        channelId,
        page: state.page,
      );

      result.fold(
        (failure) {
          debugPrint('⚠️ [ChannelFeedNotifier] loadMore failed: $failure');
          // 👑 FIX THE INFINITE SPINNER LOOP ELEGANTLY
          // Setting hasMore to false wiped the UI list! Instead, we set an ERROR.
          // This tells PagingController to stop fetching and optionally show a retry button, without dropping existing data.
          state = ChannelFeedState(
            channelItems: state.channelItems,
            remotePosts: state.remotePosts,
            pendingPosts: state.pendingPosts,
            isLoading: false,
            hasMore: state.hasMore,
            page: state.page,
            error: failure.toString(),
          );
          // _updateUIState(); // Not needed since we preserve channelItems explicitly.
        },
        (posts) {
          debugPrint(
            '🕒 [ChannelFeedNotifier] loadMore success. loaded ${posts.length} new posts',
          );
          state = state.copyWith(
            remotePosts: [...state.remotePosts, ...posts],
            isLoading: false,
            hasMore: posts.length >= 10,
            page: state.page + 1,
          );

          _updateUIState(); // 👑 Sync UI here!
        },
      );
    } catch (e) {
      debugPrint('🚨 [ChannelFeedNotifier] Critical loadMore Error: $e');
      state = state.copyWith(isLoading: false, hasMore: false);
      _updateUIState();
    }
  }

  /// 👑 INSTANT UI MERGER: Maps our memory state directly to the strict UI classes
  void _updateUIState() {
    // 1. Map whatever we got from the network (Source: channel_feed_view)
    final remoteItems = state.remotePosts
        .map(_mapPostToChannelItem)
        .toList();

    // 2. Map whatever is pending locally (Source: SQLite pending manifestos)
    final pendingItems = state.pendingPosts
        .map(_mapPostToChannelItem)
        .toList();

    // 3. Deduplicate
    final remoteIds = remoteItems.map((e) => e.id).toSet();
    final missingPending = pendingItems
        .where((p) => !remoteIds.contains(p.id))
        .toList();

    // 4. Paint the screen!
    state = state.copyWith(
      channelItems: [...missingPending, ...remoteItems],
      isLoading: false,
    );
  }

  /// Query SQLite for any posts that haven't reached the server yet
  Future<void> _loadPending() async {
    final pendingRaw = await ChartNativeDB.instance.getPendingPosts(channelId);
    final pendingEntities = pendingRaw
        .map((json) => PostEntity.fromMap(json))
        .toList();

    state = state.copyWith(pendingPosts: pendingEntities);
    _updateUIState(); // 👑 Sync UI here!
  }

  /// 👑 BACKGROUND PERSIST: Silently write fresh Supabase posts to new dual SQLite tables.
  /// This is what makes cold-start offline work — next launch reads from here instead of waiting for network.
  Future<void> _persistToNativeDB(List<PostEntity> posts) async {
    try {
      final db = await ChartNativeDB.instance.database;
      final batch = db.batch();

      for (final post in posts) {
        debugPrint('💾 [SQLite Sync] Persisting MANIFESTO: ${post.id}');
        batch.insert('manifestos', {
          'id': post.id,
          'author_id': post.authorId,
          'username': post.authorUsername,
          'profile_image_url': post.authorAvatarUrl,
          'channel_id': channelId,
          'caption': post.caption,
          'video_url': post.videoUrl,
          'image_urls': jsonEncode(post.imageUrls),
          'thumbnail_urls': jsonEncode(post.thumbnailUrls),
          'likes': post.likes,
          'comments': post.comments,
          'created_at': post.createdAt.toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
      debugPrint('💾 [SQLite Sync] Synchronized ${posts.length} items.');

      // 👑 ROLLING CACHE: Quietly trim the DB so it never bloats over time.
      // Fire-and-forget: runs in background, never blocks the UI.
      ChartNativeDB.instance.globalCacheSweep();
    } catch (e) {
      debugPrint('⚠️ [SQLite Sync] Error: $e');
    }
  }

  /// Force a refresh of pending posts (called after a new post is created)
  void notifyPostCreated() {
    _loadPending();
  }

  /// 🚀 INSTANT UI: Injects a new post at the top of the feed instantly before server confirms
  void injectOptimisticPost(PostEntity newPost) {
    // 👑 THE FIX: Convert to the new Strict UI model
    final newItem = _mapPostToChannelItem(newPost);

    state = state.copyWith(
      pendingPosts: [newPost, ...state.pendingPosts],
      channelItems: [
        newItem,
        ...state.channelItems,
      ], // ✅ UI WILL NOW SEE THIS INSTANTLY
    );
  }

  /// 👑 OPTIMISTIC UI: Toggle Like instantly, then save to C++ DB and Cloud
  void toggleLike(String itemId, bool isManifesto, {bool isLiked = true}) async {
    final int change = isLiked ? 1 : -1;
    // 1. Instantly update the UI state
    final updatedChannelItems = state.channelItems.map((item) {
      if (item.id == itemId) {
        if (item is ManifestoItem) {
          return ManifestoItem(
            id: item.id,
            authorUsername: item.authorUsername,
            authorAvatarUrl: item.authorAvatarUrl,
            createdAt: item.createdAt,
            caption: item.caption,
            imageUrls: item.imageUrls,
            videoUrl: item.videoUrl,
            commentCount: item.commentCount,
            originalPost: item.originalPost,
            likes: (item.likes + change).clamp(0, 999999), 
          );
        } else if (item is ChannelCommentItem) {
          return ChannelCommentItem(
            id: item.id,
            authorUsername: item.authorUsername,
            authorAvatarUrl: item.authorAvatarUrl,
            createdAt: item.createdAt,
            message: item.message,
            manifestoId: item.manifestoId,
            originalPost: item.originalPost,
            likes: (item.likes + change).clamp(0, 999999), 
          );
        }
      }
      return item;
    }).toList();

    state = state.copyWith(channelItems: updatedChannelItems);

    // 2. Instantly update the Local C++ SQLite DB so it survives a restart
    final table = isManifesto ? 'manifestos' : 'manifesto_comments';
    final db = await ChartNativeDB.instance.database;
    final operator = isLiked ? '+' : '-';
    await db.rawUpdate('UPDATE $table SET likes = MAX(0, likes $operator 1) WHERE id = ?', [
      itemId,
    ]);

    // 3. 👑 SMART RPC: Supabase finds the ID across all tables automatically
    try {
      debugPrint('👍 LIKING post (Change: $change): $itemId');
      final supabase = Supabase.instance.client;
      await supabase.rpc(
        'increment_like',
        params: {
          'target_id': itemId, 
          'change_amount': change, // 👑 PASS THE +1 OR -1 HERE!
        },
      );
    } catch (e) {
      debugPrint('⚠️ Network fail on like: $e'); // UI stays optimistic
    }
  }

  /// 👑 THE TRIPLE WIPE: Deletes from UI, SQLite, and Supabase
  Future<void> deleteItem(String itemId, bool isManifesto) async {
    final table = isManifesto ? 'manifestos' : 'manifesto_comments';
    final previousState = state;
    
    String? parentManifestoId;

    // 1. 🔍 PRE-FLIGHT: If deleting a comment, find its parent Manifesto ID first
    if (!isManifesto) {
      try {
        final targetComment = state.channelItems.firstWhere(
          (item) => item.id == itemId && item is ChannelCommentItem
        ) as ChannelCommentItem;
        parentManifestoId = targetComment.manifestoId;
      } catch (_) {} // Ignored if not found in current UI state
    }

    // 2. ⚡ UI HIDE & DECREMENT (Optimistic)
    final updatedItems = state.channelItems
        .where((item) => item.id != itemId) // Remove the item itself
        .map((item) {
          // If we found the parent manifesto, aggressively update its counter
          if (item is ManifestoItem && item.id == parentManifestoId) {
            return ManifestoItem(
              id: item.id,
              authorUsername: item.authorUsername,
              authorAvatarUrl: item.authorAvatarUrl,
              createdAt: item.createdAt,
              likes: item.likes,
              originalPost: item.originalPost,
              caption: item.caption,
              imageUrls: item.imageUrls,
              videoUrl: item.videoUrl,
              commentCount: (item.commentCount - 1).clamp(0, 999999), // ➖ UI DECREMENT
            );
          }
          return item;
        }).toList();

    state = state.copyWith(
      channelItems: updatedItems,
      remotePosts: state.remotePosts.where((p) => p.id != itemId && p.linkedPostId != itemId).toList(),
      pendingPosts: state.pendingPosts.where((p) => p.id != itemId).toList(),
    );

    try {
      // 3. 💾 SQLite WIPE & DECREMENT
      final db = await ChartNativeDB.instance.database;
      await db.delete(
        table, 
        where: 'id = ?', 
        whereArgs: [itemId]
      );
      
      if (parentManifestoId != null) {
        ChartNativeDB.instance.decrementManifestoCommentCount(parentManifestoId);
      }

      // 4. ☁️ SUPABASE WIPE
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from(table)
          .delete()
          .eq('id', itemId)
          .select();

      if (response.isEmpty) {
        throw Exception("Delete rejected by server (Permission or ID mismatch)");
      }
      debugPrint('✅ [Supabase] Permanent wipe confirmed for: $itemId');
    } catch (e) {
      debugPrint('🛑 [Delete Error] $e');
      state = previousState; // 🔄 ROLLBACK
    }
  }

  @override
  void dispose() {
    _subscription?.cancel(); // 🛑 Always clean up the stream
    super.dispose();
  }
}

final channelFeedProvider =
    StateNotifierProvider.autoDispose.family<ChannelFeedNotifier, ChannelFeedState, String>(
      (ref, channelId) {
        final repo = ref.watch(feedRepositoryProvider);
        return ChannelFeedNotifier(repo, channelId);
      },
    );
