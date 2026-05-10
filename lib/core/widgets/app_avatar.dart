import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// 👑 THE PREMIUM CHARTER AVATAR
/// A high-fidelity avatar component that manages:
/// 1. Status Ring (Gradient for new, Grey for seen, Segmented for multi-status)
/// 2. Online Indicator (Green dot with soft glow)
/// 3. Fallback Icons
/// 4. Tap Interactions
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  
  // Status State
  final bool hasStatus;
  final bool isStatusRead;
  final int statusSegmentCount;
  
  // Presence State
  final bool isOnline;
  
  // Interactions
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  
  // Visuals
  final IconData? fallbackIcon;
  final Color? ringColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.hasStatus = false,
    this.isStatusRead = false,
    this.statusSegmentCount = 0,
    this.isOnline = false,
    this.onTap,
    this.onLongPress,
    this.fallbackIcon,
    this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double ringThickness = 2.5.w;
    final double spacing = 4.w; // Space between ring and image
    final double totalSize = hasStatus ? (size + (ringThickness * 2) + spacing) : size;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Status Ring
          if (hasStatus)
            SizedBox(
              width: totalSize.r,
              height: totalSize.r,
              child: CustomPaint(
                painter: _StatusRingPainter(
                  color: isStatusRead 
                      ? colorScheme.outlineVariant.withValues(alpha: 0.5)
                      : (ringColor ?? theme.primaryColor),
                  segmentCount: statusSegmentCount,
                  isGradient: !isStatusRead,
                  thickness: ringThickness,
                ),
              ),
            ),

          // 2. Main Avatar
          Container(
            width: size.r,
            height: size.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHighest,
              boxShadow: [
                if (!hasStatus)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildFallback(colorScheme),
                      errorWidget: (context, url, error) => _buildFallback(colorScheme),
                    )
                  : _buildFallback(colorScheme),
            ),
          ),

          // 3. Online Indicator
          if (isOnline)
            Positioned(
              right: (totalSize * 0.05).r,
              bottom: (totalSize * 0.05).r,
              child: Container(
                width: (size * 0.28).r,
                height: (size * 0.28).r,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50), // Premium Green
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.scaffoldBackgroundColor,
                    width: 2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallback(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        fallbackIcon ?? LucideIcons.user,
        size: (size * 0.5).sp,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _StatusRingPainter extends CustomPainter {
  final Color color;
  final int segmentCount;
  final bool isGradient;
  final double thickness;
  final double spacing = 0.12;

  _StatusRingPainter({
    required this.color,
    required this.segmentCount,
    required this.isGradient,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - (thickness / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final Paint paint = Paint()
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (isGradient) {
      // 👑 CRIMCHART PREMIUM THEME: Amber/Yellow Glow
      // Matching the circled design in the screenshot
      paint.shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.6),
          color,
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.6),
        ],
      ).createShader(rect);
    } else {
      paint.color = color;
    }

    if (segmentCount <= 1) {
      canvas.drawCircle(center, radius, paint);
      return;
    }

    final double arcLength = (2 * math.pi - (segmentCount * spacing)) / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      final double startAngle = -math.pi / 2 + (i * (arcLength + spacing));
      canvas.drawArc(rect, startAngle, arcLength, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
