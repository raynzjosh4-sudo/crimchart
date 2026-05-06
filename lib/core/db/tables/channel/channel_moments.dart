import 'package:drift/drift.dart';

/// Table for special channel "Moments" (expiring photos/highlights).
class ChannelMoments extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get authorId => text().named('author_id')();
  TextColumn get authorName => text().nullable().named('author_name')();
  TextColumn get authorAvatarUrl => text().nullable().named('author_avatar_url')();
  
  TextColumn get mediaUrl => text().named('media_url')();
  TextColumn get mediaType => text().named('media_type').withDefault(const Constant('photo'))();
  TextColumn get thumbnailUrl => text().nullable().named('thumbnail_url')();
  TextColumn get caption => text().nullable()();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get expiresAt => dateTime().nullable().named('expires_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (channel_id) REFERENCES channels (id) ON DELETE CASCADE'
  ];
}
