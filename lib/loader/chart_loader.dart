import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';

/// A reusable premium Linear Loader used across the Chart app.
/// Extracted from signing pages to provide a consistent loading experience.
class ChartLinearLoader extends StatelessWidget {
  final double height;
  final Color? color;
  final Color backgroundColor;

  const ChartLinearLoader({
    super.key,
    this.height = 2.5,
    this.color,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height.h / 2),
        child: LinearProgressIndicator(
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? colorScheme.primary),
        ),
      ),
    );
  }
}





























