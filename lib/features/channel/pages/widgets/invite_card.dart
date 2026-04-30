import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/localization/localization_provider.dart';

class InviteCard extends StatelessWidget {
  final VoidCallback? onInvitePressed;
  final String? channelName;
  final bool isPrivate;

  const InviteCard({super.key, this.onInvitePressed, this.channelName, this.isPrivate = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = theme.primaryColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
        // ── Removed borders as requested ──
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // ── WhatsApp Style Icon Circle ──
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.userPlus,
                  color: primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),

              // ── Text Content ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.tr('send_an_invite'),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${context.tr("invite_others_to")} ${channelName ?? '"channel"'}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Action Button (Moved Below) ──
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onInvitePressed,
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
              ),
              child: Text(
                context.tr('invite').toUpperCase(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          
          // ── Privacy Status Beneath Button ──
          SizedBox(height: 12.h),
          Text(
            (isPrivate ? context.tr('private') : context.tr('public')).toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface.withValues(alpha: 0.3), // Subdued
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
