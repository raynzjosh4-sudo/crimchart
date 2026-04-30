import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressBar extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoProgressBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return VideoProgressIndicator(
      controller,
      allowScrubbing: true,
      colors: VideoProgressColors(
        playedColor: Colors.white,
        bufferedColor: Colors.white.withValues(alpha: 0.3),
        backgroundColor: Colors.white.withValues(alpha: 0.15),
      ),
      padding: EdgeInsets.zero,
    );
  }
}





























