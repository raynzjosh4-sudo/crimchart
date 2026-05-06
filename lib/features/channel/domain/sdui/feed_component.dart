import 'package:flutter/material.dart';

/// Base class for all Server-Driven UI components.
abstract class FeedComponent {
  final String type;
  
  const FeedComponent(this.type);

  /// Every component must know how to render itself safely.
  Widget build(BuildContext context);
}
