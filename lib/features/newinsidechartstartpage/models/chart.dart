import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crimchart/profile/models/charter_model.dart';

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
  final int followersCount;
  final int tagsCount;
  final int likesCount;
  final int postsCount;
  final String? description;
  final DateTime createdAt;

  final String? age_restriction;
  final bool visibleToOtherChannelMembers;
  final bool visibleToFollowedUsers;
  final String joinMethod;
  final bool preventLeaving;
  final List<String> countryRestrictions;
  final String allowCommentingBy;
  final String allowStatusPostingBy;
  final String? allow_invitations_by;
  final String? creatorId;
  final bool isDiscoverable;

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
    this.followersCount = 0,
    this.tagsCount = 0,
    this.likesCount = 0,
    this.postsCount = 0,
    this.memberAvatarUrls = const [],
    this.staterName,
    this.staterAvatarUrl,
    this.leaderAvatarUrl,
    this.unreadCount = 0,
    this.description,
    DateTime? createdAt,
    this.age_restriction,
    this.visibleToOtherChannelMembers = false,
    this.visibleToFollowedUsers = true,
    this.joinMethod = 'invite',
    this.preventLeaving = false,
    this.countryRestrictions = const ['Global'],
    this.allowCommentingBy = 'all',
    this.allowStatusPostingBy = 'all',
    this.allow_invitations_by = 'all',
    this.isOwnChannel = false,
    this.isCharted = false,
    this.giftsVisible = true,
    this.isPrivate = false,
    this.isActive = true,
    this.isDiscoverable = true,
    this.subChannels = const [],
    this.posts = const [],
    this.contestants = const [],
    this.creatorId,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 👑 Mapper from Domain Entity
  factory Chart.fromEntity(dynamic entity) {
    return Chart(
      id: entity.id,
      title: entity.name,
      imageUrl: entity.avatarUrl,
      memberCount: entity.memberCount ?? 0,
      followersCount: entity.followersCount ?? 0,
      tagsCount: entity.tagsCount ?? 0,
      likesCount: entity.likesCount ?? 0,
      postsCount: entity.postsCount ?? 0,
      description: entity.description,
      unreadCount: entity.unreadCount ?? 0,
      isCharted: entity.isCharted ?? false,
      isPrivate: entity.isPrivate ?? false,
      leaderAvatarUrl: entity.leaderAvatarUrl,
      staterAvatarUrl: entity.creatorAvatarUrl,
      createdAt: entity.createdAt,
      age_restriction: entity.age_restriction,
      visibleToOtherChannelMembers: entity.visible_to_other_channel_members == 1,
      visibleToFollowedUsers: entity.visible_to_followed_users == 1,
      joinMethod: entity.join_method ?? 'invite',
      preventLeaving: entity.prevent_leaving == 1,
      countryRestrictions: entity.country_restrictions != null 
          ? [entity.country_restrictions!] 
          : ['Global'],
      allowCommentingBy: entity.allow_commenting_by ?? 'all',
      allowStatusPostingBy: entity.allow_status_posting_by ?? 'all',
      allow_invitations_by: entity.allow_invitations_by ?? 'all',
      isDiscoverable: entity.is_discoverable != 0,
      staterName: entity.creatorName,
      creatorId: entity.creatorId,
      isOwnChannel: entity.creatorId == Supabase.instance.client.auth.currentUser?.id,
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
    int? followersCount,
    int? tagsCount,
    int? likesCount,
    int? postsCount,
    bool? isDiscoverable,
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
    bool? visibleToOtherChannelMembers,
    bool? visibleToFollowedUsers,
    String? joinMethod,
    bool? preventLeaving,
    List<String>? countryRestrictions,
    String? allowCommentingBy,
    String? allowStatusPostingBy,
    String? allow_invitations_by,
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
      followersCount: followersCount ?? this.followersCount,
      tagsCount: tagsCount ?? this.tagsCount,
      likesCount: likesCount ?? this.likesCount,
      postsCount: postsCount ?? this.postsCount,
      description: description ?? this.description,
      isOwnChannel: isOwnChannel ?? this.isOwnChannel,
      isCharted: isCharted ?? this.isCharted,
      giftsVisible: giftsVisible ?? this.giftsVisible,
      isPrivate: isPrivate ?? this.isPrivate,
      isActive: isActive ?? this.isActive,
      isDiscoverable: isDiscoverable ?? this.isDiscoverable,
      subChannels: subChannels ?? this.subChannels,
      posts: posts ?? this.posts,
      contestants: contestants ?? this.contestants,
      createdAt: createdAt ?? this.createdAt,
      age_restriction: age_restriction ?? this.age_restriction,
      visibleToOtherChannelMembers: visibleToOtherChannelMembers ?? this.visibleToOtherChannelMembers,
      visibleToFollowedUsers: visibleToFollowedUsers ?? this.visibleToFollowedUsers,
      joinMethod: joinMethod ?? this.joinMethod,
      preventLeaving: preventLeaving ?? this.preventLeaving,
      countryRestrictions: countryRestrictions ?? this.countryRestrictions,
      allowCommentingBy: allowCommentingBy ?? this.allowCommentingBy,
      allowStatusPostingBy: allowStatusPostingBy ?? this.allowStatusPostingBy,
      allow_invitations_by: allow_invitations_by ?? this.allow_invitations_by,
    );
  }
}
