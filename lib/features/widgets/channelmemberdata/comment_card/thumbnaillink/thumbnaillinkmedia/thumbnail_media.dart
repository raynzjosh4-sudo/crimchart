import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'thumbnail_media_type.dart';
import 'video_thumbnail.dart';

class ThumbnailMedia extends StatelessWidget {
  final String mediaUrl;
  final ThumbnailMediaType mediaType;

  const ThumbnailMedia({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    switch (mediaType) {
      case ThumbnailMediaType.video:
        return VideoThumbnail(videoUrl: mediaUrl);
      case ThumbnailMediaType.image:
      case ThumbnailMediaType.gif:
        return CachedNetworkImage(
          imageUrl: mediaUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          errorWidget: (_, __, ___) => Container(
            color: Theme.of(context).colorScheme.errorContainer,
          ),
        );
    }
  }
}





























