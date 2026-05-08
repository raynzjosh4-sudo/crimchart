import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/sdui/feed_component.dart';

class PremiumPostComponent extends FeedComponent {
  final String authorName;
  final String authorImageUrl;
  final String timeAgo;
  final String backgroundImageUrl;
  final String caption;
  final String likesCount;
  final String commentsCount;
  final String savesCount;

  const PremiumPostComponent({
    required this.authorName,
    required this.authorImageUrl,
    required this.timeAgo,
    required this.backgroundImageUrl,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.savesCount,
  }) : super('premium_post');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      height: 400.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main Background Image
            CachedNetworkImage(
              imageUrl: backgroundImageUrl,
              fit: BoxFit.cover,
            ),
            
            // Dark Gradient Overlay for content readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            
            // Glassmorphism Header
            Positioned(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20.r,
                                backgroundImage: CachedNetworkImageProvider(authorImageUrl),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            authorName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(Icons.verified, size: 14.sp, color: Colors.white),
                                      ],
                                    ),
                                    Text(
                                      timeAgo,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // More Button with Glass Effect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: const Icon(Icons.more_horiz, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Content
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Interaction Bar
                  Row(
                    children: [
                      _buildStat(Icons.favorite, likesCount),
                      SizedBox(width: 24.w),
                      _buildStat(Icons.chat_bubble, commentsCount),
                      const Spacer(),
                      _buildStat(Icons.bookmark, savesCount),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20.sp),
        SizedBox(width: 6.w),
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
