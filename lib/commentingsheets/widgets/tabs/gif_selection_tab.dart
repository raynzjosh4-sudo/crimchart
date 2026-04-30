import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../features/widgets/chartcard/models/media_data.dart';

class GifSelectionTab extends StatefulWidget {
  final List<int> selectedIndices;
  final Function(int index, MediaData item) onMediaTap;

  const GifSelectionTab({
    super.key,
    required this.selectedIndices,
    required this.onMediaTap,
  });

  @override
  State<GifSelectionTab> createState() => _GifSelectionTabState();
}

class _GifSelectionTabState extends State<GifSelectionTab> {
  bool _isCategoriesExpanded = false;
  bool _isSearchExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Placeholder list of trending GIF categories or a search bar
    final List<String> categories = ['Trending', 'Reaction', 'Dance', 'Celebrate', 'Funny', 'Sports'];

    return Column(
      children: [
        // Expandable Search Bar
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: AnimatedCrossFade(
            firstChild: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(LucideIcons.search),
                onPressed: () {
                  setState(() {
                    _isSearchExpanded = true;
                  });
                },
              ),
            ),
            secondChild: TextField(
              decoration: InputDecoration(
                hintText: 'Search GIFs...',
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(LucideIcons.x, size: 16),
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = false;
                    });
                  },
                ),
                filled: true,
                fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            crossFadeState: _isSearchExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ),
        
        // Expandable Categories Toggle
        InkWell(
          onTap: () {
            setState(() {
              _isCategoriesExpanded = !_isCategoriesExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Icon(
                  _isCategoriesExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  size: 20,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),

        // Categories List (Animated)
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(
                      categories[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
          crossFadeState: _isCategoriesExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),

        // Grid Placeholder
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final isSelected = widget.selectedIndices.contains(index);
              return GestureDetector(
                onTap: () {
                  final dummyMedia = MediaData(
                    type: MediaType.image,
                    contentUrl: 'https://picsum.photos/seed/gif$index/400/400',
                  );
                  widget.onMediaTap(index, dummyMedia);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: colorScheme.primary, width: 3) : null,
                    image: DecorationImage(
                      image: NetworkImage('https://picsum.photos/seed/gif$index/400/400'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.check, size: 16, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}





























