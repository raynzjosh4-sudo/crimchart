/// Represents a user post highlighted within a "Common Chart" context.
class CommonChartModel {
  final String id;
  final String userId;
  final String username;
  final String userProfileImageUrl;
  final String title; // e.g. 'Top', 'Prince'
  final String category; // e.g. 'Rap', 'Style'
  final List<String> imageUrls;
  final String? videoUrl;
  final String? audioUrl;
  final String? thumbnailUrl;
  final String? backgroundImageUrl;
  final String? creatorAvatarUrl; // Thumbnail link
  final bool isVideo;
  final bool isAudio;
  final List<String> mutualFriends; // Avatar URLs
  final int mutualCount;
  final String chartName;
  final int likes;
  final int comments;
  final bool isLiked;
  final int chartPoints;
  final int rank;
  final bool isCharted;
  final double? aspectRatio;
  final bool hasStatus;
  final bool isActive;
  final int isPending;
  final String localFileCache;

  const CommonChartModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfileImageUrl,
    required this.title,
    required this.category,
    required this.imageUrls,
    this.videoUrl,
    this.audioUrl,
    this.thumbnailUrl,
    this.backgroundImageUrl,
    this.creatorAvatarUrl,
    this.isVideo = false,
    this.isAudio = false,
    required this.chartName,
    this.mutualFriends = const [],
    this.mutualCount = 0,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.chartPoints = 0,
    this.rank = 0,
    this.isCharted = false,
    this.aspectRatio,
    this.hasStatus = false,
    this.isActive = false,
    this.isPending = 0,
    this.localFileCache = '',
  });
}





























