import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class ActivityStatusPage extends StatefulWidget {
  const ActivityStatusPage({super.key});

  @override
  State<ActivityStatusPage> createState() => _ActivityStatusPageState();
}

class _ActivityStatusPageState extends State<ActivityStatusPage> {
  bool _showStatus = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('Chart_activity_status')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('show_activity_status'),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _showStatus,
                    onChanged: (val) => setState(() => _showStatus = val),
                    activeThumbColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              context.tr('activity_status_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              context.tr('activity_status_footer'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











