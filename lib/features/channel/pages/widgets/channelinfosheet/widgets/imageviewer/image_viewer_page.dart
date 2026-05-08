import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/chart_image.dart';

class ImageViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final int likes;

  const ImageViewerPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.likes = 0,
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500.w),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── VERTICAL PAGEVIEW (TikTok Style) ──
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  final String url = widget.imageUrls[index];
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Center(
                      child: Hero(
                        tag: 'image_hero_${url}',
                        child: ChartImage(
                          url: url,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── TOP BAR (Actions) ──
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildTopButton(LucideIcons.moreVertical, () {}),
                        SizedBox(width: 12.w),
                        _buildTopButton(LucideIcons.x, () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                ),
              ),

              // ── BOTTOM OVERLAY (Scrim + Social Actions) ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 24.h + MediaQuery.of(context).padding.bottom),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Bottom Left: Like Count
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.red, size: 18.sp),
                            SizedBox(width: 8.w),
                            Text(
                              widget.likes.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Right: Vertical Icons
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSideIcon(Icons.favorite, Colors.red, () {}),
                          _buildSideIcon(LucideIcons.share2, Colors.white, () {}),
                          _buildSideIcon(LucideIcons.bookmark, Colors.white, () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _buildSideIcon(IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: color, size: 28.sp),
      ),
    );
  }
}
