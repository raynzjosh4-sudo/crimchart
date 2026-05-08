import 'package:crimchart/settings/subsettings/allow_comments_from_page.dart';
import 'package:crimchart/settings/subsettings/blocked_commenters_page.dart';
import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CommentControlsPage extends StatefulWidget {
  const CommentControlsPage({super.key});

  @override
  State<CommentControlsPage> createState() => _CommentControlsPageState();
}

class _CommentControlsPageState extends State<CommentControlsPage> {
  bool _hideOffensive = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('comment_controls')),
      body: ListView(
        children: [
          _buildItem(
            context,
            context.tr('allow_comments_from'),
            context.tr('everyone'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllowCommentsFromPage(),
                ),
              );
            },
          ),
          _buildItem(
            context,
            context.tr('block_comments_from'),
            context.tr('zero_people'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BlockedCommentersPage(),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              context.tr('block_comments_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
              ),
            ),
          ),
          Divider(height: 32.h, color: colorScheme.onSurface.withOpacity(0.05)),
          _buildSectionHeader(context, context.tr('filters')),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        context.tr('hide_offensive_comments'),
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
                        value: _hideOffensive,
                        onChanged: (val) =>
                            setState(() => _hideOffensive = val),
                        activeThumbColor: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  context.tr('hide_offensive_desc'),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
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

  Widget _buildItem(
    BuildContext context,
    String title,
    String trailing, {
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            LucideIcons.chevronRight,
            color: colorScheme.onSurface.withOpacity(0.3),
            size: 18.sp,
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}











