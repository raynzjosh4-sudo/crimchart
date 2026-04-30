enum EliteMediaType { image, video, audio }

class EliteModel {
  final String id;
  final String title;
  final EliteMediaType mediaType;
  final String mediaUrl;
  final String channelName;
  final String channelCreatorName;
  final String channelCreatorAvatar;
  final String winnerName;
  final String winnerAvatar;
  final int totalPoints;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isCharted;

  const EliteModel({
    required this.id,
    required this.title,
    required this.mediaType,
    required this.mediaUrl,
    required this.channelName,
    required this.channelCreatorName,
    required this.channelCreatorAvatar,
    required this.winnerName,
    required this.winnerAvatar,
    required this.totalPoints,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.isCharted = false,
  });
}





























