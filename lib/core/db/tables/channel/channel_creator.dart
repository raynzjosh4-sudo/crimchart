import 'package:drift/drift.dart';

/// Table specifically for the channel creator's profile data as seen in the UI.
class ChannelCreator extends Table {
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get creatorId => text().named('creator_id')();
  
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable().named('avatar_url')();
  
  IntColumn get isVerified => integer().withDefault(const Constant(0)).named('is_verified')();
  IntColumn get isFollowing => integer().withDefault(const Constant(0)).named('is_following')();
  
  // Role description (e.g., "Channel Creator", "Owner")
  TextColumn get roleTitle => text().withDefault(const Constant('Channel Creator')).named('role_title')();

  @override
  Set<Column> get primaryKey => {channelId};
}
