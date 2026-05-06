import 'package:drift/drift.dart';

/// Table for tracking real-time user state (online, typing) within a channel.
class ChannelPresence extends Table {
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get userId => text().named('user_id')();
  
  IntColumn get isOnline => integer().withDefault(const Constant(0)).named('is_online')();
  IntColumn get isTyping => integer().withDefault(const Constant(0)).named('is_typing')();
  TextColumn get lastSeen => text().nullable().named('last_seen')();
  
  // Cache user info for quick access in message lists
  TextColumn get lastKnownName => text().nullable().named('last_known_name')();
  TextColumn get lastKnownAvatar => text().nullable().named('last_known_avatar')();

  @override
  Set<Column> get primaryKey => {channelId, userId};
}
