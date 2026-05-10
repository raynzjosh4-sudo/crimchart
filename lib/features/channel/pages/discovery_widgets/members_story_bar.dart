import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'dart:math' as math;
import 'package:crimchart/core/widgets/app_avatar.dart';

import '../../../../mainFeed/features/cardwidgets/storychacrdwidget/status_page.dart';
import '../../domain/entities/channel_status_entity.dart';

class MembersStoryBar extends StatelessWidget {
  final List<ChannelStatusEntity> statuses;
  final VoidCallback onAddStory;
  final bool canPostStatus;

  const MembersStoryBar({
    super.key,
    required this.statuses,
    required this.onAddStory,
    this.canPostStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!canPostStatus && statuses.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
        Container(
          height: 220.h,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            // +1 for the "Add status" card if allowed
            itemCount: statuses.length + (canPostStatus ? 1 : 0),
            itemBuilder: (context, index) {
              if (canPostStatus && index == 0)
                return _buildAddStatusCard(context);
              final statusIndex = canPostStatus ? index - 1 : index;
              final status = statuses[statusIndex];
              return _buildStatusCard(context, status, index);
            },
          ),
        ),
      ],
    );
  }

  // ─── Add-Story Card ──────────────────────────────────────────────────────

  Widget _buildAddStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: onAddStory,
        child: Container(
          width: 105.w,
          height: 210.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Stack(
            children: [
              // Subtle background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15),
                      colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
              // Add icon
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.scaffoldBackgroundColor,
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 20.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Label
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Text(
                  'Add status',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Individual Status Card ───────────────────────────────────────────────

  Widget _buildStatusCard(
    BuildContext context,
    ChannelStatusEntity status,
    int index,
  ) {
    final theme = Theme.of(context);
    final String heroTag = 'status_hero_${status.id}_$index';
    final String? displayImageUrl =
        status.primaryImageUrl ?? status.authorAvatarUrl;
    final String displayName = status.authorUsername ?? 'Member';

    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: () {
          if (displayImageUrl == null) return;
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  StatusPage(status: status, heroTag: heroTag),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
            ),
          );
        },
        child: Container(
          width: 105.w,
          height: 210.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Stack(
            children: [
              // 👑 HERO BACKGROUND — status image or avatar fallback
              Positioned.fill(
                child: displayImageUrl != null
                    ? Hero(
                        tag: heroTag,
                        child: CachedNetworkImage(
                          imageUrl: displayImageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _avatarFallback(status, theme),
                        ),
                      )
                    : _avatarFallback(status, theme),
              ),
              // Dark gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              // Author avatar ring
              if (status.authorAvatarUrl != null)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: AppAvatar(
                    size: 32,
                    imageUrl: status.authorAvatarUrl,
                    hasStatus: true,
                    statusSegmentCount: status.imageUrls.length,
                    isStatusRead: false, // 👑 TODO: Link to real seen state
                  ),
                ),
              // Author name
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Text(
                  displayName.split(' ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarFallback(ChannelStatusEntity status, ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
