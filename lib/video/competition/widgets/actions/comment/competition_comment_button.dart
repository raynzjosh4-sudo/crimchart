import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CompetitionCommentButton extends StatelessWidget {
  final int comments;
  final VoidCallback? onTap;

  const CompetitionCommentButton({
    super.key,
    required this.comments,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(LucideIcons.messageSquare, color: Colors.white, size: 28.sp),
          SizedBox(height: 4.h),
          Text(
            '$comments',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











