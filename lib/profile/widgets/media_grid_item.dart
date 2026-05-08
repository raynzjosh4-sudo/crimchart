import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:crimchart/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MediaGridItem extends StatelessWidget {
  final CharterModel post;
  final VoidCallback? onTap;

  const MediaGridItem({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Generate a stable but varying aspect ratio based on the post ID
    // This creates the "tall" staggered masonry look the user wants
    final String seed = post.id;
    final int hash = seed.hashCode.abs();

    double aspectRatio = 1.0; // Default

    if (post.isVideo) {
      // Videos are often vertical in this app
      aspectRatio = 0.65;
    } else {
      // Photos: vary between tall and moderate (0.6 to 1.1)
      // We use the hash to keep it consistent for the same post
      final variations = [0.6, 0.7, 0.8, 1.0, 1.1, 0.75, 0.9];
      aspectRatio = variations[hash % variations.length];
    }

    // Override if we can actually parse it from the URL (Cloudinary often has w_100,h_200 etc)
    if (post.mediaThumbnailUrl != null &&
        post.mediaThumbnailUrl!.contains('w_') &&
        post.mediaThumbnailUrl!.contains('h_')) {
      try {
        final uri = Uri.parse(post.mediaThumbnailUrl!);
        final wMatch = RegExp(r'w_(\d+)').firstMatch(uri.path);
        final hMatch = RegExp(r'h_(\d+)').firstMatch(uri.path);
        if (wMatch != null && hMatch != null) {
          final w = double.parse(wMatch.group(1)!);
          final h = double.parse(hMatch.group(1)!);
          if (h > 0) aspectRatio = w / h;
        }
      } catch (_) {}
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          4,
        ), // Subtle rounding for a premium feel
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 👑 OPTIMISTIC UI: Use local file if pending
              if (post.isPending == 1 && post.localFileCache.isNotEmpty)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    post.localFileCache.startsWith('http')
                        ? CachedNetworkImage(imageUrl: post.localFileCache, fit: BoxFit.cover)
                        : Image.file(File(post.localFileCache), fit: BoxFit.cover),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else if (post.mediaThumbnailUrl != null &&
                  post.mediaThumbnailUrl!.isNotEmpty)
                ChartImage(
                  url: post.mediaThumbnailUrl!,
                  fit: BoxFit.cover,
                  errorWidget: _placeholder(context),
                  placeholder: _placeholder(context, isShimmer: true),
                )
              else
                _placeholder(context),

              // ... Icons for Video/Audio (keeping consistent)
              if (post.isVideo)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      LucideIcons.play,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                )
              else if (post.isAudio)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    LucideIcons.mic,
                    color: Colors.white,
                    size: 16,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                )
              else if (post.imageUrls.length > 1)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      LucideIcons.layers,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, {bool isShimmer = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: Center(
        child: isShimmer
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 1),
              )
            : Icon(
                LucideIcons.image,
                size: 20,
                color: colorScheme.onSurface.withOpacity(0.2),
              ),
      ),
    );
  }
}











