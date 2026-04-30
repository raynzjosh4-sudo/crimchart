import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/widgets/chart_image.dart';

/// 🖼️ Specialized widget for a four-image grid (2x2).
class ManifestoQuadImage extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> thumbnailUrls;
  final void Function(int)? onTap;

  const ManifestoQuadImage({
    super.key,
    required this.imageUrls,
    this.thumbnailUrls = const [],
    this.onTap,
  }) : assert(imageUrls.length >= 4);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 650.h, // 👑 Aggressive vertical (was 540.h)
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
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
                    child: GestureDetector(
                      onTap: () => onTap?.call(1),
                      child: ChartImage(
                        url: imageUrls[1],
                        thumbnailUrl: thumbnailUrls.length >= 2 ? thumbnailUrls[1] : null,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTap?.call(2),
                      child: ChartImage(
                        url: imageUrls[2],
                        thumbnailUrl: thumbnailUrls.length >= 3 ? thumbnailUrls[2] : null,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTap?.call(3),
                      child: ChartImage(
                        url: imageUrls[3],
                        thumbnailUrl: thumbnailUrls.length >= 4 ? thumbnailUrls[3] : null,
                        fit: BoxFit.cover,
                        height: double.infinity,
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
