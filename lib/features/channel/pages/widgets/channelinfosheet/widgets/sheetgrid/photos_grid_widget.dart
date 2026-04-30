import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:crown/core/widgets/chart_image.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../dummy_data.dart';
import '../manifesto_grid_widget.dart';
import '../imageviewer/image_viewer_page.dart';

class PhotosGridWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> photos;
  final List<String> manifestoImageUrls;

  const PhotosGridWidget({
    super.key,
    required this.scrollController,
    this.photos = const [],
    this.manifestoImageUrls = const [],
  });

  @override
  State<PhotosGridWidget> createState() => _PhotosGridWidgetState();
}

class _PhotosGridWidgetState extends State<PhotosGridWidget> {
  static const int _pageSize = 8;
  int _loadedCount = _pageSize;

  List<Map<String, dynamic>> get _source =>
      widget.photos.isNotEmpty ? widget.photos : SheetDummyData.photos;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleItems = _source.take(_loadedCount).toList();
    final hasMore = _loadedCount < _source.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // ── Featured at top ──
        if (widget.manifestoImageUrls.isNotEmpty)
          ManifestoGridWidget(imageUrls: widget.manifestoImageUrls)
        else if (_source.isNotEmpty)
          ManifestoGridWidget(
            imageUrls: _source.take(4).map((e) => e["url"] as String).toList(),
          ),

        SizedBox(height: 24.h),

        // ── All photos grid ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                itemCount: visibleItems.length,
                itemBuilder: (context, index) =>
                    _buildPhotoTile(context, visibleItems[index], colorScheme),
              ),
              if (hasMore) ...[
                SizedBox(height: 16.h),
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _loadedCount += _pageSize),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.chevronDown,
                              size: 16.sp,
                              color: colorScheme.onSurface.withValues(alpha: 0.5)),
                          SizedBox(width: 6.w),
                          Text(
                            'Load more',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoTile(
      BuildContext context, Map<String, dynamic> photo, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            barrierColor: Colors.black.withValues(alpha: 0.5),
            pageBuilder: (context, _, __) => ImageViewerPage(
              imageUrls: _source.map((e) => e["url"] as String).toList(),
              initialIndex: _source.indexOf(photo),
              likes: (photo["likes"] as int?) ?? 0,
            ),
            transitionsBuilder: (context, animation, _, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(position: animation.drive(tween), child: child);
            },
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: ChartImage(
              url: photo["url"] as String,
              height: photo["type"] == "tall" ? 220.h : 150.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 8.h,
            left: 8.w,
            child: Row(
              children: [
                Icon(LucideIcons.heart, size: 14.sp, color: Colors.white),
                SizedBox(width: 4.w),
                Text(
                  ((photo["likes"] as int?) ?? 0).toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
