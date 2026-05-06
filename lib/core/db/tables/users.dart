import 'package:drift/drift.dart';

/// Users table matching the legacy sqflite schema.
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get profileImageUrl => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get title => text().nullable()();
  IntColumn get isVerified => integer().nullable()();
  IntColumn get followersCount => integer().nullable()();
  IntColumn get followingCount => integer().nullable()();
  IntColumn get postsCount => integer().nullable()();
  IntColumn get chartsCount => integer().nullable().named('ChartsCount')();
  IntColumn get channelsCount => integer().nullable().named('channelsCount')();
  TextColumn get chartTitle => text().nullable().named('ChartTitle')(); // Handle legacy name
  TextColumn get birthday => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get accessToken => text().nullable()();
  TextColumn get refreshToken => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
