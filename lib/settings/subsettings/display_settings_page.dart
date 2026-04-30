import 'package:crown/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'exportsettings.dart';

class DisplaySettingsPage extends StatelessWidget {
  const DisplaySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Round to 1 decimal place for better UI
    final currentScale = (themeProvider.displayScale * 10).round() / 10;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('display_text_size')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.tr('scale_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15.w),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('smaller'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${(currentScale * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      context.tr('bigger'),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Slider(
                  value: currentScale,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  activeColor: colorScheme.primary,
                  inactiveColor: colorScheme.onSurface.withOpacity(0.1),
                  onChanged: (value) {
                    themeProvider.updateDisplayScale(value);
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(32.w),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    LucideIcons.eye,
                    size: 50.sp,
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    context.tr('preview_text'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}











