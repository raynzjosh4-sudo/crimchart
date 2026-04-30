import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../features/feed/domain/entities/post_entity.dart';
import '../../../../core/utils/responsive_size.dart';

/// A compact preview card for linked content (e.g., when a post refers to another post).
/// Similar to a "quoted tweet" or "repost preview".
class ThumbnailLinkCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;

  const ThumbnailLinkCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use linked post's preview media
    String? previewUrl;
    if (post.imageUrls.isNotEmpty) {
      previewUrl = post.imageUrls.first;
    } else if (post.videoUrl != null) {
      previewUrl = post.videoUrl;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withAlpha(50)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info (compact)
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10.r,
                    backgroundImage: post.authorAvatarUrl != null
                        ? CachedNetworkImageProvider(post.authorAvatarUrl!)
                        : null,
                    backgroundColor: colorScheme.surfaceVariant,
                    child: post.authorAvatarUrl == null
                        ? Icon(LucideIcons.user, size: 10.r)
                        : null,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      post.authorDisplayName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    post.timeAgo,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),

            // Content Preview (Side-by-side or stacked depending on media availability)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (previewUrl != null)
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: previewUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const Icon(LucideIcons.image),
                        ),
                        if (post.isVideo)
                          const Center(
                            child: Icon(LucideIcons.playCircle, color: Colors.white, size: 30),
                          ),
                      ],
                    ),
                  ),
                
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.caption.isNotEmpty)
                          Text(
                            post.caption,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: previewUrl != null ? 3 : 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (post.caption.isEmpty)
                          Text(
                            "View original content",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                              color: colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
