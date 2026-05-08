import 'package:crimchart/core/db/chart_db.dart';

class ChannelMomentEntity {
  final String id;
  final String channelId;
  final String authorId;
  final String? authorName;
  final String? authorAvatarUrl;
  final String mediaUrl;
  final String mediaType; // 'photo' or 'video'
  final String? thumbnailUrl;
  final String? caption;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const ChannelMomentEntity({
    required this.id,
    required this.channelId,
    required this.authorId,
    this.authorName,
    this.authorAvatarUrl,
    required this.mediaUrl,
    required this.mediaType,
    this.thumbnailUrl,
    this.caption,
    required this.createdAt,
    this.expiresAt,
  });

  factory ChannelMomentEntity.fromDrift(ChannelMoment row) {
    return ChannelMomentEntity(
      id: row.id,
      channelId: row.channelId,
      authorId: row.authorId,
      authorName: row.authorName,
      authorAvatarUrl: row.authorAvatarUrl,
      mediaUrl: row.mediaUrl,
      mediaType: row.mediaType,
      thumbnailUrl: row.thumbnailUrl,
      caption: row.caption,
      createdAt: row.createdAt,
      expiresAt: row.expiresAt,
    );
  }

  factory ChannelMomentEntity.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
        // Handle stringified timestamps
        final asInt = int.tryParse(value);
        if (asInt != null) return DateTime.fromMillisecondsSinceEpoch(asInt);
      }
      if (value is DateTime) return value;
      return DateTime.now();
    }

    return ChannelMomentEntity(
      id: (map['id'] ?? '') as String,
      channelId: (map['channel_id'] ?? map['channelId'] ?? '') as String,
      authorId: (map['author_id'] ?? map['authorId'] ?? '') as String,
      authorName: (map['author_name'] ?? map['authorName']) as String?,
      authorAvatarUrl: (map['author_avatar_url'] ?? map['authorAvatarUrl']) as String?,
      mediaUrl: (map['media_url'] ?? map['mediaUrl'] ?? '') as String,
      mediaType: (map['media_type'] ?? map['mediaType']) as String? ?? 'photo',
      thumbnailUrl: (map['thumbnail_url'] ?? map['thumbnailUrl']) as String?,
      caption: map['caption'] as String?,
      createdAt: parseDate(map['created_at'] ?? map['createdAt']),
      expiresAt: (map['expires_at'] != null || map['expiresAt'] != null)
          ? parseDate(map['expires_at'] ?? map['expiresAt'])
          : null,
    );
  }
}
