import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../../features/widgets/channelmemberdata/comment_card/thumbnaillink/thumbnaillinkmedia/thumbnail_media_type.dart';

class ThumbnailReferenceOverlay extends StatelessWidget {
  final String thumbnailUrl;
  final ThumbnailMediaType mediaType;
  final String? profileImageUrl;

  const ThumbnailReferenceOverlay({
    super.key,
    required this.thumbnailUrl,
    required this.mediaType,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w, // Reduced from 80
      height: 65.h, // Reduced from 110
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Pointer/Bubble Tail
          Positioned(
            bottom: -3,
            right: 12,
            child: CustomPaint(
              size: const Size(8, 8),
              painter: _BubbleTailPainter(color: Colors.yellow),
            ),
          ),

          // Main Thumbnail Capsule
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.yellow, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(thumbnailUrl, fit: BoxFit.cover),
                if (mediaType == ThumbnailMediaType.video)
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),

          // Small Profile Icon Overlay
          Positioned(
            bottom: 2,
            left: 2,
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: const BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 8),
              ),
            ),
          ),

          // Green Dot
          Positioned(
            bottom: 4,
            left: 14,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  _BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
