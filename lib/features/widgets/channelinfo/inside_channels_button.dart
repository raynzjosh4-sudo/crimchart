import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class InsideChannelsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const InsideChannelsButton({
    super.key,
    this.text = 'Inside channels',
    this.onPressed,
    this.backgroundColor = Colors.white12,
    this.textColor = Colors.white,
    this.fontSize = 14.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}











