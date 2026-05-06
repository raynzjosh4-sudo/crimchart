import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';

class ChannelInvitationCard extends StatelessWidget {
  final VoidCallback onTap;
  final String? channelName;

  const ChannelInvitationCard({
    super.key,
    required this.onTap,
    this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.2),
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            width: 1,
          ),
          // 👑 REMOVED BOTTOM BORDER TO PREVENT EXTRA SPACE FEEL
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 24.h,
            bottom: 0,
          ),
          child: Row(
            children: [
              // Text Content on the Left
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite Members',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Grow this channel by inviting friends to join ${channelName ?? 'the conversation'}.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24.w),

              // Action Button on the Right
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Colors.black,
                  size: 24.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
