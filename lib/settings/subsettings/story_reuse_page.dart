import 'package:flutter/material.dart';

import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class StoryReusePage extends StatefulWidget {
  const StoryReusePage({super.key});

  @override
  State<StoryReusePage> createState() => _StoryReusePageState();
}

class _StoryReusePageState extends State<StoryReusePage> {
  String _selectedOption = 'Only people you share the same channel';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ChartAppBar(title: 'Story reuse'),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        children: [
          _buildSectionHeader(context, 'Who can reuse your story'),
          _buildRadioItem(
            'Everyone',
            'Allows everyone on Chart to add your story to their channels or reuse it.',
          ),
          _buildRadioItem(
            'Only people you share the same channel',
            'Only people who are in the same channels as you can reuse your stories.',
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Reuse allows other users to add your story content to their own channels or posts. You will always be credited as the original author.',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
                height: 1.4,
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
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRadioItem(String title, String subtitle) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedOption == title;

    return ListTile(
      onTap: () => setState(() => _selectedOption = title),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Text(
          subtitle,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
            fontSize: 13.sp,
          ),
        ),
      ),
      trailing: Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
      contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
    );
  }
}











