import 'package:drift/drift.dart';

/// Table to cache common channels, linked to the ChannelMembers logic.
class CommonChannels extends Table {
  // These IDs should exist in the ChannelMembers table for the respective channelId
  TextColumn get userId => text().named('user_id')();
  TextColumn get otherUserId => text().named('other_user_id')();
  TextColumn get channelId => text().named('channel_id')();

  @override
  Set<Column> get primaryKey => {userId, otherUserId, channelId};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (channel_id) REFERENCES channels (id) ON DELETE CASCADE',
    'FOREIGN KEY (channel_id, user_id) REFERENCES channel_members (channel_id, user_id) ON DELETE CASCADE',
    'FOREIGN KEY (channel_id, other_user_id) REFERENCES channel_members (channel_id, user_id) ON DELETE CASCADE',
  ];
}
