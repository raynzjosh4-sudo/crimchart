import 'package:injectable/injectable.dart';
import '../../../../core/db/chart_native_db.dart';
import '../../domain/entities/user_entity.dart';
import 'package:sqflite/sqflite.dart';

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
    final db = await _dbProvider.database;
    await db.insert('users', {
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
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    print("Native Auth: User '${user.username}' session saved to C++ DB.");
  }

  /// Retrieves the current user profile from the native engine.
  Future<UserEntity?> getUser() async {
    final db = await _dbProvider.database;
    final res = await db.query('users', limit: 1);

    if (res.isEmpty) return null;
    final row = res.first;

    return UserEntity(
      id: row['id'] as String,
      username: row['username'] as String,
      displayName: row['displayName'] as String,
      profileImageUrl: row['profileImageUrl'] as String?,
      bio: row['bio'] as String?,
      ChartTitle: row['ChartTitle'] as String?,
      birthday: row['birthday'] != null ? DateTime.parse(row['birthday'] as String) : null,
      gender: row['gender'] as String?,
      isVerified: (row['isVerified'] as int) == 1,
      followersCount: row['followersCount'] as int,
      followingCount: row['followingCount'] as int,
      postsCount: row['postsCount'] as int,
      ChartsCount: (row['ChartsCount'] as int?) ?? 0,
      channelsCount: (row['channelsCount'] as int?) ?? 0,
      createdAt: DateTime.parse(row['createdAt'] as String),
    );
  }

  /// Extracts the cached auth tokens from the DB.
  Future<Map<String, String?>?> getTokens() async {
    final db = await _dbProvider.database;
    final res = await db.query(
      'users',
      columns: ['accessToken', 'refreshToken'],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return {
      'access': res.first['accessToken'] as String?,
      'refresh': res.first['refreshToken'] as String?,
    };
  }

  /// Wipes all native sessions (Logout).
  Future<void> clearAll() async {
    final db = await _dbProvider.database;
    await db.delete('users');
  }
}





























