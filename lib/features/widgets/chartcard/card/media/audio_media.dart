import 'dart:math' as math;
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../../../core/application/audio_controller.dart';

class AudioCardMedia extends ConsumerStatefulWidget {
  final String id; // Added id for tracTop
  final String url;
  final String? thumbnailUrl;
  final String? backgroundImageUrl;
  final String? creatorAvatarUrl;
  final VoidCallback? onThumbnailTap;
  final Color themeColor;

  final String? username;
  final String? subtitle;
  final bool showThumbnail;

  const AudioCardMedia({
    super.key,
    required this.id,
    required this.url,
    this.thumbnailUrl,
    this.backgroundImageUrl,
    this.creatorAvatarUrl,
    this.onThumbnailTap,
    this.themeColor = Colors.pinkAccent,
    this.username,
    this.subtitle,
    this.showThumbnail = true,
  });

  @override
  ConsumerState<AudioCardMedia> createState() => _AudioCardMediaState();
}

class _AudioCardMediaState extends ConsumerState<AudioCardMedia>
    with SingleTickerProviderStateMixin {
  late AnimationController _wave;
  final GlobalKey _widgetKey = GlobalKey();
  ScrollPosition? _scrollPosition;
  bool _userPaused = false;

  @override
  void initState() {
    super.initState();
    _wave = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    // 🛡️ INITIAL AUTO-PLAY CHECK
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkVisibility();
    });
  }

  void _attachToScroll(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;
    final pos = scrollable.position;
    if (_scrollPosition == pos) return;
    _scrollPosition?.removeListener(_checkVisibility);
    _scrollPosition = pos;
    _scrollPosition!.addListener(_checkVisibility);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachToScroll(context);
  }

  void _checkVisibility() {
    if (_userPaused || !mounted) return;
    final double visible = _getVisibleFraction();
    final audioNotifier = ref.read(audioControllerProvider.notifier);
    final audioState = ref.read(audioControllerProvider);
    final isCurrent = audioState.currentTrackId == widget.id;

    if (visible >= 0.5) { // ✅ 50% THRESHOLD
      if (!audioState.isPlaying || !isCurrent) {
         audioNotifier.play(widget.url, widget.id);
         WakelockPlus.enable(); // ✅ KEEP SCREEN ALIVE
      }
    } else {
      if (audioState.isPlaying && isCurrent) {
         audioNotifier.pause();
         WakelockPlus.disable(); // ✅ RELEASE SCREEN
      }
    }
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
    _scrollPosition?.removeListener(_checkVisibility);
    _wave.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    final audioNotifier = ref.read(audioControllerProvider.notifier);
    final audioState = ref.read(audioControllerProvider);
    final isPlaying = audioState.isPlaying && audioState.currentTrackId == widget.id;
    
    if (isPlaying) {
      audioNotifier.pause();
      WakelockPlus.disable(); // ✅ RELEASE SCREEN
      setState(() => _userPaused = true);
    } else {
      audioNotifier.play(widget.url, widget.id);
      WakelockPlus.enable(); // ✅ KEEP SCREEN ALIVE
      setState(() => _userPaused = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioControllerProvider);
    final isPlaying =
        audioState.isPlaying && audioState.currentTrackId == widget.id;

    if (isPlaying && !_wave.isAnimating) {
      _wave.repeat(reverse: true);
    } else if (!isPlaying && _wave.isAnimating) {
      _wave.stop();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Playback Tap Area
        Positioned.fill(
          child: GestureDetector(
            onTap: _togglePlayback,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        // Waveform (Cinematic Expanded)
        AnimatedBuilder(
          animation: _wave,
          builder: (_, __) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(12, (i) {
              // ✅ MORE BARS
              final double h =
                  20.h +
                  (math.sin((_wave.value + i * 0.4) * math.pi) * 60.h)
                      .abs(); // ✅ GREATER HEIGHT
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 8.w,
                height: h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(isPlaying ? 1.0 : 0.4),
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: isPlaying
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        ),
        // Play icon (Premium Round)
        Positioned(
          bottom: 32.h,
          right: 32.w,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.54),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
      ],
    );
  }
}
