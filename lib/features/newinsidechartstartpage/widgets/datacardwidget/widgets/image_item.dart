import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageItem extends StatelessWidget {
  final String contentUrl;

  const ImageItem({super.key, required this.contentUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNetwork = contentUrl.startsWith('http');

    if (contentUrl.isEmpty) return _errorIcon(colorScheme);

    return SizedBox.expand(
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: contentUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => _placeholder(colorScheme),
              errorWidget: (context, url, error) => _errorIcon(colorScheme),
            )
          : File(contentUrl).existsSync()
              ? Image.file(
                  File(contentUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _errorIcon(colorScheme),
                )
              : _errorIcon(colorScheme),
    );
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _errorIcon(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
      child: Icon(
        Icons.broken_image_outlined,
        color: colorScheme.primary.withValues(alpha: 0.5),
        size: 32,
      ),
    );
  }
}





























