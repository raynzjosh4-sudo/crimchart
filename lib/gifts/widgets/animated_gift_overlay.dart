import 'package:flutter/material.dart';

class AnimatedGiftOverlay {
  static void show({
    required BuildContext context,
    required String giftImageUrl,
    required Offset sourceOffset,
    required GlobalKey targetKey,
    VoidCallback? onArrival,
  }) {
    final OverlayState overlayState = Overlay.of(context);
    
    // Find target position
    final RenderBox? targetBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (targetBox == null) return;
    
    final Offset targetOffset = targetBox.localToGlobal(Offset.zero);
    final Size targetSize = targetBox.size;
    final Offset destination = Offset(
      targetOffset.dx + targetSize.width / 2 - 20, // Center the gift (40x40)
      targetOffset.dy + targetSize.height / 2 - 20,
    );

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _MovingGift(
        imageUrl: giftImageUrl,
        start: sourceOffset,
        end: destination,
        onArrival: onArrival,
        onComplete: () => overlayEntry.remove(),
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

class _MovingGift extends StatefulWidget {
  final String imageUrl;
  final Offset start;
  final Offset end;
  final VoidCallback onComplete;
  final VoidCallback? onArrival;

  const _MovingGift({
    required this.imageUrl,
    required this.start,
    required this.end,
    required this.onComplete,
    this.onArrival,
  });

  @override
  State<_MovingGift> createState() => _MovingGiftState();
}

class _MovingGiftState extends State<_MovingGift> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _arrivalCalled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.start,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOutBack),
    ));

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.5), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));

    _opacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _controller.addListener(_checkArrival);
    _controller.forward().then((_) => widget.onComplete());
  }

  void _checkArrival() {
    if (_controller.value >= 0.8 && !_arrivalCalled) {
      _arrivalCalled = true;
      widget.onArrival?.call();
    }
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
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.stars, color: Colors.amber, size: 30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}





























