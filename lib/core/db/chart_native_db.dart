import 'dart:convert';
import 'package:crimchart/features/channel/domain/entities/channel_entity.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'chart_db.dart';
import 'package:crimchart/core/di/injection.dart';

/// The high-performance Drift Database Engine for Chart.
/// Handles cross-platform persistence with zero UI lag.
@lazySingleton
class ChartNativeDB {
  final ChartDatabase _db;

  ChartNativeDB(this._db) {
    _syncSchema();
  }

  /// 👑 MIGRATION HELPER: Manually ensures new columns exist without wiping DB
  Future<void> _syncSchema() async {
    try {
      await _db.customStatement(
        'ALTER TABLE channel_posts ADD COLUMN is_liked INTEGER DEFAULT 0;',
      );
      debugPrint('✅ [SQLite Migration] Added is_liked to channel_posts');
    } catch (_) {} // Ignore if column already exists

    try {
      await _db.customStatement(
        'ALTER TABLE channel_post_comments ADD COLUMN is_liked INTEGER DEFAULT 0;',
      );
      debugPrint(
        '✅ [SQLite Migration] Added is_liked to channel_post_comments',
      );
    } catch (_) {}

    try {
      await _db.customStatement(
        'ALTER TABLE channel_posts ADD COLUMN is_pending INTEGER DEFAULT 0;',
      );
      debugPrint('✅ [SQLite Migration] Added is_pending to channel_posts');
    } catch (_) {}

    try {
      await _db.customStatement(
        'ALTER TABLE manifestos ADD COLUMN is_liked INTEGER DEFAULT 0;',
      );
      debugPrint('✅ [SQLite Migration] Added is_liked to manifestos');
    } catch (_) {}
  }

  // For compatibility with legacy code that might still try to access the raw db
  // Though it's highly recommended to use the helper methods instead.
  ChartDatabase get db => _db;

  /// 👑 TEMPORARY: Compatibility getter for legacy sqflite code.
  /// returns dynamic to avoid type errors but will throw at runtime if raw sqflite methods are called.
  dynamic get database => _db;

  // Static instance for legacy static access
  static ChartNativeDB get instance => getIt<ChartNativeDB>();

  Future<void> saveUser(Map<String, dynamic> data) async {
    try {
      await _db
          .into(_db.users)
          .insert(User.fromJson(data), mode: InsertMode.insertOrReplace);
    } catch (e) {
      debugPrint('🚨 [SQLite Error] saveUser FAILED: $e');
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    final result = await (_db.select(_db.users)..limit(1)).getSingleOrNull();
    return result?.toJson();
  }

  Future<void> deleteUser() async {
    await _db.delete(_db.users).go();
  }

  Future<Map<String, dynamic>?> getManifesto(String id) async {
    final result = await (_db.select(
      _db.manifestos,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return result?.toJson();
  }

  Future<Map<String, dynamic>?> getChannelPost(String id) async {
    final result = await (_db.select(
      _db.channelPosts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return result?.toJson();
  }

  Future<void> upsertManifesto(Map<String, dynamic> data) async {
    try {
      await _db
          .into(_db.manifestos)
          .insert(Manifesto.fromJson(data), mode: InsertMode.insertOrReplace);
    } catch (e) {
      debugPrint('🚨 [SQLite Error] upsertManifesto FAILED: $e');
    }
  }

  Future<void> upsertChannelPost(Map<String, dynamic> data) async {
    try {
      // 👑 Ensure all List/Map types are JSON-encoded for SQLite String columns
      final Map<String, dynamic> processedData = Map.from(data);

      final listFields = [
        'image_urls',
        'imageUrls',
        'video_urls',
        'videoUrls',
        'thumbnail_urls',
        'thumbnailUrls',
        'link_chain',
        'linkChain',
      ];

      for (final field in listFields) {
        if (processedData[field] is List) {
          processedData[field] = jsonEncode(processedData[field]);
        }
      }

      if (processedData['metadata'] is Map) {
        processedData['metadata'] = jsonEncode(processedData['metadata']);
      }

      await _db
          .into(_db.channelPosts)
          .insert(
            ChannelPost.fromJson(processedData),
            mode: InsertMode.insertOrReplace,
          );
    } catch (e) {
      debugPrint('🚨 [SQLite Error] upsertChannelPost FAILED: $e');
    }
  }

  Future<void> upsertManifestoComment(Map<String, dynamic> data) async {
    try {
      await _db
          .into(_db.manifestoComments)
          .insert(
            ManifestoComment.fromJson(data),
            mode: InsertMode.insertOrReplace,
          );
    } catch (e) {
      debugPrint('🚨 [SQLite Error] upsertManifestoComment FAILED: $e');
    }
  }

  Future<void> upsertChannelPostComment(Map<String, dynamic> data) async {
    await _db
        .into(_db.channelPostComments)
        .insert(
          ChannelPostComment.fromJson(data),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> upsertPost(Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> processedData = Map.from(data);

      final listFields = [
        'image_urls',
        'imageUrls',
        'video_urls',
        'videoUrls',
        'thumbnail_urls',
        'thumbnailUrls',
        'link_chain',
        'linkChain',
      ];

      for (final field in listFields) {
        if (processedData[field] is List) {
          processedData[field] = jsonEncode(processedData[field]);
        }
      }

      await _db
          .into(_db.posts)
          .insert(
            Post.fromJson(processedData),
            mode: InsertMode.insertOrReplace,
          );
    } catch (e) {
      debugPrint('🚨 [SQLite Error] upsertPost FAILED: $e');
    }
  }

  Future<void> upsertChannelStatus(Map<String, dynamic> data) async {
    await _db
        .into(_db.channelStatuses)
        .insert(
          ChannelStatusesCompanion.insert(
            id: (data['id'] ?? '') as String,
            channelId: (data['channelId'] ?? '') as String,
            authorId: (data['authorId'] ?? '') as String,
            caption: Value(data['caption'] as String?),
            imageUrls: Value(data['imageUrls'] as String?),
            videoUrl: Value(data['videoUrl'] as String?),
            thumbnailUrl: Value(data['thumbnailUrl'] as String?),
            audioUrl: Value(data['audioUrl'] as String?),
            isVideo: Value((data['isVideo'] as int?) ?? 0),
            isAudio: Value((data['isAudio'] as int?) ?? 0),
            // viewsCount, likesCount, commentsCount default to 0 in the schema
            commentsCount: Value((data['commentsCount'] as int?) ?? 0),
            createdAt: Value(data['createdAt'] as String?),
            expiresAt: Value(data['expiresAt'] as String?),
            // 👑 TEMP COMMENT: Run 'dart run build_runner build' to enable these!
            // username: Value(data['username'] as String?),
            // profileImageUrl: Value(data['profileImageUrl'] as String?),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> trimChannelStatuses({
    required String channelId,
    int keepCount = 10,
  }) async {
    final rows =
        await (_db.select(_db.channelStatuses)
              ..where((t) => t.channelId.equals(channelId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
                (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
              ])
              ..limit(1, offset: keepCount))
            .get();

    if (rows.isEmpty) return;

    final threshold = rows.first.createdAt;
    final thresholdId = rows.first.id;

    await (_db.delete(_db.channelStatuses)..where(
          (t) =>
              t.channelId.equals(channelId) &
              (t.createdAt.isSmallerThanValue(threshold!) |
                  (t.createdAt.equals(threshold) &
                      t.id.isSmallerThanValue(thresholdId))),
        ))
        .go();
  }

  /// Returns all non-expired statuses for a channel from the local Drift cache.
  Future<List<Map<String, dynamic>>> getChannelStatuses(
    String channelId,
  ) async {
    final now = DateTime.now().toIso8601String();
    final rows =
        await (_db.select(_db.channelStatuses)
              ..where((t) => t.channelId.equals(channelId))
              ..where(
                (t) =>
                    t.expiresAt.isNull() | t.expiresAt.isBiggerThanValue(now),
              )
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return rows.map((r) => r.toJson()).toList();
  }

  /// Returns all moments for a channel from the local Drift cache.
  Future<List<Map<String, dynamic>>> getChannelMoments(String channelId) async {
    final rows =
        await (_db.select(_db.channelMoments)
              ..where((t) => t.channelId.equals(channelId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return rows.map((r) => r.toJson()).toList();
  }

  /// Watch all moments for a channel as a reactive stream with pagination support.
  Stream<List<Map<String, dynamic>>> watchChannelMoments(
    String channelId, {
    int limit = 10,
  }) {
    return (_db.select(_db.channelMoments)
          ..where((t) => t.channelId.equals(channelId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map((r) => r.toJson()).toList());
  }

  /// Watch all moments for a list of channel IDs.
  Stream<List<Map<String, dynamic>>> watchJoinedChannelsMoments(
    List<String> channelIds,
  ) {
    return (_db.select(_db.channelMoments)
          ..where((t) => t.channelId.isIn(channelIds))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((rows) => rows.map((r) => r.toJson()).toList());
  }

  /// Watch all moments in the local cache, ordered by creation time.
  Stream<List<Map<String, dynamic>>> watchAllMoments() {
    return (_db.select(_db.channelMoments)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((rows) => rows.map((r) => r.toJson()).toList());
  }

  Future<void> upsertChannelMoment(Map<String, dynamic> data) async {
    await _db
        .into(_db.channelMoments)
        .insert(
          ChannelMomentsCompanion.insert(
            id: (data['id'] ?? '') as String,
            channelId:
                (data['channel_id'] ?? data['channelId'] ?? '') as String,
            authorId: (data['author_id'] ?? data['authorId'] ?? '') as String,
            authorName: Value(
              (data['author_name'] ?? data['authorName']) as String?,
            ),
            authorAvatarUrl: Value(
              (data['author_avatar_url'] ?? data['authorAvatarUrl']) as String?,
            ),
            mediaUrl: (data['media_url'] ?? data['mediaUrl'] ?? '') as String,
            mediaType: Value(
              (data['media_type'] ?? data['mediaType'] ?? 'photo') as String,
            ),
            thumbnailUrl: Value(
              (data['thumbnail_url'] ?? data['thumbnailUrl']) as String?,
            ),
            caption: Value(data['caption'] as String?),
            createdAt: Value(
              data['created_at'] != null
                  ? DateTime.parse(data['created_at'].toString())
                  : DateTime.now(),
            ),
            expiresAt: Value(
              data['expires_at'] != null
                  ? DateTime.parse(data['expires_at'].toString())
                  : null,
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// Deletes all expired moments for a channel from the local Drift cache.
  Future<void> deleteExpiredMoments(String channelId) async {
    final now = DateTime.now().toIso8601String();
    await (_db.delete(_db.channelMoments)
          ..where((t) => t.channelId.equals(channelId))
          ..where((t) => t.expiresAt.isSmallerThanValue(DateTime.parse(now))))
        .go();
  }

  /// Clears all cached statuses for a given channel.
  Future<void> deleteChannelStatuses(String channelId) async {
    await (_db.delete(
      _db.channelStatuses,
    )..where((t) => t.channelId.equals(channelId))).go();
  }

  Future<void> trimChannelMessages({
    required String channelId,
    required int keepCount,
  }) async {
    // 1. Find the ID of the 'keepCount'-th newest message
    final latestMessages =
        await (_db.select(_db.channelMessages)
              ..where((t) => t.channelId.equals(channelId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
                (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
              ])
              ..limit(keepCount))
            .get();

    if (latestMessages.length < keepCount) return;

    final oldestToKeep = latestMessages.last;

    // 2. Delete anything older than that message
    // We compare by createdAt, and use ID as a tie-breaker
    await (_db.delete(_db.channelMessages)..where(
          (t) =>
              t.channelId.equals(channelId) &
              (t.createdAt.isSmallerThan(
                    Variable(oldestToKeep.createdAt ?? ''),
                  ) |
                  (t.createdAt.equals(oldestToKeep.createdAt ?? '') &
                      t.id.isSmallerThan(Variable(oldestToKeep.id)))),
        ))
        .go();
  }

  Future<List<Map<String, dynamic>>> getChannelMessages(
    String channelId, {
    int limit = 50,
  }) async {
    final rows =
        await (_db.select(_db.channelMessages)
              ..where((t) => t.channelId.equals(channelId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.isPending,
                  mode: OrderingMode.asc,
                ),
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
                (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
              ])
              ..limit(limit))
            .get();
    return rows.map((r) => r.toJson()).toList();
  }

  Stream<List<Map<String, dynamic>>> watchChannelMessages(
    String channelId, {
    int limit = 50,
  }) {
    return (_db.select(_db.channelMessages)
          ..where((t) => t.channelId.equals(channelId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.isPending, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch()
        .map((rows) {
          final reversed = rows.toList().reversed.toList();
          return reversed.map((r) => r.toJson()).toList();
        });
  }

  Future<void> upsertChannelMessage(Map<String, dynamic> data) async {
    final channelId = (data['channel_id'] ?? data['channelId'] ?? '') as String;
    final senderId = (data['sender_id'] ?? data['senderId'] ?? '') as String;

    print('👑 [upsertChannelMessage] channelId=$channelId senderId=$senderId');

    // VIBE CODING HACK: Ensure channel exists to satisfy FOREIGN KEY constraint
    final channelExists = await (_db.select(
      _db.channels,
    )..where((t) => t.id.equals(channelId))).getSingleOrNull();

    print('👑 [upsertChannelMessage] channelExists=${channelExists != null}');

    if (channelExists == null) {
      await _db
          .into(_db.channels)
          .insert(
            ChannelsCompanion.insert(id: channelId),
            mode: InsertMode.insertOrIgnore,
          );
      print('👑 [upsertChannelMessage] ✅ Created placeholder channel');
    }

    // VIBE CODING HACK: Ensure channel_member exists to satisfy FOREIGN KEY constraint
    final memberExists =
        await (_db.select(_db.channelMembers)..where(
              (t) => t.channelId.equals(channelId) & t.userId.equals(senderId),
            ))
            .getSingleOrNull();

    print('👑 [upsertChannelMessage] memberExists=${memberExists != null}');

    if (memberExists == null) {
      await _db
          .into(_db.channelMembers)
          .insert(
            ChannelMembersCompanion.insert(
              channelId: channelId,
              userId: senderId,
              role: const Value('member'),
              joinedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      print('👑 [upsertChannelMessage] ✅ Created placeholder member');
    }

    print('👑 [upsertChannelMessage] Inserting message into DB...');
    await _db
        .into(_db.channelMessages)
        .insertOnConflictUpdate(
          ChannelMessagesCompanion(
            id: Value(data['id'] as String),
            channelId: Value(channelId),
            senderId: Value(senderId),
            textContent: Value(
              (data['text_content'] ?? data['textContent']) as String?,
            ),
            mediaUrl: Value((data['media_url'] ?? data['mediaUrl']) as String?),
            thumbnailUrl: Value(
              (data['thumbnail_url'] ?? data['thumbnailUrl']) as String?,
            ),
            mediaType: Value(
              (data['media_type'] ?? data['mediaType']) as String?,
            ),
            voiceNoteUrl: const Value(null),
            replyToId: Value(
              (data['reply_to_id'] ?? data['replyToId']) as String?,
            ),
            isRead: const Value(0),
            isPending: Value(
              ((data['is_pending'] ?? data['isPending']) == true ||
                      (data['is_pending'] ?? data['isPending']) == 1)
                  ? 1
                  : 0,
            ),
            messageType: Value(
              (data['message_type'] ??
                      data['messageType'] ??
                      data['media_type'] ??
                      'text')
                  as String,
            ),
            metadata: Value(
              data['metadata'] is Map
                  ? jsonEncode(data['metadata'])
                  : data['metadata'] as String?,
            ),
            createdAt: Value(
              _parseToUtcString(data['created_at'] ?? data['createdAt']),
            ),
          ),
        );
    print('👑 [upsertChannelMessage] ✅ Message inserted successfully');
  }

  Future<void> deleteChannelMessage(String messageId) async {
    await (_db.delete(
      _db.channelMessages,
    )..where((t) => t.id.equals(messageId))).go();
    print('👑 [deleteChannelMessage] ✅ Deleted local message $messageId');
  }

  /// Normalizes any timestamp value (String, DateTime, or null) to a
  /// consistent UTC ISO-8601 string. This ensures ordering is always correct
  /// regardless of device timezone or Supabase format differences.
  String? _parseToUtcString(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toUtc().toIso8601String();
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed?.toUtc().toIso8601String() ?? value;
    }
    return null;
  }

  // 👑 CHANNEL PRESENCE (ONLINE USERS)

  /// Mark a user as online in a channel. Call when entering the chat.
  Future<void> markUserOnline({
    required String channelId,
    required String userId,
    String? displayName,
    String? avatarUrl,
  }) async {
    await _db
        .into(_db.channelPresence)
        .insertOnConflictUpdate(
          ChannelPresenceCompanion(
            channelId: Value(channelId),
            userId: Value(userId),
            isOnline: const Value(1),
            isTyping: const Value(0),
            lastSeen: Value(DateTime.now().toIso8601String()),
            lastKnownName: Value(displayName),
            lastKnownAvatar: Value(avatarUrl),
          ),
        );
  }

  Future<void> markUserOffline({
    required String channelId,
    required String userId,
  }) async {
    await (_db.update(_db.channelPresence)..where(
          (t) => t.channelId.equals(channelId) & t.userId.equals(userId),
        ))
        .write(
          ChannelPresenceCompanion(
            isOnline: const Value(0),
            isTyping: const Value(0),
            lastSeen: Value(DateTime.now().toIso8601String()),
          ),
        );
  }

  /// Upsert presence data from remote source.
  Future<void> upsertPresence(Map<String, dynamic> data) async {
    final channelId = data['channel_id'] as String;
    final userId = data['user_id'] as String;
    await _db
        .into(_db.channelPresence)
        .insertOnConflictUpdate(
          ChannelPresenceCompanion(
            channelId: Value(channelId),
            userId: Value(userId),
            isOnline: Value(
              (data['is_online'] == true || data['is_online'] == 1) ? 1 : 0,
            ),
            isTyping: Value(
              (data['is_typing'] == true || data['is_typing'] == 1) ? 1 : 0,
            ),
            lastSeen: Value(data['last_seen_at']?.toString()),
            lastKnownName: Value(data['last_known_name']?.toString()),
            lastKnownAvatar: Value(data['last_known_avatar']?.toString()),
          ),
        );
  }

  /// Update typing status for a user in a channel.
  Future<void> setTypingStatus({
    required String channelId,
    required String userId,
    required bool isTyping,
  }) async {
    // 👑 1. UPDATE LOCAL
    await (_db.update(_db.channelPresence)..where(
          (t) => t.channelId.equals(channelId) & t.userId.equals(userId),
        ))
        .write(ChannelPresenceCompanion(isTyping: Value(isTyping ? 1 : 0)));
  }

  /// Watch all online users for a channel as a reactive stream.
  Stream<List<Map<String, dynamic>>> watchOnlineUsers(String channelId) {
    return (_db.select(_db.channelPresence)
          ..where((t) => t.channelId.equals(channelId) & t.isOnline.equals(1)))
        .watch()
        .map((rows) => rows.map((r) => r.toJson()).toList());
  }

  // 👑 COMMON CHANNELS
  Stream<List<Map<String, dynamic>>> watchCommonChannels(
    String currentUserId,
    String otherUserId,
  ) {
    // Join common_channels with channels to get the channel details
    final query =
        _db.select(_db.commonChannels).join([
          innerJoin(
            _db.channels,
            _db.channels.id.equalsExp(_db.commonChannels.channelId),
          ),
        ])..where(
          _db.commonChannels.userId.equals(currentUserId) &
              _db.commonChannels.otherUserId.equals(otherUserId),
        );

    return query.watch().map((rows) {
      return rows.map((row) {
        final channel = row.readTable(_db.channels);
        return channel.toJson();
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getPosts({
    String? authorId,
    String? channelId,
    int? offset,
    int? limit,
  }) async {
    final query = _db.select(_db.posts)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    if (authorId != null) {
      query.where((t) => t.authorId.equals(authorId));
    }
    if (channelId != null && channelId != 'global') {
      query.where((t) => t.channelId.equals(channelId));
    }
    if (limit != null) {
      query.limit(limit, offset: offset);
    }
    final rows = await query.get();
    return rows.map((r) => r.toJson()).toList();
  }

  Future<void> clearSyncedPosts({String? channelId}) async {
    if (channelId == 'private') {
      await (_db.delete(
        _db.channels,
      )..where((t) => t.isPrivate.equals(1))).go();
    } else if (channelId == 'public') {
      await (_db.delete(
        _db.channels,
      )..where((t) => t.isPrivate.equals(0))).go();
    } else if (channelId != null && channelId != 'global') {
      await (_db.delete(_db.channelPosts)..where(
            (t) => t.channelId.equals(channelId) & t.isPending.equals(0),
          ))
          .go();
    } else {
      await (_db.delete(_db.posts)..where((t) => t.isPending.equals(0))).go();
    }
  }

  /// 👑 ROLLING CACHE: Keeps only the newest [keepCount] posts for a channel.
  /// Deletes everything else that isn't pending.
  Future<void> trimChannelPosts({
    required String channelId,
    int keepCount = 10,
  }) async {
    try {
      // 1. Get the IDs of the newest N posts
      final newest =
          await (_db.select(_db.channelPosts)
                ..where((t) => t.channelId.equals(channelId))
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.createdAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(keepCount))
              .get();

      final newestIds = newest.map((p) => p.id).toList();

      // 2. Delete everything else
      if (newestIds.isNotEmpty) {
        await (_db.delete(_db.channelPosts)..where(
              (t) =>
                  t.channelId.equals(channelId) &
                  t.id.isNotIn(newestIds) &
                  t.isPending.equals(0),
            ))
            .go();
        debugPrint(
          '💾 [SQLite Trim] Kept only the ${newestIds.length} newest posts for $channelId',
        );
      }
    } catch (e) {
      debugPrint('🚨 [SQLite Trim Error] Failed for $channelId: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchPosts(String queryText) async {
    final rows =
        await (_db.select(_db.posts)..where(
              (t) =>
                  t.username.like('%$queryText%') |
                  t.caption.like('%$queryText%'),
            ))
            .get();
    return rows.map((r) => r.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getManifestos(String channelId) async {
    try {
      final rows =
          await (_db.select(_db.manifestos)
                ..where((t) => t.channelId.equals(channelId))
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.createdAt,
                    mode: OrderingMode.desc,
                  ),
                ]))
              .get();
      return rows.map((r) => r.toJson()).toList();
    } catch (e) {
      if (e.toString().contains('no such column: is_liked')) {
        debugPrint(
          '🛠️ [SQLite Self-Heal] Detected missing is_liked, migrating...',
        );
        await _syncSchema();
        // Retry once after migration
        return getManifestos(channelId);
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getManifestoComments(
    String channelId,
  ) async {
    final rows =
        await (_db.select(_db.manifestoComments)
              ..where((t) => t.channelId.equals(channelId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return rows.map((r) => r.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getChannelPosts(
    String channelId, {
    int? offset,
    int? limit,
  }) async {
    try {
      final query = _db.select(_db.channelPosts)
        ..where((t) => t.channelId.equals(channelId))
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]);

      if (limit != null) {
        query.limit(limit, offset: offset);
      }

      final rows = await query.get();
      return rows.map((r) => r.toJson()).toList();
    } catch (e) {
      if (e.toString().contains('no such column: is_liked')) {
        debugPrint(
          '🛠️ [SQLite Self-Heal] Detected missing is_liked, migrating...',
        );
        await _syncSchema();
        return getChannelPosts(channelId, offset: offset, limit: limit);
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getChannelPostComments(
    String channelId,
  ) async {
    final rows =
        await (_db.select(_db.channelPostComments)
              ..where((t) => t.channelId.equals(channelId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return rows.map((r) => r.toJson()).toList();
  }

  Future<Map<String, dynamic>?> getSinglePost(String id) async {
    final result = await (_db.select(
      _db.posts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return result?.toJson();
  }

  Future<void> cacheManifestos(List<Map<String, dynamic>> items) async {
    await _db.batch((batch) {
      for (var item in items) {
        final safeItem = Map<String, dynamic>.from(item);

        // 👑 DRIFT SAFETY: Normalize keys and provide defaults for non-nullable fields
        safeItem['id'] ??=
            safeItem['ID'] ?? DateTime.now().millisecondsSinceEpoch.toString();
        safeItem['authorId'] ??= safeItem['author_id'] ?? '';
        safeItem['channelId'] ??= safeItem['channel_id'] ?? '';
        safeItem['videoUrls'] ??= safeItem['video_urls'] ?? '[]';
        safeItem['likes'] ??= safeItem['likes'] ?? 0;
        safeItem['comments'] ??= safeItem['comments'] ?? 0;
        safeItem['isPublic'] ??= safeItem['is_public'] ?? 1;
        safeItem['allowComments'] ??= safeItem['allow_comments'] ?? 1;
        safeItem['isPending'] ??= safeItem['is_pending'] ?? 0;

        if (safeItem['videoUrls'] is List) {
          safeItem['videoUrls'] = jsonEncode(safeItem['videoUrls']);
        }
        if (safeItem['imageUrls'] is List) {
          safeItem['imageUrls'] = jsonEncode(safeItem['imageUrls']);
        }
        if (safeItem['thumbnailUrls'] is List) {
          safeItem['thumbnailUrls'] = jsonEncode(safeItem['thumbnailUrls']);
        }
        if (safeItem['metadata'] is Map) {
          safeItem['metadata'] = jsonEncode(safeItem['metadata']);
        }

        batch.insert(
          _db.manifestos,
          Manifesto.fromJson(safeItem),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> cachePosts(List<Map<String, dynamic>> posts) async {
    await _db.batch((batch) {
      for (var post in posts) {
        final safePost = Map<String, dynamic>.from(post);

        // 👑 DRIFT SAFETY: Normalize keys and provide defaults for non-nullable fields
        safePost['id'] ??=
            safePost['ID'] ?? DateTime.now().millisecondsSinceEpoch.toString();
        safePost['authorId'] ??= safePost['author_id'] ?? '';
        safePost['channelId'] ??= safePost['channel_id'] ?? '';
        safePost['videoUrls'] ??= safePost['video_urls'] ?? '[]';
        safePost['folderName'] ??= safePost['folder_name'] ?? 'public_posts';
        safePost['postType'] ??= safePost['post_type'] ?? 'post';
        safePost['linkChain'] ??= safePost['link_chain'] ?? '[]';
        safePost['linkDepth'] ??= safePost['link_depth'] ?? 0;
        safePost['isPublic'] ??= safePost['is_public'] ?? 1;
        safePost['allowComments'] ??= safePost['allow_comments'] ?? 1;
        safePost['isPending'] ??= safePost['is_pending'] ?? 0;
        safePost['isLiked'] ??= safePost['is_liked'] ?? 0;

        if (safePost['imageUrls'] is List) {
          safePost['imageUrls'] = jsonEncode(safePost['imageUrls']);
        }
        if (safePost['thumbnailUrls'] is List) {
          safePost['thumbnailUrls'] = jsonEncode(safePost['thumbnailUrls']);
        }
        if (safePost['videoUrls'] is List) {
          safePost['videoUrls'] = jsonEncode(safePost['videoUrls']);
        }
        if (safePost['linkChain'] is List) {
          safePost['linkChain'] = jsonEncode(safePost['linkChain']);
        }
        if (safePost['metadata'] is Map) {
          safePost['metadata'] = jsonEncode(safePost['metadata']);
        }
        batch.insert(
          _db.posts,
          Post.fromJson(safePost),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> cacheChannelPosts(List<Map<String, dynamic>> items) async {
    await _db.batch((batch) {
      for (final item in items) {
        final safeItem = Map<String, dynamic>.from(item);

        try {
          // Robust key checking
          safeItem['channelId'] ??= safeItem['channel_id'] ?? '';
          safeItem['authorId'] ??= safeItem['author_id'] ?? '';
          safeItem['profileImageUrl'] ??= safeItem['profile_image_url'] ?? '';
          safeItem['videoUrl'] ??= safeItem['video_url'] ?? '';
          safeItem['sdVideoUrl'] ??= safeItem['sd_video_url'] ?? '';
          safeItem['audioUrl'] ??= safeItem['audio_url'] ?? '';
          safeItem['postType'] ??= safeItem['post_type'] ?? 'post';
          safeItem['createdAt'] ??=
              safeItem['created_at'] ?? DateTime.now().toIso8601String();
          safeItem['isLiked'] ??= safeItem['is_liked'] ?? 0;
          safeItem['isSponsored'] ??= safeItem['is_sponsored'] ?? 0;
          safeItem['isPublic'] ??= safeItem['is_public'] ?? 1;
          safeItem['allowComments'] ??= safeItem['allow_comments'] ?? 1;
          safeItem['id'] ??= DateTime.now().millisecondsSinceEpoch.toString();
          safeItem['isPending'] ??= safeItem['is_pending'] ?? 0;
          safeItem['videoUrls'] ??= safeItem['video_urls'] ?? '[]';

          if (safeItem['imageUrls'] is List) {
            safeItem['imageUrls'] = jsonEncode(safeItem['imageUrls']);
          }
          if (safeItem['thumbnailUrls'] is List) {
            safeItem['thumbnailUrls'] = jsonEncode(safeItem['thumbnailUrls']);
          }
          if (safeItem['videoUrls'] is List) {
            safeItem['videoUrls'] = jsonEncode(safeItem['videoUrls']);
          }
          if (safeItem['metadata'] is Map) {
            safeItem['metadata'] = jsonEncode(safeItem['metadata']);
          }

          batch.insert(
            _db.channelPosts,
            ChannelPost.fromJson(safeItem),
            mode: InsertMode.insertOrReplace,
          );
        } catch (e) {
          debugPrint('🚨 [ChartNativeDB Crash] Row mapping failed!');
          debugPrint('🚨 Error: $e');
          debugPrint('🚨 Row Data: $safeItem');
          rethrow;
        }
      }
    });
  }

  Future<void> cacheOptimisticItem(
    String table,
    Map<String, dynamic> data,
  ) async {
    final safeData = Map<String, dynamic>.from(data);

    // Auto-encode JSON lists if present
    if (safeData['image_urls'] is List) {
      safeData['image_urls'] = jsonEncode(safeData['image_urls']);
    }
    if (safeData['thumbnail_urls'] is List) {
      safeData['thumbnail_urls'] = jsonEncode(safeData['thumbnail_urls']);
    }
    if (safeData['imageUrls'] is List) {
      safeData['imageUrls'] = jsonEncode(safeData['imageUrls']);
    }
    if (safeData['thumbnailUrls'] is List) {
      safeData['thumbnailUrls'] = jsonEncode(safeData['thumbnailUrls']);
    }
    if (safeData['link_chain'] is List) {
      safeData['link_chain'] = jsonEncode(safeData['link_chain']);
    }
    if (safeData['video_urls'] is List) {
      safeData['video_urls'] = jsonEncode(safeData['video_urls']);
    }

    // 👑 DRIFT SAFETY: Ensure non-nullable fields have defaults
    safeData['id'] ??= DateTime.now().millisecondsSinceEpoch.toString();
    safeData['author_id'] ??= '';
    safeData['channel_id'] ??= '';
    safeData['post_type'] ??= 'post';
    safeData['isPending'] ??= 0;
    safeData['is_liked'] ??= 0;
    safeData['is_video'] ??= 0;
    safeData['likes'] ??= 0;
    safeData['comments'] ??= 0;
    safeData['shares'] ??= 0;

    try {
      if (table == 'posts') {
        await _db
            .into(_db.posts)
            .insert(Post.fromJson(safeData), mode: InsertMode.insertOrReplace);
      } else if (table == 'manifestos') {
        safeData['videoUrls'] ??= safeData['video_urls'] ?? '[]';
        safeData['authorId'] ??= safeData['author_id'] ?? '';
        safeData['channelId'] ??= safeData['channel_id'] ?? '';
        safeData['isPublic'] ??= safeData['is_public'] ?? 1;
        safeData['allowComments'] ??= safeData['allow_comments'] ?? 1;
        safeData['isLiked'] ??= safeData['is_liked'] ?? 0;
        safeData['isPending'] ??= 0;
        safeData['likes'] ??= 0;
        safeData['comments'] ??= 0;

        if (safeData['videoUrls'] is List) {
          safeData['videoUrls'] = jsonEncode(safeData['videoUrls']);
        }
        if (safeData['imageUrls'] is List) {
          safeData['imageUrls'] = jsonEncode(safeData['imageUrls']);
        }

        await _db
            .into(_db.manifestos)
            .insert(
              Manifesto.fromJson(safeData),
              mode: InsertMode.insertOrReplace,
            );
      } else if (table == 'manifesto_comments') {
        safeData['authorId'] ??= safeData['author_id'] ?? '';
        safeData['channelId'] ??= safeData['channel_id'] ?? '';
        safeData['isPending'] ??= 0;
        safeData['isLiked'] ??= safeData['is_liked'] ?? 0;
        safeData['likes'] ??= 0;

        await _db
            .into(_db.manifestoComments)
            .insert(
              ManifestoComment.fromJson(safeData),
              mode: InsertMode.insertOrReplace,
            );
      } else if (table == 'channel_posts') {
        await _db
            .into(_db.channelPosts)
            .insert(
              ChannelPost.fromJson(safeData),
              mode: InsertMode.insertOrReplace,
            );
      } else if (table == 'channel_post_comments') {
        await _db
            .into(_db.channelPostComments)
            .insert(
              ChannelPostComment.fromJson(safeData),
              mode: InsertMode.insertOrReplace,
            );
      }
    } catch (e) {
      debugPrint('🚨 [SQLite Error] cacheOptimisticItem FAILED for $table: $e');
    }
  }

  Future<void> cacheSinglePost(Map<String, dynamic> post) async {
    final safePost = Map<String, dynamic>.from(post);
    if (safePost['imageUrls'] is List) {
      safePost['imageUrls'] = jsonEncode(safePost['imageUrls']);
    }
    if (safePost['thumbnailUrls'] is List) {
      safePost['thumbnailUrls'] = jsonEncode(safePost['thumbnailUrls']);
    }
    await _db
        .into(_db.posts)
        .insert(Post.fromJson(safePost), mode: InsertMode.insertOrReplace);
  }

  Future<void> cacheChannel(Map<String, dynamic> channel) async {
    await _db
        .into(_db.channels)
        .insert(Channel.fromJson(channel), mode: InsertMode.insertOrReplace);
  }

  /// 🗑️ Removes all locally-cached invitation posts for a channel.
  /// Called when the owner switches 'allow_invitations_by' to 'none'.
  Future<void> deleteInvitationPostsForChannel(String channelId) async {
    await (_db.delete(_db.channelPosts)..where(
          (t) =>
              t.channelId.equals(channelId) & t.postType.equals('invitation'),
        ))
        .go();
  }

  /// 👑 MODULAR CACHING: Distributes a ChannelEntity across the normalized tables
  Future<void> cacheFullChannelProfile(ChannelEntity channel) async {
    // 1. Core Identity
    await _db
        .into(_db.channels)
        .insert(
          ChannelsCompanion.insert(
            id: channel.id,
            name: Value(channel.name),
            title: const Value.absent(),
            subtitle: Value(channel.description),
            imageUrl: Value(channel.avatarUrl),
            isPrivate: Value(channel.isPrivate ? 1 : 0),
            joinMethod: Value(channel.join_method ?? 'invite'),
            ageRestriction: Value(channel.age_restriction ?? 'All Ages'),
            visibleToOtherChannelMembers: Value(
              channel.visible_to_other_channel_members ?? 0,
            ),
            visibleToFollowedUsers: Value(
              channel.visible_to_followed_users ?? 1,
            ),
            preventLeaving: Value(channel.prevent_leaving ?? 0),
            countryRestrictions: Value(
              channel.country_restrictions ?? '["Global"]',
            ),
            allowCommentingBy: Value(channel.allow_commenting_by ?? 'all'),
            allowStatusPostingBy: Value(
              channel.allow_status_posting_by ?? 'all',
            ),
            allowInvitationsBy: Value(channel.allow_invitations_by ?? 'all'),
            isDiscoverable: Value(channel.is_discoverable),
            membersCount: Value(channel.memberCount),
            followersCount: Value(channel.followersCount),
            tagsCount: Value(channel.tagsCount),
            likesCount: Value(channel.likesCount),
          ),
          mode: InsertMode.insertOrReplace,
        );

    // 2. Metadata (Stats & Badges)
    await _db
        .into(_db.channelMetadata)
        .insert(
          ChannelMetadataCompanion.insert(
            channelId: channel.id,
            memberCount: Value(channel.memberCount),
            unreadCount: Value(channel.unreadCount),
            isCharted: Value(channel.isCharted ? 1 : 0),
            isPending: const Value(0),
          ),
          mode: InsertMode.insertOrReplace,
        );

    // 3. Branding (Aesthetics)
    await _db
        .into(_db.channelBranding)
        .insert(
          ChannelBrandingCompanion.insert(
            channelId: channel.id,
            creatorAvatarUrl: Value(channel.creatorAvatarUrl),
            leaderAvatarUrl: Value(channel.leaderAvatarUrl),
            creatorId: Value(channel.creatorId),
          ),
          mode: InsertMode.insertOrReplace,
        );

    // 4. Creator Identity
    await _db
        .into(_db.channelCreator)
        .insert(
          ChannelCreatorCompanion.insert(
            channelId: channel.id,
            creatorId: channel.creatorId,
            name: Value(channel.creatorName ?? 'Creator'),
            isVerified: const Value(0),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> updateChannel(String id, Map<String, dynamic> data) async {
    final companion = Channel.fromJson(data).toCompanion(true);
    await (_db.update(
      _db.channels,
    )..where((t) => t.id.equals(id))).write(companion);
  }

  Future<List<Map<String, dynamic>>> getCachedChannels() async {
    final query = _db.select(_db.channels).join([
      leftOuterJoin(
        _db.channelMetadata,
        _db.channelMetadata.channelId.equalsExp(_db.channels.id),
      ),
      leftOuterJoin(
        _db.channelBranding,
        _db.channelBranding.channelId.equalsExp(_db.channels.id),
      ),
      leftOuterJoin(
        _db.channelCreator,
        _db.channelCreator.channelId.equalsExp(_db.channels.id),
      ),
    ]);

    final results = await query.get();
    return results.map((row) {
      final channel = row.readTable(_db.channels).toJson();
      final metadata = row.readTableOrNull(_db.channelMetadata)?.toJson() ?? {};
      final branding = row.readTableOrNull(_db.channelBranding)?.toJson() ?? {};
      final creator = row.readTableOrNull(_db.channelCreator)?.toJson() ?? {};

      return {
        ...channel,
        'memberCount': channel['members_count'] ?? metadata['memberCount'],
        'followersCount': channel['followers_count'],
        'tagsCount': channel['tags_count'],
        'likesCount': channel['likes_count'],
        'postsCount':
            metadata['postsBadgeCount'], // Mapping local badge count or similar
        'unreadCount': metadata['unreadCount'],
        'isCharted': metadata['isCharted'],
        'isDiscoverable': channel['is_discoverable'],
        'creatorAvatarUrl': branding['creatorAvatarUrl'],
        'leaderAvatarUrl': branding['leaderAvatarUrl'],
        'creator_id': branding['creatorId'],
        'creatorName': creator['name'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getCachedPosts({String? authorId}) async {
    final query = _db.select(_db.posts);
    if (authorId != null) {
      query.where((t) => t.authorId.equals(authorId));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
    ]);
    final results = await query.get();
    return results.map((row) => row.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getOwnerPosts(String authorId) async {
    final results =
        await (_db.select(_db.posts)
              ..where((t) => t.authorId.equals(authorId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return results.map((row) => row.toJson()).toList();
  }

  Future<void> markPostSynced(String id) async {
    await (_db.update(_db.posts)..where((t) => t.id.equals(id))).write(
      const PostsCompanion(isPending: Value(0)),
    );
    await (_db.update(_db.manifestos)..where((t) => t.id.equals(id))).write(
      const ManifestosCompanion(isPending: Value(0)),
    );
    await (_db.update(_db.manifestoComments)..where((t) => t.id.equals(id)))
        .write(const ManifestoCommentsCompanion(isPending: Value(0)));
  }

  Future<void> incrementManifestoCommentCount(String manifestoId) async {
    await _db.customStatement(
      'UPDATE manifestos SET comments = comments + 1 WHERE id = ?',
      [manifestoId],
    );
  }

  Future<void> incrementChannelPostCommentCount(String postId) async {
    await _db.customStatement(
      'UPDATE channel_posts SET comments = comments + 1 WHERE id = ?',
      [postId],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingPosts(String? channelId) async {
    if (channelId == null || channelId == 'general' || channelId.isEmpty) {
      final posts =
          await (_db.select(_db.posts)..where(
                (t) =>
                    t.isPending.equals(1) &
                    (t.channelId.isNull() | t.channelId.equals('general')),
              ))
              .get();
      return posts.map((row) => row.toJson()).toList();
    }

    final manifestos =
        await (_db.select(_db.manifestos)..where(
              (t) => t.isPending.equals(1) & t.channelId.equals(channelId),
            ))
            .get();

    final comments =
        await (_db.select(_db.manifestoComments)..where(
              (t) => t.isPending.equals(1) & t.channelId.equals(channelId),
            ))
            .get();

    return [
      ...manifestos.map((e) => e.toJson()),
      ...comments.map((e) => e.toJson()),
    ];
  }

  Future<void> clearAll() async {
    await _db.delete(_db.posts).go();
    await _db.delete(_db.channels).go();
  }

  Future<void> globalCacheSweep({int maxTotalPosts = 200}) async {
    // Basic implementation using custom statements for complex LIMIT subqueries
    await _db.customStatement(
      '''
      DELETE FROM manifestos 
      WHERE is_pending = 0 AND id NOT IN (
        SELECT id FROM manifestos 
        ORDER BY created_at DESC 
        LIMIT ?
      )
    ''',
      [maxTotalPosts],
    );

    await _db.customStatement(
      '''
      DELETE FROM manifesto_comments 
      WHERE is_pending = 0 AND id NOT IN (
        SELECT id FROM manifesto_comments 
        ORDER BY created_at DESC 
        LIMIT ?
      )
    ''',
      [maxTotalPosts],
    );

    await _db.customStatement(
      '''
      DELETE FROM posts 
      WHERE is_pending = 0 AND id NOT IN (
        SELECT id FROM posts 
        ORDER BY createdAt DESC 
        LIMIT ?
      )
    ''',
      [maxTotalPosts],
    );
  }

  Future<void> decrementManifestoCommentCount(String manifestoId) async {
    await _db.customStatement(
      'UPDATE manifestos SET comments = MAX(0, comments - 1) WHERE id = ?',
      [manifestoId],
    );
  }

  Future<void> toggleLike(
    String itemId,
    bool isPost, {
    bool isLiked = true,
  }) async {
    final operator = isLiked ? '+' : '-';
    final isLikedValue = isLiked ? 1 : 0;

    // 👑 Update all possible tables where this item might exist
    final tables = isPost
        ? ['manifestos', 'channel_posts', 'posts']
        : ['manifesto_comments', 'channel_post_comments'];

    for (final table in tables) {
      try {
        await _db.customStatement(
          'UPDATE $table SET likes = MAX(0, likes $operator 1), is_liked = ? WHERE id = ?',
          [isLikedValue, itemId],
        );
        debugPrint('💾 [SQLite Internal] Update success for $table ID $itemId');
      } catch (e) {
        if (e.toString().contains('no such column: is_liked')) {
          debugPrint(
            '🛠️ [SQLite Self-Heal] Missing is_liked in $table, migrating...',
          );
          await _syncSchema();
          // Retry once
          try {
            await _db.customStatement(
              'UPDATE $table SET likes = MAX(0, likes $operator 1), is_liked = ? WHERE id = ?',
              [isLikedValue, itemId],
            );
          } catch (_) {}
        } else {
          debugPrint('🚨 [SQLite Error] toggleLike FAILED for $table: $e');
        }
      }
    }
  }

  Future<void> deleteItem(String itemId, bool isManifesto) async {
    try {
      if (isManifesto) {
        await (_db.delete(
          _db.channelPosts,
        )..where((t) => t.id.equals(itemId))).go();
      } else {
        await (_db.delete(
          _db.channelPostComments,
        )..where((t) => t.id.equals(itemId))).go();
      }
    } catch (e) {
      debugPrint('🚨 [SQLite Error] deleteItem FAILED: $e');
    }
  }

  Future<void> upsertChannelInvitation(Map<String, dynamic> data) async {
    await _db
        .into(_db.channelInvitations)
        .insert(
          ChannelInvitation.fromJson(data),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<Set<String>> getInvitedChannelIds(String targetChannelId) async {
    final rows = await (_db.select(
      _db.channelInvitations,
    )..where((t) => t.targetChannelId.equals(targetChannelId))).get();
    return rows.map((r) => r.sourceChannelId).toSet();
  }

  Future<void> nukeLocalData() async {
    await _db.transaction(() async {
      await _db.delete(_db.manifestos).go();
      await _db.delete(_db.manifestoComments).go();
      await _db.delete(_db.posts).go();
      await _db.delete(_db.channels).go();
      await _db.delete(_db.users).go();
    });
    await _db.customStatement('VACUUM');
  }
  // 👑 TAGGING SYSTEM (UI -> LOCAL -> REMOTE)

  /// Stores or updates a tag in the local Native DB.
  Future<void> upsertChannelContentTag(Map<String, dynamic> data) async {
    try {
      await _db
          .into(_db.channelContentTags)
          .insert(
            ChannelContentTagsCompanion.insert(
              id: (data['id'] ?? '') as String,
              postId: (data['post_id'] ?? data['postId'] ?? '') as String,
              userId: (data['user_id'] ?? data['userId'] ?? '') as String,
              sourceChannelId:
                  (data['source_channel_id'] ?? data['sourceChannelId'] ?? '')
                      as String,
              targetChannelId:
                  (data['target_channel_id'] ?? data['targetChannelId'] ?? '')
                      as String,
              linkChain: jsonEncode(
                data['link_chain'] ?? data['linkChain'] ?? [],
              ),
              createdAt: Value(
                data['created_at'] != null
                    ? DateTime.parse(data['created_at'].toString())
                    : DateTime.now(),
              ),
            ),
            mode: InsertMode.insertOrReplace,
          );
      debugPrint('💾 [SQLite] Tag saved locally: ${data['id']}');
    } catch (e) {
      debugPrint('🚨 [SQLite Error] upsertChannelContentTag FAILED: $e');
    }
  }

  /// Retrieves all tags for a specific post from the local cache.
  Future<List<Map<String, dynamic>>> getChannelContentTags(
    String postId,
  ) async {
    final rows =
        await (_db.select(_db.channelContentTags)
              ..where((t) => t.postId.equals(postId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    return rows.map((r) => r.toJson()).toList();
  }

  /// Removes a tag from the local cache.
  Future<void> deleteChannelContentTag(String tagId) async {
    await (_db.delete(
      _db.channelContentTags,
    )..where((t) => t.id.equals(tagId))).go();
    debugPrint('💾 [SQLite] Tag deleted locally: $tagId');
  }
}
