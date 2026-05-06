import 'package:injectable/injectable.dart';
import '../../../../core/db/chart_native_db.dart';
import '../../domain/entities/user_entity.dart';

/// Elite Native Auth Source that stores user sessions in the C++ SQLite engine.
@injectable
class AuthLocalSource {
  AuthLocalSource();

  final _dbProvider = ChartNativeDB.instance;

  /// Saves the authenticated user and their tokens to the Native C++ DB.
  Future<void> saveUser(
    UserEntity user, {
    String? accessToken,
    String? refreshToken,
  }) async {
    await _dbProvider.saveUser({
      'id': user.id,
      'username': user.username,
      'displayName': user.displayName,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
      'ChartTitle': user.ChartTitle,
      'birthday': user.birthday?.toIso8601String(),
      'gender': user.gender,
      'isVerified': user.isVerified ? 1 : 0,
      'followersCount': user.followersCount,
      'followingCount': user.followingCount,
      'postsCount': user.postsCount,
      'ChartsCount': user.ChartsCount,
      'channelsCount': user.channelsCount,
      'createdAt': user.createdAt.toIso8601String(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
    print("Native Auth: User '${user.username}' session saved to C++ DB.");
  }

  /// Retrieves the current user profile from the native engine.
  Future<UserEntity?> getUser() async {
    final row = await _dbProvider.getUser();

    if (row == null) return null;

    return UserEntity(
      id: row['id'] as String,
      username: row['username'] as String,
      displayName: row['displayName'] as String,
      profileImageUrl: row['profileImageUrl'] as String?,
      bio: row['bio'] as String?,
      ChartTitle: row['ChartTitle'] as String?,
      birthday: row['birthday'] != null
          ? DateTime.parse(row['birthday'] as String)
          : null,
      gender: row['gender'] as String?,
      isVerified: ((row['isVerified'] as int?) ?? 0) == 1,
      followersCount: (row['followersCount'] as int?) ?? 0,
      followingCount: (row['followingCount'] as int?) ?? 0,
      postsCount: (row['postsCount'] as int?) ?? 0,
      ChartsCount: (row['ChartsCount'] as int?) ?? 0,
      channelsCount: (row['channelsCount'] as int?) ?? 0,
      createdAt: DateTime.parse(row['createdAt'] as String),
    );
  }

  /// Extracts the cached auth tokens from the DB.
  Future<Map<String, String?>?> getTokens() async {
    final row = await _dbProvider.getUser();
    if (row == null) return null;
    return {
      'access': row['accessToken'] as String?,
      'refresh': row['refreshToken'] as String?,
    };
  }

  /// Wipes all native sessions (Logout).
  Future<void> clearAll() async {
    await _dbProvider.deleteUser();
  }
}
