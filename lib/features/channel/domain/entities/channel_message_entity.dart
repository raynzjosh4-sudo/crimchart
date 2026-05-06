import 'package:equatable/equatable.dart';
import 'dart:convert';

enum ChannelMessageType { text, poll, gift, image, video, voice }

class ChannelMessageEntity extends Equatable {
  final String id;
  final String channelId;
  final String senderId;
  final String senderUsername;
  final String? senderAvatarUrl;

  final String? textContent;
  final String? mediaUrl;
  final ChannelMessageType messageType;

  final String? replyToId;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;
  final bool isPending;

  const ChannelMessageEntity({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.senderUsername,
    this.senderAvatarUrl,
    this.textContent,
    this.mediaUrl,
    this.messageType = ChannelMessageType.text,
    this.replyToId,
    required this.createdAt,
    this.metadata,
    this.isPending = false,
  });

  factory ChannelMessageEntity.fromMap(Map<String, dynamic> map) {
    ChannelMessageType type;
    // 👑 Robust type inference: check message_type, media_type, and mediaType
    final typeValue = map['message_type'] ?? map['messageType'] ?? map['media_type'] ?? map['mediaType'];
    
    switch (typeValue) {
      case 'poll':
        type = ChannelMessageType.poll;
        break;
      case 'gift':
        type = ChannelMessageType.gift;
        break;
      case 'image':
        type = ChannelMessageType.image;
        break;
      case 'video':
        type = ChannelMessageType.video;
        break;
      case 'voice':
      case 'audio':
        type = ChannelMessageType.voice;
        break;
      default:
        // If mediaUrl is present but type is unknown, infer from extension or default to text
        if (map['media_url'] != null || map['mediaUrl'] != null) {
          final url = (map['media_url'] ?? map['mediaUrl']).toString().toLowerCase();
          if (url.contains('.mp4') || url.contains('.mov')) {
            type = ChannelMessageType.video;
          } else if (url.contains('.jpg') || url.contains('.png') || url.contains('.jpeg')) {
            type = ChannelMessageType.image;
          } else {
            type = ChannelMessageType.text;
          }
        } else {
          type = ChannelMessageType.text;
        }
    }

    return ChannelMessageEntity(
      id: map['id'] ?? '',
      channelId: map['channel_id'] ?? map['channelId'] ?? '',
      senderId: map['sender_id'] ?? map['senderId'] ?? '',
      senderUsername: map['sender_username'] ?? map['senderUsername'] ?? 'Member',
      senderAvatarUrl: map['sender_avatar_url'] ?? map['senderAvatarUrl'],
      textContent: map['text_content'] ?? map['textContent'],
      mediaUrl: map['media_url'] ?? map['mediaUrl'],
      messageType: type,
      replyToId: map['reply_to_id'] ?? map['replyToId'],
      createdAt: map['created_at'] != null || map['createdAt'] != null
          ? DateTime.tryParse((map['created_at'] ?? map['createdAt']).toString()) ?? DateTime.now()
          : DateTime.now(),
      metadata: map['metadata'] is String
          ? (jsonDecode(map['metadata'] as String) as Map<String, dynamic>)
          : (map['metadata'] is Map
              ? Map<String, dynamic>.from(map['metadata'] as Map)
              : null),
      isPending: map['is_pending'] == true ||
          map['is_pending'] == 1 ||
          map['isPending'] == true ||
          map['isPending'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'channel_id': channelId,
      'sender_id': senderId,
      'text_content': textContent,
      'media_url': mediaUrl,
      'media_type': messageType.name,
      'reply_to_id': replyToId,
      'created_at': createdAt.toUtc().toIso8601String(),
      'is_pending': isPending,
      'metadata': metadata,
    };
  }

  ChannelMessageEntity copyWith({
    String? id,
    String? channelId,
    String? senderId,
    String? senderUsername,
    String? senderAvatarUrl,
    String? textContent,
    String? mediaUrl,
    ChannelMessageType? messageType,
    String? replyToId,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
    bool? isPending,
  }) {
    return ChannelMessageEntity(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      textContent: textContent ?? this.textContent,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      messageType: messageType ?? this.messageType,
      replyToId: replyToId ?? this.replyToId,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      isPending: isPending ?? this.isPending,
    );
  }

  @override
  List<Object?> get props => [
    id,
    channelId,
    senderId,
    textContent,
    mediaUrl,
    messageType,
    replyToId,
    createdAt,
    metadata,
    isPending,
  ];
}
