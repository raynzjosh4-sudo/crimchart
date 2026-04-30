import 'package:equatable/equatable.dart';

/// Core User entity — pure Dart, no Flutter/Dio/Firebase imports.
/// This is the single source of truth for a user across every feature.
class UserEntity extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String? profileImageUrl;
  final String? bio;
  final String? ChartTitle;
  final DateTime? birthday;
  final String? gender;
  final bool isVerified;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int ChartsCount;
  final int channelsCount;
  final bool isOnline;        // 👑 Presence Tracking
  final bool hasStatus;       // 👑 Presence Tracking
  final String? statusImageUrl; // 👑 Status/Story Deep Link
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.username,
    required this.displayName,
    this.profileImageUrl,
    this.bio,
    this.ChartTitle,
    this.birthday,
    this.gender,
    this.isVerified = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.ChartsCount = 0,
    this.channelsCount = 0,
    this.isOnline = false,
    this.hasStatus = false,
    this.statusImageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    displayName,
    profileImageUrl,
    bio,
    ChartTitle,
    birthday,
    gender,
    isVerified,
    followersCount,
    followingCount,
    postsCount,
    ChartsCount,
    channelsCount,
    isOnline,
    hasStatus,
    statusImageUrl,
    createdAt,
  ];

  UserEntity copyWith({
    String? id,
    String? username,
    String? displayName,
    String? profileImageUrl,
    String? bio,
    String? ChartTitle,
    DateTime? birthday,
    String? gender,
    bool? isVerified,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    int? ChartsCount,
    int? channelsCount,
    bool? isOnline,
    bool? hasStatus,
    String? statusImageUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      ChartTitle: ChartTitle ?? this.ChartTitle,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      isVerified: isVerified ?? this.isVerified,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      ChartsCount: ChartsCount ?? this.ChartsCount,
      channelsCount: channelsCount ?? this.channelsCount,
      isOnline: isOnline ?? this.isOnline,
      hasStatus: hasStatus ?? this.hasStatus,
      statusImageUrl: statusImageUrl ?? this.statusImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}





























