import 'dart:math';
import 'package:flutter/material.dart';

class GiftBubbleAnimation extends StatefulWidget {
  final Offset startOffset;
  final String imageUrl;
  final VoidCallback onComplete;

  const GiftBubbleAnimation({
    super.key,
    required this.startOffset,
    required this.imageUrl,
    required this.onComplete,
  });

  @override
  State<GiftBubbleAnimation> createState() => _GiftBubbleAnimationState();
}

class _GiftBubbleAnimationState extends State<GiftBubbleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    final random = Random();
    final angle = random.nextDouble() * 2 * pi; // Random angle in all directions
    final distance = 100.0 + random.nextDouble() * 100.0; // Random distance
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _xAnimation = Tween<double>(begin: 0, end: cos(angle) * distance).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _yAnimation = Tween<double>(begin: 0, end: sin(angle) * distance).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.2), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.8), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.startOffset.dx - 15 + _xAnimation.value,
          top: widget.startOffset.dy - 15 + _yAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Image.network(
                widget.imageUrl,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}





























