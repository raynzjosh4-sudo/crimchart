import 'package:drift/drift.dart';

/// Table for comments on channel posts.
class ChannelPostComments extends Table {
  TextColumn get id => text()();
  TextColumn get postId => text().named('post_id')();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get authorId => text().named('author_id')();
  TextColumn get username => text().nullable()();
  TextColumn get profileImageUrl => text().nullable().named('profile_image_url')();
  
  TextColumn get message => text().named('message')();
  TextColumn get imageUrls => text().nullable().named('image_urls')(); // JSON list
  
  IntColumn get likes => integer().withDefault(const Constant(0)).named('likes')();
  IntColumn get isPending => integer().withDefault(const Constant(0)).named('is_pending')();
  IntColumn get isLiked => integer().withDefault(const Constant(0)).named('is_liked')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (post_id) REFERENCES channel_posts (id) ON DELETE CASCADE'
  ];
}
