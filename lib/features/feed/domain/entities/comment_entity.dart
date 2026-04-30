import '../../../../core/models/content_entity.dart';

/// Comment domain entity — represents a comment on any content.
/// Extends ContentEntity for ThumbnailLink integration.
class CommentEntity extends ContentEntity {
  final String text;
  final List<String> imageUrls;
  final String? videoUrl;
  final bool isVideo;

  final int likes;
  final bool isLiked;
  final int repliesCount;
  final List<CommentEntity> replies;

  final String? parentCommentId; // For nested replies

  const CommentEntity({
    required super.id,
    required super.authorId,
    required super.authorUsername,
    required super.authorDisplayName,
    super.authorAvatarUrl,
    required super.createdAt,
    required super.thumbnailLink,
    required this.text,
    this.imageUrls = const [],
    this.videoUrl,
    this.isVideo = false,
    this.likes = 0,
    this.isLiked = false,
    this.repliesCount = 0,
    this.replies = const [],
    this.parentCommentId,
  });

  /// Creates an original comment (directly on content)
  factory CommentEntity.original({
    required String id,
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    String? authorAvatarUrl,
    required DateTime createdAt,
    required ThumbnailLink contentLink, // Link to the content being commented on
    required String text,
    List<String> imageUrls = const [],
    String? videoUrl,
    bool isVideo = false,
  }) {
    final thumbnailLink = ThumbnailLink.fromParent(
      newContentId: id,
      parentLink: contentLink,
    );

    return CommentEntity(
      id: id,
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: createdAt,
      thumbnailLink: thumbnailLink,
      text: text,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      isVideo: isVideo,
    );
  }

  /// Creates a reply to another comment
  factory CommentEntity.reply({
    required String id,
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    String? authorAvatarUrl,
    required DateTime createdAt,
    required ThumbnailLink parentCommentLink, // Link to the parent comment
    required String text,
    required String parentCommentId,
    List<String> imageUrls = const [],
    String? videoUrl,
    bool isVideo = false,
  }) {
    final thumbnailLink = ThumbnailLink.fromParent(
      newContentId: id,
      parentLink: parentCommentLink,
    );

    return CommentEntity(
      id: id,
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: createdAt,
      thumbnailLink: thumbnailLink,
      text: text,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      isVideo: isVideo,
      parentCommentId: parentCommentId,
    );
  }

  CommentEntity copyWith({
    bool? isLiked,
    int? likes,
    int? repliesCount,
    List<CommentEntity>? replies,
  }) {
    return CommentEntity(
      id: id,
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: createdAt,
      thumbnailLink: thumbnailLink,
      text: text,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      isVideo: isVideo,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      repliesCount: repliesCount ?? this.repliesCount,
      replies: replies ?? this.replies,
      parentCommentId: parentCommentId,
    );
  }

  /// Checks if this is a reply to another comment
  bool get isReply => parentCommentId != null;

  /// Gets the root content ID (original post/video/etc)
  String get rootContentId => thumbnailLink.originalContentId;

  @override
  List<Object?> get props => [
    ...super.props,
    text, imageUrls, videoUrl, isVideo,
    likes, isLiked, repliesCount, parentCommentId,
  ];
}




























