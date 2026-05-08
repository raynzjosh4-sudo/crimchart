import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A premium list tile for channel discovery in the "See All" tagging view.
class TagListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String buttonText;
  final VoidCallback? onTap;

  const TagListTile({
    super.key,
    required this.title,
    required this.buttonText,
    this.subtitle,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 👑 Theme-aware "White Light" text colors
    final lightWhite = colorScheme.onSurface.withValues(alpha: 0.95);
    final mutedWhite = colorScheme.onSurface.withValues(alpha: 0.6);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          // ── CHANNEL AVATAR ──
          Container(
            width: 56.w,
            height: 56.w,
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
                    errorWidget: (context, url, error) => _buildPlaceholder(mutedWhite),
                  )
                : _buildPlaceholder(mutedWhite),
          ),
          SizedBox(width: 16.w),

          // ── CHANNEL INFO ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: lightWhite,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: mutedWhite,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: lightWhite,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
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
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(Color textColor) {
    return Center(
      child: Text(
        title.isNotEmpty ? title[0].toUpperCase() : 'C',
        style: TextStyle(
          color: textColor,
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
