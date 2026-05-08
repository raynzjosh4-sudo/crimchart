import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/channel/pages/messages_tab/messages_tab_view.dart';
import 'package:crimchart/features/channel/pages/messages_tab/widgets/active_users_bar.dart';
import 'package:crimchart/features/channel/pages/messages_tab/models/user_model.dart';
import 'package:crimchart/features/channel/application/channel_members_provider.dart';
import 'package:crimchart/profile/models/charter_model.dart';
import 'package:crimchart/backicon/custom_back_button.dart';

class MessagesPage extends ConsumerWidget {
  final String channelId;
  final String channelName;
  final List<CharterModel> contestants;
  final bool initialIsMember;

  const MessagesPage({
    super.key,
    required this.channelId,
    required this.channelName,
    this.contestants = const [],
    this.initialIsMember = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;

    final presenceMap = ref
        .watch(channelPresenceProvider(channelId))
        .maybeWhen(data: (map) => map, orElse: () => <String, bool>{});

    final membersAsync = ref.watch(channelMembersProvider(channelId));
    final rawMembers = membersAsync.maybeWhen(
      data: (m) => m,
      orElse: () => <CharterModel>[],
    );

    final List<ChatUser> activeUsers = rawMembers
        .map(
          (m) => ChatUser(
            id: m.id,
            name: m.displayName,
            profileImageUrl: m.profileImageUrl,
            isVerified: m.title == 'Top' || m.title == 'Star',
            followersCount: m.chartCount,
            channelsCount: m.channelCount,
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: backgroundColor,
            surfaceTintColor: backgroundColor,
            forceElevated: true,
            elevation: 0,
            titleSpacing: 0,
            pinned: true,
            leading: CustomBackButton(
              color: colorScheme.onSurface,
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text(
              channelName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 24.sp,
                letterSpacing: -0.5,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(110.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActiveUsersBar(
                    users: activeUsers,
                    onlineUserIds: presenceMap.keys.toSet(),
                    typingMap: presenceMap,
                  ),
                  Divider(
                    height: 1,
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                  ),
                ],
              ),
            ),
          ),
          MessagesTabView(
            key: ValueKey(
              channelId,
            ), // 👑 Key preservation for scroll stability
            channelId: channelId,
            members: contestants,
            initialIsMember: initialIsMember,
          ),
        ],
      ),
    );
  }
}
