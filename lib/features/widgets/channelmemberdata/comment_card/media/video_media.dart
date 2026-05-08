import 'dart:io';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VideoMedia extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final VoidCallback? onTap;
  final Color? themeColor;
  final double visibilityThreshold;

  const VideoMedia({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.onTap,
    this.themeColor,
    this.visibilityThreshold = 0.5,
  });

  @override
  State<VideoMedia> createState() => _VideoMediaState();
}

class _VideoMediaState extends State<VideoMedia> {
  // 👑 GLOBAL VOLUMNE SYNC: Unmuting one unmutes all
  static final ValueNotifier<bool> globalMuted = ValueNotifier<bool>(true);

  late final player = Player();
  late final controller = VideoController(player);
  final GlobalKey _widgetKey = GlobalKey();
  bool _initialized = false;
  bool _userPaused = false;
  bool _isHovered = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    final String url = widget.videoUrl;
    final media = url.startsWith('http')
        ? Media(url)
        : (url.startsWith('file://')
            ? Media(url)
            : Media(File(Uri.decodeComponent(url)).uri.toString()));

    // 👑 Always start at global volume state
    _updateVolume();
    globalMuted.addListener(_updateVolume);

    player.open(media, play: false);
    player.setPlaylistMode(PlaylistMode.loop);
    setState(() => _initialized = true);

    // 🎥 TRAILER LOGIC: Loop back after 6 seconds
    player.stream.position.listen((pos) {
      if (pos >= const Duration(seconds: 6)) {
        player.seek(Duration.zero);
      }
    });

    // 👑 Rebuild when playback state changes (shows/hides thumbnail)
    player.stream.playing.listen((isPlaying) {
      if (mounted) setState(() {});
    });
  }

  void _updateVolume() {
    if (!mounted) return;
    player.setVolume(globalMuted.value ? 0.0 : 100.0);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // 👑 HOVER HANDLERS (Desktop / Web)
  void _onHoverEnter(PointerEvent event) {
    if (!_initialized) return;
    setState(() => _isHovered = true);
    if (!player.state.playing) {
      player.play();
    }
  }

  void _onHoverExit(PointerEvent event) {
    setState(() => _isHovered = false);
    // Only auto-pause on desktop when the user leaves hover
    // On mobile this does nothing (scroll handles it)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) return;
    if (player.state.playing && !_userPaused) {
      player.pause();
      player.seek(Duration.zero); // Reset preview to start
    }
  }



  @override
  void dispose() {
    globalMuted.removeListener(_updateVolume);
    player.pause();
    player.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) widget.onTap!();
    if (!player.state.playing) {
      player.play();
      setState(() => _userPaused = false);
    } else {
      player.pause();
      setState(() => _userPaused = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_${widget.videoUrl}_${_widgetKey.hashCode}'),
      onVisibilityChanged: (info) {
        if (!mounted || _userPaused) return;

        final isV = info.visibleFraction > 0.6;
        if (isV != _isVisible) {
          setState(() => _isVisible = isV);
          if (_isVisible) {
            player.play();
          } else {
            player.pause();
          }
        }
      },
      child: MouseRegion(
        onEnter: _onHoverEnter,
        onExit: _onHoverExit,
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          key: _widgetKey,
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          // height: 400.h, // 👑 Removed fixed height to allow parent/aspect-ratio to decide
          decoration: BoxDecoration(
            color: (widget.themeColor ?? Theme.of(context).primaryColor).withAlpha(38),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: (widget.themeColor ?? Theme.of(context).primaryColor)
                          .withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _initialized
                ? GestureDetector(
                    onTap: () {
                      _handleTap();
                      // Manual tap unmutes global if it was muted
                      if (globalMuted.value) {
                        globalMuted.value = false;
                      }
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 1. THE TRAILER PLAYER
                        Video(
                          controller: controller,
                          controls: NoVideoControls,
                          fit: BoxFit.cover,
                        ),

                        // 2. 👑 SMART THUMBNAIL
                        if (!player.state.playing)
                          widget.thumbnailUrl != null
                              ? ChartImage(url: widget.thumbnailUrl!, fit: BoxFit.cover)
                              : Container(
                                  color: (widget.themeColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
                                  child: Center(
                                    child: Icon(
                                      Icons.videocam_outlined,
                                      size: 48.sp,
                                      color: (widget.themeColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),

                        // 3. 👑 VOLUME TOGGLE (Bottom Right)
                        Positioned(
                          bottom: 12.h,
                          right: 12.w,
                          child: GestureDetector(
                            onTap: () {
                              globalMuted.value = !globalMuted.value;
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                globalMuted.value ? LucideIcons.volumeX : LucideIcons.volume2,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ),

                        // 4. 👑 HOVER PLAY ICON
                        if (!player.state.playing && _isHovered)
                          AnimatedOpacity(
                            opacity: _isHovered ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 150),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.3),
                              child: Center(
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 32,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: widget.themeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
