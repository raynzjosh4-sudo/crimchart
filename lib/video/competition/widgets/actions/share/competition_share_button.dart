import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CompetitionShareButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CompetitionShareButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            LucideIcons.share2,
            color: Theme.of(context).colorScheme.onSurface,
            size: 28.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            'Share',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}











