import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';

class MicrophonePermissionDialog {
  static Future<bool> check(BuildContext context) async {
    var status = await Permission.microphone.status;
    
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (!context.mounted) return false;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Row(
            children: [
              Icon(LucideIcons.micOff, color: Theme.of(context).colorScheme.error, size: 24.sp),
              SizedBox(width: 8.w),
              Text('Microphone Disabled', style: TextStyle(fontSize: 18.sp)),
            ],
          ),
          content: Text(
            'To record voice notes, you need to enable microphone access in your device settings.',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
              },
              child: Text('Open Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ),
          ],
        ),
      );
      return false;
    }

    if (!context.mounted) return false;
    // Show beautiful educational dialog before triggering OS prompt
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.mic,
                  size: 40.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Record Voice Notes',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              Text(
                'Crown needs access to your microphone so you can record and send voice messages directly to the channel.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(
                        'Not Now',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        'Allow',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (proceed == true) {
      status = await Permission.microphone.request();
      return status.isGranted;
    }
    
    return false;
  }
}
