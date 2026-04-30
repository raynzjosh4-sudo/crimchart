import 'dart:convert';
import '../../../../core/models/content_entity.dart';

/// Post domain entity — represents a single post in the feed.
/// Now extends ContentEntity for ThumbnailLink integration.
class PostEntity extends ContentEntity {
  final String channelId;
  final String channelName;

  final String caption;
  final String? videoUrl;
  final List<String> videoUrls; // 👑 Multi-video support (2x / 4x grid)
  final String? sdVideoUrl; // Added for Data-Saver mobile variant
  final String? audioUrl;
  final List<String> imageUrls;
  final List<String> thumbnailUrls;
  final bool isVideo;
  final bool isAudio;
  final bool isLiked;
  final String? folderName;

  final int likes;
  final int comments;
  final int shares;

  final bool authorIsOnline;
  final bool authorHasStatus;
  final String timeAgo;
  final int isPending;
  final String localFileCache;

  final String? authorTitle; 
  final String? authorCategory;
  final double? aspectRatio;

  // ── New link fields ──────────────────────────────────────
  final String? linkedPostId;
  final String postType;         // 'post' | 'comment' | 'crown' | 'repost'
  final String? parentPostId;
  final int linkDepth;
  final List<String> linkChain;
  final String? linkedAuthorUsername;
  final String? linkedCaption;
  final String? linkedChannelId;
  final bool isPublic;
  final bool allowComments;

  const PostEntity({
    required super.id,
    required super.authorId,
    required super.authorUsername,
    required super.authorDisplayName,
    super.authorAvatarUrl,
    required super.createdAt,
    required super.thumbnailLink,
    required this.channelId,
    required this.channelName,
    required this.caption,
    this.videoUrl,
    this.videoUrls = const [],
    this.audioUrl,
    this.sdVideoUrl,
    this.imageUrls = const [],
    this.thumbnailUrls = const [],
    this.isVideo = false,
    this.isAudio = false,
    this.isLiked = false,
    this.folderName,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.timeAgo = '',
    this.isPending = 0,
    this.localFileCache = '',
    this.authorTitle,
    this.authorCategory,
    this.aspectRatio,
    this.linkedPostId,
    this.postType = 'post',
    this.parentPostId,
    this.linkDepth = 0,
    this.linkChain = const [],
    this.linkedAuthorUsername,
    this.linkedCaption,
    this.linkedChannelId,
    this.authorIsOnline = false,
    this.authorHasStatus = false,
    this.isPublic = true,
    this.allowComments = true,
  });

  /// Creates an original post (not referencing other content)
  factory PostEntity.original({
    required String id,
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    String? authorAvatarUrl,
    required DateTime createdAt,
    required String channelId,
    required String channelName,
    required String caption,
    String? videoUrl,
    List<String> videoUrls = const [],
    String? audioUrl,
    String? sdVideoUrl,
    List<String> imageUrls = const [],
    List<String> thumbnailUrls = const [],
    bool isVideo = false,
    bool isAudio = false,
    int likes = 0,
    int comments = 0,
    int shares = 0,
    String timeAgo = '',
    String? authorTitle,
    String? authorCategory,
    String? folderName,
    int isPending = 0,
    String localFileCache = '',
    double? aspectRatio,
    String? linkedPostId,
    String postType = 'post',
    String? parentPostId,
    int linkDepth = 0,
    List<String> linkChain = const [],
    String? linkedAuthorUsername,
    String? linkedCaption,
    String? linkedChannelId,
    bool authorIsOnline = false,
    bool authorHasStatus = false,
    bool isPublic = true,
    bool allowComments = true,
  }) {
    final thumbnailLink = ThumbnailLink.original(
      contentId: id,
      authorId: authorId,
      authorUsername: authorUsername,
      contentType: 'post',
    );

    return PostEntity(
      id: id,
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: createdAt,
      thumbnailLink: thumbnailLink,
      channelId: channelId,
      channelName: channelName,
      caption: caption,
      videoUrl: videoUrl,
      videoUrls: videoUrls,
      audioUrl: audioUrl,
      sdVideoUrl: sdVideoUrl,
      imageUrls: imageUrls,
      thumbnailUrls: thumbnailUrls,
      isVideo: isVideo,
      isAudio: isAudio,
      folderName: folderName,
      likes: likes,
      comments: comments,
      shares: shares,
      timeAgo: timeAgo,
      isPending: isPending,
      localFileCache: localFileCache,
      authorTitle: authorTitle,
      authorCategory: authorCategory,
      aspectRatio: aspectRatio,
      linkedPostId: linkedPostId,
      postType: postType,
      parentPostId: parentPostId,
      linkDepth: linkDepth,
      linkChain: linkChain,
      linkedAuthorUsername: linkedAuthorUsername,
      linkedCaption: linkedCaption,
      linkedChannelId: linkedChannelId,
      authorIsOnline: authorIsOnline,
      authorHasStatus: authorHasStatus,
      isPublic: isPublic,
      allowComments: allowComments,
    );
  }

  /// Creates a post that references another piece of content
  factory PostEntity.fromParent({
    required String id,
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    String? authorAvatarUrl,
    required DateTime createdAt,
    required ThumbnailLink parentLink,
    required String channelId,
    required String channelName,
    required String caption,
    String? videoUrl,
    List<String> videoUrls = const [],
    String? audioUrl,
    String? sdVideoUrl,
    List<String> imageUrls = const [],
    List<String> thumbnailUrls = const [],
    bool isVideo = false,
    bool isAudio = false,
    int likes = 0,
    int comments = 0,
    int shares = 0,
    String timeAgo = '',
    int isPending = 0,
    String localFileCache = '',
    String? authorTitle,
    String? authorCategory,
    String? folderName,
    String? linkedPostId,
    String postType = 'post',
    String? parentPostId,
    int linkDepth = 0,
    List<String> linkChain = const [],
    String? linkedAuthorUsername,
    String? linkedCaption,
    String? linkedChannelId,
    bool authorIsOnline = false,
    bool authorHasStatus = false,
    bool isPublic = true,
    bool allowComments = true,
  }) {
    final thumbnailLink = ThumbnailLink.fromParent(
      newContentId: id,
      parentLink: parentLink,
    );

    return PostEntity(
      id: id,
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: createdAt,
      thumbnailLink: thumbnailLink,
      channelId: channelId,
      channelName: channelName,
      caption: caption,
      videoUrl: videoUrl,
      videoUrls: videoUrls,
      audioUrl: audioUrl,
      sdVideoUrl: sdVideoUrl,
      imageUrls: imageUrls,
      thumbnailUrls: thumbnailUrls,
      isVideo: isVideo,
      isAudio: isAudio,
      isPending: isPending,
      localFileCache: localFileCache,
      folderName: folderName,
      likes: likes,
      comments: comments,
      shares: shares,
      timeAgo: timeAgo,
      authorTitle: authorTitle,
      authorCategory: authorCategory,
      linkedPostId: linkedPostId,
      postType: postType,
      parentPostId: parentPostId,
      linkDepth: linkDepth,
      linkChain: linkChain,
      linkedAuthorUsername: linkedAuthorUsername,
      linkedCaption: linkedCaption,
      linkedChannelId: linkedChannelId,
      authorIsOnline: authorIsOnline,
      authorHasStatus: authorHasStatus,
      isPublic: isPublic,
      allowComments: allowComments,
    );
  }

  PostEntity copyWith({
    bool? isLiked,
    int? likes,
    int? comments,
    int? shares,
    String? folderName,
    int? isPending,
    List<String>? imageUrls,
    String? videoUrl,
    List<String>? videoUrls,
    String? sdVideoUrl,
    String? audioUrl,
    List<String>? thumbnailUrls,
    bool? isVideo,
    bool? isAudio,
    String? channelId,
    String? channelName,
    String? caption,
    bool? isPublic,
    bool? allowComments,
  }) {
    return PostEntity(
      id: id,
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: createdAt,
      thumbnailLink: thumbnailLink,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrls: videoUrls ?? this.videoUrls,
      audioUrl: audioUrl ?? this.audioUrl,
      sdVideoUrl: sdVideoUrl ?? this.sdVideoUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      thumbnailUrls: thumbnailUrls ?? this.thumbnailUrls,
      isVideo: isVideo ?? this.isVideo,
      isAudio: isAudio ?? this.isAudio,
      isLiked: isLiked ?? this.isLiked,
      folderName: folderName ?? this.folderName,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      timeAgo: timeAgo,
      isPending: isPending ?? this.isPending,
      localFileCache: localFileCache,
      authorTitle: authorTitle,
      authorCategory: authorCategory,
      aspectRatio: aspectRatio,
      linkedPostId: linkedPostId,
      postType: postType,
      parentPostId: parentPostId,
      linkDepth: linkDepth,
      linkChain: linkChain,
      linkedAuthorUsername: linkedAuthorUsername,
      linkedCaption: linkedCaption,
      linkedChannelId: linkedChannelId,
      isPublic: isPublic ?? this.isPublic,
      allowComments: allowComments ?? this.allowComments,
    );
  }

  /// Converts an arbitrary DB row / JSON map into a PostEntity.
  factory PostEntity.fromMap(Map<String, dynamic> map) {
    final rawImageUrls = map['imageUrls'];
    List<String> imageUrls;
    if (rawImageUrls is String && rawImageUrls.isNotEmpty) {
      try {
        final current = jsonDecode(rawImageUrls);
        if (current is List) {
          imageUrls = current.map((e) => e.toString()).toList();
        } else {
          imageUrls = [];
        }
      } catch (_) { imageUrls = []; }
    } else if (rawImageUrls is List) {
      imageUrls = rawImageUrls.map((e) => e.toString()).toList();
    } else imageUrls = [];

    final rawThumbnailUrls = map['thumbnailUrls'] ?? map['thumbnail_urls'];
    List<String> thumbnailUrls;
    if (rawThumbnailUrls is String && rawThumbnailUrls.isNotEmpty) {
      try {
        final current = jsonDecode(rawThumbnailUrls);
        if (current is List) {
          thumbnailUrls = current.map((e) => e.toString()).toList();
        } else {
          thumbnailUrls = [];
        }
      } catch (_) { thumbnailUrls = []; }
    } else if (rawThumbnailUrls is List) {
      thumbnailUrls = rawThumbnailUrls.map((e) => e.toString()).toList();
    } else thumbnailUrls = [];

    final createdAt = map['createdAt'] is String
        ? DateTime.tryParse(map['createdAt'] as String)
        : map['createdAt'] is DateTime
        ? map['createdAt'] as DateTime
        : null;

    return PostEntity.original(
      id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: map['authorId']?.toString() ?? map['author_id']?.toString() ?? 'unknown',
      authorUsername: map['authorUsername']?.toString() ?? map['username']?.toString() ?? 'unknown',
      authorDisplayName: map['authorDisplayName']?.toString() ?? map['username']?.toString() ?? 'unknown',
      authorAvatarUrl: map['authorAvatarUrl']?.toString() ?? map['userProfileImageUrl']?.toString(),
      createdAt: createdAt ?? DateTime.now(),
      channelId: map['channelId']?.toString() ?? 'unknown',
      channelName: map['channelName']?.toString() ?? 'unknown',
      caption: map['caption']?.toString() ?? map['message']?.toString() ?? '',
      videoUrl: map['videoUrl']?.toString() ?? map['video_url']?.toString(),
      videoUrls: _parseStringList(map['video_urls'] ?? map['videoUrls']),
      audioUrl: map['audioUrl']?.toString() ?? map['audio_url']?.toString(),
      sdVideoUrl: map['sdVideoUrl']?.toString(),
      imageUrls: imageUrls,
      thumbnailUrls: thumbnailUrls,
      isVideo: (map['isVideo'] is int ? (map['isVideo'] as int) == 1 : map['isVideo'] == true) || (map['is_video'] == true),
      isAudio: (map['isAudio'] is int ? (map['isAudio'] as int) == 1 : map['isAudio'] == true) || (map['is_audio'] == true),
      likes: map['likes'] is int ? map['likes'] as int : int.tryParse(map['likes']?.toString() ?? '') ?? 0,
      comments: map['comments'] is int ? map['comments'] as int : int.tryParse(map['comments']?.toString() ?? '') ?? 0,
      shares: map['shares'] is int ? map['shares'] as int : int.tryParse(map['shares']?.toString() ?? '') ?? 0,
      timeAgo: map['timeAgo']?.toString() ?? '',
      isPending: map['isPending'] ?? 0,
      localFileCache: map['localFileCache']?.toString() ?? '',
      authorTitle: map['authorTitle']?.toString(),
      authorCategory: map['authorCategory']?.toString(),
      folderName: map['folderName']?.toString() ?? map['folder_name']?.toString(),
      aspectRatio: map['aspectRatio'] is num 
          ? (map['aspectRatio'] as num).toDouble() 
          : map['aspect_ratio'] is num 
          ? (map['aspect_ratio'] as num).toDouble()
          : null,
      linkedPostId: map['linked_post_id']?.toString() ?? map['linkedPostId']?.toString() ?? map['manifesto_id']?.toString(),
      postType:     map['post_type']?.toString() ?? map['postType']?.toString() ?? (map.containsKey('manifesto_id') ? 'comment' : 'post'),
      parentPostId: map['parent_post_id']?.toString() ?? map['parentPostId']?.toString(),
      linkDepth:    (map['link_depth'] as int?) ?? (map['linkDepth'] as int?) ?? 0,
      linkChain:    _parseStringList(map['link_chain'] ?? map['linkChain']),
      linkedAuthorUsername: map['linked_author_username']?.toString() ?? map['linkedAuthorUsername']?.toString(),
      linkedCaption: map['linked_caption']?.toString() ?? map['linkedCaption']?.toString(),
      linkedChannelId: map['linked_channel_id']?.toString() ?? map['linkedChannelId']?.toString(),
      authorIsOnline: map['is_online'] == true || map['is_online'] == 1,
      authorHasStatus: map['has_status'] == true || map['has_status'] == 1,
      isPublic: map['is_public'] is int ? (map['is_public'] as int) == 1 : map['is_public'] ?? true,
      allowComments: map['allow_comments'] is int ? (map['allow_comments'] as int) == 1 : map['allow_comments'] ?? true,
    );
  }

  static List<String> _parseStringList(dynamic input) {
    if (input == null) return [];
    if (input is List) return input.map((e) => e.toString()).toList();
    if (input is String && input.isNotEmpty) {
      try {
        final decoded = jsonDecode(input);
        if (decoded is List) return decoded.map((e) => e.toString()).toList();
      } catch (_) {}
    }
    return [];
  }

  @override
  List<Object?> get props => [
    ...super.props,
    channelId,
    caption,
    videoUrl,
    videoUrls,
    audioUrl,
    sdVideoUrl,
    imageUrls,
    thumbnailUrls,
    isVideo,
    isAudio,
    isLiked,
    likes,
    comments,
    shares,
    timeAgo,
    isPending,
    localFileCache,
    linkedPostId,
    postType,
    linkDepth,
    linkChain,
    authorIsOnline,
    authorHasStatus,
    isPublic,
    allowComments,
  ];
}
