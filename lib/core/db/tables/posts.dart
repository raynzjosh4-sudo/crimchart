import 'package:drift/drift.dart';

/// Posts table matching the legacy sqflite schema.
class Posts extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text().nullable().named('author_id')();
  TextColumn get username => text().nullable()();
  TextColumn get userProfileImageUrl => text().nullable()();
  TextColumn get channelName => text().nullable()();
  TextColumn get channelId => text().nullable()();
  TextColumn get caption => text().nullable()();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get videoUrls => text().withDefault(const Constant('[]')).named('video_urls')();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get sdVideoUrl => text().nullable()();
  TextColumn get imageUrls => text().nullable()();
  TextColumn get thumbnailUrls => text().nullable()();
  IntColumn get isVideo => integer().nullable()();
  IntColumn get isAudio => integer().nullable()();
  TextColumn get folderName => text().withDefault(const Constant('public_posts')).named('folder_name')();
  RealColumn get aspectRatio => real().nullable()();
  IntColumn get likes => integer().nullable()();
  IntColumn get comments => integer().nullable()();
  TextColumn get timeAgo => text().nullable()();
  TextColumn get createdAt => text().nullable().named('createdAt')();
  IntColumn get shares => integer().nullable()();
  IntColumn get isLiked => integer().nullable()();
  IntColumn get chartedCount => integer().nullable()();
  TextColumn get localFileCache => text().nullable()();
  IntColumn get isPending => integer().withDefault(const Constant(0))();
  TextColumn get linkedPostId => text().nullable().named('linked_post_id')();
  TextColumn get linkedAuthorUsername => text().nullable().named('linked_author_username')();
  TextColumn get linkedCaption => text().nullable().named('linked_caption')();
  TextColumn get linkedChannelId => text().nullable().named('linked_channel_id')();
  TextColumn get postType => text().withDefault(const Constant('post')).named('post_type')();
  TextColumn get parentPostId => text().nullable().named('parent_post_id')();
  TextColumn get linkChain => text().withDefault(const Constant('[]')).named('link_chain')();
  IntColumn get linkDepth => integer().withDefault(const Constant(0)).named('link_depth')();
  IntColumn get isPublic => integer().withDefault(const Constant(1)).named('is_public')();
  IntColumn get allowComments => integer().withDefault(const Constant(1)).named('allow_comments')();

  @override
  Set<Column> get primaryKey => {id};
}
