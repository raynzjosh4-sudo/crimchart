import 'package:drift/drift.dart';

/// Manifestos table.
class Manifestos extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text().named('author_id')();
  TextColumn get username => text().nullable()();
  TextColumn get profileImageUrl => text().nullable()();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get caption => text().nullable()();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get videoUrls => text().withDefault(const Constant('[]'))();
  TextColumn get imageUrls => text().nullable()();
  TextColumn get thumbnailUrls => text().nullable()();
  IntColumn get likes => integer().withDefault(const Constant(0))();
  IntColumn get comments => integer().withDefault(const Constant(0))();
  IntColumn get isPublic => integer().withDefault(const Constant(1)).named('is_public')();
  IntColumn get allowComments => integer().withDefault(const Constant(1)).named('allow_comments')();
  IntColumn get isPending => integer().withDefault(const Constant(0))();
  IntColumn get isLiked => integer().withDefault(const Constant(0)).named('is_liked')();
  RealColumn get aspectRatio => real().nullable().named('aspect_ratio')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
