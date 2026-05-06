import 'package:drift/drift.dart';

/// PENDING MODIFICATIONS based on tables.sql
/// Copy these into their respective files when ready.

// -----------------------------------------------------------------------------
// 1. Update: lib/core/db/tables/channel/channel.dart
// Added missing fields: description, ageRestriction, membersOtherChannels, 
// membersFollowing, preventLeaving, countryRestrictions, allowCommentingBy
// -----------------------------------------------------------------------------
class Channels extends Table {
  TextColumn get id => text()();
  TextColumn get creatorId => text().named('creator_id')();
  TextColumn get name => text()();
  TextColumn get title => text().nullable()();
  TextColumn get subtitle => text().nullable()(); // SQL has description
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable().named('image_url')(); // SQL has avatar_url
  
  // New fields from tables.sql
  TextColumn get ageRestriction => text().withDefault(const Constant('All Ages')).named('age_restriction')();
  BoolColumn get visibleToOtherChannelMembers => boolean().withDefault(const Constant(false)).named('visible_to_other_channel_members')();
  BoolColumn get visibleToFollowedUsers => boolean().withDefault(const Constant(true)).named('visible_to_followed_users')();
  BoolColumn get preventLeaving => boolean().withDefault(const Constant(false)).named('prevent_leaving')();
  TextColumn get countryRestrictions => text().withDefault(const Constant('["Global"]')).named('country_restrictions')();
  TextColumn get allowCommentingBy => text().withDefault(const Constant('all')).named('allow_commenting_by')();

  IntColumn get isPrivate => integer().withDefault(const Constant(0)).named('is_private')();
  TextColumn get joinMethod => text().withDefault(const Constant('invite')).named('join_method')();
  IntColumn get allowComments => integer().withDefault(const Constant(1)).named('allow_comments')();
  
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

// -----------------------------------------------------------------------------
// 2. Update: lib/core/db/tables/channel/channel_post_comments.dart
// Renamed `message` to `commentText` to match SQL `comment_text`.
// -----------------------------------------------------------------------------
class ChannelPostComments extends Table {
  TextColumn get id => text()();
  TextColumn get postId => text().named('post_id')();
  TextColumn get authorId => text().named('author_id')();
  
  TextColumn get commentText => text().named('comment_text')(); // Changed from message
  TextColumn get imageUrls => text().nullable().named('image_urls')(); 
  
  IntColumn get likesCount => integer().withDefault(const Constant(0)).named('likes_count')();
  TextColumn get createdAt => text().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (post_id) REFERENCES channel_posts (id) ON DELETE CASCADE'
  ];
}

// -----------------------------------------------------------------------------
// 3. Update: lib/core/db/tables/channel/channel_statuses.dart
// Added video, audio, privacy, comments, and views support.
// -----------------------------------------------------------------------------
class ChannelStatuses extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get authorId => text().named('author_id')();
  
  TextColumn get caption => text().nullable()();
  TextColumn get imageUrls => text().nullable().named('image_urls')();
  
  // New fields from tables.sql
  TextColumn get videoUrl => text().nullable().named('video_url')();
  TextColumn get audioUrl => text().nullable().named('audio_url')();
  BoolColumn get isVideo => boolean().withDefault(const Constant(false)).named('is_video')();
  BoolColumn get isAudio => boolean().withDefault(const Constant(false)).named('is_audio')();
  TextColumn get privacy => text().withDefault(const Constant('public'))();
  BoolColumn get allowComments => boolean().withDefault(const Constant(true)).named('allow_comments')();
  IntColumn get viewsCount => integer().withDefault(const Constant(0)).named('views_count')();
  IntColumn get likesCount => integer().withDefault(const Constant(0)).named('likes_count')();
  
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get expiresAt => dateTime().nullable().named('expires_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (channel_id) REFERENCES channels (id) ON DELETE CASCADE'
  ];
}
