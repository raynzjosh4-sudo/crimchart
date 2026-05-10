import 'package:injectable/injectable.dart';
import '../../../../core/db/chart_native_db.dart';
import '../../domain/entities/user_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Elite Native Auth Source that stores user sessions in the C++ SQLite engine.
@injectable
class AuthLocalSource {
  AuthLocalSource();

  final _dbProvider = ChartNativeDB.instance;
  final _storage = const FlutterSecureStorage();

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
    await _storage.write(key: 'active_user_id', value: user.id);
    print("Native Auth: User '${user.username}' session saved to C++ DB.");
  }

  /// Retrieves the current user profile from the native engine.
  Future<UserEntity?> getUser() async {
    final activeId = await _storage.read(key: 'active_user_id');
    if (activeId == null) return null;

    final db = _dbProvider.db;
    final row = await (db.select(
      db.users,
    )..where((t) => t.id.equals(activeId))).getSingleOrNull();

    if (row == null) return null;

    return UserEntity(
      id: row.id,
      username: row.username ?? '',
      displayName: row.displayName ?? '',
      profileImageUrl: row.profileImageUrl,
      bio: row.bio,
      ChartTitle: row.chartTitle,
      birthday: row.birthday != null ? DateTime.parse(row.birthday!) : null,
      gender: row.gender,
      isVerified: (row.isVerified ?? 0) == 1,
      followersCount: row.followersCount ?? 0,
      followingCount: row.followingCount ?? 0,
      postsCount: row.postsCount ?? 0,
      ChartsCount: row.chartsCount ?? 0,
      channelsCount: row.channelsCount ?? 0,
      createdAt: row.createdAt != null
          ? DateTime.parse(row.createdAt!)
          : DateTime.now(),
    );
  }

  /// Extracts the cached auth tokens from the DB.
  Future<Map<String, String?>?> getTokens() async {
    final activeId = await _storage.read(key: 'active_user_id');
    if (activeId == null) return null;

    final db = _dbProvider.db;
    final row = await (db.select(
      db.users,
    )..where((t) => t.id.equals(activeId))).getSingleOrNull();
    if (row == null) return null;

    return {'access': row.accessToken, 'refresh': row.refreshToken};
  }

  /// Wipes all native sessions (Logout).
  Future<void> clearAll() async {
    await _storage.delete(key: 'active_user_id');
    // Intentionally NOT deleting from _dbProvider.users
    // so the Account Selector can still show the saved accounts!
  }
}
