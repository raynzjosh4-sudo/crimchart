import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'exportsettings.dart';

class HideStoryPage extends StatelessWidget {
  const HideStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('hide_story')),
      body: Column(
        children: [
          _buildItem(
            context,
            context.tr('hide_story_from'),
            context.tr('zero_people'),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.tr('hide_story_desc'),
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

  Widget _buildItem(BuildContext context, String title, String trailing) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () {},
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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











