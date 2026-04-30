import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/widgets/chart_image.dart';
import 'package:crown/features/newinsidechartstartpage/models/member.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';

import 'gift_aggregation_models.dart';
import 'all_given_gifts_sheet.dart';

class GivenGiftsDisplay extends StatelessWidget {
  final List<ReceivedGift> gifts;

  const GivenGiftsDisplay({super.key, required this.gifts});

  void _openAllGiftsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: AllGivenGiftsSheet(gifts: gifts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (gifts.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Group gifts by giver
    final groupedByGiver = <String, GiverGroup>{};
    for (final gift in gifts) {
      final key = gift.giverAvatarUrl;
      if (!groupedByGiver.containsKey(key)) {
        groupedByGiver[key] = GiverGroup(
          gift.giverName,
          gift.giverAvatarUrl,
          [],
        );
      }
      groupedByGiver[key]!.addGift(gift);
    }

    final groups = groupedByGiver.values.toList();
    if (groups.isEmpty) return const SizedBox.shrink();

    // Only show the very first giver's box
    final group = groups.first;
    final aggregatedGifts = group.aggregatedGifts;
    final visibleGifts = aggregatedGifts.take(8).toList();
    final hiddenGiftsCount = aggregatedGifts.length - visibleGifts.length;
    final showSeeAll = hiddenGiftsCount > 0 || groups.length > 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Header: Avatar, Name, Stats
          Row(
            children: [
              MemberImage(
                size: 32.w,
                imageUrl: group.giverAvatarUrl,
                showStatusRing: false,
                showActiveDot: false,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.giverName,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 13.sp,
                          color: const Color(0xFFFF69B4),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${group.totalGifts} ${context.tr('gifts')}',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (group.totalCoins > 0) ...[
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.monetization_on_rounded,
                            size: 13.sp,
                            color: const Color(0xFFFFD700),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${group.totalCoins} ${context.tr('coins')}',
                            style: TextStyle(
                              color: const Color(0xFFFFD700),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Gifts Wrapped in Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...visibleGifts.map((aggGift) {
                  final sample = aggGift.sample;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Big Gift Image
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.onSurface.withValues(alpha: 0.08),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: sample.gift.imageUrl.startsWith('http')
                              ? ChartImage(
                                  url: sample.gift.imageUrl,
                                  fit: BoxFit.contain,
                                  errorWidget: Icon(
                                    Icons.card_giftcard,
                                    size: 16.sp,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.card_giftcard,
                                  size: 16.sp,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                        ),
                      ),

                      // Count Badge (Top Right)
                      if (aggGift.count > 1)
                        Positioned(
                          right: -8.w,
                          top: -6.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF69B4),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: colorScheme.surfaceContainerHighest,
                                width: 1.5.w,
                              ),
                            ),
                            child: Text(
                              'x${aggGift.count}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                if (showSeeAll)
                  GestureDetector(
                    onTap: () => _openAllGiftsSheet(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hiddenGiftsCount > 0) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              '+$hiddenGiftsCount',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                        ],
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: hiddenGiftsCount > 0 ? 0 : 8.w,
                            vertical: 4.h,
                          ),
                          child: Text(
                            context.tr('see_all'),
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











