import 'dart:convert';
import 'package:flutter/material.dart';

import '../../domain/entities/post_entity.dart';
import '../../../../core/models/content_entity.dart';

/// Converts raw API JSON maps into [PostEntity] domain objects.
/// Lives in the data layer — domain layer never sees raw JSON.
class PostMapper {
  const PostMapper._();

  static PostEntity fromJson(Map<String, dynamic> json) {
    List<String> parseList(dynamic val) {
      if (val == null) return [];
      if (val is List) return val.map((e) => e.toString()).toList();
      if (val is String && val.isNotEmpty) {
        try {
          final decoded = jsonDecode(val);
          if (decoded is List) return decoded.map((e) => e.toString()).toList();
        } catch (_) {}
      }
      return [];
    }

    final authorData = json['author'] as Map<String, dynamic>?;

    final id = json['id']?.toString() ?? '';
    final username =
        authorData?['username']?.toString() ??
        json['username']?.toString() ??
        json['author_username']?.toString() ??
        '';
    final avatar =
        authorData?['profile_image_url']?.toString() ??
        authorData?['profileImageUrl']?.toString() ??
        json['profile_image_url']?.toString() ??
        json['author_profile_image_url']?.toString() ??
        json['author_avatar_url']?.toString() ??
        json['profile_image_url']?.toString();

    return PostEntity(
      id: id,
      authorId: json['author_id']?.toString() ?? '',
      authorUsername: username,
      authorDisplayName:
          authorData?['display_name']?.toString() ??
          authorData?['displayName']?.toString() ??
          json['display_name']?.toString() ??
          json['author_display_name']?.toString() ??
          json['author_username']?.toString() ??
          username,
      authorAvatarUrl: avatar,
      channelId: json['channel_id']?.toString() ?? '',
      channelName: json['channel_name']?.toString() ?? '',
      caption: json['caption']?.toString() ?? json['message']?.toString() ?? '',
      videoUrl: json['video_url']?.toString(),
      videoUrls: parseList(json['video_urls']),
      audioUrl: json['audio_url']?.toString(),
      imageUrls: parseList(json['image_urls'] ?? json['image_url']),
      thumbnailUrls: parseList(
        json['thumbnail_urls'] ?? 
        json['thumbnail_url'] ?? 
        json['thumbnailUrls'] ?? 
        json['thumbnailUrl']
      ),
      isVideo: json['is_video'] is bool
          ? (json['is_video'] as bool)
          : (json['is_video'] == 1),
      isAudio: json['is_audio'] is bool
          ? (json['is_audio'] as bool)
          : (json['is_audio'] == 1),
      isLiked:
          json['is_liked'] == true ||
          (json['channel_post_likes'] != null &&
              (json['channel_post_likes'] as List).isNotEmpty) ||
          (json['post_likes'] != null &&
              (json['post_likes'] as List).isNotEmpty),
      isPublic: json['is_public'] is bool
          ? (json['is_public'] as bool)
          : (json['is_public'] == 1 || json['is_public'] == null),
      allowComments: json['allow_comments'] is bool
          ? (json['allow_comments'] as bool)
          : (json['allow_comments'] == 1 || json['allow_comments'] == null),
      authorIsOnline: json['is_online'] is bool
          ? (json['is_online'] as bool)
          : (json['is_online'] == 1),
      authorHasStatus: json['has_status'] is bool
          ? (json['has_status'] as bool)
          : (json['has_status'] == 1),
      folderName: json['folder_name']?.toString(),
      likes: (json['likes_count'] as int?) ?? (json['likes'] as int?) ?? 0,
      comments:
          (json['comments_count'] as int?) ?? (json['comments'] as int?) ?? 0,
      shares: (json['shares_count'] as int?) ?? (json['shares'] as int?) ?? 0,
      tagsCount:
          (json['tags_count'] as int?) ?? (json['tagsCount'] as int?) ?? 0,
      timeAgo: json['time_ago']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
      thumbnailLink: json['thumbnail_link'] != null
          ? _parseThumbnailLink(json['thumbnail_link'])
          : ThumbnailLink.original(
              contentId: json['id']?.toString() ?? '',
              authorId: json['author_id']?.toString() ?? '',
              authorUsername:
                  authorData?['username']?.toString() ??
                  json['username']?.toString() ??
                  json['author_username']?.toString() ??
                  '',
              contentType: 'post',
            ),
      authorTitle:
          authorData?['author_title']?.toString() ??
          authorData?['ChartTitle']?.toString() ??
          json['author_title']?.toString(),
      authorCategory: json['author_category']?.toString(),
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      linkedPostId: json['linked_post_id']?.toString(),
      postType: json['post_type']?.toString() ?? 'post',
      parentPostId: json['parent_post_id']?.toString(),
      linkDepth: json['link_depth'] as int? ?? 0,
      linkChain: parseList(json['link_chain']),
      metadata:
          json['metadata'] is String && (json['metadata'] as String).isNotEmpty
          ? Map<String, dynamic>.from(
              jsonDecode(json['metadata'] as String) as Map,
            )
          : json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : {},
      taggerName: json['tagger_name']?.toString(),
      taggerAvatar: json['tagger_avatar']?.toString(),
      sourceChannelName: json['source_channel_name']?.toString(),
      sourceChannelAvatar: json['source_channel_avatar']?.toString(),
    );
  }

  static ThumbnailLink _parseThumbnailLink(dynamic json) {
    return ThumbnailLink(
      originalContentId: json['original_content_id']?.toString() ?? '',
      originalAuthorId: json['original_author_id']?.toString() ?? '',
      originalAuthorUsername:
          json['original_author_username']?.toString() ?? '',
      originalContentType: json['original_content_type']?.toString(),
      linkChain:
          (json['link_chain'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      linkDepth: json['link_depth'] as int? ?? 0,
      parentContentId: json['parent_content_id']?.toString(),
      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(PostEntity entity) {
    return {
      'id': entity.id,
      'author_id': entity.authorId,
      'username': entity.authorUsername,
      'display_name': entity.authorDisplayName,
      'profile_image_url': entity.authorAvatarUrl,
      'channel_id': entity.channelId,
      'channel_name': entity.channelName,
      'caption': entity.caption,
      'image_urls': entity.imageUrls,
      'video_url': entity.videoUrl,
      'video_urls': entity.videoUrls,
      'thumbnail_urls': entity.thumbnailUrls,
      'audio_url': entity.audioUrl,
      'is_audio': entity.isAudio,
      'is_video': entity.isVideo,
      'aspect_ratio': entity.aspectRatio,
      'likes': entity.likes,
      'comments': entity.comments,
      'shares': entity.shares,
      'created_at': entity.createdAt.toIso8601String(),
      'post_type': entity.postType,
      'parent_post_id': entity.parentPostId,
      'linked_post_id': entity.linkedPostId,
      'link_chain': entity.linkChain,
      'link_depth': entity.linkDepth,
      'metadata': entity.metadata,
      'tagger_name': entity.taggerName,
      'tagger_avatar': entity.taggerAvatar,
      'source_channel_name': entity.sourceChannelName,
      'source_channel_avatar': entity.sourceChannelAvatar,
    };
  }
}
