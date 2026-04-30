import 'package:flutter/material.dart';
import '../../../../features/channel/pages/channel_page.dart';
import '../models/channel_post_model.dart';
import '../storychacrdwidget/status_page.dart';
import '../../../../profile/pages/profile_page.dart';
import '../../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/like/like.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/comments/comment.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/comment_action.dart';
import '../../../../../features/widgets/channelinfo/stacked_contestants.dart';
import '../../../../../features/widgets/chartcard/card/media/video_media.dart';
import 'widgets/channel_chart_slide.dart';
import '../../../../../core/utils/responsive_size.dart';
import '../../../menu/main_feed_menu.dart';

class ChannelVideoCardWidget extends StatefulWidget {
  final ChannelPostModel data;
  final VoidCallback? onTap;

  const ChannelVideoCardWidget({super.key, required this.data, this.onTap});

  @override
  State<ChannelVideoCardWidget> createState() => _ChannelVideoCardWidgetState();
}

class _ChannelVideoCardWidgetState extends State<ChannelVideoCardWidget> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.data.chartedContestants.isNotEmpty
        ? (widget.data.chartedContestants.first.category.toLowerCase().contains('music') 
            ? Colors.deepPurpleAccent 
            : (widget.data.chartedContestants.first.category.toLowerCase().contains('fashion') 
                ? Colors.pinkAccent 
                : Colors.amber))
        : Colors.amber; // ✅ MATCHES THE YELLOW 'AI ART CHANNEL' THEME

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info
          Padding(
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
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        widget.data.channelName,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.data.timeAgo,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 11.sp,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, size: 20.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => MainFeedMenu.show(context),
                ),
              ],
            ),
          ),

          // Description (Caption)
          if (widget.data.caption.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
              child: Text(
                widget.data.caption,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
            ),

          // Media Area: Video Player or Chart Slide
          AspectRatio(
            aspectRatio: widget.data.aspectRatio ?? 16 / 9,
            child: ClipRRect(
              child: Stack(
                children: [
                  PageView(
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    children: [
                      // Video Player Page
                      widget.data.videoUrl != null
                        ? VideoCardMedia(
                            url: widget.data.videoUrl!,
                            creatorAvatarUrl: widget.data.thumbnailLinkUrl,
                            themeColor: themeColor,
                            username: widget.data.chartedContestants.isNotEmpty
                                ? widget.data.chartedContestants.first.username
                                : 'Contestant',
                            onThumbnailTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChannelPage(
                                    contestants: widget.data.referenceContestants.isNotEmpty
                                        ? widget.data.referenceContestants
                                        : widget.data.chartedContestants,
                                    initialMessageId: widget.data.referenceId,
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text("No video available")),

                      // Chart Slide
                      if (widget.data.chartedContestants.isNotEmpty)
                        ChannelChartSlide(
                          contestants: widget.data.chartedContestants,
                          themeColor: themeColor,
                        ),
                    ],
                  ),

                  // Member Activity Indicator - Contestants being Charted
                  if (widget.data.chartedContestants.isNotEmpty &&
                      _currentPageIndex != 1)
                    Positioned(
                      top: 16.h,
                      left: 16.w,
                      child: StackedContestants(
                        avatarUrls: widget.data.chartedContestants
                            .map((c) => c.profileImageUrl)
                            .toList(),
                        avatarSize: 50.w,
                        overlapOffset: 32.w,
                        borderColor: Colors.black.withAlpha(128),
                        borderWidth: 2.0.w,
                        maxAvatars: 5,
                      ),
                    ),

                  // The indicator "Imported thumbnaillink" is now handled inside VideoCardMedia's wrapper

                  // Page Indicators (Dots)
                  if (widget.data.chartedContestants.isNotEmpty)
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: _currentPageIndex == index ? 20.w : 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: _currentPageIndex == index
                                  ? themeColor
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(3.w),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                LikeAction(
                  initialLikes: widget.data.likes,
                  initialIsLiked: widget.data.isLiked,
                  themeColor: themeColor,
                  iconSize: 26.sp,
                ),
                SizedBox(width: 20.w),
                CommentActionWidget(
                  initialComments: widget.data.comments,
                  themeColor: themeColor,
                  iconSize: 26.sp,
                ),
                SizedBox(width: 20.w),
                CommentAction(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {},
                ),
                const Spacer(),
                Text(
                  widget.data.timeAgo,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}





























