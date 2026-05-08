import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/router/app_router.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class ChannelIntroPage extends StatelessWidget {
  const ChannelIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: '',
        showBorder: false,
        actions: [
          TextButton(
            onPressed: () => context.push(AppRoutes.channelSuggestions),
            child: Text(
              localization.tr('skip'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.hash,
                size: 64.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              localization.tr('onboarding_channel_intro_title'),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              localization.tr('onboarding_channel_intro_subtitle'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(AppRoutes.channelSuggestions);
                },
                icon: Icon(LucideIcons.plus, size: 20.sp),
                label: Text(
                  localization.tr('onboarding_channel_intro_button'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => context.push(AppRoutes.channelSuggestions),
              child: Text(
                localization.tr('onboarding_channel_intro_later'),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}











