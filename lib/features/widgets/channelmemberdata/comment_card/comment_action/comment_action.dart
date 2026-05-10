import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class CommentAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final double? fontSize;
  final bool isVertical;
  final double? iconSize;

  const CommentAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
    this.fontSize,
    this.isVertical = false,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      Icon(
        icon,
        size: iconSize ?? 16.sp,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
      if (label.isNotEmpty) ...[
        SizedBox(
          width: isVertical ? 0 : 4.w,
          height: isVertical ? 4.h : 0,
        ),
        Text(
          label,
          style: TextStyle(
            color: color ?? Theme.of(context).colorScheme.onSurface,
            fontSize: fontSize ?? 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: isVertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }
}











