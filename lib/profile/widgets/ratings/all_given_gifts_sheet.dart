import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/widgets/chart_image.dart';
import 'package:crown/features/newinsidechartstartpage/models/member.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';

import 'gift_aggregation_models.dart';

class AllGivenGiftsSheet extends StatefulWidget {
  final List<ReceivedGift> gifts;

  const AllGivenGiftsSheet({super.key, required this.gifts});

  @override
  State<AllGivenGiftsSheet> createState() => _AllGivenGiftsSheetState();
}

class _AllGivenGiftsSheetState extends State<AllGivenGiftsSheet> {
  final ScrollController _scrollController = ScrollController();
  List<GiverGroup> _allGroups = [];
  int _displayedCount = 5;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _groupGifts();
    _scrollController.addListener(_onScroll);
  }

  void _groupGifts() {
    final groupedByGiver = <String, GiverGroup>{};
    for (final gift in widget.gifts) {
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
    _allGroups = groupedByGiver.values.toList();
    if (_allGroups.length < _displayedCount) {
      _displayedCount = _allGroups.length;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _displayedCount < _allGroups.length) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _displayedCount = (_displayedCount + 5).clamp(0, _allGroups.length);
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.card_giftcard,
                  size: 16.sp,
                  color: const Color(0xFFFF69B4),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${widget.gifts.length} ${context.tr('gifts')}',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (widget.gifts.any((g) => g.gift.coinPrice > 0)) ...[
                  SizedBox(width: 20.w),
                  Icon(
                    Icons.monetization_on_rounded,
                    size: 16.sp,
                    color: const Color(0xFFFFD700),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${widget.gifts.fold<int>(0, (sum, g) => sum + g.gift.coinPrice)} ${context.tr('coins')}',
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Divider(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            height: 1,
          ),
          // Scrollable List
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 40.h),
              itemCount: _displayedCount < _allGroups.length
                  ? _displayedCount + 1
                  : _displayedCount,
              separatorBuilder: (_, __) => SizedBox(height: 24.h),
              itemBuilder: (context, index) {
                if (index == _displayedCount) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: const Color(0xFFFFD700),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }

                final group = _allGroups[index];
                final aggregatedGifts = group.aggregatedGifts;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
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
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: aggregatedGifts.map((aggGift) {
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
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.08,
                                  ),
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
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.3),
                                          ),
                                        )
                                      : Icon(
                                          Icons.card_giftcard,
                                          size: 16.sp,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.3),
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
                                        color:
                                            colorScheme.surfaceContainerHighest,
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
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}











