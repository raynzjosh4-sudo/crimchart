import 'dart:io';
import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

/// The high-performance C++ SQLite Database Engine for Chart.
/// Handles cross-platform persistence with zero UI lag via FFI.
@lazySingleton
class ChartNativeDB {
  static Database? _database;
  static final ChartNativeDB instance = ChartNativeDB._init();

  ChartNativeDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB('Chart_v2.db');
    return _database!;
  }

  Future<Database> _initializeDB(String filePath) async {
    // 1. Setup C++ FFI for SQLite (Desktop-Specific)
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // 2. Locate / Create Database File
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    print("Native Engine: Opening DB at $path");

    return await openDatabase(
      path,
      version: 22, // 👑 BUMP TO 22
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE users ADD COLUMN ChartsCount INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE users ADD COLUMN channelsCount INTEGER DEFAULT 0',
      );
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE users ADD COLUMN ChartTitle TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN birthday TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN gender TEXT');
    }
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE posts ADD COLUMN imageUrls TEXT DEFAULT "[]"',
      );
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE posts ADD COLUMN createdAt TEXT');
    }
    if (oldVersion < 6) {
      await db.execute('ALTER TABLE posts ADD COLUMN shares INTEGER DEFAULT 0');
    }
    if (oldVersion < 7) {
      await db.execute(
        'ALTER TABLE posts ADD COLUMN isPending INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN isPending INTEGER DEFAULT 0',
      );
      await db.execute('ALTER TABLE channel_cache ADD COLUMN avatarUrl TEXT');
    }
    if (oldVersion < 8) {
      await db.execute('ALTER TABLE posts ADD COLUMN sdVideoUrl TEXT');
    }
    if (oldVersion < 9) {
      await db.execute('ALTER TABLE posts ADD COLUMN author_id TEXT');
    }
    if (oldVersion < 10) {
      await db.execute('ALTER TABLE posts ADD COLUMN audioUrl TEXT');
      await db.execute(
        'ALTER TABLE posts ADD COLUMN isAudio INTEGER DEFAULT 0',
      );
    }
    if (oldVersion < 11) {
      await db.execute(
        'ALTER TABLE posts ADD COLUMN folder_name TEXT DEFAULT "public_posts"',
      );
    }
    if (oldVersion < 12) {
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN unreadCount INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN leaderAvatarUrl TEXT',
      );
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN creatorAvatarUrl TEXT',
      );
    }
    if (oldVersion < 13) {
      await db.execute(
        'ALTER TABLE posts ADD COLUMN post_type TEXT DEFAULT "post"',
      );
      await db.execute('ALTER TABLE posts ADD COLUMN parent_post_id TEXT');
      await db.execute('ALTER TABLE posts ADD COLUMN linked_post_id TEXT');
      await db.execute(
        'ALTER TABLE posts ADD COLUMN link_chain TEXT DEFAULT "[]"',
      );
      await db.execute(
        'ALTER TABLE posts ADD COLUMN link_depth INTEGER DEFAULT 0',
      );
    }
    if (oldVersion < 14) {
      await db.execute(
        'ALTER TABLE posts ADD COLUMN thumbnailUrls TEXT DEFAULT "[]"',
      );
    }
    if (oldVersion < 15) {
      await db.execute(
        'ALTER TABLE posts ADD COLUMN linked_author_username TEXT',
      );
      await db.execute('ALTER TABLE posts ADD COLUMN linked_caption TEXT');
    }
    if (oldVersion < 16) {
      await db.execute('ALTER TABLE posts ADD COLUMN linked_channel_id TEXT');
    }
    if (oldVersion < 17) {
      await db.execute('ALTER TABLE channel_cache ADD COLUMN creator_id TEXT');
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN isPrivate INTEGER DEFAULT 0',
      );
      await db.execute(
        "ALTER TABLE channel_cache ADD COLUMN age_restriction TEXT DEFAULT 'All Ages'",
      );
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN members_other_channels INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN members_following INTEGER DEFAULT 1',
      );
      await db.execute(
        "ALTER TABLE channel_cache ADD COLUMN join_method TEXT DEFAULT 'invite'",
      );
      await db.execute(
        'ALTER TABLE channel_cache ADD COLUMN prevent_leaving INTEGER DEFAULT 0',
      );
      await db.execute(
        "ALTER TABLE channel_cache ADD COLUMN country_restrictions TEXT DEFAULT  '[\"Global\"]'",
      );
      await db.execute(
        "ALTER TABLE channel_cache ADD COLUMN allow_commenting_by TEXT DEFAULT 'all'",
      );
      await db.execute('ALTER TABLE channel_cache ADD COLUMN createdAt TEXT');
    }
    if (oldVersion < 18) {
      await db.execute(
        'ALTER TABLE manifestos ADD COLUMN is_public INTEGER DEFAULT 1',
      );
      await db.execute(
        'ALTER TABLE manifestos ADD COLUMN allow_comments INTEGER DEFAULT 1',
      );
    }
    if (oldVersion < 19) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS manifesto_comments (
          id TEXT PRIMARY KEY,
          author_id TEXT NOT NULL,
          channel_id TEXT NOT NULL,
          manifesto_id TEXT NOT NULL,
          message TEXT,
          image_urls TEXT DEFAULT '[]',
          likes INTEGER DEFAULT 0,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
    }
    if (oldVersion < 20) {
      await db.execute(
        'ALTER TABLE posts ADD COLUMN is_public INTEGER DEFAULT 1',
      );
      await db.execute(
        'ALTER TABLE posts ADD COLUMN allow_comments INTEGER DEFAULT 1',
      );
    }
    // 👑 VERSION 21: Decoupling the Pending State
    if (oldVersion < 21) {
      await db.execute(
        'ALTER TABLE manifestos ADD COLUMN isPending INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE manifesto_comments ADD COLUMN isPending INTEGER DEFAULT 0',
      );
    }
    // 👑 VERSION 22: Multi-Video Support
    if (oldVersion < 22) {
      await db.execute(
        'ALTER TABLE manifestos ADD COLUMN video_urls TEXT DEFAULT "[]"',
      );
      await db.execute(
        'ALTER TABLE posts ADD COLUMN video_urls TEXT DEFAULT "[]"',
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    print("Native Engine: Bootstrapping SQLite Tables...");

    await db.execute('''
      CREATE TABLE manifestos (
        id TEXT PRIMARY KEY,
        author_id TEXT NOT NULL,
        username TEXT,
        profile_image_url TEXT,
        channel_id TEXT NOT NULL,
        caption TEXT,
        video_url TEXT,
        video_urls TEXT DEFAULT '[]',
        image_urls TEXT,
        thumbnail_urls TEXT,
        likes INTEGER DEFAULT 0,
        comments INTEGER DEFAULT 0,
        is_public INTEGER DEFAULT 1,
        allow_comments INTEGER DEFAULT 1,
        isPending INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS manifesto_comments (
        id TEXT PRIMARY KEY,
        author_id TEXT NOT NULL,
        channel_id TEXT NOT NULL,
        manifesto_id TEXT NOT NULL,
        message TEXT,
        image_urls TEXT DEFAULT '[]',
        likes INTEGER DEFAULT 0,
        isPending INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE channel_comments (
        id TEXT PRIMARY KEY,
        author_id TEXT NOT NULL,
        username TEXT,
        profile_image_url TEXT,
        channel_id TEXT NOT NULL,
        manifesto_id TEXT,
        message TEXT,
        image_urls TEXT,
        likes INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (manifesto_id) REFERENCES manifestos (id) ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_manifestos_channel ON manifestos(channel_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_channel_comments_channel ON channel_comments(channel_id)',
    );

    await db.execute('''
      CREATE TABLE posts (
        id TEXT PRIMARY KEY,
        author_id TEXT,
        username TEXT,
        userProfileImageUrl TEXT,
        channelName TEXT,
        channelId TEXT,
        caption TEXT,
        videoUrl TEXT,
        video_urls TEXT DEFAULT '[]',
        audioUrl TEXT,
        sdVideoUrl TEXT,
        imageUrls TEXT,
        thumbnailUrls TEXT,
        isVideo INTEGER,
        isAudio INTEGER,
        folder_name TEXT DEFAULT 'public_posts',
        aspectRatio REAL,
        likes INTEGER,
        comments INTEGER,
        timeAgo TEXT,
        createdAt TEXT,
        shares INTEGER,
        isLiked INTEGER,
        chartedCount INTEGER,
        localFileCache TEXT,
        isPending INTEGER DEFAULT 0,
        linked_post_id TEXT,
        linked_author_username TEXT,
        linked_caption TEXT,
        linked_channel_id TEXT,
        post_type TEXT DEFAULT 'post',
        parent_post_id TEXT,
        link_chain TEXT DEFAULT '[]',
        link_depth INTEGER DEFAULT 0,
        is_public INTEGER DEFAULT 1,
        allow_comments INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE channel_cache (
        id TEXT PRIMARY KEY,
        creator_id TEXT,
        name TEXT,
        description TEXT,
        memberCount INTEGER,
        unreadCount INTEGER DEFAULT 0,
        isCharted INTEGER,
        avatarUrl TEXT,
        leaderAvatarUrl TEXT,
        creatorAvatarUrl TEXT,
        isPrivate INTEGER DEFAULT 0,
        age_restriction TEXT DEFAULT 'All Ages',
        members_other_channels INTEGER DEFAULT 0,
        members_following INTEGER DEFAULT 1,
        join_method TEXT DEFAULT 'invite',
        prevent_leaving INTEGER DEFAULT 0,
        country_restrictions TEXT DEFAULT '["Global"]',
        allow_commenting_by TEXT DEFAULT 'all',
        createdAt TEXT,
        isPending INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT,
        displayName TEXT,
        profileImageUrl TEXT,
        bio TEXT,
        title TEXT,
        isVerified INTEGER,
        followersCount INTEGER,
        followingCount INTEGER,
        postsCount INTEGER,
        ChartsCount INTEGER,
        channelsCount INTEGER,
        ChartTitle TEXT,
        birthday TEXT,
        gender TEXT,
        createdAt TEXT,
        accessToken TEXT,
        refreshToken TEXT
      )
    ''');
  }

  Future<void> cachePosts(List<Map<String, dynamic>> posts) async {
    final db = await database;
    final batch = db.batch();
    for (var post in posts) {
      final safePost = Map<String, dynamic>.from(post);
      if (safePost['imageUrls'] is List) {
        safePost['imageUrls'] = jsonEncode(safePost['imageUrls']);
      }
      if (safePost['thumbnailUrls'] is List) {
        safePost['thumbnailUrls'] = jsonEncode(safePost['thumbnailUrls']);
      }
      batch.insert(
        'posts',
        safePost,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // 👑 NEW: Table-Aware Optimistic Caching
  Future<void> cacheOptimisticItem(
    String table,
    Map<String, dynamic> data,
  ) async {
    final db = await database;
    final safeData = Map<String, dynamic>.from(data);

    // Auto-encode JSON lists if present
    if (safeData['image_urls'] is List)
      safeData['image_urls'] = jsonEncode(safeData['image_urls']);
    if (safeData['thumbnail_urls'] is List)
      safeData['thumbnail_urls'] = jsonEncode(safeData['thumbnail_urls']);
    if (safeData['imageUrls'] is List)
      safeData['imageUrls'] = jsonEncode(safeData['imageUrls']);
    if (safeData['thumbnailUrls'] is List)
      safeData['thumbnailUrls'] = jsonEncode(safeData['thumbnailUrls']);
    if (safeData['link_chain'] is List)
      safeData['link_chain'] = jsonEncode(safeData['link_chain']);
    if (safeData['video_urls'] is List)
      safeData['video_urls'] = jsonEncode(safeData['video_urls']);

    await db.insert(
      table,
      safeData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> cacheSinglePost(Map<String, dynamic> post) async {
    final db = await database;
    final safePost = Map<String, dynamic>.from(post);
    if (safePost['imageUrls'] is List) {
      safePost['imageUrls'] = jsonEncode(safePost['imageUrls']);
    }
    if (safePost['thumbnailUrls'] is List) {
      safePost['thumbnailUrls'] = jsonEncode(safePost['thumbnailUrls']);
    }
    await db.insert(
      'posts',
      safePost,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> cacheChannel(Map<String, dynamic> channel) async {
    final db = await database;
    await db.insert(
      'channel_cache',
      channel,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateChannel(String id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update('channel_cache', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getCachedChannels() async {
    final db = await database;
    return await db.query('channel_cache');
  }

  Future<List<Map<String, dynamic>>> getCachedPosts({String? authorId}) async {
    final db = await database;
    if (authorId != null) {
      return await db.query(
        'posts',
        where: 'author_id = ?',
        whereArgs: [authorId],
        orderBy: 'createdAt DESC',
      );
    }
    return await db.query('posts', orderBy: 'createdAt DESC');
  }

  Future<List<Map<String, dynamic>>> getOwnerPosts(String authorId) async {
    final db = await database;
    return await db.query(
      'posts',
      where: 'author_id = ?',
      whereArgs: [authorId],
      orderBy: 'createdAt DESC',
    );
  }

  Future<void> markPostSynced(String id) async {
    final db = await database;
    await db.update(
      'posts',
      {'isPending': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.update(
      'manifestos',
      {'isPending': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.update(
      'manifesto_comments',
      {'isPending': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 👑 ATOMIC INCREMENT: Manifesto Comment Count
  Future<void> incrementManifestoCommentCount(String manifestoId) async {
    final db = await database;
    await db.execute(
      'UPDATE manifestos SET comments = comments + 1 WHERE id = ?',
      [manifestoId],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingPosts(String? channelId) async {
    final db = await database;

    if (channelId == null || channelId == 'general' || channelId.isEmpty) {
      return await db.query(
        'posts',
        where: 'isPending = 1 AND (channelId IS NULL OR channelId = ?)',
        whereArgs: ['general'],
      );
    }

    // 👑 UNION ALL equivalent for local channel view
    final manifestos = await db.query(
      'manifestos',
      where: 'isPending = 1 AND channel_id = ?',
      whereArgs: [channelId],
    );

    final comments = await db.query(
      'manifesto_comments',
      where: 'isPending = 1 AND channel_id = ?',
      whereArgs: [channelId],
    );

    return [...manifestos, ...comments];
  }

  /// 👑 CACHE INVALIDATION: Clears old synced data to prevent "Zombie Posts"
  /// Only deletes posts that have already been synced (isPending = 0).
  Future<void> clearSyncedPosts({String? channelId}) async {
    final db = await database;

    if (channelId == null || channelId == 'general' || channelId.isEmpty) {
      // Clear general feed zombies
      await db.delete(
        'posts', 
        where: 'isPending = 0 AND (channelId IS NULL OR channelId = ?)', 
        whereArgs: ['general']
      );
      debugPrint('🧹 [SQLite] Cleared old synced posts for General Feed');
    } else {
      // Clear channel-specific zombies
      await db.delete(
        'manifestos', 
        where: 'channel_id = ? AND isPending = 0', 
        whereArgs: [channelId]
      );
      await db.delete(
        'manifesto_comments', 
        where: 'channel_id = ? AND isPending = 0', 
        whereArgs: [channelId]
      );
      debugPrint('🧹 [SQLite] Cleared old synced manifestos for Channel: $channelId');
    }
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('posts');
    await db.delete('channel_cache');
  }

  /// 👑 GLOBAL CACHE SWEEP: Enforces a strict maximum size for the ENTIRE app cache.
  /// No matter how many channels the user joins, the DB never holds more than [maxTotalPosts].
  /// Call this after a successful feed refresh or on app launch.
  Future<void> globalCacheSweep({int maxTotalPosts = 200}) async {
    final db = await database;

    // 1. Keep only the newest N manifestos across the ENTIRE app
    await db.execute('''
      DELETE FROM manifestos 
      WHERE isPending = 0 AND id NOT IN (
        SELECT id FROM manifestos 
        ORDER BY created_at DESC 
        LIMIT ?
      )
    ''', [maxTotalPosts]);

    // 2. Same for manifesto comments
    await db.execute('''
      DELETE FROM manifesto_comments 
      WHERE isPending = 0 AND id NOT IN (
        SELECT id FROM manifesto_comments 
        ORDER BY created_at DESC 
        LIMIT ?
      )
    ''', [maxTotalPosts]);

    // 3. Same for general posts (👑 FIXED: Uses legacy camelCase createdAt)
    await db.execute('''
      DELETE FROM posts 
      WHERE isPending = 0 AND id NOT IN (
        SELECT id FROM posts 
        ORDER BY createdAt DESC 
        LIMIT ?
      )
    ''', [maxTotalPosts]);

    debugPrint('✂️ [SQLite] Global Sweep: Cache limited to newest $maxTotalPosts items per table.');
  }

  /// 👑 ATOMIC DECREMENT: Safely reduces comment count without dropping below zero
  Future<void> decrementManifestoCommentCount(String manifestoId) async {
    final db = await database;
    await db.execute(
      'UPDATE manifestos SET comments = MAX(0, comments - 1) WHERE id = ?',
      [manifestoId],
    );
  }

  /// 🧨 THE NUKE: Wipes every single row from every table and shrinks the file.
  /// Use this for testing or a "Clear Cache" button in settings.
  Future<void> nukeLocalData() async {
    final db = await database;
    final batch = db.batch();
    
    batch.delete('manifestos');
    batch.delete('manifesto_comments');
    batch.delete('channel_comments');
    batch.delete('posts');
    batch.delete('channel_cache');
    batch.delete('users');
    
    await batch.commit(noResult: true);
    
    // 🧹 VACUUM: Reclaims unused space and shrinks the physical .db file on Windows.
    await db.execute('VACUUM');
    
    debugPrint('🧨 [SQLite] All local tables wiped and file vacuumed.');
  }
}
