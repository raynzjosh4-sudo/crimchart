import 'package:flutter/material.dart';

class CombinedTimeline extends StatelessWidget {
  final int totalItems;
  final int currentIndex;
  final double currentProgress; // 0.0 to 1.0 for the active segment

  const CombinedTimeline({
    super.key,
    required this.totalItems,
    required this.currentIndex,
    required this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0) return const SizedBox();

    return Container(
      height: 4,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(totalItems, (index) {
          final isPast = index < currentIndex;
          final isActive = index == currentIndex;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Stack(
                children: [
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  if (isPast)
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  if (isActive)
                    FractionallySizedBox(
                      widthFactor: currentProgress.clamp(0.0, 1.0),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D9FFF), // Using the blue accent
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
