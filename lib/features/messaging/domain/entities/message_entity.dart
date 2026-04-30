import 'package:equatable/equatable.dart';
import '../../../../core/models/content_entity.dart';

enum MessageType { text, image, video, audio, gif, post_share }
enum MessageStatus { sending, sent, delivered, read, failed }

/// A single message in a chat thread.
/// Now extends ContentEntity for ThumbnailLink integration.
class MessageEntity extends ContentEntity {
  final String threadId;
  final String? text;
  final String? mediaUrl;
  final MessageType type;
  final MessageStatus status;

  final bool isEncrypted;
  final DateTime? readAt;

  const MessageEntity({
    required super.id,
    required super.authorId,
    required super.authorUsername,
    required super.authorDisplayName,
    super.authorAvatarUrl,
    required super.createdAt,
    required super.thumbnailLink,
    required this.threadId,
    this.text,
    this.mediaUrl,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.isEncrypted = false,
    this.readAt,
  });

  /// Creates a regular message (not sharing content)
  factory MessageEntity.regular({
    required String id,
    required String threadId,
    required String senderId,
    required String senderUsername,
    required String senderDisplayName,
    String? senderAvatarUrl,
    required DateTime sentAt,
    String? text,
    String? mediaUrl,
    MessageType type = MessageType.text,
    MessageStatus status = MessageStatus.sent,
    bool isEncrypted = false,
  }) {
    final thumbnailLink = ThumbnailLink.original(
      contentId: id,
      authorId: senderId,
      authorUsername: senderUsername,
      contentType: 'message',
    );

    return MessageEntity(
      id: id,
      authorId: senderId,
      authorUsername: senderUsername,
      authorDisplayName: senderDisplayName,
      authorAvatarUrl: senderAvatarUrl,
      createdAt: sentAt,
      thumbnailLink: thumbnailLink,
      threadId: threadId,
      text: text,
      mediaUrl: mediaUrl,
      type: type,
      status: status,
      isEncrypted: isEncrypted,
    );
  }

  /// Creates a message that shares content from elsewhere
  factory MessageEntity.share({
    required String id,
    required String threadId,
    required String senderId,
    required String senderUsername,
    required String senderDisplayName,
    String? senderAvatarUrl,
    required DateTime sentAt,
    required ThumbnailLink sharedContentLink,
    String? text,
    MessageStatus status = MessageStatus.sent,
    bool isEncrypted = false,
  }) {
    final thumbnailLink = ThumbnailLink.fromParent(
      newContentId: id,
      parentLink: sharedContentLink,
    );

    return MessageEntity(
      id: id,
      authorId: senderId,
      authorUsername: senderUsername,
      authorDisplayName: senderDisplayName,
      authorAvatarUrl: senderAvatarUrl,
      createdAt: sentAt,
      thumbnailLink: thumbnailLink,
      threadId: threadId,
      text: text,
      type: MessageType.post_share,
      status: status,
      isEncrypted: isEncrypted,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    threadId, text, mediaUrl, type, status, sentAt, readAt
  ];

  /// Alias for createdAt to maintain compatibility
  DateTime get sentAt => createdAt;
}
/// A conversation thread between users.
class ThreadEntity extends Equatable {
  final String id;
  final List<String> participantIds;
  final List<String> participantUsernames;
  final List<String?> participantAvatarUrls;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  const ThreadEntity({
    required this.id,
    required this.participantIds,
    required this.participantUsernames,
    required this.participantAvatarUrls,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, participantIds, updatedAt];
}





























