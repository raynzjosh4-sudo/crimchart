import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class SkeletonExploreGridItem extends StatefulWidget {
  final double aspectRatio;
  const SkeletonExploreGridItem({super.key, required this.aspectRatio});

  @override
  State<SkeletonExploreGridItem> createState() =>
      _SkeletonExploreGridItemState();
}

class _SkeletonExploreGridItemState extends State<SkeletonExploreGridItem>
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
      builder: (context, child) {
        final base = colorScheme.onSurface.withOpacity(0.04);
        final highlight = colorScheme.onSurface.withOpacity(0.12);
        final color = Color.lerp(base, highlight, _anim.value)!;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6.w,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Container(color: color),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
                    SizedBox(width: 7.w),
                    Expanded(
                      child: Container(
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 30.w,
                      height: 12.h,
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
        );
      },
    );
  }
}











