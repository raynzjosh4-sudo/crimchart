import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';

// ─── End of list indicator ───────────────────────────────────────────────────

class EndOfListIndicator extends StatelessWidget {
  const EndOfListIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
      child: Opacity(
        opacity: 0.5,
        child: Row(
          children: [
            Expanded(child: Divider(color: colorScheme.onSurface)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'END OF LIST',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}

// ─── Error indicator ─────────────────────────────────────────────────────────

class ErrorIndicator extends StatelessWidget {
  final VoidCallback onRetry;
  final bool compact;
  final String? message;
  const ErrorIndicator({
    super.key,
    required this.onRetry,
    this.compact = false,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (compact) {
      return Center(
        child: TextButton.icon(
          onPressed: onRetry,
          icon: Icon(Icons.refresh_rounded, size: 18, color: colorScheme.primary),
          label: Text('Retry', style: TextStyle(color: colorScheme.primary)),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48.r,
              color: colorScheme.primary.withOpacity(0.2),
            ),
            SizedBox(height: 16.h),
            Text(
              'Connection Lost',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message ??
                  'We couldn\'t load the content. Please check your data connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded, size: 18.r),
              label: Text(
                'Try Again',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800), // Match the gold theme
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // Pill shape for modern look
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





























