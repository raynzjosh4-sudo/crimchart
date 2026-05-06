import 'package:drift/drift.dart';

/// Table for tags associated with channel posts.
class ChannelPostTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get postId => text().named('post_id')();
  
  TextColumn get tagName => text().named('tag_name')();
  TextColumn get tagValue => text().nullable().named('tag_value')();
  
  // Optional: color or icon for the tag
  TextColumn get tagColor => text().nullable().named('tag_color')();

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (post_id) REFERENCES channel_posts (id) ON DELETE CASCADE'
  ];
}
