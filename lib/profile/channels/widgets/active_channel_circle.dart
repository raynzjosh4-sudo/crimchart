import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../features/widgets/memberimage/channel_avatar.dart';

class ActiveChannelCircle extends StatelessWidget {
  final String? imageUrl;
  final String? leaderAvatarUrl; // Added for community leaders in the story bar
  final String name;
  final bool hasUpdate;
  final VoidCallback? onTap;

  const ActiveChannelCircle({
    super.key,
    required this.imageUrl,
    this.leaderAvatarUrl,
    required this.name,
    this.hasUpdate = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = 72.w; // Increased from 62.w for impact

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 18.w),
        child: Column(
          children: [
            SizedBox(
              width: size,
              height: size,
              child: leaderAvatarUrl != null
                  ? ChannelAvatar(
                      imageUrl: imageUrl,
                      leaderAvatarUrl: leaderAvatarUrl,
                      size: size,
                      isActive: hasUpdate,
                    )
                  : MemberImage(
                      size: size,
                      imageUrl: imageUrl,
                      showStatusRing: hasUpdate,
                      showActiveDot: hasUpdate,
                      borderWidth: 2.5,
                    ),
            ),
            SizedBox(height: 8.h),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: hasUpdate ? FontWeight.w900 : FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











