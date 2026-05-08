import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AudioPlayerPage extends StatefulWidget {
  final String audioUrl;
  final int likes;
  final String title;
  final String artist;
  final String? coverUrl;
  final String? userImageUrl;

  const AudioPlayerPage({
    super.key,
    required this.audioUrl,
    this.likes = 0,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.userImageUrl,
  });

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = context.read<ThemeProvider>().currentColor;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16.h),
              
              // ── TOP BAR ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   _buildTopIcon(LucideIcons.chevronLeft, () => Navigator.pop(context), colorScheme),
                   Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Text(
                         context.tr("now_playing"),
                         style: TextStyle(
                           color: colorScheme.onSurface,
                           fontSize: 15.sp,
                           fontWeight: FontWeight.w900,
                           letterSpacing: 0.5,
                         ),
                       ),
                       SizedBox(height: 4.h),
                       Container(
                         height: 2.h,
                         width: 40.w,
                         decoration: BoxDecoration(
                           color: activeColor.withValues(alpha: 0.5),
                           borderRadius: BorderRadius.circular(1.r),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(width: 44.w), // maintains explicit centering for Now Playing
                ],
              ),
              
              SizedBox(height: 40.h),
              
              // ── ARTWORK CENTER ──
              // Cover Image
              Container(
                width: 270.w,
                height: 270.w,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24.r),
                  image: widget.coverUrl != null 
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(widget.coverUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: widget.coverUrl == null ? Icon(LucideIcons.music, size: 80.sp, color: colorScheme.onSurface.withValues(alpha: 0.5)) : null,
              ),
              
              SizedBox(height: 40.h),
              
              // ── TITLE & ARTIST ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, right: 8.w),
                    child: Icon(LucideIcons.sparkles, color: activeColor, size: 16.sp),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.title.isNotEmpty ? widget.title : context.tr("unknown_track"),
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.userImageUrl != null && widget.userImageUrl!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: CircleAvatar(
                                  radius: 10.r,
                                  backgroundImage: CachedNetworkImageProvider(widget.userImageUrl!),
                                ),
                              ),
                            Text(
                              widget.artist,
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // balancing invisible space for centering
                  SizedBox(width: 24.w), 
                ],
              ),
              
              SizedBox(height: 30.h),
              
              // ── WAVEFORM ──
              SizedBox(
                height: 50.h,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(28, (index) {
                        final pattern = [0.2, 0.4, 0.7, 1.0, 0.8, 0.5, 0.3, 0.6, 0.9, 0.7, 0.4, 0.8, 1.0, 0.6];
                        final baseHeight = pattern[index % pattern.length];
                        
                        final animationPhase = _animationController.value * 2 * math.pi;
                        final modulation = (math.sin(animationPhase + index) + 1) / 2; // oscillates 0 to 1 fluidly
                        final dynamicHeight = _isPlaying ? ((baseHeight * 0.5) + (baseHeight * 0.5 * modulation)) : baseHeight;
                        
                        final isPlayed = index < 12; 
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          width: 4.w,
                          height: 50.h * dynamicHeight,
                          decoration: BoxDecoration(
                            color: isPlayed ? activeColor : colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        );
                      }),
                    );
                  }
                ),
              ),
              
              SizedBox(height: 40.h),
              
              // ── PLAYBACK CONTROLS ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.skipBack, color: colorScheme.onSurface, size: 28.sp),
                  SizedBox(width: 24.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                        if (_isPlaying) {
                           _animationController.repeat();
                        } else {
                           _animationController.stop();
                        }
                      });
                    },
                    child: Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: colorScheme.onSurface, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _isPlaying ? LucideIcons.pause : LucideIcons.play,
                          color: colorScheme.onSurface,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Icon(LucideIcons.skipForward, color: colorScheme.onSurface, size: 28.sp),
                  SizedBox(width: 24.w),
                  Icon(Icons.more_horiz, color: colorScheme.onSurface.withValues(alpha: 0.5), size: 28.sp),
                ],
              ),
              
              const Spacer(),
              SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, VoidCallback onTap, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colorScheme.onSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: colorScheme.surface, size: 20.sp),
      ),
    );
  }
}
