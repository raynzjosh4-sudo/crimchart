import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';

/// Full-screen vertical-scroll video feed page.
/// Mimics the native TikTok/Reels feel — edge-to-edge, no app bar chrome,
/// swipe-up/down PageView, and platform-native status bar handling.
class VideoFeedPage extends StatefulWidget {
  final List<PostEntity> videos;
  final int initialIndex;

  const VideoFeedPage({
    super.key,
    required this.videos,
    this.initialIndex = 0,
  });

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  late final PageController _pageController;
  int _currentIndex = 0;
  int _selectedTab = 1; // 0=Explore, 1=Pings, 2=Friends

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Go fully immersive
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // ── Full-screen vertical PageView ──
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: widget.videos.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                return _VideoFeedItem(
                  video: widget.videos[index],
                  isActive: index == _currentIndex,
                );
              },
            ),

            // ── Top overlay: Back + Tab bar + Search ──
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Tab bar
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TabItem(
                            label: 'Explore',
                            isActive: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          SizedBox(width: 20.w),
                          _TabItem(
                            label: 'Pings',
                            isActive: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                          SizedBox(width: 20.w),
                          _TabItem(
                            label: 'Friends',
                            isActive: _selectedTab == 2,
                            onTap: () => setState(() => _selectedTab = 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Search icon
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
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
}

class _VideoFeedItem extends StatefulWidget {
  final PostEntity video;
  final bool isActive;

  const _VideoFeedItem({required this.video, required this.isActive});

  @override
  State<_VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<_VideoFeedItem> {
  late bool _isLiked;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likes = widget.video.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background thumbnail ──
        CachedNetworkImage(
          imageUrl: widget.video.thumbnailUrls.isNotEmpty
              ? widget.video.thumbnailUrls.first
              : (widget.video.imageUrls.isNotEmpty ? widget.video.imageUrls.first : ''),
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: Colors.grey[900]),
          errorWidget: (_, __, ___) => Container(color: Colors.grey[900]),
        ),

        // ── Dark gradient at top and bottom ──
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x66000000),
                Colors.transparent,
                Colors.transparent,
                Color(0xCC000000),
              ],
              stops: [0.0, 0.25, 0.55, 1.0],
            ),
          ),
        ),

        // ── Bottom-left: creator info + caption ──
        Positioned(
          bottom: 0,
          left: 0,
          right: 80.w,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Creator name + verified
                  Row(
                    children: [
                      Text(
                        widget.video.authorUsername,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.verified,
                        color: Colors.orange,
                        size: 16.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Caption
                  Text(
                    widget.video.caption,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 16.h),

                  // Bottom action row: "..." menu
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54, width: 1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        '• • •',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Right sidebar: avatar + actions ──
        Positioned(
          right: 12.w,
          bottom: 80.h,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Creator avatar
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        (widget.video.authorAvatarUrl?.isNotEmpty == true)
                            ? widget.video.authorAvatarUrl!
                            : 'https://picsum.photos/seed/${widget.video.authorId}/100/100',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Like button
                _SidebarAction(
                  icon: _isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: _isLiked ? Colors.red : Colors.white,
                  label: _formatCount(_likes),
                  onTap: () => setState(() {
                    _isLiked = !_isLiked;
                    _likes += _isLiked ? 1 : -1;
                  }),
                ),
                SizedBox(height: 20.h),

                // Share button
                _SidebarAction(
                  icon: Icons.send_rounded,
                  label: widget.video.comments.toString(),
                  onTap: () {},
                ),
                SizedBox(height: 20.h),

                // Tag button
                _SidebarAction(
                  icon: Icons.local_offer_rounded,
                  label: 'Tag',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }
}

class _SidebarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _SidebarAction({
    required this.icon,
    required this.label,
    this.iconColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 26.sp),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white54,
              fontSize: isActive ? 16.sp : 14.sp,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          SizedBox(height: 3.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.5,
            width: isActive ? 20.w : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
