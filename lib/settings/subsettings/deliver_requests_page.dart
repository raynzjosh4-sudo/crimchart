import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'exportsettings.dart';

class DeliverRequestsPage extends StatelessWidget {
  const DeliverRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('message_inbox_request')),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.tr('decide_inbox_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
          ),
          _buildSectionHeader(context, context.tr('potential_connections')),
          _buildItem(
            context,
            context.tr('channels_you_joins'),
            trailing: context.tr('inbox_request'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageDeliveryOptionsPage(
                    titleKey: 'channels_you_joins',
                    descriptionKey: 'channels_join_desc',
                  ),
                ),
              );
            },
          ),
          Divider(height: 32.h, color: colorScheme.onSurface.withOpacity(0.05)),
          _buildSectionHeader(context, context.tr('other_people')),
          _buildItem(
            context,
            context.tr('others_in_channels'),
            trailing: context.tr('inbox_request'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageDeliveryOptionsPage(
                    titleKey: 'others_on_Chart',
                    descriptionKey: 'others_on_chart_desc',
                  ),
                ),
              );
            },
          ),
          Divider(height: 32.h, color: colorScheme.onSurface.withOpacity(0.05)),
          _buildSectionHeader(context, context.tr('channel_settings')),
          _buildItem(
            context,
            context.tr('who_can_add_channel'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupAddSettingsPage(),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.tr('not_all_messages_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    String title, {
    String? trailing,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 14.sp,
              ),
            ),
          SizedBox(width: 8.w),
          Icon(
            LucideIcons.chevronRight,
            color: colorScheme.onSurface.withOpacity(0.3),
            size: 18.sp,
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}











