import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final double visibilityThreshold;

  const VideoThumbnail({super.key, required this.videoUrl, this.visibilityThreshold = 0.5});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;
  final GlobalKey _widgetKey = GlobalKey();
  ScrollPosition? _scrollPosition;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
        _controller.setVolume(0); 
        _controller.setLooping(true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (_getVisibleFraction() >= widget.visibilityThreshold) {
            _controller.play();
          }
        });
      });
  }

  void _attachToScroll(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;
    final pos = scrollable.position;
    if (_scrollPosition == pos) return;
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = pos;
    _scrollPosition!.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachToScroll(context);
  }

  void _onScroll() {
    if (!_initialized) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_getVisibleFraction() >= widget.visibilityThreshold) {
        if (!_controller.value.isPlaying) _controller.play();
      } else {
        if (_controller.value.isPlaying) _controller.pause();
      }
    });
  }

  double _getVisibleFraction() {
    final ro = _widgetKey.currentContext?.findRenderObject();
    if (ro == null || !ro.attached) return 0.0;
    final renderBox = ro as RenderBox;
    final size = renderBox.size;
    if (size.height == 0) return 0.0;
    final globalOffset = renderBox.localToGlobal(Offset.zero);
    final widgetTop = globalOffset.dy;
    final widgetBottom = widgetTop + size.height;
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return 0.0;
    final viewportRO = scrollable.context.findRenderObject();
    if (viewportRO == null) return 0.0;
    final viewportBox = viewportRO as RenderBox;
    final viewportTop = viewportBox.localToGlobal(Offset.zero).dy;
    final viewportBottom = viewportTop + viewportBox.size.height;
    final visibleTop = widgetTop.clamp(viewportTop, viewportBottom);
    final visibleBottom = widgetBottom.clamp(viewportTop, viewportBottom);
    return ((visibleBottom - visibleTop) / size.height).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return SizedBox.expand(
        key: _widgetKey,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    } else {
      return Container(
        key: _widgetKey,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
          ),
        ),
      );
    }
  }
}





























