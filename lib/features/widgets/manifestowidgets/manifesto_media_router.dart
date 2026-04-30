import 'package:flutter/material.dart';
import '../channelmemberdata/comment_card/media/comment_media_type.dart';
import 'manifesto_single_image.dart';
import 'manifesto_double_image.dart';
import 'manifesto_triple_image.dart';
import 'manifesto_quad_image.dart';
import 'manifesto_single_video.dart';
import 'manifesto_double_video.dart';
import 'manifesto_quad_video.dart';
import 'manifesto_music_audio.dart';
import 'manifesto_voice_audio.dart';

/// 🚦 MANIFESTO MEDIA ROUTER: Specialized logic switcher.
/// Automatically selects the best premium layout based on media count and type.
class ManifestoMediaRouter extends StatelessWidget {
  final CommentMediaType mediaType;
  final List<String> mediaUrls;     // Images (or legacy single-video fallback)
  final List<String> videoUrls;     // 👑 Multi-video streams
  final Color themeColor;
  final String? audioUrl;
  final String? username;
  final String? thumbnailUrl;
  final List<String?> thumbnailUrls;
  final void Function(int)? onTap;
  final VoidCallback? onOpenAudioPlayer;

  const ManifestoMediaRouter({
    super.key,
    required this.mediaType,
    required this.mediaUrls,
    this.videoUrls = const [],
    required this.themeColor,
    this.audioUrl,
    this.username,
    this.thumbnailUrl,
    this.thumbnailUrls = const [],
    this.onTap,
    this.onOpenAudioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final hasMedia = mediaUrls.isNotEmpty ||
        videoUrls.isNotEmpty ||
        audioUrl != null;
    if (!hasMedia && mediaType != CommentMediaType.audio) {
      return const SizedBox.shrink();
    }

    switch (mediaType) {
      // 🎤 Audio Handling (Music vs Voice)
      case CommentMediaType.audio:
        final actualAudioUrl = audioUrl ?? (mediaUrls.isNotEmpty ? mediaUrls.first : null);
        // Heuristic: If it has "music" in the name or we can detect a track pattern, use Music UI.
        // For now, let's look at the filename or just default to Voice for personal messages.
        final isMusic = actualAudioUrl?.contains('music') ?? false;

        if (isMusic) {
          return ManifestoMusicAudio(
            audioUrl: actualAudioUrl,
            themeColor: themeColor,
            trackName: "Featured Track",
            artistName: username ?? "Artist",
            onOpenPlayer: onOpenAudioPlayer,
          );
        } else {
          return ManifestoVoiceAudio(
            audioUrl: actualAudioUrl,
            themeColor: themeColor,
            senderName: username,
            onOpenPlayer: onOpenAudioPlayer,
          );
        }

      // 🎥 Video Handling (1, 2, 4 counts) — uses dedicated videoUrls field
      case CommentMediaType.video:
        final vids = videoUrls.isNotEmpty ? videoUrls : mediaUrls;
        if (vids.isEmpty) return const SizedBox.shrink();

        if (vids.length >= 4) {
          return ManifestoQuadVideo(
            videoUrls: vids.take(4).toList(),
            thumbnailUrls: thumbnailUrls,
            themeColor: themeColor,
            onTap: onTap,
          );
        } else if (vids.length >= 2) {
          return ManifestoDoubleVideo(
            videoUrls: vids.take(2).toList(),
            thumbnailUrls: thumbnailUrls,
            themeColor: themeColor,
            onTap: onTap,
          );
        } else {
          return ManifestoSingleVideo(
            videoUrl: vids.first,
            thumbnailUrl: thumbnailUrl,
            themeColor: themeColor,
            onTap: () => onTap?.call(0),
          );
        }

      // 🖼️ Image Handling (1, 2, 3, 4 counts)
      case CommentMediaType.image:
        if (mediaUrls.length >= 4) {
          return ManifestoQuadImage(
            imageUrls: mediaUrls.take(4).toList(),
            thumbnailUrls: thumbnailUrls.map((e) => e ?? '').toList(),
            onTap: onTap,
          );
        } else if (mediaUrls.length == 3) {
          return ManifestoTripleImage(
            imageUrls: mediaUrls,
            thumbnailUrls: thumbnailUrls.map((e) => e ?? '').toList(),
            onTap: onTap,
          );
        } else if (mediaUrls.length == 2) {
          return ManifestoDoubleImage(
            imageUrls: mediaUrls,
            thumbnailUrls: thumbnailUrls.map((e) => e ?? '').toList(),
            onTap: onTap,
          );
        } else {
          return ManifestoSingleImage(
            imageUrl: mediaUrls.first,
            thumbnailUrl: thumbnailUrl ?? (thumbnailUrls.isNotEmpty ? thumbnailUrls.first : null),
            onTap: () => onTap?.call(0),
          );
        }

      case CommentMediaType.text:
      case CommentMediaType.poll:
        return const SizedBox.shrink();
    }
  }
}
