import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../feed/domain/entities/post_entity.dart';
import '../../feed/domain/repositories/feed_repository.dart';
import '../../feed/data/mappers/post_mapper.dart';
import '../../feed/application/feed_controller.dart';
import '../../../core/db/chart_native_db.dart';
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
  RealtimeChannel? _likesChannel;
  RealtimeChannel? _commentsChannel; // 👑 NEW: Real-time comment count sync

  /// 👑 LOCK: Prevents rapid-fire clicks on the same item
  final Set<String> _processingIds = {};

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
        // 👑 PRESERVE ALL FIELDS while updating count
        return ManifestoItem(
          id: item.id,
          authorUsername: item.authorUsername,
          authorAvatarUrl: item.authorAvatarUrl,
          authorIsOnline: item.authorIsOnline,
          authorHasStatus: item.authorHasStatus,
          createdAt: item.createdAt,
          likes: item.likes,
          isLiked: item.isLiked, // 💖 KEEP THE HEART FILLED
          originalPost: item.originalPost,
          caption: item.caption,
          imageUrls: item.imageUrls,
          videoUrl: item.videoUrl,
          commentCount: item.commentCount + 1, // 🚀 The Increment!
          aspectRatio: item.aspectRatio,
          taggerName: item.taggerName,
          taggerAvatar: item.taggerAvatar,
          sourceChannelName: item.sourceChannelName,
          sourceChannelAvatar: item.sourceChannelAvatar,
        );
      }
      if (item is ChannelCommentItem && item.id == postId) {
        return ChannelCommentItem(
          id: item.id,
          authorUsername: item.authorUsername,
          authorAvatarUrl: item.authorAvatarUrl,
          authorIsOnline: item.authorIsOnline,
          authorHasStatus: item.authorHasStatus,
          createdAt: item.createdAt,
          likes: item.likes,
          isLiked: item.isLiked,
          originalPost: item.originalPost,
          message: item.message,
          commentCount: item.commentCount + 1,
          manifestoId: item.manifestoId,
          taggerName: item.taggerName,
          taggerAvatar: item.taggerAvatar,
          sourceChannelName: item.sourceChannelName,
          sourceChannelAvatar: item.sourceChannelAvatar,
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
    ChartNativeDB.instance.incrementManifestoCommentCount(postId).catchError((
      e,
    ) {
      debugPrint(
        '🚨 [SQLite Error] Failed to increment comment count for $postId: $e',
      );
    });
  }

  void decrementCommentCount(String postId) {
    debugPrint('➖ [UI] Decrementing comment count on Manifesto: $postId');
    final updatedChannelItems = state.channelItems.map((item) {
      if (item is ManifestoItem && item.id == postId) {
        return ManifestoItem(
          id: item.id,
          authorUsername: item.authorUsername,
          authorAvatarUrl: item.authorAvatarUrl,
          authorIsOnline: item.authorIsOnline,
          authorHasStatus: item.authorHasStatus,
          createdAt: item.createdAt,
          likes: item.likes,
          isLiked: item.isLiked,
          originalPost: item.originalPost,
          caption: item.caption,
          imageUrls: item.imageUrls,
          videoUrl: item.videoUrl,
          commentCount: (item.commentCount - 1).clamp(0, 999999),
          aspectRatio: item.aspectRatio,
          taggerName: item.taggerName,
          taggerAvatar: item.taggerAvatar,
          sourceChannelName: item.sourceChannelName,
          sourceChannelAvatar: item.sourceChannelAvatar,
        );
      }
      if (item is ChannelCommentItem && item.id == postId) {
        return ChannelCommentItem(
          id: item.id,
          authorUsername: item.authorUsername,
          authorAvatarUrl: item.authorAvatarUrl,
          authorIsOnline: item.authorIsOnline,
          authorHasStatus: item.authorHasStatus,
          createdAt: item.createdAt,
          likes: item.likes,
          isLiked: item.isLiked,
          originalPost: item.originalPost,
          message: item.message,
          commentCount: (item.commentCount - 1).clamp(0, 999999),
          manifestoId: item.manifestoId,
          taggerName: item.taggerName,
          taggerAvatar: item.taggerAvatar,
          sourceChannelName: item.sourceChannelName,
          sourceChannelAvatar: item.sourceChannelAvatar,
        );
      }
      return item;
    }).toList();

    final updatedRemote = state.remotePosts
        .map(
          (p) => p.id == postId
              ? p.copyWith(comments: (p.comments - 1).clamp(0, 999999))
              : p,
        )
        .toList();

    state = state.copyWith(
      channelItems: updatedChannelItems,
      remotePosts: updatedRemote,
    );
  }

  // 👑 HELPER: Bridges the gap between old entities and new UI items
  ChannelItem _mapPostToChannelItem(PostEntity post) {
    final map = {
      'id': post.id,
      'author_id': post.authorId,
      'username': post.authorUsername,
      'profile_image_url': post.authorAvatarUrl,
      'likes': post.likes,
      'comments': post.comments,
      'shares': post.shares,
      'tags_count': post.tagsCount,
      'caption': post.caption,
      'message': post.caption,
      'image_urls': post.imageUrls,
      'video_url': post.videoUrl,
      'aspect_ratio': post.aspectRatio,
      'created_at': post.createdAt.toIso8601String(),
      'post_type': post.postType,
      'is_liked': post.isLiked,
      'tagger_name': post.taggerName,
      'tagger_avatar': post.taggerAvatar,
      'source_channel_name': post.sourceChannelName,
      'source_channel_avatar': post.sourceChannelAvatar,
    };

    if (post.postType == 'invitation') {
      return InvitationItem.fromMap(map, originalPost: post);
    }

    bool isManifesto =
        post.postType == 'manifesto' ||
        post.postType == 'channel' ||
        (post.postType == 'post' &&
            post.linkedPostId == null &&
            post.parentPostId == null &&
            post.linkDepth == 0);

    if (isManifesto) {
      return ManifestoItem.fromMap(map, originalPost: post);
    } else {
      return ChannelCommentItem.fromMap(map, originalPost: post);
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
          '🚨 [Offline-First Error] Local fetch FAILED for $channelId: $failure',
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
            final shortCaption = p.caption.length > 20
                ? '${p.caption.substring(0, 20)}...'
                : p.caption;
            debugPrint(
              '   ├─ Post: ${p.id} (Type: ${p.postType}, Caption: $shortCaption)',
            );
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

    // 4. 👑 PERSONAL SYNC: Listens for our own likes/unlikes on other devices
    _initLikesSync();
    _initCommentCountSync();

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
            final existingIndex = state.remotePosts.indexWhere(
              (p) => p.id == patchedPost.id,
            );

            if (existingIndex != -1) {
              debugPrint(
                '🔄 [DELTA UPDATE] Patching existing post ${patchedPost.id} (Likes: ${patchedPost.likes})',
              );
              // 👑 PRESERVE LOCAL STATE: Don't let a generic server update wipe out our "isLiked" status
              final existingPost = state.remotePosts[existingIndex];
              final mergedPost = patchedPost.copyWith(
                isLiked: existingPost.isLiked, // Keep what we have in UI
              );

              // Update the post in remotePosts
              final newRemote = [...state.remotePosts];
              newRemote[existingIndex] = mergedPost;

              // Re-map to channelItems to reflect the change (likes, comments, etc)
              state = state.copyWith(remotePosts: newRemote);
              _updateUIState();
              return;
            }

            // 👑 PENDING PROMOTION: If this is our own optimistic post coming back
            // from the server, move it from pendingPosts → remotePosts so the
            // pending overlay clears and the post stays in its correct position.
            final isPendingPromotion = state.pendingPosts.any(
              (p) => p.id == patchedPost.id,
            );

            if (isPendingPromotion) {
              debugPrint(
                '✅ [DELTA] Promoting pending → confirmed: ${patchedPost.id}',
              );
              final newPending = state.pendingPosts
                  .where((p) => p.id != patchedPost.id)
                  .toList();
              // Insert into remotePosts at the correct chronological position
              final newRemote = [patchedPost, ...state.remotePosts];
              // Rebuild channelItems from scratch so ordering is correct
              final remoteItems = newRemote.map(_mapPostToChannelItem).toList();
              final pendingItems = newPending
                  .map(_mapPostToChannelItem)
                  .toList();
              final remoteIds = remoteItems.map((e) => e.id).toSet();
              final missingPending = pendingItems
                  .where((p) => !remoteIds.contains(p.id))
                  .toList();
              state = state.copyWith(
                pendingPosts: newPending,
                remotePosts: newRemote,
                channelItems: [...missingPending, ...remoteItems],
              );
              return;
            }

            // 🚀 SURGICAL INJECTION: Direct mapping to the correct UI item type
            debugPrint(
              '🚀 [DELTA] Direct injection of ${patchedPost.postType}: ${patchedPost.id}',
            );

            final newItem = _mapPostToChannelItem(patchedPost);

            state = state.copyWith(
              remotePosts: [patchedPost, ...state.remotePosts],
              channelItems: [newItem, ...state.channelItems],
            );
          },
          onError: (err) {
            debugPrint(
              '🚨 [Supabase Realtime Error] Delta stream failed for $channelId: $err',
            );
            if (err is PostgrestException) {
              debugPrint('   ├─ Message: ${err.message}');
              debugPrint('   ├─ Code: ${err.code}');
              debugPrint('   └─ Details: ${err.details}');
            }
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
      return rawPost.copyWith(
        // Enhance with cached profile data
        authorUsername: cached.authorUsername,
        authorDisplayName: cached.authorDisplayName,
        authorAvatarUrl: cached.authorAvatarUrl,
        authorTitle: cached.authorTitle,
      );
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
          debugPrint(
            '⚠️ [ChannelFeedNotifier] Network Sync Failed for $channelId: $failure',
          );
          debugPrint(
            '🕒 [ChannelFeedNotifier] refresh: network failed. setting isLoading=false',
          );
          state = state.copyWith(isLoading: false); // 👑 KILL SPINNER
        },
        (posts) async {
          // 👑 MERGE: Preserve 'isLiked' state from our current memory if Supabase returns false.
          // This ensures the heart stays filled even if the network join is flaky or hasn't synced yet.
          final mergedPosts = posts.map((newPost) {
            final existing = state.remotePosts.firstWhere(
              (p) => p.id == newPost.id,
              orElse: () => newPost,
            );

            // If we already know it's liked locally, keep it liked!
            if (existing.isLiked && !newPost.isLiked) {
              return newPost.copyWith(isLiked: true);
            }
            return newPost;
          }).toList();

          // 👑 WARM THE PROFILE CACHE from fresh results.
          for (final p in mergedPosts) {
            if (p.authorUsername.isNotEmpty && p.authorUsername != 'unknown') {
              _profileCache[p.authorId] = p;
            }
          }

          debugPrint(
            '🕒 [ChannelFeedNotifier] refresh: network success. setting isLoading=false',
          );
          state = state.copyWith(
            remotePosts: mergedPosts,
            isLoading: false, // 👑 KILL SPINNER
            hasMore: mergedPosts.length >= 10,
            page: 2,
          );

          _updateUIState(); // 👑 Sync UI here so the network data appears!

          // 👑 PERSIST: Save the merged truth to SQLite.
          // We use insertOrReplace so stale rows are updated in-place.
          // We do NOT clear first — that was wiping the correct isLiked state.
          _persistToNativeDB(mergedPosts);
        },
      );
    } catch (e) {
      debugPrint('🚨 [CRITICAL] Refresh Error for $channelId: $e');
      if (e is PostgrestException) {
        debugPrint('   ├─ Table: channel_feed_view');
        debugPrint('   ├─ Message: ${e.message}');
        debugPrint('   └─ Hint: ${e.hint}');
      }
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      debugPrint(
        '📡 [Pagination] Fetching more for channel: $channelId, page: ${state.page}',
      );
      final result = await _repository.getChannelPosts(
        channelId,
        page: state.page,
      );

      result.fold(
        (failure) {
          debugPrint('⚠️ [ChannelFeedNotifier] loadMore failed: $failure');
          state = state.copyWith(
            isLoading: false,
            error: 'No internet connection. Please try again.',
          );
        },
        (posts) {
          // 👑 MERGE: Preserve 'isLiked' state during pagination too!
          final mergedNewPosts = posts.map((newPost) {
            final existing = state.remotePosts.firstWhere(
              (p) => p.id == newPost.id,
              orElse: () => newPost,
            );
            if (existing.isLiked && !newPost.isLiked) {
              return newPost.copyWith(isLiked: true);
            }
            return newPost;
          }).toList();

          debugPrint(
            '🕒 [ChannelFeedNotifier] loadMore success. loaded ${posts.length} new posts',
          );
          state = state.copyWith(
            remotePosts: [...state.remotePosts, ...mergedNewPosts],
            isLoading: false,
            hasMore: posts.length >= 10,
            page: state.page + 1,
            error: null,
          );

          _updateUIState();
        },
      );
    } catch (e) {
      debugPrint('🚨 [ChannelFeedNotifier] Critical loadMore Error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Connection lost. Please try again.',
      );
      _updateUIState();
    }
  }

  /// 👑 INSTANT UI MERGER: Maps our memory state directly to the strict UI classes
  void _updateUIState() {
    // 1. Map whatever we got from the network (Source: channel_feed_view)
    final remoteItems = state.remotePosts.map(_mapPostToChannelItem).toList();

    // 2. Map whatever is pending locally (Source: SQLite pending manifestos)
    final pendingItems = state.pendingPosts.map(_mapPostToChannelItem).toList();

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

  /// 👑 BACKGROUND PERSIST: Silently write fresh Supabase posts to the
  /// channel_posts SQLite table — the same table _initOfflineFirst reads from.
  /// This makes cold-start offline work: next launch reads from here instead
  /// of waiting for the network.
  Future<void> _persistToNativeDB(List<PostEntity> posts) async {
    try {
      final List<Map<String, dynamic>> items = posts
          .map(
            (post) => {
              'id': post.id,
              'authorId': post.authorId,
              'username': post.authorUsername,
              'profileImageUrl': post.authorAvatarUrl,
              'channelId': channelId,
              'caption': post.caption,
              'videoUrl': post.videoUrl,
              'imageUrls': post.imageUrls,
              'thumbnailUrls': post.thumbnailUrls,
              'likes': post.likes,
              'comments': post.comments,
              'aspectRatio': post.aspectRatio,
              'createdAt': post.createdAt.toIso8601String(),
              'isLiked': post.isLiked
                  ? 1
                  : 0, // 👑 persists server-resolved state
              'videoUrls': post.videoUrls,
              'taggerName': post.taggerName,
              'taggerAvatar': post.taggerAvatar,
              'sourceChannelName': post.sourceChannelName,
              'sourceChannelAvatar': post.sourceChannelAvatar,
              'tagsCount': post.tagsCount,
              'metadata': post.metadata,
              'postType': post.postType,
            },
          )
          .toList();

      // 👑 FIX: Write to channel_posts (same table _initOfflineFirst reads from)
      await ChartNativeDB.instance.cacheChannelPosts(items);
      debugPrint(
        '💾 [SQLite Sync] Synchronized ${posts.length} items to channel_posts.',
      );

      // 👑 ROLLING CACHE: Keeps only the newest 10 posts on disk.
      await ChartNativeDB.instance.trimChannelPosts(
        channelId: channelId,
        keepCount: 10,
      );

      ChartNativeDB.instance.globalCacheSweep();
    } catch (e) {
      debugPrint('⚠️ [SQLite Sync] Error: $e');
    }
  }

  /// Force a refresh of pending posts (called after a new post is created)
  void notifyPostCreated() {
    _loadPending();
  }

  /// 👑 PERSONAL SYNC: Listens for our own likes/unlikes on other devices
  void _initLikesSync() {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final filterKey = 'likes_sync_$userId';
    debugPrint('📡 [LIKE SYNC] Subscribing to likes for user: $userId');

    _likesChannel = supabase
        .channel('public:channel_post_likes:$filterKey')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'channel_post_likes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final postId =
                (payload.newRecord['post_id'] ?? payload.oldRecord['post_id'])
                    as String?;
            if (postId == null) return;

            final isLiked = payload.eventType != PostgresChangeEvent.delete;
            debugPrint(
              '❤️ [LIKE SYNC] ${isLiked ? "Liking" : "Unliking"} $postId (Event: ${payload.eventType})',
            );

            // Update state instantly
            final updatedRemote = state.remotePosts.map((p) {
              if (p.id == postId) return p.copyWith(isLiked: isLiked);
              return p;
            }).toList();

            state = state.copyWith(remotePosts: updatedRemote);
            _updateUIState();
          },
        );

    _likesChannel?.subscribe((status, [error]) {
      debugPrint('📡 [LIKE SYNC] Status: $status');
      if (error != null) debugPrint('🚨 [LIKE SYNC Error] $error');
    });
  }

  /// 💬 REAL-TIME COMMENT COUNT SYNC
  /// Subscribes to inserts on channel_post_comment_counts for this channel.
  /// When a new row arrives, the count on the matching post increments instantly.
  void _initCommentCountSync() {
    final supabase = Supabase.instance.client;
    debugPrint('📡 [COMMENT SYNC] Subscribing for channel: $channelId');

    _commentsChannel = supabase
        .channel('comment_counts:$channelId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'channel_post_comment_counts',
          callback: (payload) {
            final postId = payload.newRecord['post_id'] as String?;
            if (postId == null) return;

            debugPrint('💬 [COMMENT SYNC] New comment on post: $postId');
            incrementCommentCount(postId);
          },
        )
        .subscribe((status, [error]) {
          debugPrint('📡 [COMMENT SYNC] Status: $status');
          if (error != null) debugPrint('🚨 [COMMENT SYNC Error] $error');
        });
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
  void toggleLike(
    String itemId,
    bool isManifesto, {
    bool isLiked = true,
  }) async {
    // 👑 0. DEBOUNCE: Stop if we are already processing this specific item
    if (_processingIds.contains(itemId)) {
      debugPrint('⏳ [LOCK] Still processing like for $itemId, ignoring click.');
      return;
    }
    _processingIds.add(itemId);

    // 👑 1. SYNC BOTH: Update UI Items AND Remote Posts simultaneously
    // This prevents the "Realtime Snap-back" where the UI reverts to old counts.
    bool currentIsLiked = false;

    final updatedRemote = state.remotePosts.map((p) {
      if (p.id == itemId) {
        currentIsLiked = !p.isLiked;
        final change = currentIsLiked ? 1 : -1;
        return p.copyWith(
          isLiked: currentIsLiked,
          likes: (p.likes + change).clamp(0, 999999),
        );
      }
      return p;
    }).toList();

    state = state.copyWith(remotePosts: updatedRemote);
    _updateUIState(); // This instantly pushes the changes to the UI items

    // 2. Instantly update the Local C++ SQLite DB so it survives a restart
    ChartNativeDB.instance
        .toggleLike(itemId, isManifesto, isLiked: currentIsLiked)
        .then((_) {
          debugPrint('💾 [SQLite] Toggle Like success for $itemId');
        })
        .catchError((e) {
          debugPrint('🚨 [SQLite Error] Toggle like failed for $itemId: $e');
        });

    // 3. 👑 SMART RPC: Toggles Like/Unlike and handles counters
    try {
      debugPrint('👍 [Supabase] TOGGLE Like for $itemId');
      final supabase = Supabase.instance.client;
      final response = await supabase.rpc(
        'toggle_channel_post_like',
        params: {'target_post_id': itemId},
      );

      if (response is Map) {
        final newIsLiked = response['is_liked'] as bool;
        final newLikes = response['new_likes'] as int;
        debugPrint(
          '☁️ [Supabase] Toggle success for $itemId: isLiked=$newIsLiked, likes=$newLikes',
        );
      }
    } catch (e) {
      debugPrint('🚨 [Supabase Error] Network fail on like for $itemId: $e');
      if (e is PostgrestException) {
        debugPrint('   ├─ Message: ${e.message}');
        debugPrint('   ├─ Code: ${e.code}');
        debugPrint('   └─ Hint: ${e.hint}');
      }
    } finally {
      // 👑 UNLOCK: Allow the next click after a short cool-down
      Future.delayed(const Duration(milliseconds: 500), () {
        _processingIds.remove(itemId);
      });
    }
  }

  /// 👑 THE TRIPLE WIPE: Deletes from UI, SQLite, and Supabase
  Future<void> deleteItem(String itemId, bool isManifesto) async {
    final table = isManifesto ? 'channel_posts' : 'channel_post_comments';
    final previousState = state;

    String? parentManifestoId;

    // 1. 🔍 PRE-FLIGHT: If deleting a comment, find its parent Manifesto ID first
    if (!isManifesto) {
      try {
        final targetComment =
            state.channelItems.firstWhere(
                  (item) => item.id == itemId && item is ChannelCommentItem,
                )
                as ChannelCommentItem;
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
              aspectRatio: item.aspectRatio,
              commentCount: (item.commentCount - 1).clamp(
                0,
                999999,
              ), // ➖ UI DECREMENT
            );
          }
          return item;
        })
        .toList();

    state = state.copyWith(
      channelItems: updatedItems,
      remotePosts: state.remotePosts
          .where((p) => p.id != itemId && p.linkedPostId != itemId)
          .toList(),
      pendingPosts: state.pendingPosts.where((p) => p.id != itemId).toList(),
    );

    try {
      // 3. 💾 SQLite WIPE & DECREMENT
      await ChartNativeDB.instance.deleteItem(itemId, isManifesto);

      if (parentManifestoId != null) {
        ChartNativeDB.instance.decrementManifestoCommentCount(
          parentManifestoId,
        );
      }

      // 4. ☁️ SUPABASE WIPE
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from(table)
          .delete()
          .eq('id', itemId)
          .select();

      if (response.isEmpty) {
        throw Exception(
          "Delete rejected by server (Permission or ID mismatch)",
        );
      }
      debugPrint('✅ [Supabase] Permanent wipe confirmed for: $itemId');
    } catch (e) {
      debugPrint('🛑 [Delete Error] $e');
      state = previousState; // 🔄 ROLLBACK
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _likesChannel?.unsubscribe();
    _commentsChannel?.unsubscribe(); // 🛑 Clean up comment count sync
    super.dispose();
  }
}

final channelFeedProvider = StateNotifierProvider.autoDispose
    .family<ChannelFeedNotifier, ChannelFeedState, String>((ref, channelId) {
      final repo = ref.watch(feedRepositoryProvider);
      return ChannelFeedNotifier(repo, channelId);
    });
