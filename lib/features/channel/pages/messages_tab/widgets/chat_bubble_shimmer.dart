import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:shimmer/shimmer.dart';

class ChatBubbleShimmer extends StatelessWidget {
  const ChatBubbleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = isDark ? Colors.grey[900]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Shimmer
            Container(
              width: 38.w,
              height: 38.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name Shimmer
                      Container(
                        width: 100.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      // Time Shimmer
                      Container(
                        width: 40.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Message Line 1
                  Container(
                    width: double.infinity,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Message Line 2 (Shorter)
                  Container(
                    width: 180.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
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
