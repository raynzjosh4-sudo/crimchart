import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum OfflinePageType { feed, chat, members, general }

class OfflineView extends StatelessWidget {
  final OfflinePageType type;
  final VoidCallback onRetry;
  final String? message;

  const OfflineView({
    super.key,
    this.type = OfflinePageType.general,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with Glow effect
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _getIconForType(),
                  color: colorScheme.primary,
                  size: 48.sp,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Title
            Text(
              _getTitleForType(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 12.h),

            // Subtitle
            Text(
              message ?? _getMessageForType(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),

            // Retry Button
            GestureDetector(
              onTap: onRetry,
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.refreshCw,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType() {
    switch (type) {
      case OfflinePageType.feed:
        return LucideIcons.layoutGrid;
      case OfflinePageType.chat:
        return LucideIcons.messageCircle;
      case OfflinePageType.members:
        return LucideIcons.users;
      case OfflinePageType.general:
      default:
        return LucideIcons.wifiOff;
    }
  }

  String _getTitleForType() {
    switch (type) {
      case OfflinePageType.feed:
        return "Feed Unavailable";
      case OfflinePageType.chat:
        return "Chat Paused";
      case OfflinePageType.members:
        return "Members Hidden";
      case OfflinePageType.general:
      default:
        return "Connection Lost";
    }
  }

  String _getMessageForType() {
    switch (type) {
      case OfflinePageType.feed:
        return "Your connection took a break. We couldn't load the latest content.";
      case OfflinePageType.chat:
        return "The conversation is on hold. Please check your internet connection.";
      case OfflinePageType.members:
        return "We can't see the crowd right now. Signal required to load members.";
      case OfflinePageType.general:
      default:
        return "It looks like you're offline. Please check your connection and try again.";
    }
  }
}
