import 'package:flutter/material.dart';

/// Interactive crop-grid overlay (rule-of-thirds grid with draggable corners).
class CropGridOverlay extends StatefulWidget {
  final Rect initialRect;
  final ValueChanged<Rect> onChanged;

  const CropGridOverlay({
    super.key,
    required this.initialRect,
    required this.onChanged,
  });

  @override
  State<CropGridOverlay> createState() => _CropGridOverlayState();
}

class _CropGridOverlayState extends State<CropGridOverlay> {
  late Rect _rect;

  @override
  void initState() {
    super.initState();
    _rect = widget.initialRect;
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size, String dragType) {
    double dx = details.delta.dx / size.width;
    double dy = details.delta.dy / size.height;

    double left   = _rect.left;
    double top    = _rect.top;
    double right  = _rect.right;
    double bottom = _rect.bottom;

    if (dragType.contains('left'))   left   += dx;
    if (dragType.contains('right'))  right  += dx;
    if (dragType.contains('top'))    top    += dy;
    if (dragType.contains('bottom')) bottom += dy;
    if (dragType == 'center') {
      left   += dx; right  += dx;
      top    += dy; bottom += dy;
    }

    left   = left.clamp(0.0, 1.0);
    top    = top.clamp(0.0, 1.0);
    right  = right.clamp(0.0, 1.0);
    bottom = bottom.clamp(0.0, 1.0);

    if (right - left < 0.2) {
      if (dragType.contains('left'))  left  = right - 0.2;
      if (dragType.contains('right')) right = left  + 0.2;
    }
    if (bottom - top < 0.2) {
      if (dragType.contains('top'))    top    = bottom - 0.2;
      if (dragType.contains('bottom')) bottom = top    + 0.2;
    }

    setState(() => _rect = Rect.fromLTRB(left, top, right, bottom));
    widget.onChanged(_rect);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _CropPainter(rect: _rect)),
            GestureDetector(
              onPanUpdate: (d) => _handlePanUpdate(d, size, 'center'),
              child: Container(color: Colors.transparent),
            ),
            _corner(size, _rect.left,  _rect.top,    'top-left'),
            _corner(size, _rect.right, _rect.top,    'top-right'),
            _corner(size, _rect.left,  _rect.bottom, 'bottom-left'),
            _corner(size, _rect.right, _rect.bottom, 'bottom-right'),
          ],
        );
      },
    );
  }

  Widget _corner(Size size, double x, double y, String type) {
    return Positioned(
      left: x * size.width  - 20,
      top:  y * size.height - 20,
      child: GestureDetector(
        onPanUpdate: (d) => _handlePanUpdate(d, size, type),
        child: Container(
          width: 40,
          height: 40,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black26, width: 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CropPainter extends CustomPainter {
  final Rect rect;
  _CropPainter({required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTRB(
      rect.left * size.width,
      rect.top * size.height,
      rect.right * size.width,
      rect.bottom * size.height,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRect(r),
      ),
      Paint()..color = Colors.black87,
    );

    final solid = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final grid = Paint()
      ..color = Colors.white60
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(r, solid);

    double w3 = r.width / 3;
    double h3 = r.height / 3;

    canvas.drawLine(Offset(r.left + w3,     r.top), Offset(r.left + w3,     r.bottom), grid);
    canvas.drawLine(Offset(r.left + w3 * 2, r.top), Offset(r.left + w3 * 2, r.bottom), grid);
    canvas.drawLine(Offset(r.left, r.top + h3),     Offset(r.right, r.top + h3),       grid);
    canvas.drawLine(Offset(r.left, r.top + h3 * 2), Offset(r.right, r.top + h3 * 2),   grid);
  }

  @override
  bool shouldRepaint(covariant _CropPainter old) => old.rect != rect;
}
