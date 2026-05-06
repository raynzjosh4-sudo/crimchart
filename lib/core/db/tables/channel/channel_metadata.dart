import 'package:drift/drift.dart';

/// Table for dynamic channel metadata and status flags.
class ChannelMetadata extends Table {
  TextColumn get channelId => text()();
  
  IntColumn get memberCount => integer().nullable().withDefault(const Constant(0))();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  
  // Badge counts for UI tabs
  IntColumn get postsBadgeCount => integer().withDefault(const Constant(0)).named('posts_badge_count')();
  IntColumn get membersBadgeCount => integer().withDefault(const Constant(0)).named('members_badge_count')();
  IntColumn get messagesBadgeCount => integer().withDefault(const Constant(0)).named('messages_badge_count')();

  IntColumn get isCharted => integer().withDefault(const Constant(0))();
  IntColumn get isPending => integer().withDefault(const Constant(0))();
  
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {channelId};
}
