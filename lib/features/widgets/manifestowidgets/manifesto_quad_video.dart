import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import '../channelmemberdata/comment_card/media/video_media.dart';

/// 🎥 Specialized widget for a four-video matrix layout.
class ManifestoQuadVideo extends StatelessWidget {
  final List<String> videoUrls;
  final List<String?> thumbnailUrls;
  final Color themeColor;
  final void Function(int)? onTap;

  const ManifestoQuadVideo({
    super.key,
    required this.videoUrls,
    this.thumbnailUrls = const [],
    required this.themeColor,
    this.onTap,
  }) : assert(videoUrls.length >= 4);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 750.h, // 👑 Aggressive vertical height (was 640.h)
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: VideoMedia(
                      videoUrl: videoUrls[0],
                      thumbnailUrl: thumbnailUrls.isNotEmpty ? thumbnailUrls[0] : null,
                      themeColor: themeColor,
                      onTap: () => onTap?.call(0),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: VideoMedia(
                      videoUrl: videoUrls[1],
                      thumbnailUrl: thumbnailUrls.length > 1 ? thumbnailUrls[1] : null,
                      themeColor: themeColor,
                      onTap: () => onTap?.call(1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: VideoMedia(
                      videoUrl: videoUrls[2],
                      thumbnailUrl: thumbnailUrls.length > 2 ? thumbnailUrls[2] : null,
                      themeColor: themeColor,
                      onTap: () => onTap?.call(2),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: VideoMedia(
                      videoUrl: videoUrls[3],
                      thumbnailUrl: thumbnailUrls.length > 3 ? thumbnailUrls[3] : null,
                      themeColor: themeColor,
                      onTap: () => onTap?.call(3),
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
