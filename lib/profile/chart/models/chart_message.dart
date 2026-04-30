enum ChartMessageType { text, image, video, audio }

class ChartMessage {
  final String id;
  final String content;
  final ChartMessageType type;
  final String? mediaUrl;
  final String? duration; // e.g. "0:15"
  final DateTime timestamp;
  final bool isMe;

  ChartMessage({
    required this.id,
    required this.content,
    this.type = ChartMessageType.text,
    this.mediaUrl,
    this.duration,
    required this.timestamp,
    required this.isMe,
  });
}





























