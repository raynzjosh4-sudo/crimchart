import 'package:flutter/material.dart';
import '../../domain/sdui/feed_component.dart';
import '../../domain/sdui/error_boundary.dart';

class DynamicFeedView extends StatelessWidget {
  final List<FeedComponent> components;

  const DynamicFeedView({
    super.key,
    required this.components,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final component = components[index];
          
          // The Error Boundary: Prevents a single bad widget from causing a White Screen of Death
          return ErrorBoundary(
            fallback: const SizedBox.shrink(), // Silently hide broken UI
            child: component.build(context),
          );
        },
        childCount: components.length,
      ),
    );
  }
}
