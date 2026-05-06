import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import '../../../domain/sdui/feed_component.dart';
import '../../../domain/sdui/error_boundary.dart';

class StatusCardCarouselComponent extends FeedComponent {
  final List<FeedComponent> cards;

  const StatusCardCarouselComponent({required this.cards})
    : super('status_card_carousel');

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
            width: 8.h,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return ErrorBoundary(
                  fallback: const SizedBox.shrink(),
                  child: card.build(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
