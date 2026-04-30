import 'package:flutter/material.dart';

/// The Chart gold linear loading indicator.
/// Displayed at the very top of every AppBar — just like Facebook/Instagram.
/// Pass [isLoading] = true to show it, false to hide it with zero height.
class ChartLinearLoader extends StatelessWidget {
  final bool isLoading;
  final double? value;
  final Color color;
  final double height;

  const ChartLinearLoader({
    super.key,
    required this.isLoading,
    this.value,
    this.color = const Color(0xFFFFB800), // Chart gold
    this.height = 3.2,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isLoading ? height : 0,
      width: double.infinity,
      child: isLoading
          ? LinearProgressIndicator(
              value: value,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: height,
            )
          : const SizedBox.shrink(),
    );
  }
}





























