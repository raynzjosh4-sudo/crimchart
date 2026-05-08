import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/localization/localization_provider.dart';

class InviteCard extends StatelessWidget {
  final VoidCallback? onInvitePressed;
  final String? channelName;
  final String? imageUrl;
  final String? buttonText;
  final String? senderName;
  final String? senderImageUrl;
  final String? senderTitle;
  final String? caption;
  final bool isPrivate;

  const InviteCard({
    super.key,
    this.onInvitePressed,
    this.channelName,
    this.imageUrl,
    this.buttonText,
    this.senderName,
    this.senderImageUrl,
    this.senderTitle,
    this.caption,
    this.isPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = theme.primaryColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header (Sender Info) ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: senderImageUrl != null && senderImageUrl!.isNotEmpty
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(senderImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  child: senderImageUrl == null || senderImageUrl!.isEmpty
                      ? Icon(
                          LucideIcons.user,
                          size: 20.sp,
                          color: colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        senderName ?? 'Member',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (senderTitle != null && senderTitle!.isNotEmpty)
                        Text(
                          senderTitle!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.moreHorizontal,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),

          // ── Caption ──
          if (caption != null && caption!.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Text(
                caption!,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),

          // ── Channel Invite Section (The actual Card) ──
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        image: imageUrl != null && imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: imageUrl == null || imageUrl!.isEmpty
                          ? Icon(
                              LucideIcons.userPlus,
                              color: primaryColor,
                              size: 24.sp,
                            )
                          : null,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            channelName ?? 'New Community',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            (isPrivate
                                    ? context.tr('private')
                                    : context.tr('public'))
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onInvitePressed,
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      (buttonText ?? context.tr('invite')).toUpperCase(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
