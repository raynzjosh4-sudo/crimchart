import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioMedia extends StatefulWidget {
  final Color themeColor;
  final String? audioUrl;
  final VoidCallback? onTap;
  final VoidCallback? onOpenPlayer; // 👑 New: Quick-Open Handler

  const AudioMedia({
    super.key,
    required this.themeColor,
    this.audioUrl,
    this.onTap,
    this.onOpenPlayer,
  });

  @override
  State<AudioMedia> createState() => _AudioMediaState();
}

class _AudioMediaState extends State<AudioMedia> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    if (widget.audioUrl == null) return;
    try {
      setState(() => _isLoading = true);
      final url = widget.audioUrl!;
      if (url.startsWith('http')) {
        await _player.setUrl(url);
      } else {
        final cleanPath = url.startsWith('file://') 
            ? Uri.parse(url).toFilePath() 
            : url;
        await _player.setFilePath(cleanPath);
      }
      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
          });
        }
      });
    } catch (e) {
      debugPrint('Error loading audio: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
        color: widget.themeColor.withAlpha(38),
        borderRadius: BorderRadius.circular(24.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // 👑 Interactive Play Button
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: widget.themeColor,
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    )
                  : Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.surface,
                      size: 20.sp,
                    ),
            ),
          ),
          SizedBox(width: 12.w),

          // Waveform (Static representation for now)
          Expanded(child: _buildDummyWaveform(context)),

          SizedBox(width: 12.w),

          // 👑 Quick-Open Arrow (Navigates to full player)
          GestureDetector(
            onTap: widget.onOpenPlayer,
            child: Icon(
              Icons.chevron_right,
              color: widget.themeColor,
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDummyWaveform(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(24, (index) {
        double height = 10.0 + ((index * 13) % 40);
        if (!_isPlaying && index > 12) height = 10;
        
        return Container(
          width: 3.w,
          height: height.h,
          decoration: BoxDecoration(
            color: (_isPlaying || index < 12) 
                ? widget.themeColor 
                : onSurface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4.w),
          ),
        );
      }),
    );
  }
}











