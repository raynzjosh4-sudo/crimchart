import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class ChartButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? color;
  final double iconSize;
  final double fontSize;
  final String label;
  final IconData icon;
  final bool isCharted;
  final int chartPoints;

  const ChartButton({
    super.key,
    required this.onTap,
    this.color,
    this.iconSize = 26,
    this.fontSize = 13,
    this.label = 'Chart',
    this.icon = Icons.workspace_premium,
    this.isCharted = false,
    this.chartPoints = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Using a muted background for the pill as in the image
    final Color pillBg = theme.colorScheme.onSurface.withValues(alpha: 0.1);
    final Color activeColor = isCharted
        ? (color ?? theme.primaryColor)
        : theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: pillBg,
          borderRadius: BorderRadius.circular(30), // Pill/Capsule shape
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .shortcut_rounded, // Arrow icon as seen in the image for "Join"
              color: activeColor,
              size: iconSize * 0.8, // Slightly smaller to fit the pill well
            ),
            SizedBox(width: 8.w),
            Text(
              _formatPoints(chartPoints),
              style: TextStyle(
                color: activeColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPoints(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}











