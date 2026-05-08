import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../../profile/models/charter_model.dart';

class BackCard extends StatefulWidget {
  final double width;
  final double height;
  final double opacity;
  final Color color;
  final CharterModel? model;
  final VoidCallback? onTap;

  const BackCard({
    super.key,
    required this.width,
    required this.height,
    this.opacity = 1.0,
    this.color = Colors.pinkAccent,
    this.model,
    this.onTap,
  });

  @override
  State<BackCard> createState() => BackCardState();
}

class BackCardState extends State<BackCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Slower, clearer pulse
    );
    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.15),
          weight: 50,
        ), // Larger scale
        TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
      ],
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void pulse() {
    debugPrint('BackCard pulse triggered');
    if (_pulseController.isAnimating) {
      _pulseController.stop();
    }
    _pulseController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.8),
                  width: 2.0,
                ),
                image: widget.model != null
                    ? DecorationImage(
                        image: NetworkImage(widget.model!.profileImageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.3),
                          BlendMode.darken,
                        ),
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: widget.model != null
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.9),
                          ],
                          stops: const [0.65, 1.0],
                        ),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model!.username.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${widget.model!.chartCount} KP',
                            style: TextStyle(
                              color: widget.color.withValues(alpha: 0.9),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}











