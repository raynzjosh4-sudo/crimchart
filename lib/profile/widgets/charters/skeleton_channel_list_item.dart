import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class SkeletonChannelListItem extends StatefulWidget {
  const SkeletonChannelListItem({super.key});

  @override
  State<SkeletonChannelListItem> createState() =>
      _SkeletonChannelListItemState();
}

class _SkeletonChannelListItemState extends State<SkeletonChannelListItem>
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final base = colorScheme.onSurface.withOpacity(0.04);
        final highlight = colorScheme.onSurface.withOpacity(0.12);
        final color = Color.lerp(base, highlight, _anim.value)!;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Avatar Stack Area
              SizedBox(
                width: 85.w,
                height: 55.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 30.w,
                      child: Container(
                        width: 55.w,
                        height: 55.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15.w,
                      child: Container(
                        width: 55.w,
                        height: 55.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 55.w,
                        height: 55.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Text Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Container(
                          width: 40.w,
                          height: 11.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Container(
                          width: 30.w,
                          height: 13.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          width: 30.w,
                          height: 13.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}











