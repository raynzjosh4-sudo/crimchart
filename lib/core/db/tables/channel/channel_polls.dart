import 'package:drift/drift.dart';

/// Table for community polls/votes within a channel message.
class ChannelPolls extends Table {
  TextColumn get id => text()();
  TextColumn get messageId => text().named('message_id')(); // FK to channel_messages
  TextColumn get title => text()();
  
  IntColumn get totalPoints => integer().withDefault(const Constant(0)).named('total_points')();
  IntColumn get isClosed => integer().withDefault(const Constant(0)).named('is_closed')();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (message_id) REFERENCES channel_messages (id) ON DELETE CASCADE'
  ];
}
