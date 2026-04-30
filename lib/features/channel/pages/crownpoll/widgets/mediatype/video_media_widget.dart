import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'image_media_widget.dart';

class VideoMediaWidget extends StatelessWidget {
  final String? thumbnailUrl;

  const VideoMediaWidget({super.key, this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnailUrl != null) 
          ImageMediaWidget(imageUrl: thumbnailUrl!)
        else
          Container(color: colorScheme.surfaceContainerHighest),
        
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.play,
              size: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
