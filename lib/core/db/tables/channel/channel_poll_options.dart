import 'package:drift/drift.dart';

/// Table for specific options within a poll (e.g. Project A, Project B).
class ChannelPollOptions extends Table {
  TextColumn get id => text()();
  TextColumn get pollId => text().named('poll_id')(); // FK to channel_polls
  
  TextColumn get title => text()();
  TextColumn get mediaUrl => text().nullable().named('media_url')(); // Image/Video URL
  TextColumn get mediaType => text().nullable().withDefault(const Constant('image')).named('media_type')();
  
  IntColumn get points => integer().withDefault(const Constant(0)).named('points')();
  TextColumn get suggestedBy => text().nullable().named('suggested_by')(); // User ID
  
  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (poll_id) REFERENCES channel_polls (id) ON DELETE CASCADE'
  ];
}
