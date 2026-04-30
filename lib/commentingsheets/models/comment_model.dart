class VideoComment {
  final String id;
  final String username;
  final String userAvatarUrl;
  final String text;
  final String timeAgo;
  final int likes;
  final bool isLiked;
  final bool isCreator;
  final List<VideoComment> replies;

  VideoComment({
    required this.id,
    required this.username,
    required this.userAvatarUrl,
    required this.text,
    required this.timeAgo,
    this.likes = 0,
    this.isLiked = false,
    this.isCreator = false,
    this.replies = const [],
  });
}





























