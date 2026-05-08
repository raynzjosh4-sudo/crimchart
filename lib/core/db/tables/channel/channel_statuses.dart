import 'package:drift/drift.dart';

/// Table for statuses/stories posted specifically within a channel.
class ChannelStatuses extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get authorId => text().named('author_id')();
  
  TextColumn get caption => text().nullable()();
  TextColumn get imageUrls => text().nullable().named('image_urls')(); // JSON string
  TextColumn get videoUrl => text().nullable().named('video_url')();
  TextColumn get thumbnailUrl => text().nullable().named('thumbnail_url')();
  TextColumn get audioUrl => text().nullable().named('audio_url')();
  
  IntColumn get isVideo => integer().withDefault(const Constant(0)).named('is_video')();
  IntColumn get isAudio => integer().withDefault(const Constant(0)).named('is_audio')();
  
  IntColumn get viewsCount => integer().withDefault(const Constant(0)).named('views_count')();
  IntColumn get likesCount => integer().withDefault(const Constant(0)).named('likes_count')();
  IntColumn get commentsCount => integer().withDefault(const Constant(0)).named('comments_count')();
  
  TextColumn get createdAt => text().nullable().named('created_at')();
  TextColumn get expiresAt => text().nullable().named('expires_at')();

  // 👑 PROFILE DATA (For offline visibility)
  TextColumn get username => text().nullable()();
  TextColumn get profileImageUrl => text().nullable().named('profile_image_url')();

  @override
  Set<Column> get primaryKey => {id};
}
