import 'dart:convert';

/// Entity model for a channel story/status.
class ChannelStatusEntity {
  final String id;
  final String channelId;
  final String authorId;
  final String? authorUsername;
  final String? authorAvatarUrl;

  final String? caption;
  final List<String> imageUrls;
  final String? videoUrl;
  final String? thumbnailUrl; // 👑 ADDED
  final String? audioUrl;

  final bool isVideo;
  final bool isAudio;

  final int viewsCount;
  final int likesCount;
  final int commentsCount;

  final DateTime createdAt;
  final DateTime? expiresAt;

  const ChannelStatusEntity({
    required this.id,
    required this.channelId,
    required this.authorId,
    this.authorUsername,
    this.authorAvatarUrl,
    this.caption,
    this.imageUrls = const [],
    this.videoUrl,
    this.thumbnailUrl, // 👑
    this.audioUrl,
    this.isVideo = false,
    this.isAudio = false,
    this.viewsCount = 0,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.expiresAt,
  });

  /// Whether this status has expired (older than 24 hours).
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// The primary display image (prefers thumbnail for videos).
  String? get primaryImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first : thumbnailUrl;

  /// Build from a raw Supabase / Drift map.
  factory ChannelStatusEntity.fromMap(Map<String, dynamic> map) {
    // Parse image_urls — can be a List or a JSON string
    List<String> parseImageUrls(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) return raw.map((e) => e.toString()).toList();
      if (raw is String && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return decoded.map((e) => e.toString()).toList();
        } catch (_) {
          // Fallback for non-JSON strings (comma separated)
          if (raw.startsWith('[') && raw.endsWith(']')) {
            final inner = raw.substring(1, raw.length - 1).trim();
            if (inner.isEmpty) return [];
            return inner
                .split(',')
                .map((s) => s.trim().replaceAll('"', ''))
                .where((s) => s.isNotEmpty)
                .toList();
          }
          return [raw];
        }
      }
      return [];
    }

    return ChannelStatusEntity(
      id: map['id'] as String,
      channelId: (map['channel_id'] ?? map['channelId']) as String,
      authorId: (map['author_id'] ?? map['authorId']) as String,
      authorUsername: map['username'] as String?,
      authorAvatarUrl:
          (map['profile_image_url'] ?? map['profileImageUrl']) as String?,
      caption: map['caption'] as String?,
      imageUrls: parseImageUrls(map['image_urls'] ?? map['imageUrls']),
      videoUrl: (map['video_url'] ?? map['videoUrl']) as String?,
      thumbnailUrl: (map['thumbnail_url'] ?? map['thumbnailUrl']) as String?,
      audioUrl: (map['audio_url'] ?? map['audioUrl']) as String?,
      isVideo: _parseBool(map['is_video'] ?? map['isVideo']),
      isAudio: _parseBool(map['is_audio'] ?? map['isAudio']),
      viewsCount: _parseInt(map['views_count'] ?? map['viewsCount']),
      likesCount: _parseInt(map['likes_count'] ?? map['likesCount']),
      commentsCount: _parseInt(map['comments_count'] ?? map['commentsCount']),
      createdAt: _parseDate(map['created_at'] ?? map['createdAt']),
      expiresAt: map['expires_at'] != null || map['expiresAt'] != null
          ? _parseDate(map['expires_at'] ?? map['expiresAt'])
          : null,
    );
  }

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    return false;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString()) ?? DateTime.now();
  }
}
