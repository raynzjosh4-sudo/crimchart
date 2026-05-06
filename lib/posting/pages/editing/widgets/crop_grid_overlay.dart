import 'package:flutter/material.dart';
import 'dart:ui';

/// A premium, Dribbble-style interactive crop overlay.
/// Features professional L-shaped handles, rule-of-thirds grid,
/// and smooth background dimming.
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

class _CropGridOverlayState extends State<CropGridOverlay> with SingleTickerProviderStateMixin {
  late Rect _rect;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _rect = widget.initialRect;
  }

  void _handlePanStart(_) => setState(() => _isDragging = true);
  void _handlePanEnd(_)   => setState(() => _isDragging = false);

  void _handlePanUpdate(DragUpdateDetails details, Size size, String dragType) {
    double dx = details.delta.dx / size.width;
    double dy = details.delta.dy / size.height;

    double left   = _rect.left;
    double top    = _rect.top;
    double right  = _rect.right;
    double bottom = _rect.bottom;

    // Movement logic
    if (dragType == 'top-left')     { left += dx; top += dy; }
    else if (dragType == 'top-right')    { right += dx; top += dy; }
    else if (dragType == 'bottom-left')  { left += dx; bottom += dy; }
    else if (dragType == 'bottom-right') { right += dx; bottom += dy; }
    else if (dragType == 'top')          { top += dy; }
    else if (dragType == 'bottom')       { bottom += dy; }
    else if (dragType == 'left')         { left += dx; }
    else if (dragType == 'right')        { right += dx; }
    else if (dragType == 'center')       { 
      left += dx; right += dx; top += dy; bottom += dy; 
    }

    // Clamping & Constraints
    left   = left.clamp(0.0, 0.8);
    top    = top.clamp(0.0, 0.8);
    right  = right.clamp(0.2, 1.0);
    bottom = bottom.clamp(0.2, 1.0);

    // Minimum size check (20%)
    if (right - left < 0.2) {
      if (dragType.contains('left')) left = right - 0.2;
      else right = left + 0.2;
    }
    if (bottom - top < 0.2) {
      if (dragType.contains('top')) top = bottom - 0.2;
      else bottom = top + 0.2;
    }

    // Bounds check for center drag
    if (left < 0) { right -= left; left = 0; }
    if (right > 1) { left -= (right - 1); right = 1; }
    if (top < 0) { bottom -= top; top = 0; }
    if (bottom > 1) { top -= (bottom - 1); bottom = 1; }

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
            // 1. Dimmable Backdrop
            CustomPaint(painter: _CropBackdropPainter(rect: _rect)),

            // 2. Center Draggable Area
            Positioned(
              left: _rect.left * size.width,
              top: _rect.top * size.height,
              width: (_rect.right - _rect.left) * size.width,
              height: (_rect.bottom - _rect.top) * size.height,
              child: GestureDetector(
                onPanStart: _handlePanStart,
                onPanUpdate: (d) => _handlePanUpdate(d, size, 'center'),
                onPanEnd: _handlePanEnd,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: _isDragging ? _GridLines(rect: _rect) : null,
                ),
              ),
            ),

            // 3. Professional Corner Handles (L-Shapes)
            _handle(size, _rect.left,  _rect.top,    'top-left'),
            _handle(size, _rect.right, _rect.top,    'top-right'),
            _handle(size, _rect.left,  _rect.bottom, 'bottom-left'),
            _handle(size, _rect.right, _rect.bottom, 'bottom-right'),

            // 4. Side Handles
            _handle(size, (_rect.left + _rect.right) / 2, _rect.top, 'top', isSide: true),
            _handle(size, (_rect.left + _rect.right) / 2, _rect.bottom, 'bottom', isSide: true),
            _handle(size, _rect.left, (_rect.top + _rect.bottom) / 2, 'left', isSide: true),
            _handle(size, _rect.right, (_rect.top + _rect.bottom) / 2, 'right', isSide: true),
          ],
        );
      },
    );
  }

  Widget _handle(Size size, double x, double y, String type, {bool isSide = false}) {
    return Positioned(
      left: x * size.width - (isSide ? 20 : 25),
      top:  y * size.height - (isSide ? 20 : 25),
      child: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: (d) => _handlePanUpdate(d, size, type),
        onPanEnd: _handlePanEnd,
        child: Container(
          width: isSide ? 40 : 50,
          height: isSide ? 40 : 50,
          color: Colors.transparent,
          child: Center(
            child: isSide 
              ? Container(
                  width: type == 'top' || type == 'bottom' ? 24 : 4,
                  height: type == 'left' || type == 'right' ? 24 : 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1)
                    ],
                  ),
                )
              : _CornerGraphic(type: type, isDragging: _isDragging),
          ),
        ),
      ),
    );
  }
}

class _CornerGraphic extends StatelessWidget {
  final String type;
  final bool isDragging;
  const _CornerGraphic({required this.type, required this.isDragging});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _CornerPainter(type: type, color: isDragging ? Colors.white : Colors.white70),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final String type;
  final Color color;
  _CornerPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    const length = 18.0;

    if (type == 'top-left') {
      path.moveTo(0, length);
      path.lineTo(0, 0);
      path.lineTo(length, 0);
    } else if (type == 'top-right') {
      path.moveTo(size.width - length, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, length);
    } else if (type == 'bottom-left') {
      path.moveTo(0, size.height - length);
      path.lineTo(0, size.height);
      path.lineTo(length, size.height);
    } else if (type == 'bottom-right') {
      path.moveTo(size.width - length, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height - length);
    }

    // Add a shadow for better visibility on complex backgrounds
    canvas.drawPath(path, Paint()
      ..color = Colors.black26
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));

    canvas.drawPath(path, paint);
  }

  @override bool shouldRepaint(covariant CustomPainter old) => true;
}

class _GridLines extends StatelessWidget {
  final Rect rect;
  const _GridLines({required this.rect});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 0.8;

    // Rule of thirds
    for (int i = 1; i <= 2; i++) {
      double x = size.width * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      
      double y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter old) => false;
}

class _CropBackdropPainter extends CustomPainter {
  final Rect rect;
  _CropBackdropPainter({required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTRB(
      rect.left * size.width,
      rect.top * size.height,
      rect.right * size.width,
      rect.bottom * size.height,
    );

    // Dimmed background
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRect(r),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.65),
    );
  }

  @override bool shouldRepaint(covariant _CropBackdropPainter old) => old.rect != rect;
}
