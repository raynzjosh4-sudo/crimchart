import 'package:drift/drift.dart';

/// The core Crowns (Polls/Voting) table.
class Crowns extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get crownerId => text().named('crowner_id')();
  TextColumn get channelId => text().nullable().named('channel_id')();
  
  BoolColumn get isActive => boolean().withDefault(const Constant(true)).named('is_active')();
  BoolColumn get hasStatus => boolean().withDefault(const Constant(false)).named('has_status')();
  
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// The options available to vote on within a Crown.
class CrownOptions extends Table {
  TextColumn get id => text()();
  TextColumn get crownId => text().named('crown_id')();
  TextColumn get description => text()();
  
  TextColumn get mediaUrl => text().nullable().named('media_url')();
  TextColumn get mediaType => text().withDefault(const Constant('none')).named('media_type')();
  TextColumn get link => text().nullable()();
  TextColumn get crownedUserId => text().nullable().named('crowned_user_id')();
  
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tracks which user voted for which crown option.
class CrownVotes extends Table {
  TextColumn get id => text()();
  TextColumn get crownId => text().named('crown_id')();
  TextColumn get optionId => text().named('option_id')();
  TextColumn get userId => text().named('user_id')();
  
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
