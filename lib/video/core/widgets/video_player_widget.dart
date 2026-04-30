import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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
      
      if (!widget.videoUrl.startsWith('http') && mounted) {
        final temp = await getTemporaryDirectory();
        final pPath = '${temp.path}/vposter_${widget.videoUrl.hashCode}.jpg';
        if (!File(pPath).existsSync()) {
          await ffi.extractThumbnail(inputPath: widget.videoUrl, outputPath: pPath, thumbWidth: 480);
        }
        setState(() {
          _posterPath = pPath;
        });
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
    final uri = Uri.parse(widget.videoUrl);
    _controller = widget.videoUrl.startsWith('http') 
        ? VideoPlayerController.networkUrl(uri)
        : VideoPlayerController.file(File(widget.videoUrl));
    
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      if (widget.autoPlay) {
        await _controller.play();
      }
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
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

    return Stack(
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
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                    child: VideoPlayer(_controller),
                  ),
                
                // Native Poster / Loading State
                if (!_isInitialized)
                  _posterPath != null 
                    ? Image.file(File(_posterPath!), fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                    : const Center(child: CircularProgressIndicator(color: Colors.white)),

                // Buffering state
                if (_isInitialized)
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, VideoPlayerValue value, child) {
                      if (value.isBuffering) {
                        return const CircularProgressIndicator(color: Colors.white);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
              ],
            ),
          ),
        ),

        // Speed Toggle Button
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: _toggleSpeed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                '${_playbackSpeed}x',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        if (_isInitialized && !_controller.value.isPlaying)
          const IgnorePointer(
            child: Icon(Icons.play_arrow, size: 80, color: Colors.white54),
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
    );
  }
}





























