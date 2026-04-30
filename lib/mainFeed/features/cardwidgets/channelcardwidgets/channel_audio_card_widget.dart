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
import '../../../../../features/widgets/chartcard/card/media/audio_media.dart';
import '../../../menu/main_feed_menu.dart';
import 'widgets/channel_chart_slide.dart';
import '../../../../../core/utils/responsive_size.dart';

class ChannelAudioCardWidget extends StatefulWidget {
  final ChannelPostModel data;
  final VoidCallback? onTap;

  const ChannelAudioCardWidget({super.key, required this.data, this.onTap});

  @override
  State<ChannelAudioCardWidget> createState() => _ChannelAudioCardWidgetState();
}

class _ChannelAudioCardWidgetState extends State<ChannelAudioCardWidget> {
  int _currentPageIndex = 0;

  // Theme color logic
  Color _getThemeColorForCategory(String category) {
    if (category.toLowerCase().contains('fashion')) return Colors.pinkAccent;
    if (category.toLowerCase().contains('tech')) return Colors.blueAccent;
    if (category.toLowerCase().contains('travel')) return Colors.amber;
    if (category.toLowerCase().contains('music')) {
      return Colors.deepPurpleAccent;
    }
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColorForCategory(
      widget.data.chartedContestants.isNotEmpty
          ? widget.data.chartedContestants.first.category
          : 'Default',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Avatar + Channel Name & Context)
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Row(
            children: [
              MemberImage(
                size: 42.w,
                imageUrl: widget.data.userProfileImageUrl,
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
                          statusImageUrl: widget.data.audioUrl ?? widget.data.userProfileImageUrl,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Posted in ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          widget.data.channelName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: themeColor.withAlpha(230),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => MainFeedMenu.show(context),
              ),
            ],
          ),
        ),

        // Description (Caption)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Text(
            widget.data.caption,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.3,
            ),
          ),
        ),

        // Main Audio with ThumbnailLink Overlay
        Stack(
          children: [
        AspectRatio(
          aspectRatio: widget.data.aspectRatio ?? 1.0,
          child: PageView.builder(
            itemCount: 1 + (widget.data.chartedContestants.isNotEmpty ? 1 : 0),
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              // Final page is the Chart Slide if there are contestants
              if (widget.data.chartedContestants.isNotEmpty && index == 1) {
                return ChannelChartSlide(
                  contestants: widget.data.chartedContestants,
                  themeColor: themeColor,
                );
              }

              // Regular audio page
                  return widget.data.audioUrl != null
                      ? AudioCardMedia(
                          id: widget.data.id,
                          url: widget.data.audioUrl!,
                          backgroundImageUrl: widget.data.imageUrls.isNotEmpty
                              ? widget.data.imageUrls.first
                              : null,
                          creatorAvatarUrl: widget.data.thumbnailLinkUrl,
                          themeColor: themeColor,
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
                        )
                  : const Center(child: Text("No audio available"));
            },
          ),
        ),

            // Member Activity Indicator - Contestants being Charted
            if (widget.data.chartedContestants.isNotEmpty &&
                _currentPageIndex != 1)
              Positioned(
                top: 16,
                left: 16,
                child: StackedContestants(
                  avatarUrls: widget.data.chartedContestants
                      .map((c) => c.profileImageUrl)
                      .toList(),
                  avatarSize: 50,
                  overlapOffset: 32,
                  borderColor: Colors.black.withAlpha(128),
                  borderWidth: 2.0,
                  maxAvatars: 5,
                ),
              ),


            // Page Indicator (single dot for the audio page only)
            if (widget.data.chartedContestants.isNotEmpty)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPageIndex == 0
                            ? themeColor
                            : Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        // Interactive Footer
        Padding(
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
              const Spacer(),
              Text(
                widget.data.timeAgo,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),
      ],
    );
  }
}





























