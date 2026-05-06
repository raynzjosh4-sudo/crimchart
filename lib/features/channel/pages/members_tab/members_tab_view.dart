import 'package:crown/commentingsheets/widgets/commenting_sheet.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/channel/pages/discovery_widgets/members_story_bar.dart';
import 'package:flutter/material.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:crown/features/channel/pages/members_tab/widgets/member_list_item.dart';
import 'package:crown/mainFeed/features/cardwidgets/storychacrdwidget/status_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/features/channel/application/channel_statuses_provider.dart';
import 'package:crown/features/channel/application/channel_members_provider.dart';
import 'package:crown/features/channel/pages/members_tab/widgets/channel_invitation_card.dart';
import 'package:crown/features/channel/channelsettings/channelinsidesettingspage/select_charter_page.dart';
import 'package:crown/profile/pages/profile_page.dart';
import 'package:crown/features/widgets/shimmer/membershimmer.dart';
import 'package:crown/features/widgets/offline/offline_view.dart';

class MembersTabView extends ConsumerWidget {
  final String channelId;
  final String? channelName;
  final String? channelImageUrl;
  final bool canPostStatus;
  final String allowInvitationsBy;

  const MembersTabView({
    super.key,
    required this.channelId,
    this.channelName,
    this.channelImageUrl,
    this.canPostStatus = true,
    this.allowInvitationsBy = 'all',
    List<CharterModel>? members,
  });

  void _openStatusSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentingSheet(
        channelId: channelId,
        channelName: channelName,
        isStatus: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(channelMembersProvider(channelId));
    final statusesAsync = ref.watch(channelStatusesProvider(channelId));
    final statuses = statusesAsync.valueOrNull ?? [];

    return membersAsync.when(
      loading: () => const SliverFillRemaining(
        child: MemberPageShimmer(),
      ),
      error: (err, stack) => SliverFillRemaining(
        child: OfflineView(
          type: OfflinePageType.members,
          onRetry: () => ref.invalidate(channelMembersProvider(channelId)),
        ),
      ),
      data: (allMembers) {
        final sortedMembers = [...allMembers]
          ..sort((a, b) {
            if (a.isMe) return -1;
            if (b.isMe) return 1;
            if (a.role == 'admin' && b.role != 'admin') return -1;
            if (b.role == 'admin' && a.role != 'admin') return 1;
            return 0;
          });

        // 👑 FLUSH BUT ACCESSIBLE: A single SliverList that respects the bottom safe area.
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            // 0: Story Bar
            if (index == 0) {
              return MembersStoryBar(
                statuses: statuses,
                onAddStory: () => _openStatusSheet(context),
                canPostStatus: canPostStatus,
              );
            }

            // 1: Section Header
            if (index == 1) {
              return Padding(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Members',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // 2 to N+1: Member Items
            if (index < sortedMembers.length + 2) {
              final member = sortedMembers[index - 2];
              final memberStatus = statuses
                  .where((s) => s.authorId == member.id)
                  .toList();
              final hasStatus = memberStatus.isNotEmpty;
              final statusCount = hasStatus
                  ? memberStatus.first.imageUrls.length
                  : 0;

              return MemberListItem(
                id: member.id,
                name: member.displayName,
                profileImageUrl: member.profileImageUrl,
                subtitle: member.isMe
                    ? 'You (${member.role})'
                    : (member.role == 'admin'
                          ? 'Admin'
                          : '${(member.channelCount * 1.2).toInt()}K followers'),
                hasStatus: hasStatus,
                statusCount: statusCount,
                showFollow: !member.isMe,
                onAvatarTap: hasStatus
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StatusPage(status: memberStatus.first),
                          ),
                        );
                      }
                    : null,
                onAddFriend: member.isMe
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                ProfilePage(userId: member.id),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: animation.drive(Tween(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeOutCubic))),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 350),
                          ),
                        );
                      },
              );
            }

            // N+2: Invitation Card — only shown if invitations are allowed
            if (index == sortedMembers.length + 2) {
              if (allowInvitationsBy == 'none') {
                return SizedBox(height: 80.h);
              }
              return ChannelInvitationCard(
                channelName: channelName,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectCharterPage(
                        channelId: channelId,
                        channelName: channelName ?? '',
                        channelImageUrl: channelImageUrl,
                      ),
                    ),
                  );
                },
              );
            }

            // 👑 FINAL PADDING: Add a small space so it's not "too down"
            if (index == sortedMembers.length + 3) {
              return SizedBox(height: 80.h);
            }

            return null;
          }, childCount: sortedMembers.length + 4),
        );
      },
    );
  }
}
