import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';

class AudioMediaWidget extends StatelessWidget {
  final Color themeColor;

  const AudioMediaWidget({super.key, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeColor.withValues(alpha: 0.2),
            themeColor.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: themeColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.music,
            size: 28.sp,
            color: themeColor,
          ),
        ),
      ),
    );
  }
}
