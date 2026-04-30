import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/content_entity.dart';
import 'thumbnail_link_widget.dart';
import '../../features/feed/domain/entities/post_entity.dart';
import '../../mainFeed/features/mainfeedcard/thumbnail_link_card.dart';

/// Unified widget for displaying any type of content in feeds.
/// Handles Posts, Comments, Messages, etc. with ThumbnailLink integration.
class FeedItemWidget extends StatelessWidget {
  final ContentEntity content;
  final VoidCallback? onTap;
  final VoidCallback? onThumbnailLinkTap;
  final bool showThumbnailLink;
  final bool compact;

  const FeedItemWidget({
    super.key,
    required this.content,
    this.onTap,
    this.onThumbnailLinkTap,
    this.showThumbnailLink = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Link (if not original and enabled)
            if (showThumbnailLink && !content.thumbnailLink.isOriginal) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ThumbnailLinkWidget(
                  thumbnailLink: content.thumbnailLink,
                  onTap: onThumbnailLinkTap,
                  compact: compact,
                ),
              ),
            ],

            // Author info
            Row(
              children: [
                // Author avatar
                CircleAvatar(
                  radius: compact ? 16 : 20,
                  backgroundImage: content.authorAvatarUrl != null
                      ? CachedNetworkImageProvider(content.authorAvatarUrl!)
                      : null,
                  child: content.authorAvatarUrl == null
                      ? Text(
                          content.authorDisplayName.isNotEmpty
                              ? content.authorDisplayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: compact ? 14 : 16,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : null,
                ),

                const SizedBox(width: 12),

                // Author details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.authorDisplayName,
                        style: TextStyle(
                          fontSize: compact ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '@${content.authorUsername}',
                        style: TextStyle(
                          fontSize: compact ? 12 : 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Timestamp
                Text(
                  _formatTimeAgo(content.createdAt),
                  style: TextStyle(
                    fontSize: compact ? 12 : 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Content body (to be overridden by subclasses)
            _buildContentBody(context),

            // Engagement metrics (likes, comments, etc.)
            if (!compact) ...[
              const SizedBox(height: 12),
              _buildEngagementBar(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the main content body - to be implemented by subclasses
  Widget _buildContentBody(BuildContext context) {
    // Default implementation - subclasses should override
    return const SizedBox.shrink();
  }

  /// Builds engagement metrics bar
  Widget _buildEngagementBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // This will be customized by subclasses based on content type
        Text(
          'Engagement metrics here',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}

/// Specific implementation for Post content
class PostFeedItem extends FeedItemWidget {
  final PostEntity postData;

  const PostFeedItem({
    super.key,
    required super.content,
    required this.postData,
    super.onTap,
    super.onThumbnailLinkTap,
    super.showThumbnailLink,
    super.compact,
  });

  @override
  Widget _buildContentBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post caption
        if (postData.caption.isNotEmpty) ...[
          Text(
            postData.caption,
            style: TextStyle(
              fontSize: compact ? 14 : 16,
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // ── Linked Content Preview ──────────────────────────────────────────
        // If this post references another (e.g. Repost), show the mini-card.
        if (postData.linkedPostId != null)
          ThumbnailLinkCard(
            post: postData, // In a real app, you'd fetch the REAL linked post.
            // For now, we use the current post as a representative placeholder 
            // of the content being linked.
            onTap: onThumbnailLinkTap,
          ),

        // Media content (images, videos) would normally go here too...
      ],
    );
  }

  @override
  Widget _buildEngagementBar(BuildContext context) {
    return Row(
      children: [
        _buildEngagementItem(
          context,
          icon: Icons.favorite,
          count: postData.likes,
          isActive: postData.isLiked,
        ),
        const SizedBox(width: 16),
        _buildEngagementItem(
          context,
          icon: Icons.comment,
          count: postData.comments,
        ),
        const SizedBox(width: 16),
        _buildEngagementItem(
          context,
          icon: Icons.share,
          count: postData.shares,
        ),
      ],
    );
  }

  Widget _buildEngagementItem(
    BuildContext context, {
    required IconData icon,
    required int count,
    bool isActive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// Specific implementation for Comment content
class CommentFeedItem extends FeedItemWidget {
  final dynamic commentData; // CommentEntity or similar

  const CommentFeedItem({
    super.key,
    required super.content,
    required this.commentData,
    super.onTap,
    super.onThumbnailLinkTap,
    super.showThumbnailLink,
    super.compact,
  });

  @override
  Widget _buildContentBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      commentData.text ?? '',
      style: TextStyle(
        fontSize: compact ? 14 : 16,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
    );
  }

  @override
  Widget _buildEngagementBar(BuildContext context) {
    return Row(
      children: [
        _buildEngagementItem(
          context,
          icon: Icons.favorite,
          count: commentData.likes ?? 0,
          isActive: commentData.isLiked ?? false,
        ),
        const SizedBox(width: 16),
        _buildEngagementItem(
          context,
          icon: Icons.reply,
          count: commentData.repliesCount ?? 0,
        ),
      ],
    );
  }

  Widget _buildEngagementItem(
    BuildContext context, {
    required IconData icon,
    required int count,
    bool isActive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}





























