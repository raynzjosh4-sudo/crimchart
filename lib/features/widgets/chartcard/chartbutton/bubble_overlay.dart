import 'dart:math' as math;
import 'package:flutter/material.dart';

class BubbleOverlay extends StatefulWidget {
  final Offset position;
  final Color color;
  final VoidCallback onCompleted;

  const BubbleOverlay({
    super.key,
    required this.position,
    required this.color,
    required this.onCompleted,
  });

  @override
  State<BubbleOverlay> createState() => _BubbleOverlayState();
}

class _BubbleOverlayState extends State<BubbleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Create fixed random offsets for particles to avoid jitter on rebuild
  late final List<Offset> _particleOffsets;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particleOffsets = List.generate(12, (index) {
      final angle = random.nextDouble() * 2 * math.pi;
      final distance = 50 + random.nextDouble() * 100;
      return Offset(math.cos(angle) * distance, math.sin(angle) * distance);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      widget.onCompleted();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Base expanding wave
                Transform.scale(
                  scale: _scaleAnimation.value * 20, // Expand significantly
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                // Particles
                ...List.generate(12, (index) {
                  final targetOffset = _particleOffsets[index];
                  final currentOffset = targetOffset * _scaleAnimation.value;

                  return Transform.translate(
                    offset: currentOffset,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}





























