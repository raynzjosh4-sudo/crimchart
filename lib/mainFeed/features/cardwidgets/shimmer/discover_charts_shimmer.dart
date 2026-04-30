import 'package:flutter/material.dart';
import '../../../../features/widgets/shimmer/shimmer_effect.dart';
import '../../../../core/utils/responsive_size.dart';

class discoverTopsShimmer extends StatelessWidget {
  const discoverTopsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(0.1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.w),
                ),
              ),
              Container(
                width: 50.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.w),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 330.h,
          child: ShimmerEffect(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 220.w,
                  margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar Stack placeholder (MimicTop TopStarAvatarStack)
                      SizedBox(
                        width: 140.w,
                        height: 80.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Main Avatar
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.withOpacity(0.2),
                              ),
                            ),
                            // Overlapping Competitors
                            Positioned(
                              left: 20.w,
                              bottom: 0,
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withOpacity(0.15),
                                  border: Border.all(color: Colors.black12, width: 1),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20.w,
                              bottom: 0,
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withOpacity(0.15),
                                  border: Border.all(color: Colors.black12, width: 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Name
                      Container(
                        width: 100.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Title
                      Container(
                        width: 140.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Count
                      Container(
                        width: 40.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Join Button
                      Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}





























