import 'package:drift/drift.dart';

/// Tracks exact users who viewed a status.
class StatusViews extends Table {
  TextColumn get statusId => text().named('status_id')();
  TextColumn get viewerId => text().named('viewer_id')();
  DateTimeColumn get viewedAt => dateTime().nullable().named('viewed_at')();

  @override
  Set<Column> get primaryKey => {statusId, viewerId};
}
