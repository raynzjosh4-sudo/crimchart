import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum PollMediaType { image, video, text }

class PollItem {
  final String id;
  final String title;
  final String? mediaUrl;
  final PollMediaType type;
  final int points;
  final String? suggestedBy;

  const PollItem({
    required this.id,
    required this.title,
    this.mediaUrl,
    required this.type,
    this.points = 0,
    this.suggestedBy,
  });
}

class PollCarousel extends StatefulWidget {
  final List<PollItem> items;
  final String title;

  const PollCarousel({
    super.key,
    required this.items,
    this.title = 'Active Poll',
    this.isFullWidth = false,
    this.onPointAdd,
  });

  final bool isFullWidth;
  final Function(PollItem)? onPointAdd;

  @override
  State<PollCarousel> createState() => _PollCarouselState();
}

class _PollCarouselState extends State<PollCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // viewportFraction 0.7 makes it "not very wide" as requested
    _pageController = PageController(viewportFraction: 0.7, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: widget.isFullWidth ? 12.h : 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poll Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.isFullWidth ? 16.w : 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: widget.isFullWidth ? 16.sp : 18.sp,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Vote now',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),

          // Horizontal Carousel
          SizedBox(
            height: 340.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              padEnds: false, // Start from the left
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return _PollCard(
                  item: item, 
                  isFullWidth: widget.isFullWidth,
                  onAdd: () => widget.onPointAdd?.call(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PollCard extends StatefulWidget {
  final PollItem item;
  final bool isFullWidth;
  final VoidCallback? onAdd;

  const _PollCard({
    required this.item,
    required this.isFullWidth,
    this.onAdd,
  });

  @override
  State<_PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<_PollCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onAdd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(
        left: widget.isFullWidth ? 16.w : 20.w, 
        right: 4.w,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Media Layer ──
          if (widget.item.type == PollMediaType.text)
            Container(
              padding: EdgeInsets.all(24.w),
              color: theme.primaryColor.withValues(alpha: 0.1),
              child: Center(
                child: Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            )
          else if (widget.item.mediaUrl != null)
            CachedNetworkImage(
              imageUrl: widget.item.mediaUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: colorScheme.surfaceContainer),
            ),

          // ── Video Icon Indicator ──
          if (widget.item.type == PollMediaType.video)
            Center(
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
              ),
            ),

          // ── Overlays ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.6, 1.0],
              ),
            ),
          ),

          Positioned(
            top: 12.h,
            left: 12.w,
            child: widget.item.suggestedBy != null
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Suggested by: ${widget.item.suggestedBy}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Bottom Content: Title + Points ──
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.item.type != PollMediaType.text)
                  Text(
                    widget.item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                SizedBox(height: 8.h),
                
                Row(
                  children: [
                    // Points Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 4.w),
                          Text(
                            '${widget.item.points} Points',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Point Add Button
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: GestureDetector(
                        onTap: _handleTap,
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
