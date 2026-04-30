import 'package:flutter/material.dart';

/// A row of story-circle avatars shown below the filmstrip — mirrors
/// the Snapchat bottom avatar bar (placeholder circles for now).
class EditStoryAvatarRow extends StatelessWidget {
  const EditStoryAvatarRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder avatars — replace with real user data as needed.
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFE66D),
      const Color(0xFF95E1D3),
      const Color(0xFFF38181),
      const Color(0xFFC4B5FD),
      Colors.white24,
    ];

    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: colors.length,
        itemBuilder: (context, i) {
          final isBlank = i == colors.length - 1;
          return Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isBlank ? Colors.white10 : colors[i],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: isBlank
                ? const Icon(Icons.location_on, color: Colors.white70, size: 20)
                : null,
          );
        },
      ),
    );
  }
}
