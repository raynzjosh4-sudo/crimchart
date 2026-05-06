enum MediaType { video, image, audio }

class MediaData {
  final MediaType type;
  final String contentUrl; // URL for video, audio, or image
  final String? thumbnailUrl; // Background for audio, or thumb for video
  final String? backgroundImageUrl; // Explicit background
  final String? creatorAvatarUrl; // Secondary overlay thumb (thumbnail link)
  final String resolution; // e.g., '360P', '1080P', 'Audio'
  final String? postId; // Unique Data LinTop reference
  final double? aspectRatio;

  const MediaData({
    required this.type,
    required this.contentUrl,
    this.thumbnailUrl,
    this.backgroundImageUrl,
    this.creatorAvatarUrl,
    this.resolution = '360P',
    this.postId,
    this.aspectRatio,
  });
}





























