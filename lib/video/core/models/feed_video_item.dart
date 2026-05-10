import 'package:crimchart/features/channel/domain/entities/channel_moment_entity.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';

class FeedVideoItem {
  final String id;
  final String videoUrl;
  final String title;
  final String description;
  final String authorName;
  final String? authorAvatarUrl;
  final String? authorId;
  final String? channelId;
  final bool isChannelPost;
  final String? thumbnailUrl;
  final double? aspectRatio;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final int tagsCount;
  final List<String> linkChain;

  FeedVideoItem({
    required this.id,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.authorName,
    this.authorAvatarUrl,
    this.authorId,
    this.channelId,
    required this.isChannelPost,
    this.thumbnailUrl,
    this.aspectRatio,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.tagsCount = 0,
    this.linkChain = const [],
  });

  factory FeedVideoItem.fromChannelMoment(
    ChannelMomentEntity moment,
    String channelName,
  ) {
    return FeedVideoItem(
      id: moment.id,
      videoUrl: moment.mediaUrl,
      title: channelName,
      description: moment.caption ?? 'Channel Moment',
      authorName: moment.authorName ?? 'User',
      authorAvatarUrl: moment.authorAvatarUrl,
      authorId: moment.authorId,
      channelId: moment.channelId,
      isChannelPost: true,
      thumbnailUrl: moment.thumbnailUrl,
      aspectRatio: null,
      likesCount: 0, // Moments don't currently store likes in the entity
      commentsCount: 0,
      sharesCount: 0,
      isLiked: false,
    );
  }

  factory FeedVideoItem.fromPostEntity(PostEntity post) {
    return FeedVideoItem(
      id: post.id,
      videoUrl:
          post.videoUrl ??
          (post.videoUrls.isNotEmpty ? post.videoUrls.first : ''),
      title: post.channelName,
      description: post.caption,
      authorName: post.authorUsername,
      authorAvatarUrl: post.authorAvatarUrl,
      authorId: post.authorId,
      channelId: post.channelId,
      isChannelPost: post.channelId != 'unknown' && post.channelId.isNotEmpty,
      thumbnailUrl: post.thumbnailUrls.isNotEmpty
          ? post.thumbnailUrls.first
          : (post.imageUrls.isNotEmpty ? post.imageUrls.first : null),
      aspectRatio: post.aspectRatio,
      likesCount: post.likes,
      commentsCount: post.comments,
      sharesCount: post.shares,
      isLiked: post.isLiked,
      tagsCount: post.tagsCount,
      linkChain: post.linkChain,
    );
  }
}
