import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';

class WhoCanCommentPage extends StatefulWidget {
  const WhoCanCommentPage({super.key});

  @override
  State<WhoCanCommentPage> createState() => _WhoCanCommentPageState();
}

class _WhoCanCommentPageState extends State<WhoCanCommentPage> {
  String _selectedOption = 'everyone';

  final List<Map<String, String>> _options = [
    {
      'id': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user can comment on your posts.',
    },
    {
      'id': 'followers',
      'title': 'Followers Only',
      'subtitle': 'Only users who follow this channel can comment.',
    },
    {
      'id': 'Charters',
      'title': 'Charters Only',
      'subtitle': 'Only members in the Charters list can comment.',
    },
    {
      'id': 'noone',
      'title': 'No One',
      'subtitle': 'Comments are disabled for everyone.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: 'Who Can Comment',
        centerTitle: true,
        showBack: true,
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 16.sp,
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: _options.length,
        itemBuilder: (context, index) {
          final option = _options[index];
          final isSelected = _selectedOption == option['id'];

          return ListTile(
            onTap: () => setState(() => _selectedOption = option['id']!),
            title: Text(
              option['title']!,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              option['subtitle']!,
              style: TextStyle(
                fontSize: 12.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            trailing: isSelected
                ? Icon(LucideIcons.check, color: primaryColor, size: 20.sp)
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 4.h,
            ),
          );
        },
      ),
    );
  }
}











