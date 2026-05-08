import 'package:crimchart/profile/models/charter_model.dart';

import '../../../../features/widgets/channelmemberdata/comment_card/thumbnaillink/thumbnaillinkmedia/thumbnail_media_type.dart';

class QuotedPost {
  final String id;
  final String username;
  final String text;
  final String? mediaUrl;
  final String? channelId;
  final String? channelName;

  const QuotedPost({
    required this.id,
    required this.username,
    required this.text,
    this.mediaUrl,
    this.channelId,
    this.channelName,
  });
}

class ChannelPostModel {
  final String id;
  final String username;
  final String userProfileImageUrl;
  final String channelName;
  final String channelId;
  final List<String> imageUrls;
  final String caption;
  final String? videoUrl;
  final bool isVideo;
  final String? audioUrl;
  final bool isAudio;
  final String? gifUrl;
  final bool isGif;
  final bool isText;
  final String? thumbnailLinkUrl;
  final ThumbnailMediaType thumbnailLinkType;
  final QuotedPost? quotedPost; // ✅ THE WHATSAPP-STYLE LINK PASSPORT
  final String? referenceId;
  final String? referenceChannelId;
  final List<CharterModel> referenceContestants;
  final int likes;
  final int comments;
  final String timeAgo;
  final bool isLiked;
  final bool isSponsored; // ✅ Support for 'Sponsored' label
  final List<CharterModel> chartedContestants;
  final int chartedCount;
  final double? aspectRatio;
  final bool hasStatus;
  final bool isActive;
  final int isPending;
  final String localFileCache;

  const ChannelPostModel({
    required this.id,
    required this.username,
    required this.userProfileImageUrl,
    required this.channelName,
    required this.channelId,
    required this.imageUrls,
    required this.caption,
    this.videoUrl,
    this.isVideo = false,
    this.audioUrl,
    this.isAudio = false,
    this.gifUrl,
    this.isGif = false,
    this.isText = false,
    this.thumbnailLinkUrl,
    this.thumbnailLinkType = ThumbnailMediaType.image,
    this.quotedPost,
    this.referenceId,
    this.referenceChannelId,
    this.referenceContestants = const [],
    required this.likes,
    required this.comments,
    required this.timeAgo,
    this.isLiked = false,
    this.isSponsored = false,
    this.chartedContestants = const [],
    this.chartedCount = 0,
    this.aspectRatio,
    this.hasStatus = false,
    this.isActive = false,
    this.isPending = 0,
    this.localFileCache = '',
  });
}











