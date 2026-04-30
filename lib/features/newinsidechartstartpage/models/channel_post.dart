class ChannelPost {
  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final String content;
  final List<String> imageUrls;
  final DateTime timestamp;

  ChannelPost({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    required this.content,
    this.imageUrls = const [],
    required this.timestamp,
  });
}





























