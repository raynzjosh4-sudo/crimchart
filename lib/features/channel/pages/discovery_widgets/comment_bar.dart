import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/app_avatar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CommentBar extends StatelessWidget {
  final String? userImageUrl;
  final String userName;
  final VoidCallback? onTap;
  final VoidCallback? onImageTap;

  const CommentBar({
    super.key,
    this.userImageUrl,
    required this.userName,
    this.onTap,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor == Colors.transparent 
            ? Colors.transparent 
            : theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ),
          top: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          AppAvatar(
            size: 36,
            imageUrl: userImageUrl,
            fallbackIcon: LucideIcons.user,
          ),
          SizedBox(width: 12.w),
          
          // Comment Input Box
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comment as $userName',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: onImageTap,
                      child: Icon(
                        LucideIcons.image,
                        size: 20.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
