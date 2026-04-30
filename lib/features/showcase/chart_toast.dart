import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChartToast {
  static void showError(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      title: title,
      message: message,
      type: ChartToastType.error,
      duration: duration,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      title: title,
      message: message,
      type: ChartToastType.success,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      title: title,
      message: message,
      type: ChartToastType.info,
      duration: duration,
    );
  }

  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required ChartToastType type,
    required Duration duration,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color primaryColor;
    IconData icon;

    switch (type) {
      case ChartToastType.error:
        primaryColor = colorScheme.error;
        icon = LucideIcons.xCircle;
        break;
      case ChartToastType.success:
        primaryColor = colorScheme.primary;
        icon = LucideIcons.checkCircle;
        break;
      case ChartToastType.info:
        primaryColor = colorScheme.primary;
        icon = LucideIcons.info;
        break;
    }

    toastification.showCustom(
      context: context,
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      builder: (context, holder) {
        return _ChartToastWidget(
          title: title,
          message: message,
          primaryColor: primaryColor,
          icon: icon,
          onClose: () => toastification.dismiss(holder),
        );
      },
    );
  }
}

enum ChartToastType { error, success, info }

class _ChartToastWidget extends StatelessWidget {
  final String title;
  final String message;
  final Color primaryColor;
  final IconData icon;
  final VoidCallback onClose;

  const _ChartToastWidget({
    required this.title,
    required this.message,
    required this.primaryColor,
    required this.icon,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, color: primaryColor, size: 20.sp),
                ),
              ),
              SizedBox(width: 14.w),
              // Content
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      message,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              // Close Button
              IconButton(
                onPressed: onClose,
                icon: Icon(
                  LucideIcons.x,
                  color: colorScheme.onSurface.withOpacity(0.3),
                  size: 16.sp,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}











