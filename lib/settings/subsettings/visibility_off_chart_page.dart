import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class VisibilityOffChartPage extends StatefulWidget {
  const VisibilityOffChartPage({super.key});

  @override
  State<VisibilityOffChartPage> createState() => _VisibilityOffChartPageState();
}

class _VisibilityOffChartPageState extends State<VisibilityOffChartPage> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('visibility_off_Chart')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.tr('show_profile_search'),
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
                    value: _isVisible,
                    onChanged: (val) => setState(() => _isVisible = val),
                    activeThumbColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              context.tr('visibility_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











