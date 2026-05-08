import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerEffect extends StatelessWidget {
  const ListShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Matching the dark theme in your image
      body: ListView.builder(
        itemCount: 8, // Number of skeleton items to show
        itemBuilder: (context, index) {
          return const ShimmerLoadingItem();
        },
      ),
    );
  }
}

class ShimmerLoadingItem extends StatelessWidget {
  const ShimmerLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    // Defining the colors for the shimmer effect
    final Color baseColor = Colors.grey[900]!;
    final Color highlightColor = Colors.grey[800]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Circular Avatar Placeholder
            Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 15),

            // 2. Text Column (Title and Subtitle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle placeholder
                  Container(
                    width: 120, // Shorter than the title
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),

            // 3. "Tag" Button Placeholder
            Container(
              width: 75,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16), // Rounded pill shape
              ),
            ),
          ],
        ),
      ),
    );
  }
}
