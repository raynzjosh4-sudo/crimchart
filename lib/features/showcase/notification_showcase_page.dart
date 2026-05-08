import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/showcase/chart_toast.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationShowcasePage extends StatelessWidget {
  const NotificationShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notification Showcase',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Chart Toast System',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Premium, themed notifications that follow our brand design system.',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 40.h),

            _ShowcaseItem(
              title: 'Error Notification',
              description: 'Used for critical failures or validation errors.',
              icon: LucideIcons.xCircle,
              color: colorScheme.error,
              onTap: () {
                ChartToast.showError(
                  context,
                  title: 'Invalid Email',
                  message: 'Please enter a valid email address to continue.',
                );
              },
            ),

            SizedBox(height: 16.h),

            _ShowcaseItem(
              title: 'Success Notification',
              description:
                  'Used for successful operations and positive feedback.',
              icon: LucideIcons.checkCircle,
              color: Colors.greenAccent[700]!,
              onTap: () {
                ChartToast.showSuccess(
                  context,
                  title: 'Account Created',
                  message: 'Your account has been successfully verified.',
                );
              },
            ),

            SizedBox(height: 16.h),

            _ShowcaseItem(
              title: 'Info Notification',
              description: 'Used for neutral messages and helpful tips.',
              icon: LucideIcons.info,
              color: colorScheme.primary,
              onTap: () {
                ChartToast.showInfo(
                  context,
                  title: 'System Update',
                  message: 'A new version of Chart is available for download.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ShowcaseItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.08),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Center(
                child: Icon(icon, color: color, size: 24.sp),
              ),
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
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: colorScheme.onSurface.withOpacity(0.2),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}











