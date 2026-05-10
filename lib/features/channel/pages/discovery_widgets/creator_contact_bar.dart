import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/app_avatar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreatorContactBar extends StatelessWidget {
  final String? creatorImageUrl;
  final String creatorName;
  final VoidCallback? onMessageTap;
  final VoidCallback? onFollowTap;
  final bool isOwnChannel;

  const CreatorContactBar({
    super.key,
    this.creatorImageUrl,
    required this.creatorName,
    this.onMessageTap,
    this.onFollowTap,
    this.isOwnChannel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 8.h,
          ),
          bottom: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 8.h,
          ),
        ),
      ),
      child: Row(
        children: [
          // Creator Avatar
          AppAvatar(
            size: 48,
            imageUrl: creatorImageUrl,
            fallbackIcon: LucideIcons.user,
          ),
          SizedBox(width: 16.w),

          // Creator Info & Actions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        creatorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.verified, size: 14.sp, color: Colors.blue),
                  ],
                ),
                Text(
                  "Channel Creator",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),

                // Interaction Buttons
                if (!isOwnChannel)
                  Row(
                    children: [
                      _buildActionButton(
                        label: "Message",
                        icon: LucideIcons.messageSquare,
                        isPrimary: true,
                        context: context,
                        onTap: onMessageTap,
                      ),
                      SizedBox(width: 10.w),
                      _buildActionButton(
                        label: "Follow",
                        icon: LucideIcons.userPlus,
                        isPrimary: false,
                        context: context,
                        onTap: onFollowTap,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? theme.colorScheme.primary.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isPrimary ? theme.colorScheme.primary : Colors.white70,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? theme.colorScheme.primary : Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
