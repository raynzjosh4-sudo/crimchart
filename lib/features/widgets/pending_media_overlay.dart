import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PendingMediaOverlay extends StatelessWidget {
  final double? progress; // 0.0 to 1.0 (null means preparing)
  final String uploadedSize;
  final String totalSize;
  final bool isOffline;

  const PendingMediaOverlay({
    super.key,
    this.progress,
    this.uploadedSize = '',
    this.totalSize = '',
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    // 👑 AUTO-HIDE: When progress is 100%, the upload is done — show nothing
    final isDone = progress != null && progress! >= 1.0;
    if (isDone) return const SizedBox.shrink();

    return Stack(
      children: [
          // 1. 👑 LIGHT FROSTED GLASS (only covers the image, not intrusive)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                color: Colors.black.withValues(alpha: 0.25),
              ),
            ),
          ),

          // 2. 👑 SMALL CORNER BADGE (bottom-right)
          Positioned(
            bottom: 10.h,
            right: 10.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Spinner or offline icon
                      SizedBox(
                        width: 14.w,
                        height: 14.w,
                        child: isOffline
                            ? Icon(LucideIcons.wifiOff, color: Colors.white, size: 12.sp)
                            : CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                              ),
                      ),
                      SizedBox(width: 6.w),
                      // Label
                      Text(
                        isOffline
                            ? 'Waiting...'
                            : progress != null
                                ? uploadedSize.isNotEmpty
                                    ? uploadedSize
                                    : '${(progress! * 100).toInt()}%'
                                : 'Preparing...',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  }
}
