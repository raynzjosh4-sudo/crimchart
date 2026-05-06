import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:crown/core/utils/responsive_size.dart';

class VideoAndMomentPageShimmer extends StatelessWidget {
  const VideoAndMomentPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Theme-aware shimmer colors - high contrast for OLED
    final baseColor = colorScheme.onSurface.withValues(alpha: 0.25);
    final highlightColor = colorScheme.onSurface.withValues(alpha: 0.45);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Horizontal Carousel
            SizedBox(height: 20.h),
            SizedBox(
              height: 300.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (context, index) =>
                    _buildTopCardShimmer(baseColor),
              ),
            ),

            // 2. Center Text & Button Section
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _shimmerBlock(
                    width: 250.w,
                    height: 30.h,
                    borderRadius: 8.r,
                    baseColor: baseColor,
                  ),
                  SizedBox(height: 10.h),
                  _shimmerBlock(
                    width: 200.w,
                    height: 15.h,
                    borderRadius: 4.r,
                    baseColor: baseColor,
                  ),
                  SizedBox(height: 10.h),
                  _shimmerBlock(
                    width: 80.w,
                    height: 15.h,
                    borderRadius: 4.r,
                    baseColor: baseColor,
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _shimmerBlock(
                      width: 140.w,
                      height: 45.h,
                      borderRadius: 25.r,
                      baseColor: baseColor,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Staggered Grid Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildGridCardShimmer(280.h, baseColor),
                        SizedBox(height: 12.h),
                        _buildGridCardShimmer(180.h, baseColor),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      children: [
                        _buildGridCardShimmer(350.h, baseColor),
                        SizedBox(height: 12.h),
                        _buildGridCardShimmer(150.h, baseColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBlock({
    required double width,
    required double height,
    required double borderRadius,
    required Color baseColor,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildTopCardShimmer(Color baseColor) {
    return Container(
      width: 220.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15.r,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 60.w,
                height: 12.h,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridCardShimmer(double height, Color baseColor) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.w,
            height: 12.h,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 60.w,
            height: 10.h,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}
