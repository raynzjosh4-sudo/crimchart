import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../core/utils/cache_manager.dart';
import 'subsettings/exportsettings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('settings')),
      body: ListView(
        children: [
          _buildSectionHeader(context, context.tr('who_can_see_content')),
          _buildSettingsItem(
            context,
            LucideIcons.lock,
            context.tr('account_privacy'),
            trailingText: context.tr('public'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountPrivacyPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.ban,
            context.tr('blocked'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlockedPage()),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.camera,
            context.tr('hide_story'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HideStoryPage()),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.eyeOff,
            context.tr('visibility_off_Chart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisibilityOffChartPage(),
                ),
              );
            },
          ),

          Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.05)),

          _buildSectionHeader(context, context.tr('how_others_interact')),
          _buildSettingsItem(
            context,
            LucideIcons.send,
            context.tr('messages_story_reuse'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagesStoryRepliesPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.messageCircle,
            context.tr('comments'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommentControlsPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.refreshCw,
            context.tr('sharing_reuse'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SharingReusePage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.minusCircle,
            context.tr('restricted_channels'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RestrictedChannelsPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.type,
            context.tr('hidden_words'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HiddenWordsPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.userCheck,
            context.tr('contacts_syncing'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactsSyncingPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.userPlus,
            context.tr('join_invite'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FollowInvitePage(),
                ),
              );
            },
          ),

          Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.05)),

          _buildSectionHeader(context, context.tr('app_and_media')),
          _buildSettingsItem(
            context,
            LucideIcons.palette,
            context.tr('theme'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemePage()),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.type,
            context.tr('fonts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FontSelectionPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.maximize,
            context.tr('display_text_size'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DisplaySettingsPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.globe,
            context.tr('language'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguagePage()),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.refreshCw,
            context.tr('data_saver'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataSaverPage()),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.downloadCloud,
            context.tr('download_data'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadDataPage(),
                ),
              );
            },
          ),

          Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.05)),

          _buildSectionHeader(context, context.tr('more_info_support')),
          _buildSettingsItem(
            context,
            LucideIcons.lifeBuoy,
            context.tr('help'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
          _buildSettingsItem(
            context,
            LucideIcons.info,
            context.tr('about'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),

          Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.05)),

          _buildSectionHeader(context, "Developer Tools (Debug)"),
          ListTile(
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("🚀 Nuking local database and cache..."),
                  backgroundColor: Colors.amber,
                ),
              );
              await CacheManager.performFullSystemClean();
              debugPrint('🏁 Clean Complete.');
            },
            leading: Icon(LucideIcons.bug, color: Colors.yellow, size: 22.sp),
            title: Text(
              "Nuke Local Cache",
              style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
            ),
            subtitle: Text(
              "Wipes SQLite tables & image files",
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 12.sp,
              ),
            ),
            trailing: Icon(
              LucideIcons.chevronRight,
              color: colorScheme.onSurface.withOpacity(0.3),
              size: 18.sp,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          ),

          Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.05)),

          _buildSectionHeader(context, context.tr('login')),
          _buildTextButton(
            context,
            context.tr('add_account'),
            color: colorScheme.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAccountPage()),
              );
            },
          ),
          _buildTextButton(
            context,
            context.tr('switch_account'),
            color: colorScheme.primary,
            onTap: () {},
          ),
          _buildTextButton(
            context,
            context.tr('log_out'),
            color: colorScheme.error,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const LogoutSheet(),
              );
            },
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title, {
    required VoidCallback onTap,
    bool showChevron = true,
    String? trailingText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: colorScheme.primary, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 14.sp,
              ),
            ),
          if (showChevron) ...[
            SizedBox(width: 8.w),
            Icon(
              LucideIcons.chevronRight,
              color: colorScheme.onSurface.withOpacity(0.3),
              size: 18.sp,
            ),
          ],
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    String title, {
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}
