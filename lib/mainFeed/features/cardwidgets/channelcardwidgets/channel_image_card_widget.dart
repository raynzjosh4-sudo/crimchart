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
import 'widgets/channel_chart_slide.dart';
import '../../../menu/main_feed_menu.dart';
import '../../../../../features/widgets/chartcard/card/media/image_media.dart';
import '../../../../../core/utils/responsive_size.dart';

class ChannelImageCardWidget extends StatefulWidget {
  final ChannelPostModel data;
  final VoidCallback? onTap;

  const ChannelImageCardWidget({super.key, required this.data, this.onTap});

  @override
  State<ChannelImageCardWidget> createState() => _ChannelImageCardWidgetState();
}

class _ChannelImageCardWidgetState extends State<ChannelImageCardWidget> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (Channel + User)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              MemberImage(
                size: 42.w,
                imageUrl: data.userProfileImageUrl,
                showStatusRing: data.hasStatus,
                showActiveDot: data.isActive,
                borderWidth: 2,
                onTap: () {
                  if (data.hasStatus) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StatusPage(
                          username: data.username,
                          userProfileImageUrl: data.userProfileImageUrl,
                          statusImageUrl: data.imageUrls.isNotEmpty 
                              ? data.imageUrls[0] 
                              : data.userProfileImageUrl,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.hub_rounded, color: themeColor, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.channelName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: themeColor.withAlpha(230),
                            ),
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
            data.caption,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.3,
            ),
          ),
        ),

        // Main Image/Carousel with ThumbnailLink Overlay
        Stack(
          children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 400),
          child: AspectRatio(
            aspectRatio: data.aspectRatio ?? 0.8, // Default to 4:5 if not provided
            child: PageView.builder(
              itemCount: data.imageUrls.length +
                  (data.chartedContestants.isNotEmpty ? 1 : 0),
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                // Final page is the Chart Slide if there are contestants
                if (data.chartedContestants.isNotEmpty &&
                    index == data.imageUrls.length) {
                  return ChannelChartSlide(
                    contestants: data.chartedContestants,
                    themeColor: themeColor,
                  );
                }

                // Regular image page
                return ImageCardMedia(
                  url: data.imageUrls[index],
                  creatorAvatarUrl: data.thumbnailLinkUrl,
                  themeColor: themeColor,
                  username: data.chartedContestants.isNotEmpty ? data.chartedContestants.first.username : 'Contestant',
                  onThumbnailTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChannelPage(
                          contestants: data.referenceContestants.isNotEmpty
                              ? data.referenceContestants
                              : data.chartedContestants,
                          initialMessageId: data.referenceId,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),

            // Member Activity Indicator - Contestants being Charted
            if (data.chartedContestants.isNotEmpty &&
                _currentImageIndex != data.imageUrls.length)
              Positioned(
                top: 16,
                left: 16,
                child: StackedContestants(
                  avatarUrls: data.chartedContestants
                      .map((c) => c.profileImageUrl)
                      .toList(),
                  avatarSize: 50, // Substantially increased size
                  overlapOffset: 32,
                  borderColor: Colors.black.withAlpha(128),
                  borderWidth: 2.0, // Thicker border for larger icons
                  maxAvatars: 5,
                ),
              ),

            // The indicator "Imported thumbnaillink" is now handled inside ImageCardMedia's wrapper


            // Page Indicators (Dots) - Circled by user
            if (data.imageUrls.length > 1 || data.chartedContestants.isNotEmpty)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    data.imageUrls.length +
                        (data.chartedContestants.isNotEmpty ? 1 : 0),
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? themeColor // Yellow/Theme color from circle
                            : Colors.white38, // Gray from circle
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Interactive Footer - Circled by user
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              LikeAction(
                initialLikes: data.likes,
                initialIsLiked: data.isLiked,
                themeColor: themeColor,
                iconSize: 26,
              ),
              const SizedBox(width: 20),
              CommentActionWidget(
                initialComments: data.comments,
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
              // Time ago matching the clean feel but kept out of the circles row
              Text(
                data.timeAgo,
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





























