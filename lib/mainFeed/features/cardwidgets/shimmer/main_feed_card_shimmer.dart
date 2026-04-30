import 'package:flutter/material.dart';
import '../../../../features/widgets/shimmer/shimmer_effect.dart';
import '../../../../core/utils/responsive_size.dart';

class mainfeedcardShimmer extends StatelessWidget {
  const mainfeedcardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(0.1);

    return ShimmerEffect(
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 4.h),
              child: Row(
                children: [
                  // Avatar with Status Ring Shimmer
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withOpacity(0.2), width: 2),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: 160.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                ],
              ),
            ),

            // Caption placeholder
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 200.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ],
              ),
            ),

            // Media Area
            Container(
              width: double.infinity,
              height: 400.h,
              color: color,
            ),

            // Footer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 50.w,
                    height: 11.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





























