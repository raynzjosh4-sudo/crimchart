import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GeneralChartBubbles extends StatefulWidget {
  const GeneralChartBubbles({super.key});

  @override
  State<GeneralChartBubbles> createState() => _GeneralChartBubblesState();
}

class _GeneralChartBubblesState extends State<GeneralChartBubbles> with TickerProviderStateMixin {
  final List<_ChartBubble> _bubbles = [];
  final Random _random = Random();
  late Timer _timer;
  final String _ChartImageUrl = 'https://cdn-icons-png.flaticon.com/512/6941/6941697.png';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        _spawnBubble();
      }
    });
  }

  void _spawnBubble() {
    final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 3000 + _random.nextInt(2000)),
    );

    final double startX = _random.nextDouble() * MediaQuery.of(context).size.width;
    final double endX = startX + (_random.nextDouble() * 100 - 50);

    final bubble = _ChartBubble(
      controller: controller,
      startX: startX,
      endX: endX,
      size: 15 + _random.nextDouble() * 15,
      rotationSpeed: (_random.nextDouble() * 2 - 1) * pi,
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
    return IgnorePointer(
      child: Stack(
        children: _bubbles.map((bubble) {
          return AnimatedBuilder(
            animation: bubble.controller,
            builder: (context, child) {
              final progress = bubble.controller.value;
              final currentY = MediaQuery.of(context).size.height - (progress * MediaQuery.of(context).size.height);
              final currentX = bubble.startX + (bubble.endX - bubble.startX) * progress;
              final opacity = (1.0 - progress).clamp(0.0, 1.0);
              final rotation = progress * bubble.rotationSpeed;

              return Positioned(
                left: currentX,
                top: currentY,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Image.network(
                      _ChartImageUrl,
                      width: bubble.size,
                      height: bubble.size,
                      fit: BoxFit.contain,
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

class _ChartBubble {
  final AnimationController controller;
  final double startX;
  final double endX;
  final double size;
  final double rotationSpeed;

  _ChartBubble({
    required this.controller,
    required this.startX,
    required this.endX,
    required this.size,
    required this.rotationSpeed,
  });
}





























