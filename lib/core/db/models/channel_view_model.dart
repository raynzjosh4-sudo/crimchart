import '../chart_db.dart';

/// A unified Domain Model (Domel) that aggregates data from modular tables.
/// This is what the UI widgets will consume.
class ChannelViewModel {
  final Channel channel;
  final ChannelMetadataData metadata;
  final ChannelBrandingData branding;
  final ChannelCreatorData creator;
  final List<ChannelMember> members;
  final List<ChannelPost> posts;
  final List<ChannelStatuse> statuses;

  ChannelViewModel({
    required this.channel,
    required this.metadata,
    required this.branding,
    required this.creator,
    this.members = const [],
    this.posts = const [],
    this.statuses = const [],
  });

  // UI Helper Getters
  String get name => channel.name ?? 'Unknown Channel';
  String get title => channel.title ?? name;
  String get subtitle => channel.subtitle ?? '';
  String get imageUrl => channel.imageUrl ?? '';

  int get memberCount => metadata.memberCount ?? 0;
  int get unreadMessages => metadata.messagesBadgeCount;
  int get unreadPosts => metadata.postsBadgeCount;

  bool get isVerified => creator.isVerified == 1;
}
