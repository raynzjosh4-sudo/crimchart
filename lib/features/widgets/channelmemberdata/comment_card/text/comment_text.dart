import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class CommentText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const CommentText({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.4,
        ),
      ),
    );
  }
}











