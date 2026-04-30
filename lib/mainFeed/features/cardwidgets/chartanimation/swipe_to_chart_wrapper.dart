import 'dart:math' as math;
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/widgets/channelinfo/stacked_contestants.dart';
import 'package:crown/gifts/horizontalgiftscroll/horizontal_gift_scroll.dart';
import 'package:crown/gifts/models/gift_recipient.dart';
import 'package:flutter/material.dart';

class SwipeToChartWrapper extends StatefulWidget {
  final Widget child;
  final List<String?> avatarUrls;
  final Color themeColor;
  final String username;
  final String userProfileImageUrl;

  const SwipeToChartWrapper({
    super.key,
    required this.child,
    required this.avatarUrls,
    required this.themeColor,
    required this.username,
    required this.userProfileImageUrl,
  });

  @override
  State<SwipeToChartWrapper> createState() => _SwipeToChartWrapperState();
}

class _SwipeToChartWrapperState extends State<SwipeToChartWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;
  double _dragOffset = 0.0;
  bool _isChartMode = false;
  final GlobalKey _avatarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isChartMode) return;
    setState(() {
      // Allow only right swipe
      _dragOffset += details.primaryDelta!;
      _dragOffset = _dragOffset.clamp(0.0, 300.0);

      // Update anim value based on drag for manual control if needed,
      // but here we'll just use it to trigger the full animation.
      if (!_animController.isAnimating) {
        _animController.value = (_dragOffset / 200).clamp(0.0, 1.0);
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_isChartMode) {
      if (_dragOffset < 100 || details.primaryVelocity! < -500) {
        _exitChartMode();
      } else {
        _animController.forward(); // Ensure it stays open
      }
      return;
    }

    if (_dragOffset > 80 || details.primaryVelocity! > 500) {
      _enterChartMode();
    } else {
      _resetPosition();
    }
  }

  void _enterChartMode() {
    setState(() => _isChartMode = true);
    _animController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
    );
  }

  void _exitChartMode() {
    _animController
        .animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        )
        .then((_) {
          setState(() {
            _isChartMode = false;
            _dragOffset = 0.0;
          });
        });
  }

  void _resetPosition() {
    _animController.animateTo(0.0);
    setState(() => _dragOffset = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background (Chart Mode UI)
          if (_isChartMode || _dragOffset > 0) _buildChartUI(),

          // The Card (Child)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final double progress = _animation.value;

              // Transformation constants based on the high-end design
              final double scale = 1.0 - (progress * 0.28);
              final double xOffset = progress * 100.w;
              final double yOffset = progress * 40.h;
              final double tilt = progress * (math.pi / 22); // ~8 degrees

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..translate(xOffset, yOffset)
                  ..scale(scale)
                  ..rotateZ(tilt),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r * progress),
                    boxShadow: [
                      if (progress > 0.1)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4 * progress),
                          blurRadius: 30,
                          spreadRadius: 2,
                          offset: const Offset(10, 20),
                        ),
                      if (progress > 0.5)
                        BoxShadow(
                          color: widget.themeColor.withValues(
                            alpha: 0.3 * (progress - 0.5) * 2,
                          ),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r * progress),
                    child: widget.child,
                  ),
                ),
              );
            },
          ),

          // Floating Close Button (Only in Chart Mode)
          if (_isChartMode && _animController.value > 0.8)
            Positioned(
              top: 40.h,
              right: 20.w,
              child: GestureDetector(
                onTap: _exitChartMode,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChartUI() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final double progress = _animController.value;
          return Opacity(
            opacity: progress.clamp(0.0, 1.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3 * progress),
              child: Column(
                children: [
                  SizedBox(
                    height: 60.h * (1 - progress) + 30.h,
                  ), // Slide in from top
                  // Top Overlay: Stacked Contestants
                  Transform.translate(
                    offset: Offset(0, -20.h * (1 - progress)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            key:
                                _avatarKey, // Attach key for the gift animation to find its destination
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (_isChartMode)
                                  BoxShadow(
                                    color: widget.themeColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                              ],
                            ),
                            child: StackedContestants(
                              avatarUrls: widget.avatarUrls,
                              avatarSize: 62, // Slightly larger for emphasis
                              overlapOffset: 38,
                              borderColor: Colors.black,
                              borderWidth: 2,
                              maxAvatars: 4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'REVEALING Chart'.toUpperCase(),
                            style: TextStyle(
                              color: widget.themeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Overlay: Gifts/Reactions
                  Transform.translate(
                    offset: Offset(0, 40.h * (1 - progress)),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HorizontalGiftScroll(
                            themeColor: widget.themeColor,
                            onSeeAll: () {},
                            recipient: GiftRecipient(
                              id: 'Chart_target',
                              name: widget.username,
                              avatarUrl: widget.userProfileImageUrl,
                              avatarKey: _avatarKey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: widget.themeColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Chart OPTIONS',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: widget.themeColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}











