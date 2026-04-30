import 'dart:math';
import 'package:flutter/material.dart';

class LikeAction extends StatefulWidget {
  final int initialLikes;
  final Color themeColor;
  final Color? inactiveColor;
  final double iconSize;
  final TextStyle? textStyle;
  final bool initialIsLiked;
  final ValueChanged<bool>? onLikeChanged;

  const LikeAction({
    super.key,
    required this.initialLikes,
    required this.themeColor,
    this.initialIsLiked = false,
    this.inactiveColor,
    this.iconSize = 16.0,
    this.textStyle,
    this.onLikeChanged,
  });

  @override
  State<LikeAction> createState() => _LikeActionState();
}

class _LikeActionState extends State<LikeAction> {
  late int _likes;
  bool _isLiked = false;
  final GlobalKey _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
    _isLiked = widget.initialIsLiked;
  }

  @override
  void didUpdateWidget(LikeAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLikes != oldWidget.initialLikes && !_isLiked) {
      _likes = widget.initialLikes;
    }
  }

  String _formatLikes(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}m';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likes++;
        _showBubbles();
      } else {
        _likes--;
      }
    });
    if (widget.onLikeChanged != null) {
      widget.onLikeChanged!(_isLiked);
    }
  }

  void _showBubbles() {
    final RenderBox? renderBox =
        _iconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final center = Offset(
      offset.dx + size.width / 2,
      offset.dy + size.height / 2,
    );

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return _BubblesAnimation(
          center: center,
          color: widget.themeColor,
          onComplete: () {
            if (entry.mounted) {
              entry.remove();
            }
          },
        );
      },
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveInactiveColor = widget.inactiveColor ??
        Theme.of(context).colorScheme.onSurface;

    final defaultTextStyle =
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
            .merge(widget.textStyle)
            .copyWith(
              color: _isLiked ? widget.themeColor : effectiveInactiveColor,
            );

    return GestureDetector(
      onTap: _toggleLike,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            key: _iconKey,
            _isLiked ? Icons.favorite : Icons.favorite_border,
            size: widget.iconSize,
            color: _isLiked ? widget.themeColor : effectiveInactiveColor,
          ),
          const SizedBox(width: 4),
          Text(_formatLikes(_likes), style: defaultTextStyle),
        ],
      ),
    );
  }
}

class _BubblesAnimation extends StatefulWidget {
  final Offset center;
  final Color color;
  final VoidCallback onComplete;

  const _BubblesAnimation({
    required this.center,
    required this.color,
    required this.onComplete,
  });

  @override
  State<_BubblesAnimation> createState() => _BubblesAnimationState();
}

class _BubblesAnimationState extends State<_BubblesAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<_Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _bubbles = List.generate(24, (index) {
      final angle = _random.nextDouble() * 2 * pi;
      // 🚀 Make the burst much wider
      final distance = 40.0 + _random.nextDouble() * 80.0;
      final dx = cos(angle) * distance;
      final dy = sin(angle) * distance - 30.0;
      final size = 2.0 + _random.nextDouble() * 6.0;

      return _Bubble(dx: dx, dy: dy, size: size);
    });

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward().then((_) {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _BubblesPainter(
            center: widget.center,
            color: widget.color,
            progress: _controller.value,
            bubbles: _bubbles,
          ),
        ),
      ),
    );
  }
}

class _Bubble {
  final double dx;
  final double dy;
  final double size;
  _Bubble({required this.dx, required this.dy, required this.size});
}

class _BubblesPainter extends CustomPainter {
  final Offset center;
  final Color color;
  final double progress; // 0.0 to 1.0
  final List<_Bubble> bubbles;

  _BubblesPainter({
    required this.center,
    required this.color,
    required this.progress,
    required this.bubbles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;

    // Scale alpha down from 255 to 0 as progress goes 0 to 1
    final alpha = ((1.0 - progress) * 255).clamp(0, 255).toInt();
    final paint = Paint()
      ..color = color.withAlpha(alpha)
      ..style = PaintingStyle.fill;

    for (var bubble in bubbles) {
      // Ease out curve
      final curve = Curves.easeOut.transform(progress);
      final currentX = center.dx + bubble.dx * curve;
      final currentY = center.dy + bubble.dy * curve;

      canvas.drawCircle(Offset(currentX, currentY), bubble.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}





























