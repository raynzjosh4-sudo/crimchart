import 'package:crown/core/localization/localization_provider.dart';
import 'package:flutter/material.dart';

class ChannelSelectorRow extends StatefulWidget {
  final String title;
  final int initialItemCount;
  final int selectedIndex;
  final ValueChanged<int>? onChannelSelect;
  final void Function(int index)? onChartConfirm;
  final VoidCallback? onBrowseAll;

  const ChannelSelectorRow({
    super.key,
    required this.title,
    this.initialItemCount = 8,
    required this.selectedIndex,
    this.onChannelSelect,
    this.onChartConfirm,
    this.onBrowseAll,
  });

  @override
  State<ChannelSelectorRow> createState() => _ChannelSelectorRowState();
}

class _ChannelSelectorRowState extends State<ChannelSelectorRow> {
  late int _itemCount;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _itemCount = widget.initialItemCount;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);

    // Simulate network delay for pagination
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _itemCount += 8;
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: widget.onBrowseAll,
                child: Text(
                  context.tr('browse_all'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10), // Reduced spacing
        SizedBox(
          height: 120, // Adjusted height
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _itemCount + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _itemCount) {
                // Progress Indicator aligned with Avatars
                return const Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final isSelected = index == widget.selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => widget.onChannelSelect?.call(index),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.white10,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://picsum.photos/seed/${index + 50}/200',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.tr(
                        'channel_name',
                        args: {'number': (index + 1).toString()},
                      ),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Chart Button with tighter integration
                    if (isSelected)
                      GestureDetector(
                        onTap: () => widget.onChartConfirm?.call(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            context.tr('Chart_confirm'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}











