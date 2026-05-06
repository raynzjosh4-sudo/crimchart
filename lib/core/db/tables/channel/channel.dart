import 'package:drift/drift.dart';

/// Core Channel table for identity and settings.
class Channels extends Table {
  TextColumn get id => text()();
  
  // Identity
  TextColumn get name => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get subtitle => text().nullable().named('description')();
  TextColumn get imageUrl => text().nullable().named('avatar_url')();
  
  // Settings
  IntColumn get isPrivate => integer().withDefault(const Constant(0))();
  TextColumn get ageRestriction => text().withDefault(const Constant('All Ages')).named('age_restriction')();
  TextColumn get joinMethod => text().withDefault(const Constant('invite')).named('join_method')();
  IntColumn get preventLeaving => integer().withDefault(const Constant(0)).named('prevent_leaving')();
  TextColumn get countryRestrictions => text().withDefault(const Constant('["Global"]')).named('country_restrictions')();
  TextColumn get allowCommentingBy => text().withDefault(const Constant('all')).named('allow_commenting_by')();
  TextColumn get allowStatusPostingBy => text().withDefault(const Constant('all')).named('allow_status_posting_by')();
  TextColumn get allowInvitationsBy => text().withDefault(const Constant('all')).named('allow_invitations_by')();
  IntColumn get visibleToOtherChannelMembers => integer().withDefault(const Constant(0)).named('visible_to_other_channel_members')();
  IntColumn get visibleToFollowedUsers => integer().withDefault(const Constant(1)).named('visible_to_followed_users')();
  IntColumn get isDiscoverable => integer().withDefault(const Constant(1)).named('is_discoverable')();
  
  // Stats
  IntColumn get membersCount => integer().withDefault(const Constant(1)).named('members_count')();
  IntColumn get followersCount => integer().withDefault(const Constant(0)).named('followers_count')();
  IntColumn get tagsCount => integer().withDefault(const Constant(0)).named('tags_count')();
  IntColumn get likesCount => integer().withDefault(const Constant(0)).named('likes_count')();

  @override
  Set<Column> get primaryKey => {id};
}
