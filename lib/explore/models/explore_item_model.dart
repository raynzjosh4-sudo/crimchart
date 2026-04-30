enum ExploreItemType { member, Chart, media }

class ExploreItemModel {
  final String id;
  final String imageUrl;
  final String? profileImageUrl;
  final String username;
  final String description;
  final int likes;
  final ExploreItemType type;
  final bool isVideo;
  final String? videoUrl;
  final bool isAudio;
  final String? audioUrl;
  final String? audioBackgroundUrl;
  final double aspectRatio;
  final List<String?> contestantImageUrls;

  const ExploreItemModel({
    required this.id,
    required this.imageUrl,
    this.profileImageUrl,
    required this.username,
    required this.description,
    required this.likes,
    required this.type,
    this.isVideo = false,
    this.videoUrl,
    this.isAudio = false,
    this.audioUrl,
    this.audioBackgroundUrl,
    this.aspectRatio = 1.0,
    this.contestantImageUrls = const [],
  });
}





























