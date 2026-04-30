import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MainFeedMenu extends StatelessWidget {
  const MainFeedMenu({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
      ),
      builder: (context) => const MainFeedMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),

          _buildMenuItem(
            context,
            icon: LucideIcons.userMinus,
            title: 'UnChart',
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement UnChart
            },
          ),
          _buildMenuItem(
            context,
            icon: LucideIcons.eyeOff,
            title: 'Not Interested',
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement Not Interested
            },
          ),
          _buildMenuItem(
            context,
            icon: LucideIcons.flag,
            title: 'Report',
            isDestructive: true,
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement Report
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.w),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: color),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











