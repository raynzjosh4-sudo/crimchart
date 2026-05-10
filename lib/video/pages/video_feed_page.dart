import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import '../core/widgets/tiktok_video_card.dart';
import '../../core/video_engine/native_engine.dart';

class VideoFeedPage extends StatefulWidget {
  const VideoFeedPage({super.key});

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // The Sliding Window Pool (Phase 5)
  // We keep exactly 3 textures alive to prevent Garbage Collection stutters
  final Map<int, int?> _texturePool = {
    0: null, // Previous
    1: null, // Current
    2: null, // Next
  };

  // Tracks the URL currently loaded in each hardware texture
  final Map<int, String> _loadedUrls = {};

  final List<String> testUrls = [
    "https://crown.nexassearch.com/users/a2b1e51a-0343-496b-aea6-8edb17e4f602/channel_posts/Chart_1778126883343.mp4",
    "https://crown.nexassearch.com/users/a2b1e51a-0343-496b-aea6-8edb17e4f602/channel_posts/Chart_1778107583297.mp4",
    "https://crown.nexassearch.com/users/a2b1e51a-0343-496b-aea6-8edb17e4f602/channel_posts/Chart_1778102663539.mp4",
  ];

  @override
  void initState() {
    super.initState();
    _initializePool();
  }

  Future<void> _initializePool() async {
    print('[VideoFeedPage] Initializing Pool...');
    NativeVideoEngine.initialize();

    // Allocate hardware textures from C++
    final t0 = await NativeVideoEngine.createTexture();
    final t1 = await NativeVideoEngine.createTexture();
    final t2 = await NativeVideoEngine.createTexture();

    print('[VideoFeedPage] Textures allocated: $t0, $t1, $t2');

    if (mounted) {
      setState(() {
        _texturePool[0] = t0;
        _texturePool[1] = t1;
        _texturePool[2] = t2;
      });

      // Immediately play the first video on the first texture
      if (t0 != null && t0 >= 0) {
        _loadedUrls[t0] = testUrls[0];
        NativeVideoEngine.playVideo(t0, testUrls[0]);
      }
      
      // Preload the second video on the second texture (TikTok style)
      if (t1 != null && t1 >= 0 && testUrls.length > 1) {
        _loadedUrls[t1] = testUrls[1];
        NativeVideoEngine.preloadVideo(t1, testUrls[1]);
      }
    } else {
      print('[VideoFeedPage] Page disposed during texture allocation.');
    }
  }

  @override
  void dispose() {
    print('[VideoFeedPage] Disposing page, triggering C++ Handshake Disposal...');
    // Destroy all C++ VideoDecoder instances and safely release ANativeWindows
    for (final textureId in _texturePool.values) {
      if (textureId != null && textureId >= 0) {
        NativeVideoEngine.disposeVideo(textureId);
        NativeVideoEngine.disposeTexture(textureId);
      }
    }
    _pageController.dispose();
    super.dispose();
  }

  int _getPoolIndex(int globalIndex) {
    // Maps infinite scroll index to our 3 hardware textures (0, 1, 2)
    return globalIndex % 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. The Infinite Vertical Feed
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: 100, // Infinite scroll simulation
            onPageChanged: (index) {
              if (!mounted) return;

              setState(() {
                _currentIndex = index;
              });

              final poolIndex = _getPoolIndex(index);
              final currentTexture = _texturePool[poolIndex];
              final currentUrl = testUrls[index % testUrls.length];
              
              // ▶️ 1. Play or Resume the current video
              if (currentTexture != null && currentTexture >= 0) {
                if (_loadedUrls[currentTexture] != currentUrl) {
                  _loadedUrls[currentTexture] = currentUrl;
                  NativeVideoEngine.playVideo(currentTexture, currentUrl);
                } else {
                  // The video was already preloaded, just unpause it!
                  NativeVideoEngine.resumeVideo(currentTexture);
                }
              }
              
              // 🛑 2. Handle adjacent textures (Preload new ones, pause departing ones)
              for (int i = 0; i < 3; i++) {
                if (i != poolIndex) {
                  final t = _texturePool[i];
                  if (t != null && t >= 0) {
                    int targetIndex = -1;
                    if (i == _getPoolIndex(index + 1)) targetIndex = index + 1;
                    if (index - 1 >= 0 && i == _getPoolIndex(index - 1)) targetIndex = index - 1;

                    if (targetIndex != -1) {
                      final targetUrl = testUrls[targetIndex % testUrls.length];
                      if (_loadedUrls[t] != targetUrl) {
                        // This texture needs to preload a new video entering the adjacent slot
                        _loadedUrls[t] = targetUrl;
                        NativeVideoEngine.preloadVideo(t, targetUrl);
                      } else {
                        // This texture holds an existing video that just left the screen, freeze it!
                        NativeVideoEngine.pauseVideo(t);
                      }
                    } else {
                        // Failsafe pause
                        NativeVideoEngine.pauseVideo(t);
                    }
                  }
                }
              }
            },
            itemBuilder: (context, index) {
              final poolIndex = _getPoolIndex(index);
              final isPlaying = index == _currentIndex;

              return TikTokVideoCard(
                index: index,
                textureId: _texturePool[poolIndex],
                isPlaying: isPlaying,
              );
            },
          ),

          // 2. The Top Header Overlay (Explore | Pings | Friends)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNavText("Explore", false),
                        SizedBox(width: 4.w),
                        _buildNavText("Pings", true),
                        SizedBox(width: 4.w),
                        _buildNavText("Friends", false),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        LucideIcons.search,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavText(String text, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        if (isSelected) ...[
          SizedBox(height: 1.h),
          Container(width: 20.w, height: 2, color: Colors.white),
        ],
      ],
    );
  }
}
