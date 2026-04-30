import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  const CustomBackButton({
    super.key,
    required this.onPressed,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        LucideIcons.chevronLeft, // Tailless back icon
        size: size,
      ),
      color: color ?? Theme.of(context).colorScheme.onSurface,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 24,
    );
  }
}





























