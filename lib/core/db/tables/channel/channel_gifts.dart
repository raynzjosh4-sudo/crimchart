import 'package:drift/drift.dart';

/// Tracks gifts/coins sent within a channel.
class ChannelGifts extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text().named('channel_id')();
  TextColumn get giverId => text().named('giver_id')();
  TextColumn get receiverId => text().named('receiver_id')();
  TextColumn get giftId => text().named('gift_id')();
  
  IntColumn get coinValue => integer().withDefault(const Constant(0)).named('coin_value')();
  DateTimeColumn get receivedAt => dateTime().nullable().named('received_at')();
  
  TextColumn get messageId => text().nullable().named('message_id')(); // FK to channel_messages

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (message_id) REFERENCES channel_messages (id) ON DELETE SET NULL',
    'FOREIGN KEY (channel_id, giver_id) REFERENCES channel_members (channel_id, user_id) ON DELETE CASCADE'
  ];
}
