import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VideoTabShimmer extends StatelessWidget {
  const VideoTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark theme shimmer colors
    final Color baseColor = Colors.grey[900]!;
    final Color highlightColor = Colors.grey[800]!;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. "Moments" Title Placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Container(width: 80.w, height: 16.h, color: Colors.white),
            ),

            // 2. Horizontal Carousel Section
            SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (context, index) => Container(
                  width: 110.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),

            // 3. Middle Info & "Post a Moment" Button Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 18.h,
                    color: Colors.white,
                  ), // "beautiful"
                  SizedBox(height: 8.h),
                  Container(
                    width: 200.w,
                    height: 10.h,
                    color: Colors.white,
                  ), // subtitle line 1
                  SizedBox(height: 6.h),
                  Container(
                    width: 80.w,
                    height: 10.h,
                    color: Colors.white,
                  ), // subtitle line 2

                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 140.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
