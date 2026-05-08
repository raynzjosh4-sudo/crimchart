import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

/// A loading shimmer effect for the Tag selection UI.
class TagShimmer extends StatelessWidget {
  const TagShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey[900]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title Shimmer ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 100.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),

        // ── Carousel Shimmer ──
        SizedBox(
          height: 230.h, // 👑 Matches new carousel height
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) => _buildCardShimmer(baseColor, highlightColor),
          ),
        ),
      ],
    );
  }

  Widget _buildCardShimmer(Color base, Color highlight) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: 150.w, // 👑 Matches new card width
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            Container(
              width: 80.w, // 👑 Matches new image size
              height: 80.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              width: 90.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              width: 50.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            const Spacer(),
            Container(
              width: 90.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
