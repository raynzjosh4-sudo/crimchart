import 'package:crimchart/core/native/chart_native_ffi.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// ─── Visibility Detection ──────────────────────────────────────────────────
// We use a lightweight NotificationListener + LayoutBuilder approach so we
// don't need an extra package. Each video registers itself and compares its
// rendered rect against the viewport to decide whether to play.

/// A scroll-aware video player that auto-plays when >= [visibilityThreshold]
/// of the widget is visible in the scroll viewport, and auto-pauses otherwise.
///
/// The user can also tap the video to manually toggle play/pause.
class VideoCardMedia extends StatefulWidget {
  final String url;
  final String? creatorAvatarUrl;
  final VoidCallback? onThumbnailTap;
  final Color themeColor;
  final String? username;
  final String? subtitle;
  final bool showThumbnail;

  /// 0.0–1.0 — fraction of widget that must be on-screen to auto-play.
  final double visibilityThreshold;

  const VideoCardMedia({
    super.key,
    required this.url,
    this.creatorAvatarUrl,
    this.onThumbnailTap,
    this.themeColor = Colors.pinkAccent,
    this.username,
    this.subtitle,
    this.showThumbnail = true,
    this.visibilityThreshold = 0.5,
  });

  @override
  State<VideoCardMedia> createState() => _VideoCardMediaState();
}

class _VideoCardMediaState extends State<VideoCardMedia> {
  late final player = Player();
  late final controller = VideoController(player);
  String? _posterPath;
  VideoInfo? _videoInfo;
  bool _initialized = false;

  /// Whether the user has manually paused the video.
  bool _userPaused = false;

  /// Key used to measure this widget's position in the scroll view.
  final GlobalKey _widgetKey = GlobalKey();

  String? _previewDir;
  final int _numPreviews = 12;
  double _dragValue = 0.0;
  bool _isDragging = false;

  // ── Scroll-visibility tracTop ────────────────────────────────────────────

  ScrollPosition? _scrollPosition;

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
    if (!_initialized || _userPaused) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final visible = _getVisibleFraction();
      if (visible >= widget.visibilityThreshold) {
        if (!player.state.playing) {
          player.play();
          WakelockPlus.enable(); // ✅ KEEP SCREEN ALIVE
        }
      } else {
        if (player.state.playing) {
          player.pause();
          WakelockPlus.disable(); // ✅ RELEASE SCREEN
        }
      }
    });
  }

  /// Returns what fraction (0.0–1.0) of this widget is currently visible
  /// inside the nearest ScrollView's viewport.
  double _getVisibleFraction() {
    final ro = _widgetKey.currentContext?.findRenderObject();
    if (ro == null || !ro.attached) return 0.0;

    final renderBox = ro as RenderBox;
    final size = renderBox.size;
    if (size.height == 0) return 0.0;

    // Get this widget's global rect
    final globalOffset = renderBox.localToGlobal(Offset.zero);
    final widgetTop = globalOffset.dy;
    final widgetBottom = widgetTop + size.height;

    // Get the viewport rect from the scroll position metadata
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return 0.0;

    final viewportRO = scrollable.context.findRenderObject();
    if (viewportRO == null) return 0.0;
    final viewportBox = viewportRO as RenderBox;
    final viewportOffset = viewportBox.localToGlobal(Offset.zero);
    final viewportTop = viewportOffset.dy;
    final viewportBottom = viewportTop + viewportBox.size.height;

    // Calculate intersection
    final visibleTop = widgetTop.clamp(viewportTop, viewportBottom);
    final visibleBottom = widgetBottom.clamp(viewportTop, viewportBottom);
    final visibleHeight = visibleBottom - visibleTop;

    return (visibleHeight / size.height).clamp(0.0, 1.0);
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initController();
    _loadMetadataAndPoster();
  }

  void _initController() {
    player.open(Media(widget.url), play: false);
    player.setVolume(100.0); // ✅ UNMUTED IN DETAIL VIEW
    player.setPlaylistMode(PlaylistMode.loop);
    
    player.stream.playing.listen((isPlaying) {
      if (mounted) setState(() {});
    });
    
    player.stream.position.listen((pos) {
      if (mounted && !_isDragging) {
        setState(() {});
      }
    });

    setState(() => _initialized = true);
    
    // Trigger a first check after the frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final visible = _getVisibleFraction();
      if (visible >= widget.visibilityThreshold && !_userPaused) {
        player.play();
      }
    });
  }

  Future<void> _loadMetadataAndPoster() async {
    if (!widget.url.startsWith('http') && File(widget.url).existsSync()) {
      final ffi = ChartNativeFFI();
      final info = await ffi.getVideoInfo(widget.url);

      final temp = await getTemporaryDirectory();
      final posterName = 'poster_${widget.url.hashCode}.jpg';
      final posterFile = File('${temp.path}/$posterName');

      if (!posterFile.existsSync()) {
        await ffi.extractThumbnail(
          inputPath: widget.url,
          outputPath: posterFile.path,
          timeSec: 0.1,
          thumbWidth: 640,
        );
      }

      final previewDirPath = '${temp.path}/previews_${widget.url.hashCode}';
      final previewDir = Directory(previewDirPath);
      if (!previewDir.existsSync()) {
        previewDir.createSync();
        await ffi.generatePreviewStrip(
          inputPath: widget.url,
          outputDir: previewDirPath,
          numFrames: _numPreviews,
          thumbWidth: 238,
        );
      }

      if (mounted) {
        setState(() {
          _videoInfo = info;
          _posterPath = posterFile.path;
          _previewDir = previewDirPath;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (player.state.playing) {
      player.pause();
      WakelockPlus.disable(); // ✅ RELEASE SCREEN
      setState(() => _userPaused = true);
    } else {
      player.play();
      WakelockPlus.enable(); // ✅ KEEP SCREEN ALIVE
      setState(() => _userPaused = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = _videoInfo != null
        ? (_videoInfo!.width / _videoInfo!.height)
        : (player.state.width != null && player.state.height != null
            ? player.state.width! / player.state.height!
            : 16 / 9);

    return GestureDetector(
      onTap: _initialized ? _togglePlayPause : null,
      child: ClipRRect(
        borderRadius: BorderRadius.zero, // ✅ CINEMATIC EDGE-TO-EDGE
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            key: _widgetKey,
            fit: StackFit.expand,
            children: [
              // 1. Poster while loading
              if (_posterPath != null && !_initialized)
                Image.file(File(_posterPath!), fit: BoxFit.cover),

              // 2. Actual video
              if (_initialized) Video(controller: controller, controls: NoVideoControls, fit: BoxFit.cover,),

              // 3. Loading spinner
              if (!_initialized && _posterPath == null)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white54),
                ),

              // 4. Play/Pause icon overlay (shows when paused)
              if (_initialized && !player.state.playing)
                Center(
                  child: AnimatedOpacity(
                    opacity: _userPaused ? 1.0 : 0.7,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),

              // 5. Scrub bar
              if (_initialized)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildScrubBar(),
                ),

              // 6. Floating preview during scrub
              if (_isDragging && _previewDir != null) _buildFloatingPreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrubBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          activeTrackColor: widget.themeColor,
          inactiveTrackColor: Colors.white30,
          thumbColor: widget.themeColor,
        ),
        child: Slider(
          value: _isDragging
              ? _dragValue
              : (player.state.position.inMilliseconds /
                    player.state.duration.inMilliseconds.clamp(
                      1,
                      100000000,
                    )),
          onChanged: (val) {
            setState(() {
              _isDragging = true;
              _dragValue = val;
            });
          },
          onChangeEnd: (val) {
            player.seek(
              Duration(
                milliseconds: (val * player.state.duration.inMilliseconds)
                    .toInt(),
              ),
            );
            setState(() => _isDragging = false);
          },
        ),
      ),
    );
  }

  Widget _buildFloatingPreview() {
    final int index = (_dragValue * (_numPreviews - 1)).round();
    final String framePath =
        '$_previewDir/${index.toString().padLeft(3, '0')}.jpg';

    return Positioned(
      bottom: 60,
      left: (_dragValue * (MediaQuery.of(context).size.width - 150))
          .clamp(20, MediaQuery.of(context).size.width - 170)
          .toDouble(),
      child: Container(
        width: 130,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
          image: DecorationImage(
            image: FileImage(File(framePath)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}











