import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InboxOptionsSheet extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final VoidCallback onViewStatus;
  final VoidCallback onOpenChat;

  const InboxOptionsSheet({
    super.key,
    required this.userName,
    this.userAvatar,
    required this.onViewStatus,
    required this.onOpenChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minimal Header with Avatar and Name
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: userAvatar != null
                    ? NetworkImage(userAvatar!)
                    : null,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: userAvatar == null
                    ? Icon(
                        LucideIcons.user,
                        color: colorScheme.primary,
                        size: 20.sp,
                      )
                    : null,
              ),
              SizedBox(width: 16.w),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Option 1: View Status
          _buildMinimalOption(
            context,
            icon: LucideIcons.circleDashed,
            title: 'View Status',
            onTap: () {
              Navigator.pop(context);
              onViewStatus();
            },
          ),

          SizedBox(height: 8.h),

          // Option 2: Open Chat
          _buildMinimalOption(
            context,
            icon: LucideIcons.messageCircle,
            title: 'Open Chat',
            isPrimary: true,
            onTap: () {
              Navigator.pop(context);
              onOpenChat();
            },
          ),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildMinimalOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.7),
              size: 24.sp,
            ),
            SizedBox(width: 20.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: isPrimary ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











