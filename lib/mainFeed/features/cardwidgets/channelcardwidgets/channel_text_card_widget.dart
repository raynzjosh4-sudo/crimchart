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
import '../../../menu/main_feed_menu.dart';
import 'widgets/channel_chart_slide.dart';
import '../../../../../core/utils/responsive_size.dart';

class ChannelTextCardWidget extends StatefulWidget {
  final ChannelPostModel data;
  final VoidCallback onTap;

  const ChannelTextCardWidget({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  State<ChannelTextCardWidget> createState() => _ChannelTextCardWidgetState();
}

class _ChannelTextCardWidgetState extends State<ChannelTextCardWidget> {
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

          // Media Area: Text Content or Chart Slide
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    // Text Content Page
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
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                themeColor.withValues(alpha: 0.08),
                                Colors.black.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.data.caption,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                letterSpacing: 0.2,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Chart Slide
                    if (widget.data.chartedContestants.isNotEmpty)
                      ChannelChartSlide(
                        contestants: widget.data.chartedContestants,
                        themeColor: themeColor,
                      ),
                  ],
                ),

                // Overlays (Only on Text page)
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

                // Bottom Right: Thumbnail Link is now handled inside ChartStackMediaWrapper


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

          // Footer: Actions
          _buildFooter(theme, themeColor),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color themeColor) {
    return Padding(
      padding: EdgeInsets.all(8.w),
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
                      statusImageUrl: widget.data.userProfileImageUrl,
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
          const SizedBox(width: 8),
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





























