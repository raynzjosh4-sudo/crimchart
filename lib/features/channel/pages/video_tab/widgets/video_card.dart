import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:crimchart/video/pages/video_feed_page.dart';
import 'package:crimchart/video/core/models/feed_video_item.dart';

class VideoCard extends StatelessWidget {
  final PostEntity video;
  final int index;
  final List<PostEntity> allVideos;

  const VideoCard({
    super.key,
    required this.video,
    required this.index,
    required this.allVideos,
  });

  void _openFeed(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => VideoFeedPage(
          videos: allVideos
              .map((p) => FeedVideoItem.fromPostEntity(p))
              .toList(),
          initialIndex: index,
          initialTab: VideoFeedTab.channel,
        ),
        transitionsBuilder: (_, animation, __, child) {
          // Native-feel fade + scale up from the card
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFeed(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey[900],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            CachedNetworkImage(
              imageUrl: video.thumbnailUrls.isNotEmpty
                  ? video.thumbnailUrls.first
                  : (video.imageUrls.isNotEmpty ? video.imageUrls.first : ''),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
            ),

            // Gradient Overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          video.authorUsername,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.verified, color: Colors.orange, size: 13.sp),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    video.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
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
}
