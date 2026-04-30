import 'package:flutter/material.dart';
import '../../../../features/channel/pages/channel_page.dart';
import '../models/channel_post_model.dart';
import '../storychacrdwidget/status_page.dart';
import '../../../../profile/pages/profile_page.dart';
import '../../../../../features/widgets/chartcard/charterstack/chart_stack_media_wrapper.dart';
import '../../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/comment_action.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/like/like.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/comments/comment.dart';
import '../../../../../features/widgets/channelinfo/stacked_contestants.dart';
import 'widgets/channel_chart_slide.dart';
import '../../../menu/main_feed_menu.dart';
import '../../../../../core/utils/responsive_size.dart';

class ChannelGifCardWidget extends StatefulWidget {
  final ChannelPostModel data;
  final VoidCallback onTap;

  const ChannelGifCardWidget({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  State<ChannelGifCardWidget> createState() => _ChannelGifCardWidgetState();
}

class _ChannelGifCardWidgetState extends State<ChannelGifCardWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeColor = theme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info
          _buildHeader(theme, themeColor),

          // Caption (Above Media)
          if (widget.data.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                widget.data.caption,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

          // Media Area: GIF or Chart Slide
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 400),
            child: AspectRatio(
              aspectRatio: widget.data.aspectRatio ?? 0.8,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    children: [
                      // GIF Page
                      ChartStackMediaWrapper(
                        creatorAvatarUrl: widget.data.thumbnailLinkUrl,
                        onThumbnailTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChannelPage(
                                contestants:
                                    widget.data.referenceContestants.isNotEmpty
                                    ? widget.data.referenceContestants
                                    : widget.data.chartedContestants,
                                initialMessageId: widget.data.referenceId,
                              ),
                            ),
                          );
                        },
                        themeColor: themeColor,
                        username: widget.data.username,
                        subtitle: widget.data.channelName,
                        referenceId: widget.data.referenceId,
                        child: GestureDetector(
                          onTap: widget.onTap,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                widget.data.gifUrl ??
                                    (widget.data.imageUrls.isNotEmpty
                                        ? widget.data.imageUrls.first
                                        : ''),
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.black12,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                              // GIF Badge Overlay
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(153),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'GIF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Chart Slide
                      ChannelChartSlide(
                        contestants: widget.data.chartedContestants,
                        themeColor: themeColor,
                      ),
                    ],
                  ),

                  // Overlays (Only on GIF page)
                  if (_currentPage == 0) ...[
                    // Bottom Left: Stacked Contestants
                    if (widget.data.chartedContestants.isNotEmpty)
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: StackedContestants(
                            avatarUrls: widget.data.chartedContestants
                                .map((c) => c.profileImageUrl)
                                .toList(),
                            avatarSize: 50,
                            overlapOffset: 32,
                            maxAvatars: 5,
                          ),
                        ),
                      ),
                  ],

                  // The indicator "Imported thumbnaillink" is now handled inside ChartStackMediaWrapper


                  // Page Indicator
                  if (widget.data.chartedContestants.isNotEmpty)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentPage == index ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? themeColor
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Footer: Actions
          _buildFooter(theme, themeColor),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color themeColor) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          MemberImage(
            imageUrl: widget.data.userProfileImageUrl,
            size: 42.w,
            showStatusRing: widget.data.hasStatus,
            showActiveDot: widget.data.isActive,
            onTap: () {
              if (widget.data.hasStatus) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StatusPage(
                      username: widget.data.username,
                      userProfileImageUrl: widget.data.userProfileImageUrl,
                      statusImageUrl: widget.data.gifUrl ?? widget.data.userProfileImageUrl,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              }
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  widget.data.channelName,
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.data.timeAgo,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11),
          ),
          const SizedBox(height: 4),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => MainFeedMenu.show(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, Color themeColor) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          LikeAction(
            initialLikes: widget.data.likes,
            initialIsLiked: widget.data.isLiked,
            themeColor: themeColor,
            iconSize: 26,
          ),
          const SizedBox(width: 20),
          CommentActionWidget(
            initialComments: widget.data.comments,
            themeColor: themeColor,
            iconSize: 26,
          ),
          const SizedBox(width: 20),
          CommentAction(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}





























