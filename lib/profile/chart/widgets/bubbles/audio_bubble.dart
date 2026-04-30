import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/utils/responsive_size.dart';
import '../../models/chart_message.dart';

class AudioBubble extends StatelessWidget {
  final ChartMessage message;

  const AudioBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMe = message.isMe;

    return Container(
      width: 220.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isMe ? theme.primaryColor : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(isMe ? 20.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 20.r),
        ),
      ),
      child: Row(
        children: [
          // Play Button
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isMe ? Colors.black.withValues(alpha:0.1) : colorScheme.onSurface.withValues(alpha:0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.play,
              size: 20.sp,
              color: isMe ? Colors.black : colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 12.w),

          // Waveform Simulation / Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWaveform(isMe, colorScheme, theme),
                SizedBox(height: 4.h),
                Text(
                  message.duration ?? '0:12',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: isMe ? Colors.black.withValues(alpha: 0.5) : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          
          // Small Mic Icon
          Icon(
            LucideIcons.mic,
            size: 14.sp,
            color: isMe ? Colors.black.withValues(alpha: 0.3) : colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform(bool isMe, ColorScheme colorScheme, ThemeData theme) {
    final barColor = isMe ? Colors.black.withValues(alpha: 0.2) : colorScheme.onSurface.withValues(alpha: 0.1);
    return Row(
      children: List.generate(15, (index) {
        final height = (index % 3 == 0) ? 12.h : (index % 2 == 0 ? 8.h : 6.h);
        return Container(
          width: 2.w,
          height: height,
          margin: EdgeInsets.only(right: 2.w),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(1.r),
          ),
        );
      }),
    );
  }
}





























