import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'comment_media_type.dart';
import '../../../imageveiwerwidget/image_grid.dart';
import 'video_media.dart';
import 'audio_media.dart';

class CommentMedia extends StatelessWidget {
  final CommentMediaType mediaType;
  final List<String> mediaUrls;
  final Color themeColor;
  final String? avatarUrl;
  final String? username;
  final String? referenceId;
  final void Function(int)? onTap;
  final VoidCallback? onTapThumbnail;
  final String? thumbnailUrl;
  final VoidCallback? onOpenAudioPlayer; // 👑 New: Arrow Handler
  final String? audioUrl; // 👑 NEW: Player Source

  const CommentMedia({
    super.key,
    required this.mediaType,
    required this.mediaUrls,
    required this.themeColor,
    this.avatarUrl,
    this.username,
    this.referenceId,
    this.onTap,
    this.onTapThumbnail,
    this.thumbnailUrl,
    this.onOpenAudioPlayer,
    this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaUrls.isEmpty && mediaType != CommentMediaType.audio) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: _buildMedia(context),
    );
  }

  Widget _buildMedia(BuildContext context) {
    switch (mediaType) {
      case CommentMediaType.audio:
        return AudioMedia(
          themeColor: themeColor,
          audioUrl: audioUrl ?? (mediaUrls.isNotEmpty ? mediaUrls.first : null),
          onTap: () => onTap?.call(0),
          onOpenPlayer: onOpenAudioPlayer, // 👑 Passed to refined UI
        );

      case CommentMediaType.video:
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.w), // ✅ SMOOTH ROUNDED CORNERS
          child: AspectRatio(
            aspectRatio: 1.0, 
            child: VideoMedia(
              videoUrl: mediaUrls.first,
              thumbnailUrl: thumbnailUrl, // ✅ NO MORE BLACK SCREEN
              themeColor: themeColor,
              onTap: () => onTap?.call(0),
            ),
          ),
        );

      case CommentMediaType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(14.w),
          child: ImageGrid(imageUrls: mediaUrls, onTap: onTap),
        );
      case CommentMediaType.text:
      case CommentMediaType.poll:
        return const SizedBox.shrink();
    }
  }
}











