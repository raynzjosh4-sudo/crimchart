import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'feed_component.dart';

class UnknownComponent extends FeedComponent {
  const UnknownComponent() : super('unknown');

  @override
  Widget build(BuildContext context) {
    // In production, this usually returns a SizedBox.shrink() to silently ignore new/unsupported types.
    // We render a small debug indicator for development.
    return SizedBox.shrink();
  }
}

class CorruptedComponentError extends FeedComponent {
  final String error;

  const CorruptedComponentError({required this.error}) : super('corrupted');

  @override
  Widget build(BuildContext context) {
    // Silently ignore or show debug info
    return Container(
      margin: EdgeInsets.all(8.h),
      padding: EdgeInsets.all(8.h),
      color: Colors.red.withValues(alpha: 0.1),
      child: Text(
        'SDUI Parse Error: $error',
        style: TextStyle(color: Colors.red, fontSize: 10.sp),
      ),
    );
  }
}
