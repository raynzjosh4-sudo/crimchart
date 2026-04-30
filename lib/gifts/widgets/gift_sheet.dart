import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/gift_model.dart';
import '../dummydata/gift_dummy_data.dart';
import '../models/gift_recipient.dart';
import 'animated_gift_overlay.dart';

class GiftSheet extends StatefulWidget {
  final Color themeColor;
  final GiftRecipient? recipient;

  const GiftSheet({super.key, required this.themeColor, this.recipient});

  @override
  State<GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends State<GiftSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(color: Color(0xFF121212)),
      child: Column(
        children: [
          // Header with Cancel Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 40,
                ), // Placeholder to balance close button
                const Text(
                  'SEND GIFT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Tab bar
          TabBar(
            controller: _tabController,
            isScrollable: false,
            indicatorColor: widget.themeColor,
            indicatorWeight: 2,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
            tabs: const [
              Tab(text: 'FREE'),
              Tab(text: 'PREMIUM'),
              Tab(text: 'MORE'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _GiftGrid(
                  key: const PageStorageKey('free_gifts'),
                  category: 'Free',
                  themeColor: widget.themeColor,
                  recipient: widget.recipient,
                  onClose: (gift) => Navigator.pop(context, gift),
                ),
                _GiftGrid(
                  key: const PageStorageKey('paid_gifts'),
                  category: 'Paid',
                  themeColor: widget.themeColor,
                  recipient: widget.recipient,
                  onClose: (gift) => Navigator.pop(context, gift),
                ),
                _GiftGrid(
                  key: const PageStorageKey('more_gifts'),
                  category: 'More',
                  themeColor: widget.themeColor,
                  recipient: widget.recipient,
                  onClose: (gift) => Navigator.pop(context, gift),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GiftGrid extends StatefulWidget {
  final String category;
  final Color themeColor;
  final GiftRecipient? recipient;
  final void Function(GiftModel)? onClose;

  const _GiftGrid({
    super.key,
    required this.category,
    required this.themeColor,
    this.recipient,
    this.onClose,
  });

  @override
  State<_GiftGrid> createState() => _GiftGridState();
}

class _GiftGridState extends State<_GiftGrid>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 15;
  late final PagingController<int, GiftModel> _pagingController;
  late List<GiftModel> _filteredGifts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _filterGifts();
    _pagingController = PagingController<int, GiftModel>(
      fetchPage: (pageKey) async {
        await Future.delayed(const Duration(milliseconds: 300));
        final start = pageKey;
        if (start >= _filteredGifts.length) return [];
        final end = (start + _pageSize).clamp(0, _filteredGifts.length);
        return _filteredGifts.sublist(start, end);
      },
      getNextPageKey: (state) {
        final totalLoaded =
            state.pages?.fold(0, (sum, page) => sum + page.length) ?? 0;
        if (totalLoaded >= _filteredGifts.length) return null;
        return totalLoaded;
      },
    );
  }

  void _filterGifts() {
    if (widget.category == 'Free') {
      _filteredGifts = dummyGifts.where((g) => g.coinPrice == 0).toList();
    } else if (widget.category == 'Paid') {
      _filteredGifts = dummyGifts
          .where((g) => g.coinPrice > 0 && g.coinPrice < 100)
          .toList();
    } else if (widget.category == 'More') {
      _filteredGifts = dummyGifts.where((g) => g.coinPrice >= 100).toList();
    } else {
      _filteredGifts = [];
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_filteredGifts.isEmpty) {
      return const Center(
        child: Text(
          'No gifts in this category',
          style: TextStyle(color: Colors.white24),
        ),
      );
    }

    return ValueListenableBuilder<PagingState<int, GiftModel>>(
      valueListenable: _pagingController,
      builder: (context, state, _) {
        final items = state.pages?.expand((p) => p).toList() ?? [];
        final totalLoaded = items.length;
        final hasMore = totalLoaded < _filteredGifts.length;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: totalLoaded + (hasMore ? 1 : 0),
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.white10, height: 0, indent: 70),
          itemBuilder: (context, index) {
            if (index == totalLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _pagingController.fetchNextPage();
              });
              return const _LoadingListTile();
            }

            final gift = items[index];
            return _GiftListTile(
              gift: gift,
              themeColor: widget.themeColor,
              recipient: widget.recipient,
              onSend: (g) => widget.onClose?.call(g),
            );
          },
        );
      },
    );
  }
}

class _GiftListTile extends StatelessWidget {
  final GiftModel gift;
  final Color themeColor;
  final GiftRecipient? recipient;
  final void Function(GiftModel)? onSend;

  const _GiftListTile({
    required this.gift,
    required this.themeColor,
    this.recipient,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          // Gift Image/Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                gift.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.card_giftcard,
                    size: 20,
                    color: Colors.white24,
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gift.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 12,
                      color: Colors.amber.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${gift.coinPrice}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Send Button
          GestureDetector(
            onTap: () {
              if (recipient != null) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final Offset sourceOffset = box.localToGlobal(Offset.zero);
                final Size buttonSize = box.size;

                // Center the animation start point (gift is 40x40)
                final Offset centeredSource = Offset(
                  sourceOffset.dx + buttonSize.width / 2 - 20,
                  sourceOffset.dy + buttonSize.height / 2 - 20,
                );

                AnimatedGiftOverlay.show(
                  context: context,
                  giftImageUrl: gift.imageUrl,
                  sourceOffset: centeredSource,
                  targetKey: recipient!.avatarKey,
                );
              }
              onSend?.call(gift);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeColor,
                    themeColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'SEND',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingListTile extends StatelessWidget {
  const _LoadingListTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
        ),
      ),
    );
  }
}





























