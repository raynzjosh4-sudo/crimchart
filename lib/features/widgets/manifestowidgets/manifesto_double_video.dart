import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import '../channelmemberdata/comment_card/media/video_media.dart';

/// 🎥 Specialized widget for a dual-video split layout.
class ManifestoDoubleVideo extends StatelessWidget {
  final List<String> videoUrls;
  final List<String?> thumbnailUrls;
  final Color themeColor;
  final void Function(int)? onTap;

  const ManifestoDoubleVideo({
    super.key,
    required this.videoUrls,
    this.thumbnailUrls = const [],
    required this.themeColor,
    this.onTap,
  }) : assert(videoUrls.length >= 2);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 620.h, // 👑 Aggressive vertical height (was 500.h)
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
    );
  }
}
