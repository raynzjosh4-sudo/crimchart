import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InfoSheet extends StatelessWidget {
  final String title;
  final Color themeColor;
  final bool isAuthor;
  final VoidCallback? onDelete;

  const InfoSheet({
    super.key,
    required this.title,
    required this.themeColor,
    this.isAuthor = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),

          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: themeColor,
            ),
          ),
          SizedBox(height: 24.h),

          _buildActionItem(
            context,
            icon: LucideIcons.flag,
            label: context.tr('report_post'),
            color: Colors.redAccent,
          ),
          _buildActionItem(
            context,
            icon: LucideIcons.userMinus,
            label: context.tr('unfollow_member'),
          ),
          _buildActionItem(
            context,
            icon: LucideIcons.copy,
            label: context.tr('copy_text'),
          ),
          _buildActionItem(
            context,
            icon: LucideIcons.eyeOff,
            label: context.tr('hide_this_post'),
          ),

          if (isAuthor) ...[
            const Divider(color: Colors.white10),
            _buildActionItem(
              context,
              icon: LucideIcons.trash2,
              label: context.tr('delete_post'),
              color: Colors.redAccent,
              onTap: onDelete,
            ),
          ],

          SizedBox(height: 16.h),

          // Close button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                backgroundColor: theme.colorScheme.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.w),
                ),
              ),
              child: Text(
                context.tr('close'),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(16.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.sp,
                color:
                    color ?? theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              SizedBox(width: 16.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      color ??
                      theme.colorScheme.onSurface.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}











