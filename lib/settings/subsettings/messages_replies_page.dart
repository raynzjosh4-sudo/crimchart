import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'exportsettings.dart';

class MessagesStoryRepliesPage extends StatelessWidget {
  const MessagesStoryRepliesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('messages_story_reuse')),
      body: ListView(
        children: [
          _buildSectionHeader(context, context.tr('how_people_reach_you')),
          _buildItem(
            context,
            context.tr('message_inbox_request'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliverRequestsPage(),
                ),
              );
            },
          ),
          _buildItem(
            context,
            context.tr('story_reuse'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StoryReusePage()),
              );
            },
          ),
          Divider(height: 32.h, color: colorScheme.onSurface.withOpacity(0.05)),
          _buildSectionHeader(context, context.tr('who_can_see_online')),
          _buildItem(
            context,
            context.tr('show_activity_status'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityStatusPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
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

  Widget _buildItem(
    BuildContext context,
    String title, {
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        color: colorScheme.onSurface.withOpacity(0.3),
        size: 18.sp,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}











