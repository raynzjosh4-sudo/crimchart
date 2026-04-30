import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/gift_model.dart';
import '../models/gift_recipient.dart';
import '../dummydata/gift_dummy_data.dart';
import '../widgets/gift_item.dart';
import '../widgets/animated_gift_overlay.dart';

class HorizontalGiftScroll extends StatefulWidget {
  final Color themeColor;
  final VoidCallback onSeeAll;
  final Function(String giftId)? onGiftTap;
  final GiftRecipient? recipient;
  final GlobalKey? targetKey;
  final ValueNotifier<GlobalKey?>? targetKeyNotifier;
  final VoidCallback? onArrival;

  const HorizontalGiftScroll({
    super.key,
    required this.themeColor,
    required this.onSeeAll,
    this.onGiftTap,
    this.recipient,
    this.targetKey,
    this.targetKeyNotifier,
    this.onArrival,
  });

  @override
  State<HorizontalGiftScroll> createState() => _HorizontalGiftScrollState();
}

class _HorizontalGiftScrollState extends State<HorizontalGiftScroll> {
  static const int _pageSize = 10;

  late final PagingController<int, GiftModel> _pagingController =
      PagingController<int, GiftModel>(
        fetchPage: (pageKey) async {
          await Future.delayed(const Duration(milliseconds: 300));
          final start = pageKey;
          if (start >= dummyGifts.length) return [];
          final end = (start + _pageSize).clamp(0, dummyGifts.length);
          return dummyGifts.sublist(start, end);
        },
        getNextPageKey: (state) {
          final totalRecords =
              state.pages?.fold(0, (sum, page) => sum + page.length) ?? 0;
          if (totalRecords >= dummyGifts.length) return null;
          return totalRecords;
        },
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50, // Reduced height for horizontal design
          child: ValueListenableBuilder<PagingState<int, GiftModel>>(
            valueListenable: _pagingController,
            builder: (context, state, _) {
              final items = state.pages?.expand((p) => p).toList() ?? [];
              final totalRecords = items.length;
              final bool hasMore = totalRecords < dummyGifts.length;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: totalRecords + 1,
                itemBuilder: (context, index) {
                  if (index == totalRecords) {
                    if (hasMore) {
                      // Fix: Trigger fetchNextPage in the next frame to avoid setState during build
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _pagingController.fetchNextPage();
                        }
                      });
                      return const _LoadingItem();
                    } else {
                      return _buildSeeAll();
                    }
                  }

                  final gift = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Builder(
                      builder: (context) {
                        return SizedBox(
                          width: 95, // Increased width for Row layout
                          child: GiftItem(
                            gift: gift,
                            isSelected: false,
                            onTap: () {
                                final effectiveTargetKey = widget.recipient?.avatarKey ?? 
                                                     widget.targetKey ?? 
                                                     widget.targetKeyNotifier?.value;

                                if (effectiveTargetKey != null) {
                                  final RenderBox box = context.findRenderObject() as RenderBox;
                                  final Offset sourceOffset = box.localToGlobal(Offset.zero);
                                  final Size itemSize = box.size;

                                  // Spawn a burst of 6 gifts
                                  final random = math.Random();
                                  for (int i = 0; i < 6; i++) {
                                    // Slight delay and jitter
                                    Future.delayed(Duration(milliseconds: i * 80), () {
                                      if (!mounted) return;
                                      
                                      // Jitter the source and target slightly
                                      final Offset jitterSource = Offset(
                                        sourceOffset.dx + itemSize.width / 2 - 20 + random.nextDouble() * 10 - 5,
                                        sourceOffset.dy + itemSize.height / 2 - 20 + random.nextDouble() * 10 - 5,
                                      );

                                      AnimatedGiftOverlay.show(
                                        context: context,
                                        giftImageUrl: gift.imageUrl,
                                        sourceOffset: jitterSource,
                                        targetKey: effectiveTargetKey,
                                        onArrival: widget.onArrival,
                                      );
                                    });
                                  }
                                }
                              
                              if (widget.onGiftTap != null) {
                                widget.onGiftTap!(gift.id);
                              }
                            },
                          ),
                        );
                      }
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeeAll() {
    return GestureDetector(
      onTap: widget.onSeeAll,
      child: Container(
        width: 95,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: widget.themeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.themeColor.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: widget.themeColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'ALL',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingItem extends StatelessWidget {
  const _LoadingItem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95,
      height: 50,
      child: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24),
            ),
          ),
        ),
      ),
    );
  }
}





























