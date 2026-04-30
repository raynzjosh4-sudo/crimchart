class ChartChart {
  final String id;
  final String senderName;
  final String? senderAvatarUrl;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;

  ChartChart({
    required this.id,
    required this.senderName,
    this.senderAvatarUrl,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}





























