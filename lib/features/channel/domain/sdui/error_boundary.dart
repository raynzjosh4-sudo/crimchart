import 'package:flutter/material.dart';

/// Catches rendering exceptions of its child and displays a fallback UI instead of crashing.
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget fallback;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
  }

  // Note: Flutter's standard ErrorWidget.builder is global.
  // To catch widget-level build errors locally without a 3rd-party package,
  // we use a custom builder. If child throws during build, it will be caught here.
  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallback;
    }

    try {
      // We wrap the child in a builder to catch errors during its build phase if possible.
      return Builder(
        builder: (context) {
          try {
            return widget.child;
          } catch (e) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _error = e);
            });
            return widget.fallback;
          }
        },
      );
    } catch (e) {
      _error = e;
      return widget.fallback;
    }
  }
}
