import 'dart:math' as math;
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';

class AudioCardMedia extends StatefulWidget {
  final String url;
  final String? thumbnailUrl;
  final String? backgroundImageUrl;
  final bool isVideo;
  final bool isAudio;

  const AudioCardMedia({
    super.key,
    required this.url,
    this.thumbnailUrl,
    this.backgroundImageUrl,
    this.isVideo = false,
    this.isAudio = false,
  });

  @override
  State<AudioCardMedia> createState() => _AudioCardMediaState();
}

class _AudioCardMediaState extends State<AudioCardMedia>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (_isPlaying) {
      _animController.repeat(reverse: true);
    }
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animController.repeat(reverse: true);
      } else {
        _animController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? bgUrl = widget.backgroundImageUrl ?? widget.thumbnailUrl;
    final bool hasBg = bgUrl != null;
    final bool isNetworkBg = hasBg && bgUrl.startsWith('http');

    return GestureDetector(
      onTap: _togglePlayback,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Positioned(
            child: Column(
              children: [
                MemberImage(size: 30, imageUrl: widget.backgroundImageUrl),
                Text('Channel Name'),
                Text('1000 members'),
                Column(
                  children: [
                    Row(
                      children: [Icon(Icons.play_arrow_rounded), Text('1000')],
                    ),
                    Row(children: [Icon(Icons.comment_rounded), Text('1000')]),
                    Row(children: [Icon(Icons.share_rounded), Text('1000')]),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          // Background Image
          if (hasBg)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: isNetworkBg
                      ? NetworkImage(bgUrl) as ImageProvider
                      : AssetImage(bgUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
              ),
            )
          else
            Container(color: const Color(0xFF1A1A1A)),

          // Audio Visualizer lines in the center
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    double value = _animController.value;
                    double height =
                        15 +
                        (math.sin((value + index * 0.5) * math.pi) * 20).abs();

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 6,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(_isPlaying ? 1.0 : 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          // Play/Pause Overlay Icon
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}











