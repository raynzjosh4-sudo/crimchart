import 'package:crimchart/features/widgets/chartcard/models/media_data.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';
import '../../models/member.dart';
import '../datacardwidget/data_card.dart';
import '../datacardwidget/sample_media_data.dart';

class MemberMediaDataSheet extends StatefulWidget {
  final Member member;

  const MemberMediaDataSheet({super.key, required this.member});

  @override
  State<MemberMediaDataSheet> createState() => _MemberMediaDataSheetState();
}

class _MemberMediaDataSheetState extends State<MemberMediaDataSheet> {
  final SampleMediaData _sampleData = SampleMediaData();
  final ScrollController _scrollController = ScrollController();

  static const int _pageSize = 5;
  int _visibleCount = _pageSize;
  bool _isLoadingMore = false;
  int? _selectedIndex;

  bool get _hasMore => _visibleCount < _sampleData.items.length;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Pre-select if member already has a selection
    if (widget.member.selectedMedia != null) {
      final idx = _sampleData.items.indexWhere(
        (m) => m.contentUrl == widget.member.selectedMedia!.contentUrl,
      );
      if (idx != -1) _selectedIndex = idx;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 40 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _visibleCount = (_visibleCount + _pageSize).clamp(
          0,
          _sampleData.items.length,
        );
        _isLoadingMore = false;
      });
    }
  }

  void _onCardTap(int index, MediaData item) {
    setState(() => _selectedIndex = index);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) Navigator.pop(context, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleItems = _sampleData.items.take(_visibleCount).toList();
    final hasFooter = _hasMore || _isLoadingMore;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const MemberImage(size: 34),
                    const SizedBox(width: 12),
                    Text(
                      widget.member.name,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Grid with pagination
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => DataCard(
                        mediaData: visibleItems[index],
                        isSelected: _selectedIndex == index,
                        onTap: () => _onCardTap(index, visibleItems[index]),
                      ),
                      childCount: visibleItems.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 100 / 160,
                        ),
                  ),
                ),
                if (hasFooter)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _isLoadingMore
                          ? Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              ),
                            )
                          : Center(
                              child: TextButton(
                                onPressed: _loadMore,
                                child: Text(
                                  'Load more',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}











