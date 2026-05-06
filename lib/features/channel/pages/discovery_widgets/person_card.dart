import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:crown/core/theme/design_system.dart';

class PersonCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String mutualFriendsText;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const PersonCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.mutualFriendsText,
    required this.onButtonPressed,
    this.buttonText = 'Follow',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: 140.w,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppShapes.cardRadius),
        boxShadow: AppShadows.diffused(
          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
          blurRadius: 10,
        ),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: AppShapes.cardSquircle),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    LucideIcons.image, 
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            
            // Details Section
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if (mutualFriendsText.isNotEmpty)
                    Text(
                      mutualFriendsText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 11.sp,
                      ),
                    ),
                  SizedBox(height: 10.h),
                  
                  // Follow / Join Button
                  SizedBox(
                    width: double.infinity,
                    height: 34.h,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9EED2),
                        foregroundColor: const Color(0xFFFFA500),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
