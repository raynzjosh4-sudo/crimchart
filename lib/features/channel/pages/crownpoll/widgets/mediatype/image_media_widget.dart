import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ImageMediaWidget extends StatelessWidget {
  final String imageUrl;

  const ImageMediaWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context, url, error) => Icon(
        LucideIcons.image,
        color: colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}
