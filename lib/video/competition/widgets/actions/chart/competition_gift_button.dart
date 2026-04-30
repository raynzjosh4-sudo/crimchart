import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/video/competition/widgets/actions/chart/gift_bubble_animation.dart';
import 'package:flutter/material.dart';
import '../../../../../../gifts/models/gift_model.dart';

class CompetitionGiftButton extends StatefulWidget {
  final GiftModel gift;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onPlusTap;

  const CompetitionGiftButton({
    super.key,
    required this.gift,
    this.onTap,
    this.onLongPress,
    this.onPlusTap,
  });

  @override
  State<CompetitionGiftButton> createState() => CompetitionGiftButtonState();
}

class CompetitionGiftButtonState extends State<CompetitionGiftButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _pressController.forward().then((_) => _pressController.reverse());
    showBurst();
    if (widget.onTap != null) widget.onTap!();
  }

  void showBurst() {
    final overlay = Overlay.of(context);
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Create a burst of 6 gift icons
    for (int i = 0; i < 6; i++) {
      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (context) => GiftBubbleAnimation(
          startOffset: Offset(
            offset.dx + renderBox.size.width / 2,
            offset.dy + renderBox.size.height / 2,
          ),
          imageUrl: widget.gift.imageUrl,
          onComplete: () => entry.remove(),
        ),
      );
      overlay.insert(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.4),
                      width: 1.5.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Image.network(
                    widget.gift.imageUrl,
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Chart',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











