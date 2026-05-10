import 'dart:async';
import 'package:crimchart/core/db/chart_db.dart';
import 'package:crimchart/features/channel/data/sources/channel_remote_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crimchart/core/db/chart_native_db.dart';
import 'package:crimchart/core/di/injection.dart';
import 'package:drift/drift.dart';

final bool _fileLoaded = () {
  print('🚨🚨🚨 [Sync-V3-DNA] UNREAD_COUNT_PROVIDER.DART LOADED 🚨🚨🚨');
  return true;
}();

/// 👑 UNREAD COUNT NOTIFIER (The "Message Pipe" Style)
/// This manages both the SQLite stream and the Supabase background sync in one place.
final unreadCountProviderV2 = StreamProvider.family<int, String>((
  ref,
  channelId,
) async* {
  final db = ChartNativeDB.instance.db;
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  print('🚨🔌 [Sync-V3-DNA] Starting pipe for $channelId (User: $userId)');

  if (userId == null) {
    print('🚨🚫 [Sync-V3-DNA] No User ID, defaulting to 0');
    yield 0;
    return;
  }

  // 1. First, yield whatever is currently in SQLite (Fast UI)
  final initialRow =
      await (db.select(db.channelMembers)
            ..where((t) => t.channelId.equals(channelId))
            ..where((t) => t.userId.equals(userId)))
          .getSingleOrNull();

  final initialCount = initialRow?.unreadCount ?? 0;
  print('🚨💾 [Sync-V3-DNA] Initial SQLite load: $initialCount');
  yield initialCount;

  // 2. Open the Supabase Realtime Pipe (Background Sync)
  final controller = StreamController<int>.broadcast();

  print('🚨📡 [Sync-V3-DNA] Connecting to Supabase stream for $channelId...');
  final subscription = supabase
      .from('channel_members')
      .stream(primaryKey: ['channel_id', 'user_id'])
      .listen((event) async {
        // Filter locally because .eq() on stream can be finicky in some Supabase versions
        final myRow = event
            .where(
              (row) =>
                  row['channel_id'] == channelId && row['user_id'] == userId,
            )
            .firstOrNull;

        if (myRow != null) {
          final count = myRow['unread_count'] as int? ?? 0;
          final momentsCount = myRow['unread_moments_count'] as int? ?? 0;

          print('🚨🛰️ [Sync-V3-DNA] Supabase Event! Unread: $count');

          // Update local DB
          await db
              .into(db.channelMembers)
              .insertOnConflictUpdate(
                ChannelMembersCompanion(
                  channelId: Value(channelId),
                  userId: Value(userId),
                  unreadCount: Value(count),
                  unreadMomentsCount: Value(momentsCount),
                ),
              );

          if (!controller.isClosed) {
            controller.add(count);
          }
        }
      });

  // 3. Also listen to LOCAL DB changes
  final sqliteSub =
      (db.select(db.channelMembers)
            ..where((t) => t.channelId.equals(channelId))
            ..where((t) => t.userId.equals(userId)))
          .watchSingleOrNull()
          .listen((member) {
            if (member != null && !controller.isClosed) {
              print('🚨💾 [Sync-V3-DNA] SQLite change: ${member.unreadCount}');
              controller.add(member.unreadCount);
            }
          });

  ref.onDispose(() {
    print('🚨🔌 [Sync-V3-DNA] Disposing pipe for $channelId');
    subscription.cancel();
    sqliteSub.cancel();
    controller.close();
  });

  yield* controller.stream;
});

/// 👑 UNREAD MOMENTS V2
final unreadMomentsCountProviderV2 = StreamProvider.family<int, String>((
  ref,
  channelId,
) async* {
  final db = ChartNativeDB.instance.db;
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    yield 0;
    return;
  }

  yield* (db.select(db.channelMembers)
        ..where((t) => t.channelId.equals(channelId))
        ..where((t) => t.userId.equals(userId)))
      .watchSingleOrNull()
      .map((member) => member?.unreadMomentsCount ?? 0);
});

/// 👑 Mark as Read Handlers
final markAsReadProvider = Provider<Function(String)>((ref) {
  return (channelId) async {
    print('🔔 [MarkAsRead] Triggered for $channelId');
    // 1. Update Remote
    await getIt<ChannelRemoteSource>().resetUnreadCount(channelId);
  };
});

final markMomentsAsReadProvider = Provider<Function(String)>((ref) {
  return (channelId) async {
    print('🎬 [MarkMomentsAsRead] Triggered for $channelId');
    // 1. Update Remote
    await getIt<ChannelRemoteSource>().resetUnreadMomentsCount(channelId);
  };
});
