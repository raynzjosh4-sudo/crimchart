import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class SkeletonChartCard extends StatefulWidget {
  final double? width;
  const SkeletonChartCard({super.key, this.width});

  @override
  State<SkeletonChartCard> createState() => _SkeletonChartCardState();
}

class _SkeletonChartCardState extends State<SkeletonChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final base = colorScheme.onSurface.withOpacity(0.04);
        final highlight = colorScheme.onSurface.withOpacity(0.12);
        final color = Color.lerp(base, highlight, _anim.value)!;

        return Container(
          width: widget.width,
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Avatar Stack Area
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              SizedBox(height: 12.h),
              // 2. Name Skeleton
              Container(
                width: 100.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.w),
                ),
              ),
              SizedBox(height: 6.h),
              // 3. Title Skeleton
              Container(
                width: 130.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.w),
                ),
              ),
              const Spacer(),
              // 4. Button Skeleton
              Container(
                width: double.infinity,
                height: 32.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.w),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}











