import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'channelmemberdata/comment_card/media/comment_media_type.dart';
import '../../core/theme/theme_provider.dart';
import 'channelmemberdata/manifesto_card.dart';
import '../newinsidechartstartpage/widgets/pagination_indicators.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/channel/application/channel_feed_provider.dart';
import 'package:crown/features/feed/application/feed_navigator.dart';
import 'package:crown/mainFeed/features/cardwidgets/models/channel_post_model.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:crown/features/channel/domain/entities/channel_item.dart';
import 'package:crown/features/channel/pages/widgets/channelinfosheet/widgets/videoviewer/video_viewer_page.dart';
import 'package:crown/features/channel/pages/widgets/channelinfosheet/widgets/imageviewer/image_viewer_page.dart';
import '../../mainFeed/features/cardwidgets/storychacrdwidget/status_page.dart';
import '../../profile/pages/profile_page.dart';
import 'channelmemberdata/manifesto_comments_sheet.dart';
import '../../posting/application/posting_progress_provider.dart';

class MessagesSection extends ConsumerStatefulWidget {
  final String? initialMessageId;
  final String? targetMemberId;
  final String? channelId;
  final ScrollController? scrollController;
  final Widget? headerWidget;

  const MessagesSection({
    super.key,
    this.initialMessageId,
    this.targetMemberId,
    this.channelId,
    this.scrollController,
    this.headerWidget,
  });

  @override
  ConsumerState<MessagesSection> createState() => _MessagesSectionState();
}

class _MessagesSectionState extends ConsumerState<MessagesSection> {
  late final PagingController<int, ChannelItem> _pagingController;
  final Map<String, GlobalKey> _postKeys = {}; // 👑 THE POST REGISTRY

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, ChannelItem>(
      fetchPage: (pageKey) async {
        await ref
            .read(channelFeedProvider(widget.channelId ?? 'general').notifier)
            .loadMore();
        return [];
      },
      getNextPageKey: (state) {
        final feedState = ref.read(
          channelFeedProvider(widget.channelId ?? 'general'),
        );
        return feedState.hasMore ? feedState.page : null;
      },
    );

    // 👑 SYNC IMMEDIATELY: If the state is already loaded (cached),
    // tell the controller to stop spinning right now.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPagingState());
  }

  void _syncPagingState() {
    if (!mounted) return;
    final feedState = ref.read(
      channelFeedProvider(widget.channelId ?? 'general'),
    );

    // Log for debugging
    debugPrint(
      '🕒 [MessagesSection] Manual Sync: isLoading=${feedState.isLoading}, hasData=${feedState.channelItems.isNotEmpty}',
    );

    // 👑 MANIFESTO-ONLY VIEW: Filter the list before giving it to the controller
    final manifestos = feedState.channelItems
        .whereType<ManifestoItem>()
        .toList();

    _pagingController.value = PagingState(
      pages: manifestos.isNotEmpty ? [manifestos] : [],
      keys: manifestos.isNotEmpty ? [1] : [],
      hasNextPage: feedState.hasMore,
      isLoading: feedState.isLoading,
      error: feedState.error,
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  ChannelPostModel _mapEntityToLegacy(PostEntity post) {
    return ChannelPostModel(
      id: post.id,
      username: post.authorUsername,
      userProfileImageUrl: post.authorAvatarUrl ?? '',
      channelName: post.channelName,
      channelId: post.channelId,
      imageUrls: post.imageUrls,
      videoUrl: post.videoUrl,
      isVideo: post.isVideo,
      audioUrl: post.audioUrl,
      isAudio: post.isAudio,
      isText: !post.isVideo && !post.isAudio && post.imageUrls.isEmpty,
      thumbnailLinkUrl: post.authorAvatarUrl,
      aspectRatio: post.aspectRatio ?? 1.0,
      caption: post.caption,
      likes: post.likes,
      comments: post.comments,
      timeAgo: 'Just now',
    );
  }

  void _handleLinkTap(PostEntity post) {
    if (post.linkedPostId == null) return;

    final feedState = ref.read(
      channelFeedProvider(widget.channelId ?? 'general'),
    );
    final linkedIndex = feedState.allPosts.indexWhere(
      (p) => p.id == post.linkedPostId,
    );

    // 🏷️ ROUTING DNA: Compare IDs to see if we stay or go!
    final currentId = widget.channelId ?? 'general';
    final targetChannelId = post.linkedChannelId ?? currentId;
    final isLocal = targetChannelId == currentId;

    if (isLocal && linkedIndex != -1) {
      // 👑 OPTION A: PINPOINT SCROLL (Local to this list)
      final key = _postKeys[post.linkedPostId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(
            milliseconds: 600,
          ), // Slightly slower for better UX
          curve: Curves.easeOutCubic,
          alignment: 0.1,
        );
      } else if (widget.scrollController != null) {
        // 🧪 PRECISE ESTIMATION: Start Padding (80.h) + Index * Avg height (480.h)
        // With reverse: true, messages start from the bottom (offset 0).
        final startPadding = 80.0.h;
        final estimatedOffset = startPadding + (linkedIndex * 480.0.h);

        widget.scrollController!.animateTo(
          estimatedOffset.clamp(
            0,
            widget.scrollController!.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // 👑 OPTION B: GLOBAL ROUTIER (Delegated to FeedNavigator)
      // Handles cases where post is in different channel OR it's too deep in
      // the current channel to have been loaded yet.
      FeedNavigator.handleLinkTap(
        context,
        post,
        feedState.allPosts,
        widget.scrollController,
      );
    }
  }

  /// 👑 SMART MEDIA NAVIGATOR: Decides between Full-Screen Image Viewer or Post Detail
  void _handleMediaTap(
    PostEntity post,
    CommentMediaType mediaType,
    int initialIndex,
  ) {
    if (mediaType == CommentMediaType.image && post.imageUrls.isNotEmpty) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ImageViewerPage(
                imageUrls: post.imageUrls,
                initialIndex: initialIndex,
                likes: post.likes,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // 👑 FROM THE BOTTOM
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    } else if (mediaType == CommentMediaType.video) {
      // 🎥 IMMERSIVE VIDEO VIEWER (APPROVED)
      final feedState = ref.read(
        channelFeedProvider(widget.channelId ?? 'general'),
      );

      // Filter for all videos in current feed
      final allVideos = feedState.remotePosts.where((p) => p.isVideo).toList();
      final localIndex = allVideos.indexWhere((v) => v.id == post.id);

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              VideoViewerPage(
                initialVideos: allVideos,
                initialIndex: localIndex != -1 ? localIndex : 0,
                channelId: widget.channelId,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // FROM BOTTOM
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    } else {
      final feedState = ref.read(
        channelFeedProvider(widget.channelId ?? 'general'),
      );
      FeedNavigator.openPostDetail(
        context,
        post,
        feedState.remotePosts, // Pass the entities, not items
        _mapEntityToLegacy,
      );
    }
  }

  void _handleAvatarNavigation(ChannelItem item) {
    if (item.authorHasStatus) {
      // 🚀 1. If user has a new Status, open the Status Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StatusPage(
            username: item.authorUsername,
            userProfileImageUrl:
                item.authorAvatarUrl ??
                'https://picsum.photos/seed/user${item.authorUsername.hashCode}/100',
            // 👑 Dynamic Status Image logic or placeholder
            statusImageUrl:
                'https://picsum.photos/seed/status${item.id}/800/1200',
            isChartable: true,
            isPublic: true,
          ),
        ),
      );
    } else {
      // 👤 2. Else, open the Profile Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProfilePage(userId: item.originalPost?.authorId ?? 'unknown'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 UI Sync logic
    final currentColor = legacy_provider.Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).currentColor;
    final feedState = ref.watch(
      channelFeedProvider(widget.channelId ?? 'general'),
    );
    final currentUser = ref.watch(authControllerProvider).user;

    ref.listen(channelFeedProvider(widget.channelId ?? 'general'), (
      previous,
      next,
    ) {
      if (!mounted) return;

      // 👑 MANIFESTO-ONLY VIEW: Skip comments in the main scrolling feed
      final manifestos = next.channelItems.whereType<ManifestoItem>().toList();

      _pagingController.value = PagingState(
        pages: manifestos.isNotEmpty ? [manifestos] : [],
        keys: manifestos.isNotEmpty ? [1] : [],
        hasNextPage: next.hasMore,
        isLoading: next.isLoading,
        error: next.error,
      );
    });

    // 👑 WRAPPED IN SLIVER MAIN AXIS GROUP!
    return SliverMainAxisGroup(
      slivers: [
        // 💬 1. The Messages List
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: PagedSliverList<int, ChannelItem>(
            // 👑 REVERTED TO YOUR CUSTOM PARAMETERS!
            state: _pagingController.value,
            fetchNextPage: _pagingController.fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate<ChannelItem>(
              itemBuilder: (context, ChannelItem item, index) {
                // 🛑 SAFETY: Ensure we only render Manifestos in the main feed
                if (item is! ManifestoItem) return const SizedBox.shrink();
                final m = item;
                final post = m.originalPost!;

                CommentMediaType mediaType = CommentMediaType.text;
                if (post.postType == 'poll' || post.postType == 'crown') {
                  mediaType = CommentMediaType.poll;
                } else if (post.isVideo &&
                    (post.videoUrls.isNotEmpty ||
                     (post.videoUrl != null && post.videoUrl!.isNotEmpty))) {
                  mediaType = CommentMediaType.video;
                } else if (post.isAudio &&
                    post.audioUrl != null &&
                    post.audioUrl!.isNotEmpty) {
                  mediaType = CommentMediaType.audio;
                } else if (post.imageUrls.isNotEmpty) {
                  mediaType = CommentMediaType.image;
                }

                // 👑 WATCH POSTING PROGRESS
                final isPending = post.isPending == 1;
                final uploadProgress = isPending 
                    ? ref.watch(postingProgressProvider(post.id)) 
                    : null;

                return Padding(
                  key: ValueKey(post.id),
                  padding: EdgeInsets.only(
                    top: index == 0 ? 12.0.h : 0,
                    bottom: 12.0.h,
                  ),
                  child: ManifestoCard(
                    memberName: m.authorUsername,
                    messageText: m.caption,
                    // 👑 Images use attachmentUrls, videos use videoUrls
                    attachmentUrls: m.imageUrls,
                    videoUrls: post.videoUrls.isNotEmpty
                        ? post.videoUrls
                        : (post.videoUrl != null && post.videoUrl!.isNotEmpty
                            ? [post.videoUrl!]
                            : []),
                    thumbnailUrls: post.thumbnailUrls,
                    commentMediaType: mediaType,
                    likes: m.likes,
                    comments: m.commentCount,
                    outlineColor: currentColor,
                    referenceId: m.id,
                    quotedPost: post.linkedPostId != null
                        ? QuotedPost(
                            id: post.linkedPostId!,
                            username: post.linkedAuthorUsername ?? 'Original',
                            text: post.linkedCaption ?? 'Shared Media',
                            mediaUrl: post.thumbnailUrls.isNotEmpty
                                ? post.thumbnailUrls.first
                                : null,
                          )
                        : null,
                    onTapMedia: (index) =>
                        _handleMediaTap(post, mediaType, index),
                    onTapThumbnail: () => _handleLinkTap(post),
                    channelId: widget.channelId ?? 'general',
                    channelName: (widget.channelId ?? 'general').toUpperCase(),
                    thumbnailUrl: post.thumbnailUrls.isNotEmpty
                        ? post.thumbnailUrls.first
                        : null,
                    isMe: post.authorId == currentUser?.id,
                    onDelete: () => ref
                        .read(
                          channelFeedProvider(
                            widget.channelId ?? 'general',
                          ).notifier,
                        )
                        .deleteItem(item.id, true), // Manifesto
                    onLikeChanged: (isLiked) => ref
                        .read(
                          channelFeedProvider(
                            widget.channelId ?? 'general',
                          ).notifier,
                        )
                        .toggleLike(item.id, true, isLiked: isLiked),
                    // 👑 DYNAMIC IDENTITY
                    avatarUrl: m.authorAvatarUrl,
                    showActiveDot: m.authorIsOnline,
                    showStatusRing: m.authorHasStatus,
                    onTapAvatar: () => _handleAvatarNavigation(m),
                    audioUrl: post.audioUrl,
                    allowComments: post.allowComments,
                    
                    // 👑 PENDING STATE
                    isPending: isPending,
                    uploadProgress: uploadProgress?.progress,
                    uploadedSize: uploadProgress?.uploadedSize,
                    totalSize: uploadProgress?.totalSize,
                    isOffline: uploadProgress?.isOffline ?? false,

                    // 👑 COMMENTER AVATARS:
                    // Look into the current feed to find the first 3 people who commented on this manifesto
                    commenterAvatars: feedState.channelItems
                        .whereType<ChannelCommentItem>()
                        .where((c) => c.manifestoId == m.id)
                        .map((c) => c.authorAvatarUrl ?? '')
                        .where((url) => url.isNotEmpty)
                        .take(3)
                        .toList(),
                    onTapCommenters: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => ManifestoCommentsSheet(
                          manifestoId: m.id,
                          channelId: widget.channelId,
                          channelName: widget.channelId?.toUpperCase(),
                          themeColor: currentColor,
                          attachmentUrls: m.imageUrls,
                          videoUrls: post.videoUrls,
                          thumbnailUrls: post.thumbnailUrls,
                          authorAvatarUrl: m.authorAvatarUrl,
                          authorUsername: m.authorUsername,
                          authorCategory: post.authorCategory,
                          initialLikes: m.likes,
                          initialComments: m.commentCount,
                        ),
                      );
                    },
                  ),
                );
              },
              // 👑 FIXED: If the list is empty, delete the "End of List" text entirely!
              noMoreItemsIndicatorBuilder: (_) {
                if (feedState.allPosts.isEmpty) return const SizedBox.shrink();
                return const EndOfListIndicator();
              },
              noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
            ),
          ),
        ),

        // 👑 2. THE HEADER WIDGET!
        if (widget.headerWidget != null)
          SliverToBoxAdapter(child: widget.headerWidget!),
      ],
    );
  }
}
