import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/app_avatar.dart';

class MemberListItem extends StatelessWidget {
  final String id;
  final String name;
  final String? profileImageUrl;
  final String? subtitle;
  final VoidCallback? onAddFriend;
  final bool hasStatus;
  final int statusCount;
  final VoidCallback? onAvatarTap;
  final bool showFollow;

  const MemberListItem({
    super.key,
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.subtitle,
    this.onAddFriend,
    this.hasStatus = false,
    this.statusCount = 0,
    this.onAvatarTap,
    this.showFollow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // 👑 PREMIUM CHARTER AVATAR
              AppAvatar(
                size: 52,
                imageUrl: profileImageUrl,
                hasStatus: hasStatus,
                statusSegmentCount: statusCount,
                isStatusRead: false, // 👑 TODO: Link to real seen state
                isOnline: !hasStatus, // 👑 Show online dot if no status active
                onTap: onAvatarTap ?? onAddFriend,
              ),
              SizedBox(width: 16.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Follow Button (WhatsApp Style)
              if (showFollow)
                SizedBox(
                  height: 32.h,
                  child: OutlinedButton(
                    onPressed: onAddFriend,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      foregroundColor: colorScheme.onSurface,
                    ),
                    child: Text(
                      "View",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 84.w), // Align with text
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: colorScheme.onSurface.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }
}
