import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class GroupAddSettingsPage extends StatefulWidget {
  const GroupAddSettingsPage({super.key});

  @override
  State<GroupAddSettingsPage> createState() => _GroupAddSettingsPageState();
}

class _GroupAddSettingsPageState extends State<GroupAddSettingsPage> {
  String _selectedOption = 'Everyone on Chart';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('who_can_add_channel')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        children: [
          _buildRadioItem(
            'Everyone on Chart',
            context.tr('everyone_on_Chart'),
            context.tr('everyone_on_chart_desc'),
          ),
          _buildRadioItem(
            'Only people you share the same channel',
            context.tr('only_shared_channels'),
            context.tr('only_shared_channels_desc'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String value, String displayTitle, String subtitle) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      title: Text(
        displayTitle,
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
            color: _selectedOption == value
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: _selectedOption == value
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











