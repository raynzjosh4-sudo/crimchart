import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/widgets/chart_image.dart';

/// 🖼️ Specialized widget for a single, large hero image.
class ManifestoSingleImage extends StatelessWidget {
  final String imageUrl;
  final String? thumbnailUrl;
  final VoidCallback? onTap;

  const ManifestoSingleImage({
    super.key,
    required this.imageUrl,
    this.thumbnailUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          constraints: BoxConstraints(maxHeight: 700.h), // 👑 Aggressive vertical (was 600.h)
          width: double.infinity,
          child: ChartImage(
            url: imageUrl,
            thumbnailUrl: thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: Container(
              height: 300.h,
              color: Colors.grey.withOpacity(0.1),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
