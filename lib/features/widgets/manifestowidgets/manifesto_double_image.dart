import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/widgets/chart_image.dart';

/// 🖼️ Specialized widget for a two-image split screen.
class ManifestoDoubleImage extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> thumbnailUrls;
  final void Function(int)? onTap;

  const ManifestoDoubleImage({
    super.key,
    required this.imageUrls,
    this.thumbnailUrls = const [],
    this.onTap,
  }) : assert(imageUrls.length >= 2);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 520.h,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTap?.call(0),
                child: Hero(
                  tag: 'image_hero_${imageUrls[0]}',
                  child: ChartImage(
                    url: imageUrls[0],
                    thumbnailUrl: thumbnailUrls.isNotEmpty ? thumbnailUrls[0] : null,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: GestureDetector(
                onTap: () => onTap?.call(1),
                child: Hero(
                  tag: 'image_hero_${imageUrls[1]}',
                  child: ChartImage(
                    url: imageUrls[1],
                    thumbnailUrl: thumbnailUrls.length >= 2 ? thumbnailUrls[1] : null,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
