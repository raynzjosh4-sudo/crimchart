import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../dummy_data.dart';
import '../manifesto_grid_widget.dart';
import '../imageviewer/image_viewer_page.dart';

class VideosGridWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> videos;
  final List<String> manifestoVideoUrls;

  const VideosGridWidget({
    super.key,
    required this.scrollController,
    this.videos = const [],
    this.manifestoVideoUrls = const [],
  });

  @override
  State<VideosGridWidget> createState() => _VideosGridWidgetState();
}

class _VideosGridWidgetState extends State<VideosGridWidget> {
  static const int _pageSize = 8;
  int _loadedCount = _pageSize;

  List<Map<String, dynamic>> get _source =>
      widget.videos.isNotEmpty ? widget.videos : SheetDummyData.videos;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = context.read<ThemeProvider>().currentColor;
    final visibleItems = _source.take(_loadedCount).toList();
    final hasMore = _loadedCount < _source.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // ── Featured at top ──
        if (widget.manifestoVideoUrls.isNotEmpty)
          ManifestoGridWidget(imageUrls: widget.manifestoVideoUrls, isVideo: true)
        else if (_source.isNotEmpty)
          ManifestoGridWidget(
            imageUrls: _source.take(1).map((e) => e["url"] as String).toList(),
            isVideo: true,
          ),

        SizedBox(height: 24.h),

        // ── All videos grid ──
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
                    _buildVideoTile(context, visibleItems[index], colorScheme, activeColor),
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

  Widget _buildVideoTile(
      BuildContext context, Map<String, dynamic> video, ColorScheme colorScheme, Color activeColor) {
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
              initialIndex: _source.indexOf(video),
              likes: (video["likes"] as int?) ?? 0,
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
              url: video["url"] as String,
              height: video["type"] == "tall" ? 220.h : 150.h,
              fit: BoxFit.cover,
            ),
          ),
          // Themed play overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.black.withValues(alpha: 0.2),
              ),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: activeColor.withValues(alpha: 0.9),
                  radius: 20.r,
                  child: Icon(LucideIcons.play, color: Colors.white, size: 18.sp),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            left: 10.w,
            child: Row(
              children: [
                Icon(LucideIcons.heart, size: 14.sp, color: Colors.white),
                SizedBox(width: 4.w),
                Text(
                  ((video["likes"] as int?) ?? 0).toString(),
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
