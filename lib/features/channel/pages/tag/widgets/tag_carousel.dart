import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'tag_card.dart';

/// A horizontal carousel that displays a collection of TagCards.
class TagCarousel extends StatelessWidget {
  final List<TagCard> cards;
  final String? title;
  final String? trailingText;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const TagCarousel({
    super.key,
    required this.cards,
    this.title,
    this.trailingText,
    this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (trailingText != null)
                  Text(
                    trailingText!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(
          height: 230.h, // 👑 Increased to accommodate larger buttons
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: cards.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              if (index < cards.length) {
                return cards[index];
              } else {
                return _buildLoadMoreIndicator();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      width: 60.w,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
      ),
    );
  }
}
