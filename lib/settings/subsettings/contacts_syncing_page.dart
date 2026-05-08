import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class ContactsSyncingPage extends StatefulWidget {
  const ContactsSyncingPage({super.key});

  @override
  State<ContactsSyncingPage> createState() => _ContactsSyncingPageState();
}

class _ContactsSyncingPageState extends State<ContactsSyncingPage> {
  bool _syncEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('contacts_syncing')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.tr('connect_with_members'),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _syncEnabled,
                    onChanged: (val) => setState(() => _syncEnabled = val),
                    activeThumbColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              context.tr('sync_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











