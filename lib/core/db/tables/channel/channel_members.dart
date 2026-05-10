import 'package:drift/drift.dart';

/// The central Member table that links users to the main Channels table.
class ChannelMembers extends Table {
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get userId => text().named('user_id')();
  
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn get joinedAt => dateTime().nullable().named('joined_at')();
  IntColumn get unreadCount => integer().withDefault(const Constant(0)).named('unread_count')();
  IntColumn get unreadMomentsCount => integer().withDefault(const Constant(0)).named('unread_moments_count')();

  @override
  Set<Column> get primaryKey => {channelId, userId};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (channel_id) REFERENCES channels (id) ON DELETE CASCADE'
  ];
}
