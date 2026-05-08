import 'package:drift/drift.dart';

/// Elite Tagging Table: Stores the trail of channel tags for posts.
/// Syncs with Supabase table 'channel_content_tags'.
class ChannelContentTags extends Table {
  TextColumn get id => text()(); // UUID from Supabase
  TextColumn get postId => text().named('post_id')();
  TextColumn get userId => text().named('user_id')();
  TextColumn get sourceChannelId => text().named('source_channel_id')();
  TextColumn get targetChannelId => text().named('target_channel_id')();
  
  /// Stores the link chain as a JSON-encoded list of channel IDs
  TextColumn get linkChain => text().named('link_chain')();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
