import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/sdui/feed_component.dart';

class UserProfileCardComponent extends FeedComponent {
  final String name;
  final String username;
  final String profileImageUrl;
  final bool isVerified;
  final bool isFollowing;

  const UserProfileCardComponent({
    required this.name,
    required this.username,
    required this.profileImageUrl,
    this.isVerified = true,
    this.isFollowing = true,
  }) : super('user_profile_card');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 8.h,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rounded Square Avatar
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              
              // User Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (isVerified)
                          Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Icon(
                              Icons.verified,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '@$username',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    
                    // Buttons
                    Row(
                      children: [
                        _buildButton(
                          label: isFollowing ? 'Following' : 'Follow',
                          isSecondary: true,
                          context: context,
                        ),
                        SizedBox(width: 8.w),
                        _buildButton(
                          label: 'Enter',
                          isSecondary: false,
                          context: context,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isSecondary,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSecondary 
            ? Colors.white.withValues(alpha: 0.1) 
            : Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSecondary ? Colors.white : const Color(0xFFFFD700), // Gold/Yellow for Message
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
