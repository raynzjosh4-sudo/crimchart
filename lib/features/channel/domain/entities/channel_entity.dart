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
  final DateTime createdAt;

  final String? leaderAvatarUrl;
  final String? age_restriction;
  final int? members_other_channels;
  final int? members_following;
  final String? join_method;
  final int? prevent_leaving;
  final String? country_restrictions;
  final String? allow_commenting_by;

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
    this.isCharted = false,
    this.isPrivate = false,
    this.leaderAvatarUrl,
    this.age_restriction,
    this.members_other_channels,
    this.members_following,
    this.join_method,
    this.prevent_leaving,
    this.country_restrictions,
    this.allow_commenting_by,
  });

  factory ChannelEntity.fromJson(Map<String, dynamic> json) {
    return ChannelEntity(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown User', 
      description: json['description']?.toString() ?? '',
      avatarUrl: _correctImageUrl(json['avatar_url']?.toString() ?? ''), 
      creatorId: json['creator_id']?.toString() ?? '',
      creatorAvatarUrl: json['creator_profile']?['profile_image_url'] ?? json['creator_profile']?['profileImageUrl'],
      memberCount: _toInt(json['member_count'] ?? json['members_count'] ?? json['memberCount'] ?? 0),
      unreadCount: _toInt(json['unread_count'] ?? json['unreadCount'] ?? 0), // ✅ NEW mapping from snake_case
      isPrivate: json['is_private'] == true || json['isPrivate'] == 1,
      leaderAvatarUrl: json['leader_avatar_url']?.toString(),
      age_restriction: json['age_restriction']?.toString(),
      members_other_channels: _toInt(json['members_other_channels']),
      members_following: _toInt(json['members_following']),
      join_method: json['join_method']?.toString(),
      prevent_leaving: _toInt(json['prevent_leaving']),
      country_restrictions: json['country_restrictions']?.toString(),
      allow_commenting_by: json['allow_commenting_by']?.toString(),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
    );
  }
  
  static String _correctImageUrl(String url) {
    if (url.isEmpty) return url;
    var fixed = url;

    // 👑 REBRAND: channel-profiles was the old folder, channel_avatars is working!
    fixed = fixed.replaceFirst('/channel-profiles/', '/channel_avatars/');

    // Ensure /users/ prefix exists
    if (fixed.contains('crown.nexassearch.com/') && !fixed.contains('crown.nexassearch.com/users/')) {
       fixed = fixed.replaceFirst('crown.nexassearch.com/', 'crown.nexassearch.com/users/');
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
      isCharted: (json['isCharted'] == 1),
      isPrivate: (json['isPrivate'] == 1),
      leaderAvatarUrl: json['leaderAvatarUrl']?.toString(),
      age_restriction: json['age_restriction']?.toString(),
      members_other_channels: _toInt(json['members_other_channels']),
      members_following: _toInt(json['members_following'] ?? 1),
      join_method: json['join_method']?.toString(),
      prevent_leaving: _toInt(json['prevent_leaving']),
      country_restrictions: json['country_restrictions']?.toString(),
      allow_commenting_by: json['allow_commenting_by']?.toString(),
      createdAt: _toDate(json['createdAt']),
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
    id, name, description, avatarUrl, memberCount, unreadCount, isCharted, 
    creatorId, leaderAvatarUrl, creatorAvatarUrl, age_restriction, 
    members_other_channels, members_following, join_method, 
    prevent_leaving, country_restrictions, allow_commenting_by
  ];
}
