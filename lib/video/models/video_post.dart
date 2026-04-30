class VideoPost {
  final String id;
  final String url;
  final String authorName;
  final String? authorAvatarUrl;
  final String description;
  final int likes;
  final int comments;
  final int shares;

  VideoPost({
    required this.id,
    required this.url,
    required this.authorName,
    this.authorAvatarUrl,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}





























