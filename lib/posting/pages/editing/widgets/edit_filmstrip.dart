import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/media_item.dart';

/// Horizontal filmstrip — white-bordered thumbnail strip with no [+] button
/// (the [+] lives on the right side of the strip row).
class EditFilmstrip extends StatelessWidget {
  final List<MediaItem> items;
  final int currentIndex;
  final VoidCallback? onAddMore;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onRemove;

  const EditFilmstrip({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onAddMore,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: Row(
        children: [
          const SizedBox(width: 12),

          // ── Filmstrip container (scrollable area) ───────────────────────
          Expanded(
            child: Container(
              height: 64, // matched to thumbnail height + border
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final isActive = index == currentIndex;
                    final item = items[index];
                    
                    return LongPressDraggable<int>(
                      data: index,
                      axis: Axis.vertical,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: _buildThumb(item),
                        ),
                      ),
                      childWhenDragging: const SizedBox(width: 54),
                      onDragEnd: (details) {
                        // If drag ends significantly above the starting point, remove item
                        if (details.offset.dy < (MediaQuery.of(context).size.height * 0.7)) {
                          onRemove?.call(index);
                        }
                      },
                      child: GestureDetector(
                        onTap: () => onTap?.call(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 54,
                          decoration: BoxDecoration(
                            border: isActive
                                ? const Border(right: BorderSide(color: Colors.white, width: 2), left: BorderSide(color: Colors.white, width: 2))
                                : null,
                          ),
                          child: _buildThumb(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── [+] Add more ─────────────────────────────────────────────────
          GestureDetector(
            onTap: onAddMore,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumb(MediaItem item) {
    if (item.thumbnailBytes != null) {
      return Image.memory(item.thumbnailBytes!, fit: BoxFit.cover);
    }
    if (item.path.startsWith('http')) {
      return CachedNetworkImage(imageUrl: item.path, fit: BoxFit.cover);
    }
    if (item.type == MediaType.photo) {
      return Image.file(File(item.path), fit: BoxFit.cover);
    }
    return Container(
      color: Colors.white12,
      child: const Center(
        child: Icon(LucideIcons.music, color: Colors.white54, size: 22),
      ),
    );
  }
}
