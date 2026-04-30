import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';

class ChartButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color currentColor;

  const ChartButton({
    super.key,
    required this.onTap,
    required this.currentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: currentColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: currentColor.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          LucideIcons.send,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }
}
