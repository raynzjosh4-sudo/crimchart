import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';

/// A drop-in replacement for Image.network that adds:
/// - Disk + memory caching via cached_network_image
/// - Progressive Blur Loading (Blur-Up) via thumbnailUrl
/// - Branded shimmer placeholder 
/// - Silent error fallback icon
class ChartImage extends StatelessWidget {
  final String? url;
  final String? thumbnailUrl; // 👑 NEW: Progressive Blur
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const ChartImage({
    super.key,
    required this.url,
    this.thumbnailUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget image;

    if (url == null || url!.isEmpty) {
      image = _buildFallback(colorScheme);
    } else if (url!.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: url!,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, __) =>
            placeholder ?? _buildProgressiveBlur(colorScheme),
        errorWidget: (_, __, ___) =>
            errorWidget ?? _buildFallback(colorScheme),
      );
    } else {
      // 👑 LOCAL FILE HANDLING (Optimistic UI)
      image = Image.file(
        File(url!),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildFallback(colorScheme),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _buildProgressiveBlur(ColorScheme colorScheme) {
    if (thumbnailUrl == null || thumbnailUrl!.isEmpty) {
      return _buildShimmer(colorScheme);
    }

    return Stack(
      children: [
        // 1. The Small Thumbnail (High Compression)
        CachedNetworkImage(
          imageUrl: thumbnailUrl!,
          fit: fit,
          width: width,
          height: height,
          errorWidget: (_, __, ___) => _buildShimmer(colorScheme),
        ),
        // 2. The "Blu Thing" (Frosted Glass Blur)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: colorScheme.surfaceContainerHigh,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: colorScheme.surfaceContainerHigh,
      child: Icon(
        LucideIcons.image,
        color: colorScheme.onSurface.withOpacity(0.2),
        size: 24.sp,
      ),
    );
  }
}





























