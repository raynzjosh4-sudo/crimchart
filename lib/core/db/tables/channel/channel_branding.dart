import 'package:drift/drift.dart';

/// Table for channel-specific branding assets and social identity.
class ChannelBranding extends Table {
  TextColumn get channelId => text()();
  
  TextColumn get leaderAvatarUrl => text().nullable().named('leader_avatar_url')();
  TextColumn get creatorAvatarUrl => text().nullable().named('creator_avatar_url')();
  TextColumn get creatorId => text().nullable().named('creator_id')();
  
  // Custom branding colors or themes could go here too
  TextColumn get themeColor => text().nullable()();

  @override
  Set<Column> get primaryKey => {channelId};
}
