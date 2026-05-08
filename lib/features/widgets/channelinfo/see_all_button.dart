import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class SeeAllButton extends StatelessWidget {
  final String? text;
  final int? count;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const SeeAllButton({
    super.key,
    this.text,
    this.count,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 13.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
    final effectiveTextColor =
        textColor ?? Theme.of(context).colorScheme.onSurface;

    return TextButton(
      onPressed: onPressed ?? () {},
      style: TextButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
      ),
      child: Text(
        count != null
            ? '${context.tr('see_all')} $count'
            : (text ?? context.tr('see_all')),
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}











