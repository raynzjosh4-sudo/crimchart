import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/video/core/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/video_post.dart';

import 'package:lucide_icons/lucide_icons.dart';

class VideoFeedCard extends StatelessWidget {
  final VideoPost post;

  const VideoFeedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Black base — ensures loading state is always dark, not theme-dependent
        const Positioned.fill(child: ColoredBox(color: Colors.black)),
        // Video Player
        Positioned.fill(child: VideoPlayerWidget(videoUrl: post.url)),

        // Gradient Overlay — always black-based so text is readable over any video
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                  stops: const [0.0, 0.15, 0.65, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Right Side Action Buttons
        Positioned(
          right: 16.w,
          bottom: 100.h,
          child: Column(
            children: [
              _ActionButton(
                icon: LucideIcons.heart,
                label: '${post.likes}',
                onTap: () {},
              ),
              SizedBox(height: 20.h),
              _ActionButton(
                icon: LucideIcons.messageSquare,
                label: '${post.comments}',
                onTap: () {},
              ),
              SizedBox(height: 20.h),
              _ActionButton(
                icon: LucideIcons.share2,
                label: '${post.shares}',
                onTap: () {},
              ),
            ],
          ),
        ),

        // Bottom Info Overlay
        Positioned(
          left: 16.w,
          right: 80.w,
          bottom: 40.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author row
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                    backgroundImage: post.authorAvatarUrl != null
                        ? CachedNetworkImageProvider(post.authorAvatarUrl!)
                        : null,
                    child: post.authorAvatarUrl == null
                        ? Icon(
                            LucideIcons.user,
                            color: Colors.white,
                            size: 20.sp,
                          )
                        : null,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      '@${post.authorName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Join button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      context.tr('join'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Caption
              Text(
                post.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),
              // Original sound
              Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 14.sp),
                  SizedBox(width: 6.w),
                  Text(
                    context.tr('original_sound'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28.sp,
            shadows: const [
              Shadow(
                color: Colors.black45,
                offset: Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              shadows: const [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











