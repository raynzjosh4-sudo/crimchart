import 'dart:math';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CompetitionLikeButton extends StatefulWidget {
  final int initialLikes;
  final bool isLiked;
  final VoidCallback? onTap;

  const CompetitionLikeButton({
    super.key,
    required this.initialLikes,
    this.isLiked = false,
    this.onTap,
  });

  @override
  State<CompetitionLikeButton> createState() => _CompetitionLikeButtonState();
}

class _CompetitionLikeButtonState extends State<CompetitionLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLiked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likes = widget.initialLikes;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likes++;
        _controller.forward(from: 0);
        _showBubbles();
      } else {
        _likes = max(0, _likes - 1);
      }
    });
    if (widget.onTap != null) widget.onTap!();
  }

  void _showBubbles() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final themeColor = Theme.of(context).primaryColor;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _LikeBubbles(
        startOffset: Offset(
          offset.dx + renderBox.size.width / 2,
          offset.dy + 10,
        ),
        color: themeColor,
        onComplete: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              LucideIcons.heart,
              color: _isLiked ? themeColor : Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$_likes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeBubbles extends StatefulWidget {
  final Offset startOffset;
  final Color color;
  final VoidCallback onComplete;

  const _LikeBubbles({
    required this.startOffset,
    required this.color,
    required this.onComplete,
  });

  @override
  State<_LikeBubbles> createState() => _LikeBubblesState();
}

class _LikeBubblesState extends State<_LikeBubbles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_BubbleData> _bubbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    for (int i = 0; i < 6; i++) {
      _bubbles.add(
        _BubbleData(
          angle: (i * 60 + _random.nextInt(30)) * pi / 180,
          distance: 40.0 + _random.nextDouble() * 40.0,
          size: 4.0 + _random.nextDouble() * 6.0,
        ),
      );
    }

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _bubbles.map((bubble) {
            final progress = _controller.value;
            final currentDistance = bubble.distance * progress;
            final x =
                widget.startOffset.dx + cos(bubble.angle) * currentDistance;
            final y =
                widget.startOffset.dy -
                sin(bubble.angle) * currentDistance -
                (progress * 50);

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: (1 - progress).clamp(0, 1),
                child: Container(
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _BubbleData {
  final double angle;
  final double distance;
  final double size;
  _BubbleData({
    required this.angle,
    required this.distance,
    required this.size,
  });
}











