import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/utils/responsive_size.dart';
import '../../models/chart_message.dart';
import 'image_bubble.dart';

class VideoBubble extends StatelessWidget {
  final ChartMessage message;

  const VideoBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageBubble(message: message), // Reuses ImageBubble for thumbnail
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Icon(
            LucideIcons.play,
            color: Colors.white,
            size: 28.sp,
          ),
        ),
      ],
    );
  }
}





























