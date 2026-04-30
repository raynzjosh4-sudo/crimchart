class ChannelComment {
  final String id;
  final String userName;
  final String? userAvatar;
  final String timeAgo;
  final String commentText;
  final String userStatus; // e.g. "Diamond Elite", "Gold Member", etc.
  final int level;

  const ChannelComment({
    required this.id,
    required this.userName,
    required this.timeAgo,
    required this.commentText,
    this.userAvatar,
    this.userStatus = "Bronze Member",
    this.level = 1,
  });
}
