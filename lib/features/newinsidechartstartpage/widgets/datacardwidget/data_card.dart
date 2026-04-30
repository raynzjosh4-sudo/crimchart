import 'package:crown/features/widgets/chartcard/models/media_data.dart';
import 'package:flutter/material.dart';
import 'widgets/video_item.dart';
import 'widgets/image_item.dart';
import 'widgets/audio_item.dart';

class DataCard extends StatelessWidget {
  final MediaData mediaData;
  final bool isSelected;
  final VoidCallback? onTap;

  const DataCard({
    super.key,
    required this.mediaData,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 160,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildMediaItem(),
          ),

          // Selection overlay when selected
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

          // Selection indicator — top-right circle icon
          Positioned(
            top: 8,
            right: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : Colors.white.withOpacity(0.8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14, color: colorScheme.onPrimary)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem() {
    switch (mediaData.type) {
      case MediaType.video:
        return VideoItem(contentUrl: mediaData.contentUrl);
      case MediaType.image:
        return ImageItem(contentUrl: mediaData.contentUrl);
      case MediaType.audio:
        return AudioItem(
          contentUrl: mediaData.contentUrl,
          thumbnailUrl: mediaData.thumbnailUrl,
        );
    }
  }
}











