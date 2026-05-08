import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/core/db/chart_native_db.dart';

/// 👑 The Centralized Rule File for Channel Membership
/// Watches the local Drift database for instant, offline-first membership status
final isMemberProvider = StreamProvider.autoDispose.family<bool, String>((
  ref,
  channelId,
) {
  final currentUser = ref.watch(authControllerProvider).user;

  if (currentUser == null) {
    return Stream.value(false);
  }

  // 👑 Unified Membership Rule: True if user is a member OR the creator
  final db = ChartNativeDB.instance.db;

  final query =
      db.select(db.channels).join([
        leftOuterJoin(
          db.channelMembers,
          db.channelMembers.channelId.equalsExp(db.channels.id) &
              db.channelMembers.userId.equals(currentUser.id),
        ),
        leftOuterJoin(
          db.channelBranding,
          db.channelBranding.channelId.equalsExp(db.channels.id),
        ),
      ])..where(
        db.channels.id.equals(channelId) &
            (db.channelBranding.creatorId.equals(currentUser.id) |
                db.channelMembers.userId.isNotNull()),
      );

  return query.watch().map((rows) => rows.isNotEmpty);
});
