import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AnimatedSendButton extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final Color color;
  final double size;
  final IconData icon;

  const AnimatedSendButton({
    super.key,
    required this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    required this.color,
    required this.icon,
    this.size = 20,
  });

  @override
  State<AnimatedSendButton> createState() => _AnimatedSendButtonState();
}

class _AnimatedSendButtonState extends State<AnimatedSendButton> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _rocketController;
  late Animation<double> _shakeAnimation;
  late Animation<Offset> _rocketAnimationOut;
  late Animation<Offset> _rocketAnimationIn;

  Timer? _cycleTimer;
  bool _isInteracting = false;
  bool _isLongPressed = false;
  int _step = 0;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.linear),
    );

    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Rocket out (up and right)
    _rocketAnimationOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(60.0, -60.0),
    ).animate(CurvedAnimation(
      parent: _rocketController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Rocket in (from bottom left to center)
    _rocketAnimationIn = Tween<Offset>(
      begin: const Offset(-60.0, 60.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _rocketController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
    ));

    _startCycleTimer();
  }

  void _startCycleTimer() {
    _cycleTimer?.cancel();
    
    // Cycle every 1 minute
    _cycleTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_isInteracting || !mounted) return;
      if (_step == 0) {
        _runRocketSequence();
        _step = 1;
      } else {
        _runShakeSequence();
        _step = 0;
      }
    });
    
    // Initial shake
    Future.delayed(const Duration(seconds: 2), () {
      if (!_isInteracting && mounted) {
        _runShakeSequence();
      }
    });
  }

  Future<void> _runShakeSequence() async {
    if (!mounted || _isInteracting) return;
    try {
      await _shakeController.forward();
      if (mounted) _shakeController.reset();
    } catch (e) {
      // Animation cancelled
    }
  }

  Future<void> _runRocketSequence() async {
    if (!mounted || _isInteracting) return;
    try {
      await _rocketController.forward();
      if (mounted) _rocketController.reset();
    } catch (e) {
      // Animation cancelled
    }
  }

  void _stopAnimations() {
    _isInteracting = true;
    if (_shakeController.isAnimating) {
      _shakeController.stop();
      _shakeController.reset();
    }
    if (_rocketController.isAnimating) {
      _rocketController.stop();
      _rocketController.reset();
    }
  }

  void _resumeAnimations() {
    _isInteracting = false;
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _shakeController.dispose();
    _rocketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _stopAnimations(),
      onExit: (_) => _resumeAnimations(),
      child: GestureDetector(
        onTapDown: (_) => _stopAnimations(),
        onTapUp: (_) {
          if (!_isLongPressed) {
            widget.onTap();
          }
          _resumeAnimations();
        },
        onTapCancel: _resumeAnimations,
        onLongPressStart: (_) {
          _stopAnimations();
          setState(() {
            _isLongPressed = true;
          });
          widget.onLongPressStart?.call();
        },
        onLongPressEnd: (_) {
          setState(() {
            _isLongPressed = false;
          });
          _resumeAnimations();
          widget.onLongPressEnd?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: Listenable.merge([_shakeController, _rocketController]),
          builder: (context, child) {
            
            Offset offset = Offset.zero;
            double rotation = 0.0;
            double opacity = 1.0;
 
            if (_isLongPressed) {
              offset = Offset.zero;
              rotation = 0.0;
              opacity = 1.0;
            } else if (_rocketController.isAnimating) {
              if (_rocketController.value <= 0.4) {
                // Flying out
                offset = _rocketAnimationOut.value;
                opacity = 1.0 - (_rocketController.value / 0.4);
              } else if (_rocketController.value >= 0.6) {
                // Flying in
                offset = _rocketAnimationIn.value;
                opacity = (_rocketController.value - 0.6) / 0.4;
              } else {
                // Invisible in between
                opacity = 0.0;
              }
            } else if (_shakeController.isAnimating) {
               // Shake left/right and slight rotation
               final progress = _shakeAnimation.value;
               offset = Offset(sin(progress * pi * 6) * 4.0, 0); // 3 complete shakes
               rotation = sin(progress * pi * 6) * 0.1;
            }

            return Transform.translate(
              offset: offset,
              child: Transform.rotate(
                angle: rotation,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: child,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4), // Slightly expanded hit area
            color: Colors.transparent,
            child: Icon(
              _isLongPressed ? LucideIcons.mic : widget.icon,
              size: widget.size,
              color: _isLongPressed ? Colors.red : widget.color, // Red for recording
            ),
          ),
        ),
      ),
    );
  }
}





























