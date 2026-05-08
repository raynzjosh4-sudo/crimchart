import 'package:equatable/equatable.dart';

/// Represents a "Tag" or "Repost" action where a post is shared to a target channel.
class TagEntity extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String sourceChannelId;
  final String targetChannelId;
  final List<String> linkChain;
  final DateTime createdAt;

  const TagEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.sourceChannelId,
    required this.targetChannelId,
    required this.linkChain,
    required this.createdAt,
  });

  factory TagEntity.fromJson(Map<String, dynamic> json) {
    return TagEntity(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      sourceChannelId: json['source_channel_id'] as String,
      targetChannelId: json['target_channel_id'] as String,
      linkChain: (json['link_chain'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'source_channel_id': sourceChannelId,
      'target_channel_id': targetChannelId,
      'link_chain': linkChain,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        postId,
        userId,
        sourceChannelId,
        targetChannelId,
        linkChain,
        createdAt,
      ];
}
