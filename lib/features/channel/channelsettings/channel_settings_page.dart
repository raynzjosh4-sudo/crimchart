import 'package:flutter/material.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'widgets/settings_common.dart';
import 'widgets/channel_header.dart';
import 'widgets/management_section.dart';
import 'widgets/allmember/members_horizontal_list.dart';
import 'insidesettingspage/all_members_page.dart';
import 'channelinsidesettingspage/channel_settings_detailed_page.dart';
import 'package:crown/features/newinsidechartstartpage/models/member.dart';
import 'package:intl/intl.dart';

class ChannelSettingsPage extends StatelessWidget {
  final String channelId;
  final String channelTitle;
  final String? staterAvatarUrl;
  final String? description;
  final int memberCount;
  final List<Member> members;
  final DateTime createdAt;
  final String? ageRestriction;
  final bool visibleToOtherChannelMembers;
  final bool visibleToFollowedUsers;
  final String joinMethod;
  final bool preventLeaving;
  final List<String> countryRestrictions;
  final String allowCommentingBy;
  final String allowStatusPostingBy;
  final String allowInvitationsBy;

  const ChannelSettingsPage({
    super.key,
    required this.channelId,
    required this.channelTitle,
    required this.memberCount,
    required this.createdAt,
    this.staterAvatarUrl,
    this.description,
    this.members = const [],
    this.ageRestriction,
    this.visibleToOtherChannelMembers = false,
    this.visibleToFollowedUsers = true,
    this.joinMethod = 'invite',
    this.preventLeaving = false,
    this.countryRestrictions = const ['Global'],
    this.allowCommentingBy = 'all',
    this.allowStatusPostingBy = 'all',
    this.allowInvitationsBy = 'all',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: 'Channel Details',
        showBack: true,
        actions: [
          IconButton(
            icon: Icon(LucideIcons.share2, size: 20.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section with Gradient Overlay
            Container(
              padding: EdgeInsets.only(top: 24.h, bottom: 32.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.1),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: ChannelHeader(
                channelId: channelId,
                title: channelTitle,
                avatarUrl: staterAvatarUrl ?? '',
                followerCountText: '$memberCount members',
                description: description ?? '',
                createdAt: createdAt,
              ),
            ),

            // Created Date Display
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 14.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Created on ${DateFormat('MMMM d, yyyy').format(createdAt)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Section 1: Community Insights
            if (members.isNotEmpty) ...[
              _buildSectionHeader('COMMUNITY'),
              SettingsSection(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: MembersHorizontalList(
                      members: members,
                      title: 'MEMBERS',
                      showChannels: false,
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllMembersPage(
                              members: members,
                              title: 'Members',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],

            // Section 2: Control Center
            _buildSectionHeader('CONTROL CENTER'),
            SettingsSection(
              children: [
                SettingsTile(
                  icon: LucideIcons.bell,
                  title: 'Notifications',
                  subtitle: 'Custom sounds and visual alerts',
                  trailing: Switch.adaptive(
                    value: true,
                    onChanged: (v) {},
                    activeColor: colorScheme.primary,
                  ),
                ),
                SettingsTile(
                  icon: LucideIcons.settings2,
                  title: 'Privacy and Permissions',
                  subtitle: 'Who can join and see content',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChannelSettingsDetailedPage(
                          channelId: channelId,
                          initialAge: ageRestriction ?? 'All Ages',
                          initialVisibleToOtherChannelMembers: visibleToOtherChannelMembers,
                          initialVisibleToFollowedUsers: visibleToFollowedUsers,
                          initialJoinMethod: joinMethod,
                          initialPreventLeaving: preventLeaving,
                          initialCountryRestrictions: countryRestrictions,
                          initialAllowCommentingBy: allowCommentingBy,
                          initialAllowStatusPostingBy: allowStatusPostingBy,
                          initialAllowInvitationsBy: allowInvitationsBy,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Section 3: Management
            _buildSectionHeader('MANAGEMENT'),
            SettingsSection(children: [ManagementSection(followers: members)]),

            // Section 4: Danger Zone
            _buildSectionHeader('DANGER ZONE'),
            SettingsSection(
              children: [
                SettingsTile(
                  icon: LucideIcons.logOut,
                  title: 'Leave Channel',
                  color: Colors.orange,
                  onTap: () {},
                ),
                SettingsTile(
                  icon: LucideIcons.trash2,
                  title: 'Delete channel',
                  color: Colors.redAccent,
                  onTap: () {},
                ),
                SettingsTile(
                  icon: LucideIcons.thumbsDown,
                  title: 'Report channel',
                  color: Colors.redAccent,
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 12.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
            ),
          ),
        );
      },
    );
  }
}
