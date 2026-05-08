import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math' as math;
import 'dart:ui';

class VoiceMessagePlayer extends StatefulWidget {
  final String url;
  final Duration? duration;
  final bool isMe;

  const VoiceMessagePlayer({
    super.key,
    required this.url,
    this.duration,
    required this.isMe,
  });

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;
  late final List<double> _waveformHeights;

  @override
  void initState() {
    super.initState();
    _waveformHeights = _generateHeights(widget.url);
    _initPlayer();
  }

  List<double> _generateHeights(String url) {
    final seed = url.hashCode;
    final random = math.Random(seed);
    return List.generate(40, (index) {
      // Create a visually pleasing waveform that tends to taper at edges
      double height = 0.2 + random.nextDouble() * 0.8;
      if (index < 3) height *= (index + 1) / 4; // taper start
      if (index > 36) height *= (40 - index) / 4; // taper end
      return height.clamp(0.1, 1.0);
    });
  }

  Future<void> _initPlayer() async {
    try {
      final duration = await _player.setUrl(widget.url);
      setState(() {
        _totalDuration = duration ?? widget.duration ?? Duration.zero;
      });

      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
          });
          if (state.processingState == ProcessingState.completed) {
            _player.seek(Duration.zero);
            _player.pause();
          }
        }
      });

      _player.positionStream.listen((pos) {
        if (mounted) {
          setState(() {
            _position = pos;
          });
        }
      });
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _seekToRelativePosition(Offset localPosition, Size size) {
    if (_totalDuration.inMilliseconds == 0) return;
    
    final percent = (localPosition.dx / size.width).clamp(0.0, 1.0);
    final seekMs = (_totalDuration.inMilliseconds * percent).toInt();
    _player.seek(Duration(milliseconds: seekMs));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final Color activeColor = widget.isMe ? theme.primaryColor : theme.colorScheme.onSurface;
    final Color inactiveColor = activeColor.withValues(alpha: 0.3);
    final Color textColor = theme.colorScheme.onSurface;

    final Color playBtnBg = widget.isMe ? theme.primaryColor.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest;
    final Color playBtnIconColor = widget.isMe ? theme.primaryColor : theme.colorScheme.onSurface;

    final double progress = _totalDuration.inMilliseconds > 0
        ? (_position.inMilliseconds / _totalDuration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 260.w),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: playBtnBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                color: playBtnIconColor,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  _seekToRelativePosition(details.localPosition, renderBox.size);
                }
              },
              onHorizontalDragUpdate: (details) {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  _seekToRelativePosition(details.localPosition, renderBox.size);
                }
              },
              child: Container(
                height: 28.h, // Height for the waveform
                color: Colors.transparent, // Required for gesture detector to catch hits everywhere
                child: CustomPaint(
                  painter: _WaveformPainter(
                    heights: _waveformHeights,
                    progress: progress,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Text(
            _isPlaying || _position.inMilliseconds > 0 
                ? _formatDuration(_position) 
                : _formatDuration(_totalDuration),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: textColor.withValues(alpha: 0.8),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(width: 4.w),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> heights;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _WaveformPainter({
    required this.heights,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5; // Slightly thicker bars for better visibility

    final spacing = 2.5; 
    final totalWidth = size.width;
    
    final barTotalWidth = paint.strokeWidth + spacing;
    final int barCount = (totalWidth / barTotalWidth).floor();

    for (int i = 0; i < barCount; i++) {
      final normalizedHeight = heights[i % heights.length];
      
      final x = i * barTotalWidth;
      final isPlayed = (x / totalWidth) <= progress;

      paint.color = isPlayed ? activeColor : inactiveColor;
      
      final barHeight = normalizedHeight * size.height;
      final yOffset = (size.height - barHeight) / 2;

      canvas.drawLine(
        Offset(x, yOffset),
        Offset(x, size.height - yOffset),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
