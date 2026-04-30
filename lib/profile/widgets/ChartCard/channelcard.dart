import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DiscoverCard extends StatefulWidget {
  final CharterModel model;
  final VoidCallback? onRemove;
  final double? width;

  const DiscoverCard({
    super.key,
    required this.model,
    this.onRemove,
    this.width,
  });

  @override
  State<DiscoverCard> createState() => DiscoverCardState();
}

class DiscoverCardState extends State<DiscoverCard> {
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Using theme colors for consistency
    final Color cardBg = theme.cardColor;
    final Color followBlue = colorScheme.primary;
    final Color textColor = colorScheme.onSurface;
    final Color subtextColor = colorScheme.onSurface.withOpacity(0.6);

    // Style for Joined state: More subtle background
    final Color buttonColor = _isJoined
        ? colorScheme.surfaceContainerHighest
        : followBlue;
    final Color buttonTextColor = _isJoined
        ? colorScheme.onSurfaceVariant
        : Colors.white;

    return Container(
      width: widget.width,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 0.8,
        ),
      ),
      child: Stack(
        children: [
          // Close Button (top-right)
          Positioned(
            top: -4.h,
            right: -4.w,
            child: GestureDetector(
              onTap: widget.onRemove,
              child: Icon(
                LucideIcons.x,
                size: 16.sp,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ),

          Column(
            children: [
              // Profile Image (centered)
              Center(
                child: MemberImage(
                  size: 78.w, // Slightly smaller as in Image A
                  imageUrl: widget.model.profileImageUrl,
                  showStatusRing: false,
                  showActiveDot: false,
                ),
              ),
              SizedBox(height: 14.h),

              // Display Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.model.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  if (widget.model.hasStatus) ...[
                    // Using hasStatus as a proxy for 'verified' icon in A
                    SizedBox(width: 4.w),
                    Icon(
                      LucideIcons.checkCircle2,
                      size: 12.sp,
                      color: followBlue,
                    ),
                  ],
                ],
              ),
              SizedBox(height: 2.h),

              // Subtext: "Suggested for you" as in Image A
              Text(
                context.tr('suggested_for_you'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: subtextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),

              const Spacer(), // Use Spacer to push button to the bottom
              // Action Button (Join -> Joined)
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(8.w),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isJoined = !_isJoined;
                      });
                    },
                    borderRadius: BorderRadius.circular(8.w),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 9.h),
                      child: Text(
                        _isJoined ? context.tr('joined') : context.tr('join'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: buttonTextColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}











