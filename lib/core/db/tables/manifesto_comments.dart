import 'package:drift/drift.dart';

/// Manifesto Comments table.
class ManifestoComments extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text().named('author_id')();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get manifestoId => text().named('manifesto_id')();
  TextColumn get message => text().nullable()();
  TextColumn get imageUrls => text().withDefault(const Constant('[]'))();
  IntColumn get likes => integer().withDefault(const Constant(0))();
  IntColumn get isPending => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
