import 'dart:typed_data';
import 'package:flutter/material.dart';

enum MediaType { photo, video, audio }

enum MediaSource { device, gallery, members }

class PostType {
  PostType._();
  static const String profile = 'profile_post';
  static const String channel = 'channel_post';
  static const String manifesto = 'manifesto';
  static const String reel = 'reel';
  static const String status = 'status';
  static const String comment = 'comment';
}

class PostFolder {
  PostFolder._();
  static const String public = 'public_posts';
  static const String status = 'status_posts';
  static const String channel = 'channel_posts';
  static const String profile = 'profile_posts';

  static String compute({
    required MediaSource source,
    required bool hasChannel,
    required bool isMyChannel,
    required bool isRepost,
  }) {
    if (source == MediaSource.members) return channel;
    if (isRepost) return public;
    if (hasChannel) return channel;
    return profile;
  }
}

class MediaItem {
  final String path;
  final MediaType type;
  final String? title;
  final String? artist;
  final String? thumbnailUrl;
  final Uint8List? thumbnailBytes;
  final double? aspectRatio;
  
  /// List of stickers or text overlays.
  /// Made mutable to support the C++ overlay coordinate commitment.
  List<dynamic>? overlays;
  
  // ── Link attributes ────────────────────────────────────────────────────────
  final String? linkedPostId;
  final String? linkedAuthorId;
  final List<String> linkChain;
  final int linkDepth;
  final String? linkedAuthorUsername;
  final String? linkedCaption;
  final String? linkedChannelId;

  // ── Source ────────────────────────────────────────────────────────────────
  final MediaSource source;

  MediaItem({
    required this.path,
    required this.type,
    this.title,
    this.artist,
    this.thumbnailUrl,
    this.thumbnailBytes,
    this.aspectRatio,
    this.overlays,
    this.linkedPostId,
    this.linkedAuthorId,
    this.linkChain = const [],
    this.linkDepth = 0,
    this.linkedAuthorUsername,
    this.linkedCaption,
    this.linkedChannelId,
    this.source = MediaSource.device,
  });

  bool get isLinked => linkedPostId != null;

  MediaItem withPath(String newPath) => MediaItem(
    path: newPath,
    type: type,
    title: title,
    artist: artist,
    thumbnailUrl: thumbnailUrl,
    thumbnailBytes: thumbnailBytes,
    aspectRatio: aspectRatio,
    overlays: overlays,
    linkedPostId: linkedPostId,
    linkedAuthorId: linkedAuthorId,
    linkChain: linkChain,
    linkDepth: linkDepth,
    linkedAuthorUsername: linkedAuthorUsername,
    linkedCaption: linkedCaption,
    linkedChannelId: linkedChannelId,
    source: source,
  );
}

class MediaOverlay {
  final String? imagePath;
  final String? text;
  final Color? color;
  final bool hasBackground;
  final int x;
  final int y;
  final double scale;
  final double rotation;

  MediaOverlay({
    this.imagePath,
    this.text,
    this.color,
    this.hasBackground = false,
    required this.x,
    required this.y,
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}
