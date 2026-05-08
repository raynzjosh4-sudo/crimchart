import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class StatusWidgetShimmer extends StatelessWidget {
  const StatusWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Shimmer
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 80.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        // Cards Shimmer
        Container(
          height: 220.h,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 6, // 1 placeholder for 'Add status' + 5 for actual statuses
            itemBuilder: (context, index) {
              final isAddStatus = index == 0;
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 105.w,
                    height: 210.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      // Add a subtle border-like feel for the first card
                      border: isAddStatus ? Border.all(color: Colors.white24, width: 2) : null,
                    ),
                    child: isAddStatus 
                      ? Stack(
                          children: [
                            Positioned(
                              top: 8.h,
                              left: 8.w,
                              child: Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
