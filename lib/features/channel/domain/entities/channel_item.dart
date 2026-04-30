import 'dart:convert';

import 'package:crown/features/feed/domain/entities/post_entity.dart';

sealed class ChannelItem {
  final String id;
  final String authorUsername;
  final String? authorAvatarUrl;
  final bool authorIsOnline;   // 👑 Snapshot presence
  final bool authorHasStatus;  // 👑 Snapshot presence
  final DateTime createdAt;
  final int likes;
  final PostEntity? originalPost; // Bridge to legacy features

  ChannelItem({
    required this.id,
    required this.authorUsername,
    this.authorAvatarUrl,
    this.authorIsOnline = false,
    this.authorHasStatus = false,
    required this.createdAt,
    required this.likes,
    this.originalPost,
  });
}

// 👑 STRICT MANIFESTO DATA
class ManifestoItem extends ChannelItem {
  final String caption;
  final List<String> imageUrls;
  final String? videoUrl;
  final int commentCount;

  ManifestoItem({
    required super.id,
    required super.authorUsername,
    super.authorAvatarUrl,
    super.authorIsOnline,
    super.authorHasStatus,
    required super.createdAt,
    required super.likes,
    super.originalPost,
    required this.caption,
    required this.imageUrls,
    this.videoUrl,
    required this.commentCount,
  });

  factory ManifestoItem.fromMap(
    Map<String, dynamic> map, {
    PostEntity? originalPost,
  }) {
    List<String> parseImages(dynamic raw) {
      if (raw is List) return raw.map((e) => e.toString()).toList();
      if (raw is String && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return decoded.map((e) => e.toString()).toList();
        } catch (_) {}
      }
      return [];
    }

    return ManifestoItem(
      id: map['id'],
      authorUsername: map['username'] ?? 'Anonymous',
      authorAvatarUrl: map['profile_image_url'],
      authorIsOnline: map['is_online'] == true || map['is_online'] == 1,
      authorHasStatus: map['has_status'] == true || map['has_status'] == 1,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      likes: map['likes'] ?? 0,
      caption: map['caption'] ?? '',
      imageUrls: parseImages(map['image_urls']),
      videoUrl: map['video_url'],
      commentCount: map['comments'] ?? 0,
      originalPost: originalPost,
    );
  }
}

// 💬 STRICT CHANNEL COMMENT DATA
class ChannelCommentItem extends ChannelItem {
  final String message;
  final String? manifestoId;

  ChannelCommentItem({
    required super.id,
    required super.authorUsername,
    super.authorAvatarUrl,
    super.authorIsOnline,
    super.authorHasStatus,
    required super.createdAt,
    required super.likes,
    super.originalPost,
    required this.message,
    this.manifestoId,
  });

  factory ChannelCommentItem.fromMap(
    Map<String, dynamic> map, {
    PostEntity? originalPost,
  }) {
    return ChannelCommentItem(
      id: map['id'],
      authorUsername: map['username'] ?? 'Anonymous',
      authorAvatarUrl: map['profile_image_url'],
      authorIsOnline: map['is_online'] == true || map['is_online'] == 1,
      authorHasStatus: map['has_status'] == true || map['has_status'] == 1,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      likes: map['likes'] ?? 0,
      message: map['message'] ?? '',
      manifestoId: map['manifesto_id'],
      originalPost: originalPost,
    );
  }
}
