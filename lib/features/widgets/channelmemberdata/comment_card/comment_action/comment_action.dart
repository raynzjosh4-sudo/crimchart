import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class CommentAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final double? fontSize;
  final double? iconSize;

  const CommentAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize ?? 16.sp,
            color:
                color ??
                Theme.of(context).colorScheme.onSurface,
          ),
          if (label.isNotEmpty) ...[
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color:
                    color ??
                    Theme.of(
                      context,
                    ).colorScheme.onSurface,
                fontSize: fontSize ?? 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}











