import 'package:drift/drift.dart';

/// Table for group chat messages within a channel.
class ChannelMessages extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get senderId => text().named('sender_id')();
  
  TextColumn get textContent => text().nullable().named('text_content')();
  TextColumn get mediaUrl => text().nullable().named('media_url')();
  TextColumn get thumbnailUrl => text().nullable().named('thumbnail_url')();
  TextColumn get mediaType => text().nullable().named('media_type')(); // image, video, file
  TextColumn get voiceNoteUrl => text().nullable().named('voice_note_url')();
  
  TextColumn get replyToId => text().nullable().named('reply_to_id')();
  
  IntColumn get isRead => integer().withDefault(const Constant(0)).named('is_read')();
  IntColumn get isPending => integer().withDefault(const Constant(0)).named('is_pending')();
  
  TextColumn get messageType => text().withDefault(const Constant('text')).named('message_type')();
  TextColumn get metadata => text().nullable().named('metadata')(); // JSON for polls, etc.
  
  TextColumn get createdAt => text().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (channel_id) REFERENCES channels (id) ON DELETE CASCADE',
    'FOREIGN KEY (channel_id, sender_id) REFERENCES channel_members (channel_id, user_id) ON DELETE CASCADE'
  ];
}
