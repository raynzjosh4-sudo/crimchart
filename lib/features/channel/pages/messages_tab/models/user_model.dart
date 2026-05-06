class ChatUser {
  final String id;
  final String name;
  final String profileImageUrl;
  final bool isVerified;
  final bool isTyping;
  final int followersCount;
  final int channelsCount;

  const ChatUser({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    this.isVerified = false,
    this.isTyping = false,
    this.followersCount = 0,
    this.channelsCount = 0,
  });

  ChatUser copyWith({
    String? id,
    String? name,
    String? profileImageUrl,
    bool? isVerified,
    bool? isTyping,
    int? followersCount,
    int? channelsCount,
  }) {
    return ChatUser(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isVerified: isVerified ?? this.isVerified,
      isTyping: isTyping ?? this.isTyping,
      followersCount: followersCount ?? this.followersCount,
      channelsCount: channelsCount ?? this.channelsCount,
    );
  }
}
