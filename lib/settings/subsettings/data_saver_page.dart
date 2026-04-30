import 'package:flutter/material.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';

class DataSaverPage extends StatefulWidget {
  const DataSaverPage({super.key});

  @override
  State<DataSaverPage> createState() => _DataSaverPageState();
}

class _DataSaverPageState extends State<DataSaverPage> {
  bool _dataSaver = false;
  String _highResMediaKey = 'wifi_only';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('data_saver')),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('data_saver'),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        context.tr('data_saver_desc'),
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _dataSaver,
                    onChanged: (val) => setState(() => _dataSaver = val),
                    activeThumbColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.05)),
          ListTile(
            title: Text(
              context.tr('high_res_media'),
              style: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
            ),
            subtitle: Text(
              context.tr(_highResMediaKey),
              style: TextStyle(color: colorScheme.primary, fontSize: 14.sp),
            ),
            onTap: _showHighResOptions,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
          ),
        ],
      ),
    );
  }

  void _showHighResOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption('never'),
            _buildOption('wifi_only'),
            _buildOption('cellular_wifi'),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String key) {
    final isSelected = _highResMediaKey == key;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(
        context.tr(key),
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: colorScheme.primary)
          : null,
      onTap: () {
        setState(() => _highResMediaKey = key);
        Navigator.pop(context);
      },
    );
  }
}











