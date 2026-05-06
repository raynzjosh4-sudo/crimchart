import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:shimmer/shimmer.dart';

class FeedPostShimmer extends StatelessWidget {
  const FeedPostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 8.h,
          ),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: colorScheme.onSurface.withValues(alpha: 0.05),
        highlightColor: colorScheme.onSurface.withValues(alpha: 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  // Avatar Circle
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Name Bar
                  Container(
                    width: 120.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  const Spacer(),
                  // More Icon Circle
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Content Lines
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 220.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
