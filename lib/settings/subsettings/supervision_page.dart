import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'exportsettings.dart';

class SupervisionPage extends StatelessWidget {
  const SupervisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ChartAppBar(title: 'Supervision'),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Icon(
                  LucideIcons.shield,
                  color: colorScheme.primary,
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Family Center',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Supervision helps you support your teen\'s experience on Chart with tools to see who they follow, who follows them, and how much time they spend on the app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          _buildInfoItem(
            context,
            LucideIcons.clock,
            'Manage time limits',
            'Set daily limits for how long your teen can use Chart.',
          ),
          _buildInfoItem(
            context,
            LucideIcons.users,
            'See member list',
            'View who your teen joins and who joins their channels.',
          ),
          _buildInfoItem(
            context,
            LucideIcons.bell,
            'Privacy notifications',
            'Get notified when your teen changes their privacy settings.',
          ),
          SizedBox(height: 40.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Get started',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











