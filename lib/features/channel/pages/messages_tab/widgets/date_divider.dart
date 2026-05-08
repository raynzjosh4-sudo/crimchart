import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:intl/intl.dart';

class DateDivider extends StatelessWidget {
  final DateTime date;

  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) {
      return 'TODAY';
    } else if (msgDate == yesterday) {
      return 'YESTERDAY';
    } else {
      return DateFormat('MMMM d, y').format(date).toUpperCase();
    }
  }
}
