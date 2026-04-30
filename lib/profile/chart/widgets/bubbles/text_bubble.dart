import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_size.dart';
import '../../models/chart_message.dart';

class TextBubble extends StatelessWidget {
  final ChartMessage message;

  const TextBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMe = message.isMe;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isMe ? theme.primaryColor : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(isMe ? 20.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 20.r),
        ),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isMe ? Colors.black : colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}





























