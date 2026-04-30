import 'package:crown/profile/models/charter_model.dart';

import 'channel_post.dart';

class Chart {
  final String id;
  final String title;
  final String? imageUrl;
  final int memberCount;
  final List<String?> memberAvatarUrls;

  final String? staterName;
  final String? staterAvatarUrl;
  final String? leaderAvatarUrl;

  final int unreadCount;
  final String? description;
  final DateTime createdAt;

  final String? age_restriction;
  final bool membersOtherChannels;
  final bool membersFollowing;
  final String joinMethod;
  final bool preventLeaving;
  final List<String> countryRestrictions;
  final String allowCommentingBy;

  /// Whether the current logged-in user created (owns) this channel.
  final bool isOwnChannel;

  /// Controls whether gifts & points are visible to all members in this channel.
  final bool giftsVisible;

  final bool isPrivate;
  final bool isCharted;
  final bool isActive;

  final List<Chart> subChannels;
  final List<ChannelPost> posts;
  final List<CharterModel> contestants;

  Chart({
    required this.id,
    required this.title,
    this.imageUrl,
    this.memberCount = 0,
    this.memberAvatarUrls = const [],
    this.staterName,
    this.staterAvatarUrl,
    this.leaderAvatarUrl,
    this.unreadCount = 0, // ✅ NEW
    this.description,
    DateTime? createdAt,
    this.age_restriction,
    this.membersOtherChannels = false,
    this.membersFollowing = true,
    this.joinMethod = 'invite',
    this.preventLeaving = false,
    this.countryRestrictions = const ['Global'],
    this.allowCommentingBy = 'all',
    this.isOwnChannel = false,
    this.isCharted = false,
    this.giftsVisible = true,
    this.isPrivate = false,
    this.isActive = true,
    this.subChannels = const [],
    this.posts = const [],
    this.contestants = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  /// 👑 Mapper from Domain Entity
  factory Chart.fromEntity(dynamic entity) {
    return Chart(
      id: entity.id,
      title: entity.name,
      imageUrl: entity.avatarUrl,
      memberCount: entity.memberCount,
      description: entity.description,
      unreadCount: entity.unreadCount,
      isCharted: entity.isCharted,
      isPrivate: entity.isPrivate,
      leaderAvatarUrl: entity.leaderAvatarUrl,
      staterAvatarUrl: entity.creatorAvatarUrl,
      createdAt: entity.createdAt,
      age_restriction: entity.age_restriction,
      membersOtherChannels: entity.members_other_channels == 1,
      membersFollowing: entity.members_following == 1,
      joinMethod: entity.join_method ?? 'invite',
      preventLeaving: entity.prevent_leaving == 1,
      countryRestrictions: entity.country_restrictions != null 
          ? [entity.country_restrictions!] 
          : ['Global'],
      allowCommentingBy: entity.allow_commenting_by ?? 'all',
    );
  }

  Chart copyWith({
    String? id,
    String? title,
    String? imageUrl,
    int? memberCount,
    List<String?>? memberAvatarUrls,
    String? staterName,
    String? staterAvatarUrl,
    String? leaderAvatarUrl,
    int? unreadCount,
    String? description,
    bool? isOwnChannel,
    bool? isCharted,
    bool? giftsVisible,
    bool? isPrivate,
    bool? isActive,
    List<Chart>? subChannels,
    List<ChannelPost>? posts,
    List<CharterModel>? contestants,
    DateTime? createdAt,
    String? age_restriction,
    bool? membersOtherChannels,
    bool? membersFollowing,
    String? joinMethod,
    bool? preventLeaving,
    List<String>? countryRestrictions,
    String? allowCommentingBy,
  }) {
    return Chart(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      memberCount: memberCount ?? this.memberCount,
      memberAvatarUrls: memberAvatarUrls ?? this.memberAvatarUrls,
      staterName: staterName ?? this.staterName,
      staterAvatarUrl: staterAvatarUrl ?? this.staterAvatarUrl,
      leaderAvatarUrl: leaderAvatarUrl ?? this.leaderAvatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      description: description ?? this.description,
      isOwnChannel: isOwnChannel ?? this.isOwnChannel,
      isCharted: isCharted ?? this.isCharted,
      giftsVisible: giftsVisible ?? this.giftsVisible,
      isPrivate: isPrivate ?? this.isPrivate,
      isActive: isActive ?? this.isActive,
      subChannels: subChannels ?? this.subChannels,
      posts: posts ?? this.posts,
      contestants: contestants ?? this.contestants,
      createdAt: createdAt ?? this.createdAt,
      age_restriction: age_restriction ?? this.age_restriction,
      membersOtherChannels: membersOtherChannels ?? this.membersOtherChannels,
      membersFollowing: membersFollowing ?? this.membersFollowing,
      joinMethod: joinMethod ?? this.joinMethod,
      preventLeaving: preventLeaving ?? this.preventLeaving,
      countryRestrictions: countryRestrictions ?? this.countryRestrictions,
      allowCommentingBy: allowCommentingBy ?? this.allowCommentingBy,
    );
  }
}
