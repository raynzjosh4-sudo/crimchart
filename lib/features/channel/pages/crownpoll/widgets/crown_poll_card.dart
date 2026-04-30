import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';
import '../crown_option_model.dart';
import 'mediatype/crown_media_type.dart';
import 'mediatype/image_media_widget.dart';
import 'mediatype/video_media_widget.dart';
import 'mediatype/audio_media_widget.dart';

class CrownPollCard extends StatelessWidget {
  final CrownOptionModel option;
  final VoidCallback onTap;
  final Color themeColor;
  final double width;
  final double height;

  const CrownPollCard({
    super.key,
    required this.option,
    required this.onTap,
    required this.themeColor,
    this.width = 110,
    this.height = 160,
  });

  Widget _buildMedia(BuildContext context) {
    switch (option.mediaType) {
      case CrownMediaType.image:
        if (option.mediaUrl != null && option.mediaUrl!.isNotEmpty) {
          return ImageMediaWidget(imageUrl: option.mediaUrl!);
        }
        break;
      case CrownMediaType.video:
        return VideoMediaWidget(thumbnailUrl: option.mediaUrl);
      case CrownMediaType.audio:
        return AudioMediaWidget(themeColor: themeColor);
      case CrownMediaType.none:
        break;
    }
    // Fallback if no media
    return Container(color: Theme.of(context).colorScheme.surfaceContainerHighest);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: colorScheme.surfaceContainerHighest,
          // If option isMe (selected), give it a border with the themeColor
          border: option.isMe
              ? Border.all(color: themeColor, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Render Media based on type
              _buildMedia(context),

              // Gradient Overlay for Text Readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.5, 0.8, 1.0],
                  ),
                ),
              ),

              // Title and Info
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Row(
                      children: [
                        Icon(
                          LucideIcons.crown,
                          size: 14.sp,
                          color: const Color(0xFFFFD700),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${option.crowns}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
