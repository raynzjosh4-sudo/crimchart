import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../models/media_model.dart';

class MediaGalleryBottomSheet extends StatefulWidget {
  final List<MessageMediaItem> items;
  final int initialIndex;

  const MediaGalleryBottomSheet({
    super.key,
    required this.items,
    this.initialIndex = 0,
  });

  static void show(
    BuildContext context,
    List<MessageMediaItem> items, {
    int initialIndex = 0,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      useSafeArea: true,
      builder: (context) =>
          MediaGalleryBottomSheet(items: items, initialIndex: initialIndex),
    );
  }

  @override
  State<MediaGalleryBottomSheet> createState() =>
      _MediaGalleryBottomSheetState();
}

class _MediaGalleryBottomSheetState extends State<MediaGalleryBottomSheet> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Page View for Media
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              if (item.type == MessageMediaType.video) {
                return _VideoGalleryItem(url: item.url);
              } else {
                return _ImageGalleryItem(url: item.url);
              }
            },
          ),

          // Top Bar
          Positioned(
            top: 10.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '${_currentIndex + 1} / ${widget.items.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                    onPressed: () {
                      // Handle download
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageGalleryItem extends StatelessWidget {
  final String url;

  const _ImageGalleryItem({required this.url});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.contain,
          width: double.infinity,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _VideoGalleryItem extends StatefulWidget {
  final String url;

  const _VideoGalleryItem({required this.url});

  @override
  State<_VideoGalleryItem> createState() => _VideoGalleryItemState();
}

class _VideoGalleryItemState extends State<_VideoGalleryItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller),
            VideoProgressIndicator(_controller, allowScrubbing: true),
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 80.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
