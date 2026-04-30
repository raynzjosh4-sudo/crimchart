import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../features/widgets/shimmer/shimmer_effect.dart';
import '../../../../core/utils/responsive_size.dart';

class StoryListShimmer extends StatelessWidget {
  const StoryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(0.1);

    return Container(
      height: 110.h,
      margin: EdgeInsets.only(bottom: 16.h),
      child: ShimmerEffect(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                children: [
                  CustomPaint(
                    size: Size(72.w, 72.w),
                    painter: _HexagonSkeletonPainter(color: color),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 50.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HexagonSkeletonPainter extends CustomPainter {
  final Color color;
  _HexagonSkeletonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      double angle = (i * 60 - 90) * math.pi / 180;
      double x = centerX + radius * math.cos(angle);
      double y = centerY + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}











