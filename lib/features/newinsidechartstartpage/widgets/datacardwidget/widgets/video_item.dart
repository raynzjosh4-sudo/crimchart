import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final String contentUrl;

  const VideoItem({super.key, required this.contentUrl});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController? _controller;
  bool _isInitFailed = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final isNetwork = widget.contentUrl.startsWith('http');
    
    if (isNetwork) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.contentUrl));
    } else if (File(widget.contentUrl).existsSync()) {
      _controller = VideoPlayerController.file(File(widget.contentUrl));
    } else {
      setState(() => _isInitFailed = true);
      return;
    }

    try {
      await _controller!.initialize();
      if (!mounted) return;
      
      setState(() {
        _controller!.setLooping(true);
        _controller!.setVolume(0);
        _controller!.play();
      });
    } catch (e) {
      debugPrint("Video init failed for ${widget.contentUrl}: $e");
      if (mounted) setState(() => _isInitFailed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitFailed) {
      return Center(
        child: Icon(
          Icons.videocam_off_outlined,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          size: 32,
        ),
      );
    }

    return SizedBox.expand(
      child: _controller != null && _controller!.value.isInitialized
          ? VideoPlayer(_controller!)
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}





























