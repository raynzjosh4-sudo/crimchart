import 'dart:io';
import 'package:crimchart/posting/models/media_item.dart';
import 'package:crimchart/posting/pages/editing/functioning/edit_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'crop_grid_overlay.dart';

class EditMediaPreview extends StatefulWidget {
  final List<MediaItem> selectedMedia;
  final List<MediaEditState> mediaStates;
  final int currentPage;
  final PageController pageController;
  final bool isCropMode;
  final bool isDrawingMode;
  final ColorFilter? Function(MediaEditState) buildFilter;
  final Function(int) onPageChanged;
  final Function(MediaEditState) onTogglePlay;
  final Function(MediaEditState, MediaOverlayUI, Offset, Size?) onMoveSticker;
  final Function(MediaOverlayUI) onAdjustSticker;
  final Function(MediaOverlayUI) onRemoveSticker;
  final VoidCallback onToggleCrop;
  final Function(int) onRemoveItem;
  final Function(MediaEditState, Offset) onStartDrawing;
  final Function(MediaEditState, Offset) onUpdateDrawing;

  const EditMediaPreview({
    super.key,
    required this.selectedMedia,
    required this.mediaStates,
    required this.currentPage,
    required this.pageController,
    required this.isCropMode,
    required this.isDrawingMode,
    required this.buildFilter,
    required this.onPageChanged,
    required this.onTogglePlay,
    required this.onMoveSticker,
    required this.onAdjustSticker,
    required this.onRemoveSticker,
    required this.onToggleCrop,
    required this.onRemoveItem,
    required this.onStartDrawing,
    required this.onUpdateDrawing,
  });

  @override
  State<EditMediaPreview> createState() => _EditMediaPreviewState();
}

class _EditMediaPreviewState extends State<EditMediaPreview> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      itemCount: widget.selectedMedia.length,
      onPageChanged: widget.onPageChanged,
      physics: widget.isCropMode || widget.isDrawingMode
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final state = widget.mediaStates[index];
        return _MediaFrame(
          state: state,
          isCropMode: widget.isCropMode,
          isDrawingMode: widget.isDrawingMode,
          filter: widget.buildFilter(state),
          onTogglePlay: () => widget.onTogglePlay(state),
          onMoveSticker: (sticker, delta, size) =>
              widget.onMoveSticker(state, sticker, delta, size),
          onAdjustSticker: widget.onAdjustSticker,
          onRemoveSticker: widget.onRemoveSticker,
          onRemove: () => widget.onRemoveItem(index),
          onStartDrawing: (p) => widget.onStartDrawing(state, p),
          onUpdateDrawing: (p) => widget.onUpdateDrawing(state, p),
          mediaImage: Image.file(File(state.item.path), fit: BoxFit.contain),
        );
      },
    );
  }
}

class _MediaFrame extends StatefulWidget {
  final MediaEditState state;
  final bool isCropMode;
  final bool isDrawingMode;
  final ColorFilter? filter;
  final VoidCallback onTogglePlay;
  final Function(MediaOverlayUI, Offset, Size?) onMoveSticker;
  final Function(MediaOverlayUI) onAdjustSticker;
  final Function(MediaOverlayUI) onRemoveSticker;
  final VoidCallback onRemove;
  final Function(Offset) onStartDrawing;
  final Function(Offset) onUpdateDrawing;
  final Widget mediaImage;

  const _MediaFrame({
    required this.state,
    required this.isCropMode,
    required this.isDrawingMode,
    this.filter,
    required this.onTogglePlay,
    required this.onMoveSticker,
    required this.onAdjustSticker,
    required this.onRemoveSticker,
    required this.onRemove,
    required this.onStartDrawing,
    required this.onUpdateDrawing,
    required this.mediaImage,
  });

  @override
  State<_MediaFrame> createState() => _MediaFrameState();
}

class _MediaFrameState extends State<_MediaFrame> {
  double _dragY = 0;
  bool _isDragging = false;
  double _initialStickerScale = 1.0;
  double _initialStickerRotation = 0.0;

  @override
  Widget build(BuildContext context) {
    final isContentActive = !widget.isCropMode && !widget.isDrawingMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onTogglePlay,
                onVerticalDragUpdate: (details) {
                  if (isContentActive) {
                    setState(() {
                      _dragY += details.delta.dy;
                      _isDragging = true;
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  if (_isDragging) {
                    if (_dragY < -150) {
                      widget.onRemove();
                    }
                    setState(() {
                      _dragY = 0;
                      _isDragging = false;
                    });
                  }
                },
                child: Transform.translate(
                  offset: Offset(0, _dragY.clamp(-200.0, 0.0)),
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: ColorFiltered(
                        colorFilter:
                            widget.filter ??
                            const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.multiply,
                            ),
                        child:
                            widget.state.item.type == MediaType.video &&
                                widget
                                        .state
                                        .videoController
                                        ?.value
                                        .isInitialized ==
                                    true
                            ? Center(
                                child: AspectRatio(
                                  aspectRatio: widget
                                      .state
                                      .videoController!
                                      .value
                                      .aspectRatio,
                                  child: VideoPlayer(
                                    widget.state.videoController!,
                                  ),
                                ),
                              )
                            : widget.mediaImage,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.isDrawingMode)
              Positioned.fill(
                child: GestureDetector(
                  onPanStart: (d) => widget.onStartDrawing(d.localPosition),
                  onPanUpdate: (d) => widget.onUpdateDrawing(d.localPosition),
                  child: Container(color: Colors.transparent),
                ),
              ),
            if (widget.isCropMode)
              CropGridOverlay(
                initialRect: widget.state.cropRect,
                onChanged: (rect) => widget.state.cropRect = rect,
              ),
            ...widget.state.stickers.map((sticker) {
              return Positioned(
                left: sticker.position.dx,
                top: sticker.position.dy,
                child: GestureDetector(
                  onTap: () {
                    widget.onAdjustSticker(sticker);
                  },
                  onDoubleTap: () => widget.onRemoveSticker(sticker),
                  onScaleStart: (details) {
                    _initialStickerScale = sticker.scale;
                    _initialStickerRotation = sticker.rotation;
                  },
                  onScaleUpdate: (details) {
                    widget.onMoveSticker(
                      sticker,
                      details.focalPointDelta,
                      Size(constraints.maxWidth, constraints.maxHeight),
                    );
                    if (details.scale != 1.0 || details.rotation != 0.0) {
                      sticker.scale = (_initialStickerScale * details.scale).clamp(0.5, 5.0);
                      sticker.rotation = _initialStickerRotation + details.rotation;
                      setState(() {});
                    }
                  },
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(sticker.scale)
                      ..rotateZ(sticker.rotation),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.85),
                      child: sticker.text != null
                          ? (sticker.color == null && !sticker.hasBackground
                              ? _EmojiOverlay(emoji: sticker.text!)
                              : _TextOverlay(sticker: sticker))
                          : (sticker.imagePath != null
                              ? Image.asset(
                                  sticker.imagePath!,
                                  width: 80,
                                  height: 80,
                                  errorBuilder: (_, __, ___) =>
                                      _EmojiOverlay(emoji: '🖼️'),
                                )
                              : const SizedBox.shrink()),
                    ),
                  ),
                ),
              );
            }),
            if (widget.state.drawingPaths.isNotEmpty)
              IgnorePointer(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _DrawingPainter(
                    paths: widget.state.drawingPaths,
                    color: widget.state.currentDrawingColor,
                    strokeWidth: widget.state.drawingStrokeWidth,
                  ),
                ),
              ),
            if (isContentActive && widget.state.item.type == MediaType.video)
              IgnorePointer(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: widget.state.isPlaying ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.state.isPlaying
                            ? LucideIcons.pause
                            : LucideIcons.play,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> paths;
  final Color color;
  final double strokeWidth;

  _DrawingPainter({
    required this.paths,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final path in paths) {
      if (path.isEmpty) continue;
      final p = Path();
      p.moveTo(path.first.dx, path.first.dy);
      for (int i = 1; i < path.length; i++) {
        p.lineTo(path[i].dx, path[i].dy);
      }
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}

// ── Text overlay (Organic 'Instagram' Melted Background) ──────────────────────

class _TextOverlay extends StatelessWidget {
  final MediaOverlayUI sticker;

  const _TextOverlay({required this.sticker});

  @override
  Widget build(BuildContext context) {
    final textColor = sticker.color ?? Colors.white;
    final hasBg = sticker.hasBackground;

    final bgLuminance = hasBg ? textColor.computeLuminance() : 0.0;
    final onBgColor = bgLuminance > 0.5 ? Colors.black : Colors.white;

    final lines = sticker.text!.split('\n');
    const double fontSize = 26;
    const double linePaddingH = 18.0;
    const double linePaddingV = 8.0;
    const double borderRadius = 18.0;

    return IntrinsicWidth(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasBg)
            Positioned.fill(
              child: CustomPaint(
                painter: _MeltedBackgroundPainter(
                  text: sticker.text!,
                  fontSize: fontSize,
                  fontFamily: sticker.fontFamily ?? 'monospace',
                  color: textColor,
                  paddingH: linePaddingH,
                  paddingV: linePaddingV,
                  radius: borderRadius,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: hasBg ? linePaddingV : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: lines.map((line) {
                if (line.trim().isEmpty)
                  return const SizedBox(height: fontSize);
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hasBg ? linePaddingH : 0,
                  ),
                  child: Text(
                    line,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: hasBg ? onBgColor : textColor,
                      fontSize: fontSize,
                      fontFamily: sticker.fontFamily ?? 'monospace',
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.1,
                      shadows: hasBg
                          ? []
                          : [
                              const Shadow(
                                blurRadius: 1,
                                offset: Offset(-1, -1),
                                color: Colors.black,
                              ),
                              const Shadow(
                                blurRadius: 1,
                                offset: Offset(1, -1),
                                color: Colors.black,
                              ),
                              const Shadow(
                                blurRadius: 1,
                                offset: Offset(-1, 1),
                                color: Colors.black,
                              ),
                              const Shadow(
                                blurRadius: 1,
                                offset: Offset(1, 1),
                                color: Colors.black,
                              ),
                              const Shadow(
                                blurRadius: 8,
                                color: Colors.black54,
                              ),
                            ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeltedBackgroundPainter extends CustomPainter {
  final String text;
  final double fontSize;
  final String fontFamily;
  final Color color;
  final double paddingH;
  final double paddingV;
  final double radius;

  _MeltedBackgroundPainter({
    required this.text,
    required this.fontSize,
    required this.fontFamily,
    required this.color,
    required this.paddingH,
    required this.paddingV,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final lines = text.split('\n');
    final List<Rect> rects = [];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    double currentY = 0;

    // 1. Precise Measurement
    for (var line in lines) {
      if (line.isEmpty) {
        currentY += fontSize;
        continue;
      }
      textPainter.text = TextSpan(
        text: line,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w900,
        ),
      );
      textPainter.layout();

      final width = textPainter.width + (paddingH * 2);
      final height = textPainter.height + (paddingV * 2);
      rects.add(
        Rect.fromLTWH((size.width - width) / 2, currentY, width, height),
      );
      currentY += textPainter.height;
    }

    if (rects.isEmpty) return;

    // 2. Draw Unified Path
    final path = Path();
    for (var r in rects) {
      path.addRRect(RRect.fromRectAndRadius(r, Radius.circular(radius)));
    }

    // Fill the basic rounded rects
    canvas.drawPath(path, paint);

    // 3. Bridging Logic (The "Melt")
    // We add circular/arc fillers at the junctions between lines of different widths
    for (int i = 0; i < rects.length - 1; i++) {
      final rTop = rects[i];
      final rBot = rects[i + 1];

      // LEFT SIDE JUNCTION
      _bridge(canvas, rTop.bottomLeft, rBot.topLeft, paint, true);
      // RIGHT SIDE JUNCTION
      _bridge(canvas, rTop.bottomRight, rBot.topRight, paint, false);
    }
  }

  void _bridge(
    Canvas canvas,
    Offset pTop,
    Offset pBot,
    Paint paint,
    bool isLeft,
  ) {
    final double diff = (pTop.dx - pBot.dx);
    if (diff.abs() < 4) return; // Same width

    final path = Path();
    final double r = radius;

    if (isLeft) {
      if (diff < 0) {
        // Top is narrower than bottom
        // Concave corner at the junction
        path.moveTo(pTop.dx, pTop.dy);
        path.lineTo(pBot.dx, pTop.dy);
        path.lineTo(pBot.dx, pBot.dy);
        path.quadraticBezierTo(pTop.dx, pBot.dy, pTop.dx, pTop.dy);
      } else {
        // Top is wider than bottom
        path.moveTo(pBot.dx, pBot.dy);
        path.lineTo(pTop.dx, pBot.dy);
        path.lineTo(pTop.dx, pTop.dy);
        path.quadraticBezierTo(pBot.dx, pTop.dy, pBot.dx, pBot.dy);
      }
    } else {
      if (diff > 0) {
        // Top is narrower than bottom (right edge is further left)
        path.moveTo(pTop.dx, pTop.dy);
        path.lineTo(pBot.dx, pTop.dy);
        path.lineTo(pBot.dx, pBot.dy);
        path.quadraticBezierTo(pTop.dx, pBot.dy, pTop.dx, pTop.dy);
      } else {
        // Top is wider than bottom
        path.moveTo(pBot.dx, pBot.dy);
        path.lineTo(pTop.dx, pBot.dy);
        path.lineTo(pTop.dx, pTop.dy);
        path.quadraticBezierTo(pBot.dx, pTop.dy, pBot.dx, pBot.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MeltedBackgroundPainter old) =>
      old.text != text || old.color != color;
}

class _EmojiOverlay extends StatelessWidget {
  final String emoji;

  const _EmojiOverlay({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 48,
          shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
        ),
      ),
    );
  }
}
