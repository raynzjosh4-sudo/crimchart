import 'package:flutter/material.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';

class SharingReusePage extends StatefulWidget {
  const SharingReusePage({super.key});

  @override
  State<SharingReusePage> createState() => _SharingReusePageState();
}

class _SharingReusePageState extends State<SharingReusePage> {
  bool _allowResharing = true;
  bool _allowSharing = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('sharing_and_reuse')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildSectionHeader(context, context.tr('sharing')),
          _buildSwitchItem(
            context.tr('allow_resharing_channels'),
            context.tr('resharing_desc'),
            _allowResharing,
            (val) => setState(() => _allowResharing = val),
          ),
          SizedBox(height: 24.h),
          _buildSwitchItem(
            context.tr('allow_sharing_inbox'),
            context.tr('sharing_inbox_desc'),
            _allowSharing,
            (val) => setState(() => _allowSharing = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
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
                value: value,
                onChanged: onChanged,
                activeThumbColor: colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
            fontSize: 13.sp,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}











