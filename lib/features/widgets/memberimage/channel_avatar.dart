import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChannelAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? leaderAvatarUrl;
  final double size;
  final double? borderWidth;
  final Color? borderColor;
  final bool isActive;

  const ChannelAvatar({
    super.key,
    this.imageUrl,
    this.leaderAvatarUrl,
    this.size = 58.0,
    this.borderWidth,
    this.borderColor,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary; // Dynamic gold/theme color

    // Proportional sizes for the triple-layer design
    final baseSize = size * 0.85;
    final badgeSize = size * 0.38;

    return SizedBox(
      width: size, 
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── LAYER 1: BACK AVATAR (MAIN USER/LEADER) ──
          Positioned(
            top: 0,
            left: size * 0.15,
            child: _buildCircle(
              size: baseSize,
              url: leaderAvatarUrl, // ✅ NOW MAIN (BACK)
              borderColor: primaryColor.withValues(alpha: 0.5),
              borderWidth: 2.0.w,
            ),
          ),

          // ── LAYER 2: FRONT AVATAR (CHANNEL LOGO) ──
          Positioned(
            bottom: 4.h,
            left: 0,
            child: _buildCircle(
              size: baseSize,
              url: imageUrl, // ✅ NOW SECONDARY (FRONT)
              borderColor: primaryColor,
              borderWidth: 2.0.w,
              hasShadow: true,
            ),
          ),

          // ── LAYER 3: APP ICON BADGE ──
          Positioned(
            bottom: -2.h,
            left: baseSize * 0.45,
            child: SizedBox(
              width: badgeSize * 1.1,
              height: badgeSize * 1.1,
              child: Image.asset(
                'assets/icons/playstore.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle({
    required double size,
    required String? url,
    required Color borderColor,
    required double borderWidth,
    bool hasShadow = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Borders are no longer necessary for the premium look per user request
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: url != null && url.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey[900],
                  child: Center(
                    child: SizedBox(
                      width: size * 0.35,
                      height: size * 0.35,
                      child: const CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => _buildPlaceholder(size),
              )
            : _buildPlaceholder(size),
      ),
    );
  }

  Widget _buildPlaceholder(double size) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Icon(LucideIcons.users, size: size * 0.4, color: Colors.white24),
      ),
    );
  }
}











