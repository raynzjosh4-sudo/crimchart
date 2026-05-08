import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:crimchart/features/channel/pages/widgets/channelinfosheet/widgets/imageviewer/image_viewer_page.dart';
import 'package:crimchart/features/channel/pages/widgets/channelinfosheet/widgets/videoviewer/video_viewer_page.dart';

class PinterestGridWidget extends StatefulWidget {
  final List<PostEntity> posts;
  final ScrollController scrollController;

  const PinterestGridWidget({
    super.key,
    required this.posts,
    required this.scrollController,
  });

  @override
  State<PinterestGridWidget> createState() => _PinterestGridWidgetState();
}

class _PinterestGridWidgetState extends State<PinterestGridWidget> {
  static const int _pageSize = 12;
  int _loadedCount = _pageSize;

  List<PostEntity> get _filteredPosts => widget.posts
      .where((p) => (p.imageUrls.isNotEmpty || p.isVideo) && !p.isAudio)
      .toList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allMedia = _filteredPosts;
    final visibleItems = allMedia.take(_loadedCount).toList();
    final hasMore = _loadedCount < allMedia.length;

    if (allMedia.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h),
          child: Column(
            children: [
              Icon(LucideIcons.imageOff, size: 48.sp, color: colorScheme.onSurface.withValues(alpha: 0.1)),
              SizedBox(height: 16.h),
              Text(
                'No media in this channel gallery.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final post = visibleItems[index];
                return _buildPinterestTile(context, post, colorScheme);
              },
            ),
            if (hasMore) ...[
              SizedBox(height: 24.h),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _loadedCount += _pageSize),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.chevronDown, size: 16.sp, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        SizedBox(width: 8.w),
                        Text(
                          'Load more',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPinterestTile(BuildContext context, PostEntity post, ColorScheme colorScheme) {
    // 👑 Pinterest Logic: Tall height for vertical videos, Mixed for images
    final bool isTall = post.isVideo || (post.aspectRatio != null && post.aspectRatio! < 0.85);
    final String thumbUrl = post.imageUrls.isNotEmpty 
        ? post.imageUrls.first 
        : (post.thumbnailUrls.isNotEmpty ? post.thumbnailUrls.first : (post.videoUrl ?? ''));

    return GestureDetector(
      onTap: () => _handleMediaTap(context, post),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 📸 THE MEDIA CONTENT
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: ChartImage(
                url: thumbUrl,
                height: isTall ? 260.h : 180.h,
                fit: BoxFit.cover,
              ),
            ),

            // 🎥 VIDEO OVERLAY (Themed Play Icon)
            if (post.isVideo)
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.play, color: Colors.white, size: 24.sp),
                  ),
                ),
              ),

            // ❤️ LIKES OVERLAY
            Positioned(
              bottom: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.heart, size: 12.sp, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      post.likes.toString(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMediaTap(BuildContext context, PostEntity post) {
    if (post.isVideo) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VideoViewerPage(
            initialVideos: [post],
            initialIndex: 0,
            channelId: post.channelId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => ImageViewerPage(
            imageUrls: [post.imageUrls.first],
            initialIndex: 0,
            likes: post.likes,
          ),
        ),
      );
    }
  }
}
