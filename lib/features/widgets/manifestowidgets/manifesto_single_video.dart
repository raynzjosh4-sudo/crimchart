import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import '../channelmemberdata/comment_card/media/video_media.dart';

/// 🎥 Specialized widget for a single, immersive video player.
class ManifestoSingleVideo extends StatelessWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final Color themeColor;
  final VoidCallback? onTap;

  const ManifestoSingleVideo({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.themeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: AspectRatio(
        aspectRatio: 0.7, // 👑 Aggressive vertical portrait (was 0.82)
        child: VideoMedia(
          videoUrl: videoUrl,
          thumbnailUrl: thumbnailUrl,
          themeColor: themeColor,
          onTap: onTap,
        ),
      ),
    );
  }
}
