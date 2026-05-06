enum MessageMediaType { image, video, audio }

class MessageMediaItem {
  final String url;
  final MessageMediaType type;
  final String? thumbnail;
  final Duration? duration;

  const MessageMediaItem({
    required this.url,
    required this.type,
    this.thumbnail,
    this.duration,
  });
}
