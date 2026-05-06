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
  final bool isLiked;
  final PostEntity? originalPost; // Bridge to legacy features

  ChannelItem({
    required this.id,
    required this.authorUsername,
    this.authorAvatarUrl,
    this.authorIsOnline = false,
    this.authorHasStatus = false,
    required this.createdAt,
    required this.likes,
    this.isLiked = false,
    this.originalPost,
  });
}

// 👑 STRICT MANIFESTO DATA
class ManifestoItem extends ChannelItem {
  final String caption;
  final List<String> imageUrls;
  final String? videoUrl;
  final int commentCount;
  final double? aspectRatio;

  ManifestoItem({
    required super.id,
    required super.authorUsername,
    super.authorAvatarUrl,
    super.authorIsOnline,
    super.authorHasStatus,
    required super.createdAt,
    required super.likes,
    super.isLiked,
    super.originalPost,
    required this.caption,
    required this.imageUrls,
    this.videoUrl,
    required this.commentCount,
    this.aspectRatio,
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
      id: map['id']?.toString() ?? '',
      authorUsername: map['username']?.toString() ?? 'Anonymous',
      authorAvatarUrl: map['profile_image_url'],
      authorIsOnline: map['is_online'] == true || map['is_online'] == 1,
      authorHasStatus: map['has_status'] == true || map['has_status'] == 1,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      likes: map['likes'] ?? 0,
      isLiked: map['is_liked'] == true || map['is_liked'] == 1 || (originalPost?.isLiked ?? false),
      caption: map['caption'] ?? '',
      imageUrls: parseImages(map['image_urls']),
      videoUrl: map['video_url'],
      commentCount: map['comments'] ?? 0,
      aspectRatio: (map['aspect_ratio'] as num?)?.toDouble(),
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
    super.isLiked,
    super.originalPost,
    required this.message,
    this.manifestoId,
  });

  factory ChannelCommentItem.fromMap(
    Map<String, dynamic> map, {
    PostEntity? originalPost,
  }) {
    return ChannelCommentItem(
      id: map['id']?.toString() ?? '',
      authorUsername: map['username']?.toString() ?? 'Anonymous',
      authorAvatarUrl: map['profile_image_url'],
      authorIsOnline: map['is_online'] == true || map['is_online'] == 1,
      authorHasStatus: map['has_status'] == true || map['has_status'] == 1,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      likes: map['likes'] ?? 0,
      isLiked: map['is_liked'] == true || map['is_liked'] == 1 || (originalPost?.isLiked ?? false),
      message: map['message'] ?? '',
      manifestoId: map['manifesto_id'],
      originalPost: originalPost,
    );
  }
}

// 👑 CROSS-CHANNEL INVITATION DATA
class InvitationItem extends ChannelItem {
  final String targetChannelId;
  final String targetChannelName;
  final String? targetChannelImage;
  final String? targetChannelTitle;
  final String? authorTitle;
  final String? caption;

  InvitationItem({
    required super.id,
    required super.authorUsername,
    super.authorAvatarUrl,
    super.authorIsOnline,
    super.authorHasStatus,
    required super.createdAt,
    required super.likes,
    super.isLiked,
    super.originalPost,
    required this.targetChannelId,
    required this.targetChannelName,
    this.targetChannelImage,
    this.targetChannelTitle,
    this.authorTitle,
    this.caption,
  });

  factory InvitationItem.fromMap(
    Map<String, dynamic> map, {
    PostEntity? originalPost,
  }) {
    // 👑 Extract target channel info from metadata if present
    final metadata = originalPost?.metadata ?? {};

    return InvitationItem(
      id: map['id']?.toString() ?? '',
      authorUsername: map['username']?.toString() ?? 'Anonymous',
      authorAvatarUrl: map['profile_image_url'],
      authorIsOnline: map['is_online'] == true || map['is_online'] == 1,
      authorHasStatus: map['has_status'] == true || map['has_status'] == 1,
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      likes: map['likes'] ?? 0,
      isLiked: map['is_liked'] == true || map['is_liked'] == 1 || (originalPost?.isLiked ?? false),
      targetChannelId: metadata['target_channel_id']?.toString() ?? '',
      targetChannelName:
          metadata['target_channel_name']?.toString() ?? 'Unknown Channel',
      targetChannelImage: metadata['target_channel_image']?.toString(),
      targetChannelTitle: metadata['target_channel_title']?.toString(),
      authorTitle: originalPost?.authorTitle,
      caption: originalPost?.caption,
      originalPost: originalPost,
    );
  }
}
