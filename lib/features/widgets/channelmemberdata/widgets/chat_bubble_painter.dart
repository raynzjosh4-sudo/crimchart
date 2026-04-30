import 'package:flutter/material.dart';

class ChatBubblePainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  ChatBubblePainter({required this.color, this.isLeft = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const double radius = 18.0;
    const double tailWidth = 10.0;
    const double tailHeight = 12.0;

    if (isLeft) {
      // 👑 WhatsApp-style Left Tail (Top-Left)
      path.moveTo(tailWidth, tailHeight);
      path.lineTo(0, 0);
      path.lineTo(tailWidth + radius, 0);
      path.arcToPoint(
        const Offset(tailWidth, radius),
        radius: const Radius.circular(radius),
        clockwise: false,
      );
      path.close();
      
      // Main Body
      final bodyRect = RRect.fromLTRBAndCorners(
        tailWidth,
        0,
        size.width,
        size.height,
        topLeft: Radius.zero,
        topRight: const Radius.circular(radius),
        bottomLeft: const Radius.circular(radius),
        bottomRight: const Radius.circular(radius),
      );
      canvas.drawRRect(bodyRect, paint);
      canvas.drawPath(path, paint);
    } else {
      // 👑 WhatsApp-style Right Tail (Top-Right)
      path.moveTo(size.width - tailWidth, tailHeight);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - tailWidth - radius, 0);
      path.arcToPoint(
        Offset(size.width - tailWidth, radius),
        radius: const Radius.circular(radius),
        clockwise: true,
      );
      path.close();

      // Main Body
      final bodyRect = RRect.fromLTRBAndCorners(
        0,
        0,
        size.width - tailWidth,
        size.height,
        topLeft: const Radius.circular(radius),
        topRight: Radius.zero,
        bottomLeft: const Radius.circular(radius),
        bottomRight: const Radius.circular(radius),
      );
      canvas.drawRRect(bodyRect, paint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
