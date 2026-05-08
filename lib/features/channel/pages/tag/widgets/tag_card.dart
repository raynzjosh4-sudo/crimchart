import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A premium, high-fidelity card for tagging and discovery.
class TagCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? imageUrl;
  final String buttonText;
  final VoidCallback? onTap;
  final Color? themeColor;

  const TagCard({
    super.key,
    required this.title,
    required this.buttonText,
    this.description,
    this.imageUrl,
    this.onTap,
    this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 👑 Using theme-aware colors
    final cardColor = theme.brightness == Brightness.dark
        ? const Color(0xFF1A1A1A)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    // 👑 Theme-aware "White Light" text colors
    final lightWhite = colorScheme.onSurface.withValues(alpha: 0.95);
    final mutedWhite = colorScheme.onSurface.withValues(alpha: 0.6);

    return Container(
      width: 150.w, // 👑 Compact width
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── CHANNEL IMAGE ──
          Container(
            width: 80.w, // 👑 Reduced size
            height: 80.w,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.black12),
                    errorWidget: (context, url, error) => _buildTextPlaceholder(mutedWhite),
                  )
                : _buildTextPlaceholder(mutedWhite),
          ),
          SizedBox(height: 18.h),

          // ── CHANNEL NAME ──
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: lightWhite, // 👑 Pure Light White
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
          
          if (description != null && description!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              description!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: mutedWhite, // 👑 Muted Light White
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          
          const Spacer(),

          // ── ACTION BUTTON ──
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: lightWhite,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              minimumSize: Size(100.w, 38.h),
              shape: StadiumBorder(
                side: BorderSide(
                  color: lightWhite.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextPlaceholder(Color textColor) {
    return Center(
      child: Text(
        title.isNotEmpty ? title[0].toUpperCase() : 'C',
        style: TextStyle(
          color: textColor,
          fontSize: 44.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
