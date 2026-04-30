import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCardMedia extends StatelessWidget {
  final String url;
  final String? creatorAvatarUrl;
  final VoidCallback? onThumbnailTap;
  final Color themeColor;
  final String? username;
  final String? subtitle;
  final bool showThumbnail;

  const ImageCardMedia({
    super.key,
    required this.url,
    this.creatorAvatarUrl,
    this.onThumbnailTap,
    this.themeColor = Colors.pinkAccent,
    this.username,
    this.subtitle,
    this.showThumbnail = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNetwork = url.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.12),
        image: DecorationImage(
          image: isNetwork
              ? CachedNetworkImageProvider(url) as ImageProvider
              : AssetImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
