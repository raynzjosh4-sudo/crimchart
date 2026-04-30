import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateChannelButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CreateChannelButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<CreateChannelButton> createState() => _CreateChannelButtonState();
}

class _CreateChannelButtonState extends State<CreateChannelButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  Timer? _rotationTimer;

  @override
  void initState() {
    super.initState();
    // Scale animation (tap)
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Start periodic timer for rotation
    _rotationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _rotationController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _rotationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Icon(
              LucideIcons.plus,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}





























