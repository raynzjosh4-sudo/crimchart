import 'dart:io';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/native/chart_native_ffi.dart';
import 'progress_bar/video_progress_bar.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  VideoInfo? _videoInfo;
  String? _posterPath;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadNativeMetadata();
    _initializeController();
  }

  Future<void> _loadNativeMetadata() async {
    try {
      final ffi = ChartNativeFFI();
      final info = await ffi.getVideoInfo(widget.videoUrl);

      if (widget.videoUrl.isNotEmpty &&
          !widget.videoUrl.startsWith('http') &&
          mounted) {
        final temp = await getTemporaryDirectory();
        final pPath = '${temp.path}/vposter_${widget.videoUrl.hashCode}.jpg';
        if (!File(pPath).existsSync()) {
          final success = await ffi.extractThumbnail(
            inputPath: widget.videoUrl,
            outputPath: pPath,
            thumbWidth: 480,
          );
          if (success && mounted && File(pPath).existsSync()) {
            setState(() {
              _posterPath = pPath;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _posterPath = pPath;
            });
          }
        }
      }

      if (mounted) {
        setState(() {
          _videoInfo = info;
        });
      }
    } catch (e) {
      debugPrint('Native metadata load failed: $e');
    }
  }

  Future<void> _initializeController() async {
    if (widget.videoUrl.isEmpty) return;
    final uri = Uri.parse(widget.videoUrl);
    _controller = widget.videoUrl.startsWith('http')
        ? VideoPlayerController.networkUrl(uri)
        : VideoPlayerController.file(File(widget.videoUrl));

    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.setVolume(0.0); // 👑 Default to muted for feed autoplay
      if (widget.autoPlay) {
        await _controller.play();
      }
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _toggleSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.dispose();
      _isInitialized = false;
      _initializeController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = _videoInfo != null
        ? (_videoInfo!.width / _videoInfo!.height)
        : (_isInitialized ? _controller.value.aspectRatio : 9 / 16);

    return VisibilityDetector(
      key: ValueKey('video_${widget.videoUrl}_${hashCode}'),
      onVisibilityChanged: (info) {
        if (!mounted || !_isInitialized || _hasError) return;

        // 👑 AUTO-PLAY LOGIC: Play if > 50% visible, pause otherwise
        if (info.visibleFraction > 0.5) {
          if (!_controller.value.isPlaying) {
            _controller.play();
            if (mounted) setState(() {});
          }
        } else {
          if (_controller.value.isPlaying) {
            _controller.pause();
            if (mounted) setState(() {});
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isInitialized)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_controller),
                          if (!_controller.value.isPlaying)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                        ],
                      ),
                    ),

                  // Native Poster / Loading State
                  if (!_isInitialized)
                    _posterPath != null
                        ? Image.file(
                            File(_posterPath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Container(color: Colors.black12),

                  // Error state
                  if (!_isInitialized && _hasError)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            color: Colors.white.withValues(alpha: 0.2),
                            size: 28.sp,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Preview Unavailable',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.2),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Controls Row (Bottom-Right)
          Positioned(
            bottom: 20,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Play/Pause Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                // Mute/Unmute Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_controller.value.volume > 0) {
                        _controller.setVolume(0);
                      } else {
                        _controller.setVolume(1.0);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Icon(
                      _controller.value.volume > 0
                          ? Icons.volume_up
                          : Icons.volume_off,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Progress Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 1,
            child: SizedBox(
              height: 4,
              child: VideoProgressBar(controller: _controller),
            ),
          ),
        ],
      ),
    );
  }
}
