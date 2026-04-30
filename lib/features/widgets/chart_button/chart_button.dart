import 'package:flutter/material.dart';

class ChartButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double size;

  const ChartButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.icon,
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
    this.size = 56.0, // Standard floating action button size
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      clipBehavior:
          Clip.hardEdge, // Ensures the ripple effect stays inside the circle
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
        ),
      ),
    );
  }
}





























