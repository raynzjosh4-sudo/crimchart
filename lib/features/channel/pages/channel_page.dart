import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/channel/pages/video_tab/video_tab_view.dart';
import 'package:crimchart/features/allchannels/models/chart_channel.dart';
import 'package:crimchart/features/channel/channelsettings/channel_settings_page.dart';
import 'package:crimchart/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/features/newinsidechartstartpage/models/member.dart';
import 'package:crimchart/features/newinsidechartstartpage/models/chart.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/members_story_bar.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/status_widget_shimmer.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/creator_contact_bar.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/suggestion_channels_section.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/channel_end_summary.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/channel_nav_bar.dart';
import 'package:crimchart/features/channel/pages/members_tab/members_tab_view.dart';
import 'package:crimchart/features/channel/pages/messages_tab/messages_page.dart';
import 'package:crimchart/backicon/custom_back_button.dart';
import 'package:crimchart/features/channel/domain/entities/channel_item.dart';
import 'package:crimchart/posting/pages/post_page.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crimchart/commentingsheets/widgets/commenting_sheet.dart';
import 'package:crimchart/features/channel/application/channel_feed_provider.dart';
import 'package:crimchart/features/channel/application/channel_statuses_provider.dart';
import 'package:crimchart/features/channel/pages/tag/tag_overlay.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/feed_post_placeholder.dart';
import 'package:crimchart/features/widgets/channelmemberdata/thread_discussion_sheet.dart';
import 'package:crimchart/features/channel/pages/discovery_widgets/feed_post_shimmer.dart';
import 'package:crimchart/features/channel/pages/widgets/pagination_error_footer.dart';
import 'package:crimchart/features/channel/application/unread_count_provider.dart';

import 'package:crimchart/features/channel/application/channels_list_controller.dart';
import 'dart:math';

class ChannelPage extends ConsumerStatefulWidget {
  final ChartChannel? channel;
  final List<CharterModel> contestants;
  final String? initialMessageId;
  final CharterModel? focusedContestant;

  const ChannelPage({
    super.key,
    this.channel,
    this.contestants = const [],
    this.initialMessageId,
    this.focusedContestant,
  });

  @override
  ConsumerState<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends ConsumerState<ChannelPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  late final AudioRecorder _audioRecorder;
  bool _isRecording = false;
  bool _showFab = true;
  int _currentTabIndex = 0;
  late final int _randomSuggestionIndex;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _randomSuggestionIndex = Random().nextInt(3) + 2; // 2, 3, or 4

    // 👑 REFRESH CHANNEL DATA: Ensure counts (members, likes) are accurate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.channel != null) {
        ref
            .read(channelsListControllerProvider('all').notifier)
            .loadChannels(refresh: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  // ─── Time Helper ─────────────────────────────────────────────────────────────

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  // ─── Recording Logic ────────────────────────────────────────────────────────

  void _openPostPage() {
    final displayChannel = widget.channel ?? _getEmptyChannel();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostPage(
          targetChannelId: displayChannel.id,
          isManifestoContext: false,
        ),
      ),
    );
  }

  void _openStatusSheet() {
    final displayChannel = widget.channel ?? _getEmptyChannel();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentingSheet(
        channelId: displayChannel.id,
        channelName: displayChannel.title,
        isStatus: true, // 👑 New flag
      ),
    );
  }

  void _openPostCommentSheet(dynamic item) {
    final displayChannel = widget.channel ?? _getEmptyChannel();
    // 👑 Extract postId for ALL item types
    final String postId;
    if (item is ManifestoItem) {
      postId = item.id;
    } else if (item is ChannelCommentItem) {
      postId = item.id;
    } else if (item is InvitationItem) {
      postId = item.id;
    } else {
      postId = '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ThreadDiscussionSheet(
        threadId: postId,
        channelId: displayChannel.id,
        channelName: displayChannel.title,
      ),
    );
  }

  void _openTagSheet(dynamic item) {
    final displayChannel = widget.channel ?? _getEmptyChannel();

    // Extraction logic
    final String? postId = (item is ManifestoItem) ? item.id : null;
    final String? sourceChannelId = (item is ManifestoItem)
        ? (item.originalPost?.channelId)
        : (item is InvitationItem ? item.targetChannelId : null);
    final String? channelName = (item is ManifestoItem)
        ? (item.originalPost?.channelName)
        : (item is InvitationItem ? item.targetChannelName : null);

    if (postId == null) return;

    TagOverlay.show(
      context,
      postId: postId,
      sourceChannelId: sourceChannelId ?? displayChannel.id,
      linkChain: (item is ManifestoItem)
          ? (item.originalPost?.linkChain ?? [])
          : [],
      channelName: channelName ?? displayChannel.title,
    );
  }

  // 👑 EXTRACTED HEADER UI: We moved this out of the Slivers list!

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final displayChannel = widget.channel ?? _getEmptyChannel();

    bool canPostStatus =
        displayChannel.isOwnChannel ||
        displayChannel.allowStatusPostingBy == 'all' ||
        displayChannel.allowStatusPostingBy == 'joined';
    if (displayChannel.allowStatusPostingBy == 'none' &&
        !displayChannel.isOwnChannel) {
      canPostStatus = false;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent * 0.7) {
            if (_currentTabIndex == 0) {
              final notifier = ref.read(
                channelFeedProvider(displayChannel.id).notifier,
              );
              debugPrint(
                '📜 [Scroll Trigger] Near bottom (70%), calling loadMore...',
              );
              notifier.loadMore();
            }
          }
          return true;
        },
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: backgroundColor,
              surfaceTintColor: backgroundColor,
              forceElevated: true,
              elevation: 0,
              titleSpacing: 0,
              floating: _currentTabIndex != 1,
              pinned: _currentTabIndex == 1,
              snap: _currentTabIndex != 1,
              leading: CustomBackButton(
                color: colorScheme.onSurface,
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Text(
                displayChannel.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 24.sp,
                  letterSpacing: -0.5,
                ),
              ),
              actions: [
                SizedBox(width: 8.w),
                // Plus Button
                Container(
                  height: 36.w,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 22.sp,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CommentingSheet(
                          channelId: displayChannel.id,
                          channelName: displayChannel.title,
                          showInputField: true,
                          showPostSettings: true,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                // Settings Button
                Container(
                  height: 36.w,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20.sp,
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChannelSettingsPage(
                          channelId: displayChannel.id,
                          channelTitle: displayChannel.title,
                          memberCount: displayChannel.memberCount,
                          createdAt: displayChannel.createdAt,
                          staterAvatarUrl: displayChannel.imageUrl,
                          description: displayChannel.description,
                          ageRestriction: displayChannel.age_restriction,
                          visibleToOtherChannelMembers:
                              displayChannel.visibleToOtherChannelMembers,
                          visibleToFollowedUsers:
                              displayChannel.visibleToFollowedUsers,
                          joinMethod: displayChannel.joinMethod,
                          preventLeaving: displayChannel.preventLeaving,
                          countryRestrictions:
                              displayChannel.countryRestrictions,
                          allowCommentingBy: displayChannel.allowCommentingBy,
                          allowStatusPostingBy:
                              displayChannel.allowStatusPostingBy,
                          allowInvitationsBy:
                              displayChannel.allow_invitations_by ?? 'all',
                          members: widget.contestants
                              .map(
                                (c) => Member(
                                  id: c.id,
                                  name: c.displayName,
                                  avatarUrl: c.profileImageUrl,
                                  title: c.title,
                                  channelsCount: c.channelCount,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                  _currentTabIndex == 1 ? 166.h : 72.h,
                ),
                child: Container(
                  color: backgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          debugPrint('👑 [UI-V3-DNA] Nav Bar Consumer: Checking unread counts for ${displayChannel.id}...');
                          final unreadCountAsync = ref.watch(
                            unreadCountProviderV2(displayChannel.id),
                          );
                          final unreadMessages =
                              unreadCountAsync.value ??
                              displayChannel.unreadCount;
                          
                          if (unreadCountAsync.hasValue) {
                             debugPrint('👑 [UI-V3-DNA] Nav Bar: Received unread count = $unreadMessages');
                          }

                          final unreadMomentsAsync = ref.watch(
                            unreadMomentsCountProviderV2(displayChannel.id),
                          );
                          final unreadMoments = unreadMomentsAsync.value ?? 0;

                          return ChannelNavBar(
                            selectedIndex: _currentTabIndex,
                            unreadMessages: unreadMessages,
                            unreadMoments: unreadMoments,
                            totalMembers: displayChannel.memberCount,
                            onTabSelected: (index) {
                              if (index == 1) {
                                // 👑 MARK MESSAGES AS READ
                                ref.read(markAsReadProvider)(displayChannel.id);
                                // ... existing navigation ...

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    pageBuilder: (context, anim, sec) =>
                                        MessagesPage(
                                          channelId: displayChannel.id,
                                          channelName: displayChannel.title,
                                          contestants: widget.contestants,
                                          initialIsMember:
                                              displayChannel.isOwnChannel ||
                                              displayChannel.isCharted ||
                                              widget.contestants.any(
                                                (c) => c.isMe,
                                              ),
                                        ),
                                    transitionsBuilder:
                                        (context, anim, sec, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          final tween =
                                              Tween(
                                                begin: begin,
                                                end: end,
                                              ).chain(
                                                CurveTween(
                                                  curve: Curves.easeOutCubic,
                                                ),
                                              );
                                          return SlideTransition(
                                            position: anim.drive(tween),
                                            child: child,
                                          );
                                        },
                                  ),
                                );
                              } else if (index == 2) {
                                // 👑 MARK MOMENTS AS READ
                                ref.read(markMomentsAsReadProvider)(
                                  displayChannel.id,
                                );
                                setState(() => _currentTabIndex = index);
                              } else {
                                setState(() => _currentTabIndex = index);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_currentTabIndex == 0) ...[
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final statusesAsync = ref.watch(
                      channelStatusesProvider(displayChannel.id),
                    );

                    return statusesAsync.when(
                      data: (statuses) => MembersStoryBar(
                        statuses: statuses,
                        onAddStory: _openStatusSheet,
                        canPostStatus: canPostStatus,
                      ),
                      loading: () => const StatusWidgetShimmer(),
                      error: (e, st) => const SizedBox.shrink(),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: CreatorContactBar(
                  creatorName: displayChannel.staterName?.isNotEmpty == true
                      ? displayChannel.staterName!
                      : displayChannel.title,
                  creatorImageUrl:
                      displayChannel.staterAvatarUrl?.isNotEmpty == true
                      ? displayChannel.staterAvatarUrl
                      : null,
                  onMessageTap: () {},
                  onFollowTap: () {},
                  isOwnChannel: displayChannel.isOwnChannel,
                ),
              ),

              Consumer(
                builder: (context, ref, child) {
                  final feedState = ref.watch(
                    channelFeedProvider(displayChannel.id),
                  );
                  final notifier = ref.read(
                    channelFeedProvider(displayChannel.id).notifier,
                  );
                  final allChannelsState = ref.watch(
                    channelsListControllerProvider('all'),
                  );
                  final currentUserId =
                      Supabase.instance.client.auth.currentUser?.id;
                  final suggestions = allChannelsState.channels
                      .where(
                        (c) =>
                            c.id != displayChannel.id &&
                            c.creatorId != currentUserId &&
                            !c.isCharted,
                      )
                      .map((e) => Chart.fromEntity(e))
                      .toList();

                  if (feedState.isLoading && feedState.channelItems.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: const FeedPostShimmer(),
                      ),
                    );
                  }

                  final items = feedState.channelItems;

                  if (items.isEmpty) {
                    final canPost =
                        displayChannel.isOwnChannel ||
                        displayChannel.allowCommentingBy == 'all';
                    if (!canPost) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.h),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => CommentingSheet(
                                    channelId: displayChannel.id,
                                    channelName: displayChannel.title,
                                    showInputField: true,
                                  ),
                                );
                              },
                              child: Container(
                                height: 80.w,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 40.sp,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No posts yet. Be the first to post!',
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  int getSuggestionCount() =>
                      items.length < 10 ? 1 : (items.length / 10).floor();
                  final totalItems = items.length + getSuggestionCount() + 1;
                  final hasMore = feedState.hasMore;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == totalItems - 1) {
                        if (hasMore) {
                          if (feedState.error != null) {
                            return PaginationErrorFooter(
                              error: feedState.error!,
                              onRetry: () => notifier.loadMore(),
                            );
                          }
                          return const FeedPostShimmer();
                        }
                        return ChannelEndSummary(
                          title: displayChannel.title,
                          imageUrl: displayChannel.imageUrl,
                          postCount: displayChannel.postsCount,
                          followerCount: displayChannel.followersCount,
                          tagsCount: displayChannel.tagsCount,
                          likesCount: displayChannel.likesCount,
                        );
                      }

                      bool isSuggestionSlot = items.length < 10
                          ? index == _randomSuggestionIndex
                          : (index + 1) % 11 == 0;
                      if (isSuggestionSlot && suggestions.isNotEmpty) {
                        return SuggestionChannelsSection(
                          channels: suggestions,
                          onSeeAll: () {},
                        );
                      }

                      int adjustedIndex = items.length < 10
                          ? (index < _randomSuggestionIndex ? index : index - 1)
                          : index - (index + 1) ~/ 11;
                      if (adjustedIndex < 0 || adjustedIndex >= items.length) {
                        return const SizedBox.shrink();
                      }

                      final item = items[adjustedIndex];

                      if (item is InvitationItem) {
                        return FeedPostPlaceholder(
                          authorName: item.authorUsername.isNotEmpty
                              ? item.authorUsername
                              : 'Member',
                          content: item.caption ?? '',
                          timeAgo: _formatTimeAgo(item.createdAt),
                          authorImageUrl: item.authorAvatarUrl,
                          type: 'invite',
                          likesCount: item.likes,
                          tagsCount: item.originalPost?.tagsCount ?? 0,
                          isLiked: item.isLiked,
                          onLikeTap: () => notifier.toggleLike(item.id, true),
                          onCommentTap: () => _openPostCommentSheet(item),
                          inviteChannelId: item.targetChannelId,
                          inviteChannelName: item.targetChannelName,
                          inviteChannelImage: item.targetChannelImage,
                          inviteChannelTitle: item.targetChannelTitle,
                          onJoinPressed: () {},
                          onTagTap: () => _openTagSheet(item),
                          currentChannelAvatar: displayChannel.imageUrl,
                        );
                      }
                      if (item is ManifestoItem) {
                        return FeedPostPlaceholder(
                          authorName: item.authorUsername.isNotEmpty
                              ? item.authorUsername
                              : 'Member',
                          content: item.caption,
                          timeAgo: _formatTimeAgo(item.createdAt),
                          authorImageUrl:
                              item.authorAvatarUrl?.isNotEmpty == true
                              ? item.authorAvatarUrl
                              : null,
                          imageUrls: item.imageUrls.isNotEmpty
                              ? item.imageUrls
                              : null,
                          videoUrl: item.videoUrl?.isNotEmpty == true
                              ? item.videoUrl
                              : null,
                          aspectRatio: item.aspectRatio,
                          likesCount: item.likes,
                          commentsCount: item.commentCount,
                          tagsCount: item.originalPost?.tagsCount ?? 0,
                          isLiked: item.isLiked,
                          onLikeTap: () => notifier.toggleLike(item.id, true),
                          onCommentTap: () => _openPostCommentSheet(item),
                          onTagTap: () => _openTagSheet(item),
                          taggerName: item.taggerName,
                          taggerAvatar: item.taggerAvatar,
                          sourceChannelName: item.sourceChannelName,
                          sourceChannelAvatar: item.sourceChannelAvatar,
                          currentChannelAvatar: displayChannel.imageUrl,
                        );
                      }
                      if (item is ChannelCommentItem) {
                        return FeedPostPlaceholder(
                          authorName: item.authorUsername.isNotEmpty
                              ? item.authorUsername
                              : 'Member',
                          content: item.message,
                          timeAgo: _formatTimeAgo(item.createdAt),
                          authorImageUrl: item.authorAvatarUrl,
                          likesCount: item.likes,
                          commentsCount: item.commentCount,
                          tagsCount: item.originalPost?.tagsCount ?? 0,
                          isLiked: item.isLiked,
                          onLikeTap: () => notifier.toggleLike(item.id, false),
                          onCommentTap: () => _openPostCommentSheet(item),
                          onTagTap: () => _openTagSheet(item),
                          taggerName: item.taggerName,
                          taggerAvatar: item.taggerAvatar,
                          sourceChannelName: item.sourceChannelName,
                          sourceChannelAvatar: item.sourceChannelAvatar,
                          currentChannelAvatar: displayChannel.imageUrl,
                        );
                      }
                      return const SizedBox.shrink();
                    }, childCount: totalItems),
                  );
                },
              ),
            ] else if (_currentTabIndex == 2) ...[
              VideoTabView(
                channelId: displayChannel.id,
                channelName: displayChannel.title,
                channelTitle: displayChannel.description,
              ),
            ] else if (_currentTabIndex == 3) ...[
              MembersTabView(
                members: widget.contestants,
                channelId: displayChannel.id,
                channelName: displayChannel.title,
                channelImageUrl: displayChannel.imageUrl,
                canPostStatus: canPostStatus,
                allowInvitationsBy:
                    displayChannel.allow_invitations_by ?? 'all',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFocusedHero(CharterModel contestant) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final bool locallyCrowned = _showFab;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.9,
          height: 360.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
            image: DecorationImage(
              image: CachedNetworkImageProvider(contestant.profileImageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          contestant.displayName,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${(contestant.chartCount / 1000).toStringAsFixed(1)}k Crowns',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFFD700),
          ),
        ),
        SizedBox(height: 18.h),
        if (!locallyCrowned)
          GestureDetector(
            onTap: () {
              setState(() {
                _showFab = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                'CROWN',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  ChartChannel _getEmptyChannel() {
    return ChartChannel(
      id: 'loading',
      title: 'Channel',
      description: '...',
      memberCount: 0,
      followersCount: 0,
      tagsCount: 0,
      likesCount: 0,
      postsCount: 0,
      isPrivate: false,
      staterName: '...',
      staterAvatarUrl: '',
      imageUrl: '',
    );
  }
}
