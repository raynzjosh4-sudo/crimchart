import 'package:equatable/equatable.dart';

/// Represents a link to the original source of content.
/// Maintains the complete chain of content lineage.
class ThumbnailLink extends Equatable {
  /// The original content that started this chain
  final String originalContentId;
  final String originalAuthorId;
  final String originalAuthorUsername;
  final String? originalContentType; // 'post', 'comment', 'message'

  /// The complete chain of content IDs leading back to the original
  final List<String> linkChain;

  /// How many levels deep this content is from the original
  final int linkDepth;

  /// The immediate parent content ID (what this content is responding to)
  final String? parentContentId;

  /// When this link was created (for ordering)
  final DateTime createdAt;

  const ThumbnailLink({
    required this.originalContentId,
    required this.originalAuthorId,
    required this.originalAuthorUsername,
    this.originalContentType,
    required this.linkChain,
    required this.linkDepth,
    this.parentContentId,
    required this.createdAt,
  });

  /// Creates a new ThumbnailLink for original content
  factory ThumbnailLink.original({
    required String contentId,
    required String authorId,
    required String authorUsername,
    String? contentType,
  }) {
    return ThumbnailLink(
      originalContentId: contentId,
      originalAuthorId: authorId,
      originalAuthorUsername: authorUsername,
      originalContentType: contentType,
      linkChain: [contentId],
      linkDepth: 0,
      parentContentId: null,
      createdAt: DateTime.now(),
    );
  }

  /// Creates a ThumbnailLink for content that references another piece of content
  factory ThumbnailLink.fromParent({
    required String newContentId,
    required ThumbnailLink parentLink,
  }) {
    return ThumbnailLink(
      originalContentId: parentLink.originalContentId,
      originalAuthorId: parentLink.originalAuthorId,
      originalAuthorUsername: parentLink.originalAuthorUsername,
      originalContentType: parentLink.originalContentType,
      linkChain: [...parentLink.linkChain, newContentId],
      linkDepth: parentLink.linkDepth + 1,
      parentContentId: parentLink.linkChain.isNotEmpty
          ? parentLink.linkChain.last
          : null,
      createdAt: DateTime.now(),
    );
  }

  /// Gets the immediate parent content ID
  String? get parentId => linkChain.length > 1 ? linkChain[linkChain.length - 2] : null;

  /// Checks if this is the original content
  bool get isOriginal => linkDepth == 0;

  /// Gets a display string showing the link depth
  String get depthDisplay => linkDepth == 0 ? 'Original' : 'Linked (${linkDepth}x)';

  @override
  List<Object?> get props => [originalContentId, linkChain, linkDepth, createdAt];
}

/// Base class for all content in the app.
/// Provides common fields and ThumbnailLink integration.
abstract class ContentEntity extends Equatable {
  final String id;
  final String authorId;
  final String authorUsername;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final DateTime createdAt;
  final ThumbnailLink thumbnailLink;

  const ContentEntity({
    required this.id,
    required this.authorId,
    required this.authorUsername,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.createdAt,
    required this.thumbnailLink,
  });

  @override
  List<Object?> get props => [id, authorId, createdAt, thumbnailLink];
}




























