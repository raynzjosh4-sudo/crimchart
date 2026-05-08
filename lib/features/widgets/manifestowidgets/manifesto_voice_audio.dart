import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../channelmemberdata/comment_card/media/audio_media.dart';

/// 🎙️ Specialized widget for a Voice Message manifesto.
class ManifestoVoiceAudio extends StatelessWidget {
  final String? audioUrl;
  final Color themeColor;
  final String? senderName;
  final VoidCallback? onOpenPlayer;

  const ManifestoVoiceAudio({
    super.key,
    this.audioUrl,
    required this.themeColor,
    this.senderName,
    this.onOpenPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎙️ Voice Header
            Row(
              children: [
                Icon(LucideIcons.mic, color: themeColor, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  "Voice Message from ${senderName ?? 'Author'}",
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  "Voice Memo",
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // 🔊 The Player
            AudioMedia(
              themeColor: themeColor,
              audioUrl: audioUrl,
              onOpenPlayer: onOpenPlayer,
            ),
          ],
        ),
      ),
    );
  }
}
