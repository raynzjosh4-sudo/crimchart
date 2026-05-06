import 'package:equatable/equatable.dart';

class ChannelEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String avatarUrl;
  final String creatorId;
  final String? creatorAvatarUrl;
  final int memberCount;
  final bool isCharted;
  final bool isPrivate;
  final int unreadCount; // ✅ NEW: Track new messages/data
  final int followersCount;
  final int tagsCount;
  final int likesCount;
  final int postsCount;
  final DateTime createdAt;
  final String? creatorName;
  final int is_discoverable;

  final String? leaderAvatarUrl;
  final String? age_restriction;
  final int? visible_to_other_channel_members;
  final int? visible_to_followed_users;
  final String? join_method;
  final int? prevent_leaving;
  final String? country_restrictions;
  final String? allow_commenting_by;
  final String? allow_status_posting_by;
  final String? allow_invitations_by;

  const ChannelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.creatorId,
    required this.createdAt,
    this.creatorAvatarUrl,
    this.memberCount = 0,
    this.unreadCount = 0, // ✅ NEW
    this.followersCount = 0,
    this.tagsCount = 0,
    this.likesCount = 0,
    this.postsCount = 0,
    this.is_discoverable = 1,
    this.isCharted = false,
    this.isPrivate = false,
    this.leaderAvatarUrl,
    this.age_restriction,
    this.visible_to_other_channel_members,
    this.visible_to_followed_users,
    this.join_method,
    this.prevent_leaving,
    this.country_restrictions,
    this.allow_commenting_by,
    // ignore: non_constant_identifier_names
    this.allow_status_posting_by,
    // ignore: non_constant_identifier_names
    this.allow_invitations_by,
    this.creatorName,
  });

  factory ChannelEntity.fromJson(Map<String, dynamic> json) {
    return ChannelEntity(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown User',
      description: json['description']?.toString() ?? '',
      avatarUrl: _correctImageUrl(json['avatar_url']?.toString() ?? ''),
      creatorId: json['creator_id']?.toString() ?? '',
      creatorAvatarUrl: _correctImageUrl(
        json['creator_profile']?['profile_image_url']?.toString() ??
            json['creator_profile']?['profileImageUrl']?.toString() ??
            '',
      ),
      memberCount: _toInt(
        json['member_count'] ??
            json['members_count'] ??
            json['memberCount'] ??
            0,
      ),
      unreadCount: _toInt(
        json['unread_count'] ?? json['unreadCount'] ?? 0,
      ), // ✅ NEW mapping from snake_case
      followersCount: _toInt(
        json['followers_count'] ?? json['followersCount'] ?? 0,
      ),
      tagsCount: _toInt(json['tags_count'] ?? json['tagsCount'] ?? 0),
      likesCount: _toInt(json['likes_count'] ?? json['likesCount'] ?? 0),
      postsCount: _toInt(json['posts_count'] ?? json['postsCount'] ?? 0),
      is_discoverable: _toInt(json['is_discoverable'] ?? 1),
      isCharted: json['is_charted'] == true || json['isCharted'] == 1,
      isPrivate: json['is_private'] == true || json['isPrivate'] == 1,
      leaderAvatarUrl: json['leader_avatar_url']?.toString(),
      age_restriction: json['age_restriction']?.toString(),
      visible_to_other_channel_members: _toInt(
        json['visible_to_other_channel_members'],
      ),
      visible_to_followed_users: _toInt(json['visible_to_followed_users']),
      join_method: json['join_method']?.toString(),
      prevent_leaving: _toInt(json['prevent_leaving']),
      country_restrictions: json['country_restrictions']?.toString(),
      allow_commenting_by: json['allow_commenting_by']?.toString(),
      allow_status_posting_by: json['allow_status_posting_by']?.toString(),
      allow_invitations_by: json['allow_invitations_by']?.toString(),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      creatorName: json['creator_profile'] != null
          ? (json['creator_profile']['display_name'] ??
                json['creator_profile']['username'])
          : null,
    );
  }

  static String _correctImageUrl(String url) {
    if (url.isEmpty) return url;
    var fixed = url;

    // 👑 REBRAND: channel-profiles was the old folder, channel_avatars is working!
    fixed = fixed.replaceFirst('/channel-profiles/', '/channel_avatars/');

    // Ensure /users/ prefix exists
    if (fixed.contains('crown.nexassearch.com/') &&
        !fixed.contains('crown.nexassearch.com/users/')) {
      fixed = fixed.replaceFirst(
        'crown.nexassearch.com/',
        'crown.nexassearch.com/users/',
      );
    }
    return fixed;
  }

  factory ChannelEntity.fromLocalCache(Map<String, dynamic> json) {
    return ChannelEntity(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Channel',
      description: json['description']?.toString() ?? '',
      avatarUrl: _correctImageUrl(json['avatarUrl']?.toString() ?? ''),
      creatorId: json['creator_id']?.toString() ?? '',
      creatorAvatarUrl: json['creatorAvatarUrl']?.toString(),
      memberCount: _toInt(json['memberCount'] ?? 0),
      unreadCount: _toInt(json['unreadCount'] ?? 0),
      followersCount: _toInt(
        json['followersCount'] ?? json['followers_count'] ?? 0,
      ),
      tagsCount: _toInt(json['tagsCount'] ?? json['tags_count'] ?? 0),
      likesCount: _toInt(json['likesCount'] ?? json['likes_count'] ?? 0),
      postsCount: _toInt(json['postsCount'] ?? json['posts_count'] ?? 0),
      is_discoverable: _toInt(json['isDiscoverable'] ?? json['is_discoverable'] ?? 1),
      isCharted: (json['isCharted'] == 1),
      isPrivate: (json['isPrivate'] == 1),
      leaderAvatarUrl: json['leaderAvatarUrl']?.toString(),
      age_restriction:
          json['ageRestriction']?.toString() ??
          json['age_restriction']?.toString(),
      visible_to_other_channel_members: _toInt(
        json['visibleToOtherChannelMembers'],
      ),
      visible_to_followed_users: _toInt(json['visibleToFollowedUsers'] ?? 1),
      join_method:
          json['joinMethod']?.toString() ?? json['join_method']?.toString(),
      prevent_leaving: _toInt(
        json['preventLeaving'] ?? json['prevent_leaving'],
      ),
      country_restrictions:
          json['countryRestrictions']?.toString() ??
          json['country_restrictions']?.toString(),
      allow_commenting_by:
          json['allowCommentingBy']?.toString() ??
          json['allow_commenting_by']?.toString(),
      allow_status_posting_by:
          json['allowStatusPostingBy']?.toString() ??
          json['allow_status_posting_by']?.toString(),
      allow_invitations_by:
          json['allowInvitationsBy']?.toString() ??
          json['allow_invitations_by']?.toString(),
      createdAt: _toDate(json['createdAt']),
      creatorName: json['creatorName']?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static DateTime _toDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    avatarUrl,
    memberCount,
    unreadCount,
    followersCount,
    tagsCount,
    likesCount,
    postsCount,
    is_discoverable,
    isCharted,
    creatorId,
    leaderAvatarUrl,
    creatorAvatarUrl,
    age_restriction,
    visible_to_other_channel_members,
    visible_to_followed_users,
    join_method,
    prevent_leaving,
    country_restrictions,
    allow_commenting_by,
    allow_status_posting_by,
    allow_invitations_by,
  ];
}
