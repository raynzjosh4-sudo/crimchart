import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/core/widgets/chart_image.dart';

class MemberImage extends StatelessWidget {
  final double size;
  final double borderWidth;
  final String? imageUrl;
  final bool showStatusRing;
  final bool showActiveDot;
  final bool useHexagon;
  final VoidCallback? onTap;
  final Color? ringColor;

  const MemberImage({
    super.key,
    this.size = 50.0,
    this.borderWidth = 2.0,
    this.imageUrl,
    this.showStatusRing = true,
    this.showActiveDot = true,
    this.useHexagon = false,
    this.onTap,
    this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background/Border Container
            if (useHexagon)
              CustomPaint(
                size: Size(size, size),
                painter: _HexagonPainter(
                  color: showStatusRing
                      ? (ringColor ?? colorScheme.primary)
                      : Colors.grey.withOpacity(0.3),
                  borderWidth: showStatusRing ? borderWidth : 1.0,
                ),
                child: Container(
                  width: size,
                  height: size,
                  padding: EdgeInsets.all(showStatusRing ? borderWidth + 2 : 2),
                  child: ClipPath(
                    clipper: _HexagonClipper(),
                    child: _buildImageContent(size, colorScheme),
                  ),
                ),
              )
            else
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: showStatusRing
                      ? Border.all(
                          color: ringColor ?? colorScheme.primary,
                          width: borderWidth,
                        )
                      : null,
                ),
                child: Padding(
                  padding: EdgeInsets.all(showStatusRing ? 2.0 : 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _buildImageContent(size, colorScheme),
                    ),
                  ),
                ),
              ),

            // Active Dot
            if (showActiveDot)
              Positioned(
                bottom: useHexagon ? -2 : size * 0.04,
                right: useHexagon ? -2 : size * 0.04,
                child: Container(
                  width: size * 0.24,
                  height: size * 0.24,
                  decoration: BoxDecoration(
                    color: colorScheme.primary, // 👑 Yellow Theme Sync
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: size * 0.04,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(double size, ColorScheme colorScheme) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ChartImage(
        url: imageUrl!,
        fit: BoxFit.cover,
      );
    }
    return _buildPlaceholder(size, colorScheme);
  }

  Widget _buildPlaceholder(double size, ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
        size: size * 0.5,
      ),
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return _getHexagonPath(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _HexagonPainter extends CustomPainter {
  final Color color;
  final double borderWidth;

  _HexagonPainter({required this.color, required this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(_getHexagonPath(size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path _getHexagonPath(Size size) {
  final path = Path();
  final w = size.width;
  final h = size.height;
  final centerX = w / 2;
  final centerY = h / 2;
  final radius = math.min(centerX, centerY);

  // Pointy top hexagon
  for (int i = 0; i < 6; i++) {
    double angle = (i * 60 - 90) * math.pi / 180;
    double x = centerX + radius * math.cos(angle);
    double y = centerY + radius * math.sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}
