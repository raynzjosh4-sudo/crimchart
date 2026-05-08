import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class CrownButton extends StatelessWidget {
  final bool isMe;
  final int crowns;
  final Color themeColor;
  final VoidCallback onTap;

  const CrownButton({
    super.key,
    required this.isMe,
    required this.crowns,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isMe ? themeColor.withValues(alpha: 0.15) : themeColor,
          borderRadius: BorderRadius.circular(10.r),
          border: isMe ? Border.all(color: themeColor.withValues(alpha: 0.5), width: 1.5) : null,
        ),
        child: Text(
          isMe ? "Crowned  •  $crowns" : "Crown  •  $crowns",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isMe 
                ? themeColor 
                : (themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
