import 'package:flutter/material.dart';

class StarterName extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final String name;

  const StarterName({
    super.key,
    this.fontSize = 15.0,
    this.color,
    this.name = "Chart stater's name",
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    return Text(
      name,
      style: TextStyle(fontSize: fontSize, color: effectiveColor),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}





























