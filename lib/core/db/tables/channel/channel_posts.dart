import 'package:drift/drift.dart';

/// Modular table for posts within a channel.
class ChannelPosts extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get authorId => text().named('author_id')();
  TextColumn get username => text().nullable()();
  TextColumn get profileImageUrl => text().nullable().named('profile_image_url')();
  
  TextColumn get caption => text().nullable()();
  TextColumn get imageUrls => text().nullable().named('image_urls')(); // JSON list
  TextColumn get videoUrl => text().nullable().named('video_url')();
  TextColumn get videoUrls => text().nullable().named('video_urls')(); // JSON list
  TextColumn get thumbnailUrls => text().nullable().named('thumbnail_urls')(); // JSON list
  
  IntColumn get isVideo => integer().withDefault(const Constant(0)).named('is_video')();
  IntColumn get isSponsored => integer().withDefault(const Constant(0)).named('is_sponsored')();
  RealColumn get aspectRatio => real().nullable().named('aspect_ratio')();
  
  IntColumn get likes => integer().withDefault(const Constant(0)).named('likes')();
  IntColumn get comments => integer().withDefault(const Constant(0)).named('comments')();
  IntColumn get shares => integer().withDefault(const Constant(0)).named('shares')();
  
  IntColumn get isPublic => integer().withDefault(const Constant(1)).named('is_public')();
  IntColumn get allowComments => integer().withDefault(const Constant(1)).named('allow_comments')();
  IntColumn get isPending => integer().withDefault(const Constant(0)).named('is_pending')();
  IntColumn get isLiked => integer().withDefault(const Constant(0)).named('is_liked')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  // 👑 For Cross-Channel Invitations & Extensibility
  TextColumn get postType => text().nullable().withDefault(const Constant('post')).named('post_type')();
  TextColumn get metadata => text().nullable().named('metadata')(); // JSON map

  @override
  Set<Column> get primaryKey => {id};
}
