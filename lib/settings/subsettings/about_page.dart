import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

import 'exportsettings.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('about')),
      body: ListView(
        children: [
          _buildAboutItem(context, context.tr('privacy_policy')),
          _buildAboutItem(context, context.tr('terms_of_use')),
          _buildAboutItem(context, context.tr('open_source_libs')),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              '${context.tr('version')} 1.0.0',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        color: colorScheme.onSurface.withOpacity(0.3),
        size: 18.sp,
      ),
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }
}











