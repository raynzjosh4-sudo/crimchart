import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import '../../features/channel/pages/channel_page.dart';
import '../models/explore_item_model.dart';
import '../../../features/widgets/memberimage/starter_image.dart';
import '../../../features/widgets/channelinfo/stacked_contestants.dart';
import '../../../features/widgets/chartcard/card/media/video_media.dart';
import '../../../features/widgets/chartcard/card/media/audio_media.dart';
import 'package:crown/core/utils/responsive_size.dart';

class ExploreGridItem extends StatelessWidget {
  final ExploreItemModel item;

  const ExploreGridItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // Map ExploreItemModel to CharterModel
        final primaryContestant = CharterModel(
          id: item.id,
          username: item.username,
          displayName: item.username, // Using username as display name
          profileImageUrl: item.profileImageUrl ?? '',
          title: item.type == ExploreItemType.Chart ? '👑 Chart' : '⭐ Member',
          category: 'Trending', // Placeholder category
          isVideo: item.isVideo,
          videoUrl: item.videoUrl,
          isAudio: item.isAudio,
          audioUrl: item.audioUrl,
          mediaThumbnailUrl: item.imageUrl,
        );

        // Pass only ONE contestant so the carousel shows only that specific card
        final contestants = [primaryContestant];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelPage(contestants: contestants),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6.w,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media area — dynamic AspectRatio for masonry look (not level)
            AspectRatio(
              aspectRatio: item.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Render content based on media type
                  _buildMediaContent(context),

                  // Subtle icon indicator for video/audio
                  if (item.isVideo || item.isAudio)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.isVideo
                              ? Icons.videocam_rounded
                              : Icons.audiotrack_rounded,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),

                  // Bottom gradient with stacked avatars + caption
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10.w, 40.h, 10.w, 10.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.85),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.contestantImageUrls.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: StackedContestants(
                                avatarUrls: item.contestantImageUrls,
                                avatarSize: 28.w,
                                overlapOffset: 20.w,
                                borderWidth: 1.5.w,
                                borderColor: Colors.black87,
                              ),
                            ),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer: avatar + username + likes
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                children: [
                  MemberImage(
                    size: 26.w,
                    imageUrl: item.profileImageUrl,
                    showStatusRing: false,
                    showActiveDot: false,
                    useHexagon: true,
                  ),
                  SizedBox(width: 7.w),
                  Expanded(
                    child: Text(
                      '@${item.username}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.favorite_rounded,
                    size: 13.sp,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    _formatCount(item.likes),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    if (item.isVideo && item.videoUrl != null) {
      return VideoCardMedia(url: item.videoUrl!);
    } else if (item.isAudio && item.audioUrl != null) {
      return AudioCardMedia(
        id: item.id,
        url: item.audioUrl!,
        thumbnailUrl: item.imageUrl,
        backgroundImageUrl: item.audioBackgroundUrl,
      );
    } else {
      return Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade800,
          child: const Icon(Icons.broken_image_rounded, color: Colors.white54),
        ),
      );
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}











