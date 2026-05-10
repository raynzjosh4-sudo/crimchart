import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/app_avatar.dart';
import 'channel_comment_model.dart';

class ChannelCommentsListTile extends StatelessWidget {
  final ChannelComment comment;
  final VoidCallback? onTap;

  const ChannelCommentsListTile({super.key, required this.comment, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- AVATAR ---
          AppAvatar(
            size: 44,
            imageUrl: comment.userAvatar,
            fallbackIcon: LucideIcons.user,
          ),

          SizedBox(width: 14.w),

          // --- CONTENT ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line 1: User Name
                Text(
                  comment.userName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 2.h),

                // Line 2: Status, Level, and Time
                Row(
                  children: [
                    Icon(
                      LucideIcons.star,
                      size: 12.sp,
                      color: const Color(0xFFFFD700),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Level ${comment.level} • ${comment.userStatus}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "•  ${comment.timeAgo}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Line 3: The Comment Content
                Text(
                  comment.commentText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
