import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';

class NativeButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const NativeButton({super.key, required this.onTap, required this.text});

  @override
  State<NativeButton> createState() => _NativeButtonState();
}

class _NativeButtonState extends State<NativeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}
