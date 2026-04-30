import 'package:flutter/material.dart';

class VisibilityTracker extends StatefulWidget {
  final Widget child;
  final ValueChanged<bool> onVisibilityChanged;

  const VisibilityTracker({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
  });

  @override
  State<VisibilityTracker> createState() => _VisibilityTrackerState();
}

class _VisibilityTrackerState extends State<VisibilityTracker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onVisibilityChanged(true);
      }
    });
  }

  @override
  void dispose() {
    // Schedule the callback so it doesn't execute during the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onVisibilityChanged(false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
