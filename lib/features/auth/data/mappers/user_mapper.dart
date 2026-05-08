import 'package:crimchart/features/auth/domain/entities/auth_params.dart';
import 'package:crimchart/features/auth/domain/entities/user_entity.dart';

class UserMapper {
  const UserMapper._();

  static UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      profileImageUrl: json['profile_image_url']?.toString(),
      bio: json['bio']?.toString(),
      ChartTitle: json['Chart_title']?.toString() ?? json['title']?.toString(),
      isVerified: json['is_verified'] as bool? ?? false,
      followersCount: json['followers_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      postsCount: json['posts_count'] as int? ?? 0,
      ChartsCount: json['Charts_count'] as int? ?? 0,
      channelsCount: json['channels_count'] as int? ?? 0,
      isOnline: json['is_online'] as bool? ?? false,
      hasStatus: json['has_status'] as bool? ?? false,
      statusImageUrl: json['status_image_url']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static AuthTokens tokensFromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'].toString()) ??
                DateTime.now().add(const Duration(hours: 1))
          : DateTime.now().add(const Duration(hours: 1)),
    );
  }

  static Map<String, dynamic> signUpToJson(SignUpParams params) {
    return {
      'country_code': params.countryCode,
      'country_name': params.countryName,
      'phone_number': params.phoneNumber,
      'password': params.password,
      'username': params.username,
      'display_name': params.displayName,
      if (params.birthday != null)
        'birthday': params.birthday!.toIso8601String(),
      if (params.gender != null) 'gender': params.gender,
      if (params.ChartTitle != null) 'Chart_title': params.ChartTitle,
    };
  }
}











