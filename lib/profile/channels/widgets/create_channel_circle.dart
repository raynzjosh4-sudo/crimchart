import 'dart:async';
import 'package:crimchart/channelcreatepage/channel_create_page.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateChannelCircle extends StatefulWidget {
  const CreateChannelCircle({super.key});

  @override
  State<CreateChannelCircle> createState() => _CreateChannelCircleState();
}

class _CreateChannelCircleState extends State<CreateChannelCircle>
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

    // Rotation animation (periodic)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Start periodic timer for rotation every 30s
    _rotationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _rotationController.forward(from: 0.0);
      }
    });

    // Start first rotation after 3 seconds for initial polish
    Timer(const Duration(seconds: 3), () {
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
    final primaryColor = theme.primaryColor;
    final size = 72.w; // Increased from 62.w

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const ChannelCreatePage(),
          ),
        );
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.only(right: 18.w),
          child: Column(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 2.5.w, // Slightly thicker border
                  ),
                  color: primaryColor.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      LucideIcons.plus,
                      color: primaryColor,
                      size: size * 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Create',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}











