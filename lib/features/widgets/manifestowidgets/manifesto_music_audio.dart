import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../channelmemberdata/comment_card/media/audio_media.dart';

/// 🎵 Specialized widget for a featured Music Track manifesto.
class ManifestoMusicAudio extends StatelessWidget {
  final String? audioUrl;
  final Color themeColor;
  final String? trackName;
  final String? artistName;
  final String? coverUrl;
  final VoidCallback? onOpenPlayer;

  const ManifestoMusicAudio({
    super.key,
    this.audioUrl,
    required this.themeColor,
    this.trackName,
    this.artistName,
    this.coverUrl,
    this.onOpenPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: themeColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // 💿 Music Header with Cover Art
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    color: themeColor.withValues(alpha: 0.2),
                    child: coverUrl != null
                        ? ChartImage(url: coverUrl!, fit: BoxFit.cover)
                        : Icon(LucideIcons.music, color: themeColor),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trackName ?? "Featured Track",
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        artistName ?? "Unknown Artist",
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.externalLink, color: themeColor, size: 20.sp),
                  onPressed: onOpenPlayer,
                ),
              ],
            ),
          ),
          // 🔊 The Player
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
            child: AudioMedia(
              themeColor: themeColor,
              audioUrl: audioUrl,
              onOpenPlayer: onOpenPlayer,
            ),
          ),
        ],
      ),
    );
  }
}
