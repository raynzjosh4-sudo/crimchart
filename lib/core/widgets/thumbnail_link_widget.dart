import 'package:flutter/material.dart';
import '../models/content_entity.dart';

/// Widget that displays thumbnail link information for content.
/// Shows the original source and link depth.
class ThumbnailLinkWidget extends StatelessWidget {
  final ThumbnailLink thumbnailLink;
  final VoidCallback? onTap;
  final bool compact;

  const ThumbnailLinkWidget({
    super.key,
    required this.thumbnailLink,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: BoxConstraints(
          minWidth: compact ? 120 : 150,
          maxWidth: compact ? 200 : 300,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Link icon
            Icon(
              thumbnailLink.isOriginal ? Icons.link : Icons.link_off,
              size: compact ? 14 : 16,
              color: thumbnailLink.isOriginal
                  ? colorScheme.primary
                  : colorScheme.secondary,
            ),

            SizedBox(width: compact ? 4 : 6),

            // Link depth indicator
            if (!thumbnailLink.isOriginal) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 4 : 6,
                  vertical: compact ? 2 : 3,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${thumbnailLink.linkDepth}x',
                  style: TextStyle(
                    fontSize: compact ? 10 : 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              SizedBox(width: compact ? 4 : 6),
            ],

            // Original author info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    thumbnailLink.isOriginal ? 'Original Post' : 'Linked from',
                    style: TextStyle(
                      fontSize: compact ? 10 : 12,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '@${thumbnailLink.originalAuthorUsername}',
                    style: TextStyle(
                      fontSize: compact ? 11 : 13,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow icon for navigation
            if (onTap != null) ...[
              SizedBox(width: compact ? 4 : 6),
              Icon(
                Icons.arrow_forward_ios,
                size: compact ? 12 : 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact version for use in lists/cards
class CompactThumbnailLink extends StatelessWidget {
  final ThumbnailLink thumbnailLink;
  final VoidCallback? onTap;

  const CompactThumbnailLink({
    super.key,
    required this.thumbnailLink,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link,
            size: 14,
            color: thumbnailLink.isOriginal
                ? colorScheme.primary
                : colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            thumbnailLink.isOriginal
                ? 'Original'
                : '${thumbnailLink.linkDepth}x linked',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}





























