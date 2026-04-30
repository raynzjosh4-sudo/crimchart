import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/widgets/chart_image.dart';
import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final List<String> imageUrls;
  final void Function(int)? onTap;

  const ImageGrid({super.key, required this.imageUrls, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    if (imageUrls.length == 1) {
      return GestureDetector(
        onTap: () => onTap?.call(0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.w),
            child: ChartImage(
              url: imageUrls[0],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      );
    }

    // Determine grid layout based on number of images
    int crossAxisCount = imageUrls.length == 2
        ? 2
        : (imageUrls.length >= 3 ? 3 : 2);
    if (imageUrls.length == 4) {
      crossAxisCount = 2; // 2x2 looks better for 4 images
    }

    int displayCount = imageUrls.length > 4 ? 4 : imageUrls.length;
    if (imageUrls.length > 4) {
      crossAxisCount = 2; // Limit to 4 images max on screen (2x2 grid)
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.75, // 👑 Reduced aspect ratio makes them taller!
      ),
      itemCount: displayCount,
      itemBuilder: (context, index) {
        // If there are more than 4 images, show an overlay on the 4th image
        if (index == 3 && imageUrls.length > 4) {
          int remaining = imageUrls.length - 4;
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.w),
                  child: ChartImage(url: imageUrls[index], fit: BoxFit.cover),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Center(
                    child: Text(
                      '+$remaining',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.w),
            child: ChartImage(url: imageUrls[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}











