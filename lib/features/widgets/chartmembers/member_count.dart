import 'package:flutter/material.dart';

class MemberCount extends StatelessWidget {
  final int count;
  final String label;
  final Color? countColor;
  final Color? labelColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  const MemberCount({
    super.key,
    this.count = 560,
    this.label = 'members',
    this.countColor,
    this.labelColor,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCountColor = countColor ?? Theme.of(context).colorScheme.onSurface;
    final effectiveLabelColor = labelColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54);

    return Padding(
      padding: padding,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$count+ ',
              style: TextStyle(
                color: effectiveCountColor,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: label,
              style: TextStyle(
                color: effectiveLabelColor,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





























