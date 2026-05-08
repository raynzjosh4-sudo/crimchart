import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/chart_image.dart';

/// 🖼️ Specialized widget for a three-image mosaic.
class ManifestoTripleImage extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> thumbnailUrls;
  final void Function(int)? onTap;

  const ManifestoTripleImage({
    super.key,
    required this.imageUrls,
    this.thumbnailUrls = const [],
    this.onTap,
  }) : assert(imageUrls.length >= 3);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 600.h, // 👑 Aggressive vertical (was 480.h)
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => onTap?.call(0),
                child: ChartImage(
                  url: imageUrls[0],
                  thumbnailUrl: thumbnailUrls.isNotEmpty ? thumbnailUrls[0] : null,
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTap?.call(1),
                      child: ChartImage(
                        url: imageUrls[1],
                        thumbnailUrl: thumbnailUrls.length >= 2 ? thumbnailUrls[1] : null,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTap?.call(2),
                      child: ChartImage(
                        url: imageUrls[2],
                        thumbnailUrl: thumbnailUrls.length >= 3 ? thumbnailUrls[2] : null,
                        fit: BoxFit.cover,
                        width: double.infinity,
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
