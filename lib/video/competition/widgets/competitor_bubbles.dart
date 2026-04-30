import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../profile/models/charter_model.dart';

class CompetitorBubbles extends StatefulWidget {
  final List<CharterModel> competitors;

  const CompetitorBubbles({super.key, required this.competitors});

  @override
  State<CompetitorBubbles> createState() => _CompetitorBubblesState();
}

class _CompetitorBubblesState extends State<CompetitorBubbles> with TickerProviderStateMixin {
  final List<_Bubble> _bubbles = [];
  final Random _random = Random();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Periodically spawn bubbles
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (widget.competitors.isNotEmpty) {
        _spawnBubble();
      }
    });
  }

  void _spawnBubble() {
    final competitor = widget.competitors[_random.nextInt(widget.competitors.length)];
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000 + _random.nextInt(3000)),
    );

    final bool fromLeft = _random.nextBool();
    
    // Side margins
    const double sideMargin = 70.0;
    final double startX = fromLeft ? -50 : MediaQuery.of(context).size.width;
    
    // Pre-calculate target X to avoid jitter in build method
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetX = fromLeft 
        ? sideMargin - _random.nextDouble() * 40 
        : screenWidth - sideMargin + _random.nextDouble() * 40;

    final bubble = _Bubble(
      competitor: competitor,
      controller: controller,
      startX: startX,
      targetX: targetX,
      size: 35 + _random.nextDouble() * 25,
      // Random vertical drift variation
      verticalOscillation: 5 + _random.nextDouble() * 10,
    );

    setState(() {
      _bubbles.add(bubble);
    });

    controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _bubbles.remove(bubble);
        });
      }
      controller.dispose();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var bubble in _bubbles) {
      bubble.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        clipBehavior: Clip.none,
        children: _bubbles.map((bubble) {
          return AnimatedBuilder(
            animation: bubble.controller,
            builder: (context, child) {
              final progress = bubble.controller.value;
              
              // Smooth horizontal interpolation
              final double currentX = bubble.startX + (bubble.targetX - bubble.startX) * progress;
              
              // Smooth vertical travel with gentle oscillation
              final double currentY = 220 - (progress * 220) + (sin(progress * pi * 2) * bubble.verticalOscillation);

              // Fade and scale down as they vanish
              final opacity = (1.0 - progress).clamp(0.0, 1.0);
              final scale = 1.0 - (progress * 0.2);

              return Positioned(
                left: currentX,
                top: currentY,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: bubble.size,
                      height: bubble.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          bubble.competitor.profileImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _Bubble {
  final CharterModel competitor;
  final AnimationController controller;
  final double startX;
  final double targetX;
  final double size;
  final double verticalOscillation;

  _Bubble({
    required this.competitor,
    required this.controller,
    required this.startX,
    required this.targetX,
    required this.size,
    required this.verticalOscillation,
  });
}





























