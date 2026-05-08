import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class PaginationErrorFooter extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const PaginationErrorFooter({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
      child: Column(
        children: [
          // Icon
          Icon(
            Icons.wifi_off_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            size: 40.sp,
          ),
          SizedBox(height: 12.h),
          // Title
          Text(
            'Connection lost',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          // Subtitle
          Text(
            'Check your internet and try again',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 16.h),
          // Pills-style RETRY button
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh_rounded, size: 14.sp, color: Colors.white),
            label: Text(
              'RETRY',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1),
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
