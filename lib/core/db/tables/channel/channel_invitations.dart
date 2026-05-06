import 'package:drift/drift.dart';
import 'channel.dart';
import '../users.dart';

@DataClassName('ChannelInvitation')
class ChannelInvitations extends Table {
  TextColumn get id => text()();
  TextColumn get senderId => text().references(Users, #id)();
  TextColumn get sourceChannelId => text().references(Channels, #id)(); // Where it's posted
  TextColumn get targetChannelId => text().references(Channels, #id)(); // Being invited to
  TextColumn get createdAt => text().nullable()();
  IntColumn get isPending => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
