import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'Charter_stack.dart';
import '../../channelmemberdata/comment_card/thumbnaillink/thumbnail_link.dart';

class ChartStackMediaWrapper extends StatefulWidget {
  final Widget child;
  final String? backgroundImageUrl;
  final String? creatorAvatarUrl;
  final VoidCallback? onThumbnailTap;
  final Color themeColor;
  final String? username;
  final String? subtitle;
  final bool showThumbnail;
  final String? referenceId;

  const ChartStackMediaWrapper({
    super.key,
    required this.child,
    this.backgroundImageUrl,
    this.creatorAvatarUrl,
    this.onThumbnailTap,
    this.themeColor = Colors.pinkAccent,
    this.username,
    this.subtitle,
    this.showThumbnail = true,
    this.referenceId,
  });

  @override
  State<ChartStackMediaWrapper> createState() => _ChartStackMediaWrapperState();
}

class _ChartStackMediaWrapperState extends State<ChartStackMediaWrapper>
    with TickerProviderStateMixin {
  late AnimationController _peel;
  int _dischargedCount = 0;
  int _undocTopIndex = -1;

  @override
  void initState() {
    super.initState();
    _peel = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      lowerBound: 0.0,
      upperBound: 2.0,
    );
  }

  @override
  void dispose() {
    _peel.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d, double sw) {
    final double delta = -(d.primaryDelta ?? 0) / sw;
    final double maxVal = (_dischargedCount < 5) ? 2.0 : 1.0;
    _peel.value = (_peel.value + delta).clamp(0.0, maxVal);
  }

  void _onDragEnd(DragEndDetails d, double sw) {
    final double velocity = -(d.primaryVelocity ?? 0) / sw;

    if (velocity > 0.3 || (_peel.value > 0.4 && velocity > -0.3)) {
      if (_peel.value > 1.0) {
        _peel.animateTo(2.0, curve: Curves.easeOutQuart);
      } else {
        _peel.animateTo(1.0, curve: Curves.easeOutQuart);
      }
    } else {
      if (_peel.value > 1.2) {
        if (_peel.value > 1.7) {
          _peel.animateTo(2.0, curve: Curves.easeOutQuart).then((_) {
            setState(() {
              _dischargedCount++;
              _undocTopIndex = -1;
              _peel.value = 1.0;
            });
          });
        } else {
          _peel.animateTo(1.0, curve: Curves.easeOutQuart);
        }
      } else {
        _peel.animateTo(0.0, curve: Curves.easeOutQuart);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double sw = constraints.maxWidth;
        // Guard against infinite height (e.g. when inside a Column/ListView without bounds)
        final double sh = constraints.maxHeight.isInfinite ? sw : constraints.maxHeight;

        return GestureDetector(
          onHorizontalDragUpdate: (d) => _onDragUpdate(d, sw),
          onHorizontalDragEnd: (d) => _onDragEnd(d, sw),
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              // Layer 1: Background Discovery Gallery
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _peel,
                  builder: (context, _) => CharterStackBackground(
                    discharge: (_peel.value - 1.0).clamp(0.0, 1.0),
                    dischargedCount: _dischargedCount,
                    undocTopIndex: _undocTopIndex,
                    themeColor: widget.themeColor,
                    onUndock: (index) {
                      if (_dischargedCount > 0) {
                        setState(() {
                          _undocTopIndex = index;
                          _dischargedCount--;
                          _peel.value = 2.0;
                        });
                        _peel.animateTo(1.0, curve: Curves.easeOutQuart).then((_) {
                          setState(() => _undocTopIndex = -1);
                        });
                      }
                    },
                  ),
                ),
              ),

              // Layer 2: The Main Animated Media Card
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _peel,
                  builder: (_, __) {
                    final double p = _peel.value.clamp(0.0, 1.0);
                    final double scale = 1.0 - 0.82 * p;
                    final double tx = sw * 0.35 * p;
                    final double ty = sh * 0.42 * p;
                    final double contentOpacity = (1.0 - p * 2.2).clamp(0.0, 1.0);

                    final double targetSize = math.min(sw, sh);
                    final double boxW = sw + (targetSize - sw) * p;
                    final double boxH = sh + (targetSize - sh) * p;
                    final double currentRadius = (targetSize / 2) * p;

                    Widget card = Container(
                      width: boxW,
                      height: boxH,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        image: widget.backgroundImageUrl != null
                            ? DecorationImage(
                                image: widget.backgroundImageUrl!.startsWith('http')
                                    ? NetworkImage(widget.backgroundImageUrl!) as ImageProvider
                                    : AssetImage(widget.backgroundImageUrl!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5 + 0.3 * p),
                                  BlendMode.darken,
                                ),
                              )
                            : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Custom content (e.g. Waveform)
                          Opacity(opacity: contentOpacity, child: widget.child),

                          // Creator Info
                          if (widget.username != null)
                            Positioned(
                              bottom: 20,
                              left: 16,
                              child: Opacity(
                                opacity: contentOpacity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.username!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    if (widget.subtitle != null)
                                      Text(
                                        widget.subtitle!,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );

                    card = ClipRRect(
                      borderRadius: BorderRadius.circular(currentRadius),
                      child: card,
                    );

                    if (p >= 0.95) {
                      card = Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: widget.themeColor, width: 8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 14,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => _peel.animateTo(0.0, curve: Curves.easeOutQuart),
                          child: ClipOval(child: card),
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        Transform(
                          transform: Matrix4.identity()
                            ..translate(tx, ty)
                            ..scale(scale),
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment(0, -0.65 * (1.0 - p)),
                            child: card,
                          ),
                        ),
                        
                        // Floating Thumbnail Link
                        if (widget.showThumbnail && widget.creatorAvatarUrl != null) ...[
                          Positioned(
                             right: 16.0 + (sw * 0.12 - 16.0) * p,
                             bottom: 16.0 + (sh * 0.08 - 16.0) * p,
                             child: Transform.scale(
                               scale: 1.0 - 0.1 * p,
                               child: ThumbnailLink(
                                 mediaUrl: widget.creatorAvatarUrl!,
                                 width: 42,
                                 height: 56,
                                 referenceId: widget.referenceId,
                                 themeColor: widget.themeColor,
                                 onTap: widget.onThumbnailTap,
                               ),
                             ),
                           ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}





























