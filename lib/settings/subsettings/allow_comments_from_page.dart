import 'package:flutter/material.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';

class AllowCommentsFromPage extends StatefulWidget {
  const AllowCommentsFromPage({super.key});

  @override
  State<AllowCommentsFromPage> createState() => _AllowCommentsFromPageState();
}

class _AllowCommentsFromPageState extends State<AllowCommentsFromPage> {
  String _selectedId = 'everyone';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('allow_comments_from')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.tr('allow_comments_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ),
          _buildOption('everyone', context.tr('everyone_on_Chart')),
          _buildOption(
            'sharing_channel',
            context.tr('only_shared_channels_comments'),
          ),
          _buildOption('competitors', context.tr('only_competitors')),
          _buildOption('off', context.tr('off')),
        ],
      ),
    );
  }

  Widget _buildOption(String id, String title, {String? subtitle}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedId == id;

    return ListTile(
      onTap: () => setState(() => _selectedId = id),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
              ),
            )
          : null,
      trailing: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                ),
              )
            : null,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }
}











