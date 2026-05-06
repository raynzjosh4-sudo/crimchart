import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:crown/core/utils/responsive_size.dart';

class MemberPageShimmer extends StatelessWidget {
  const MemberPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Significantly increased opacity for guaranteed visibility across themes
    final baseColor = colorScheme.onSurface.withValues(alpha: 0.25);
    final highlightColor = colorScheme.onSurface.withValues(alpha: 0.45);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Status Section ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: _buildSectionHeader(baseColor),
          ),
          SizedBox(
            height: 160.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, __) => Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),

          SizedBox(height: 32.h),

          // --- Members Section Header ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(baseColor),
                Container(
                  width: 60.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // --- Member Items ---
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 5,
              itemBuilder: (_, __) => _buildMemberShimmer(baseColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(Color baseColor) {
    return Container(
      width: 100.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildMemberShimmer(Color baseColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 80.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
        ],
      ),
    );
  }
}
