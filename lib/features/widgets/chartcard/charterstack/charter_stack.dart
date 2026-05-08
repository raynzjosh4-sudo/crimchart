import 'dart:math' as math;
import 'package:crimchart/mainFeed/dummydata/charter_star_dummy_data.dart';
import 'package:flutter/material.dart';
import 'back_card.dart';
import '../../../../gifts/horizontalgiftscroll/horizontal_gift_scroll.dart';
import '../../../../profile/pages/profile_page.dart';

class CharterStackBackground extends StatefulWidget {
  final double discharge;
  final int dischargedCount;
  final int undocTopIndex;
  final Color themeColor;
  final ValueChanged<int>? onUndock;

  const CharterStackBackground({
    super.key,
    this.discharge = 0.0,
    this.dischargedCount = 0,
    this.undocTopIndex = -1,
    this.themeColor = Colors.pinkAccent,
    this.onUndock,
  });

  @override
  State<CharterStackBackground> createState() => _CharterStackBackgroundState();
}

class _CharterStackBackgroundState extends State<CharterStackBackground> {
  final ScrollController _scrollController = ScrollController();
  late PageController _pageController;
  double _currentPage = 0.0;
  final GlobalKey _centerTargetKey = GlobalKey();
  final GlobalKey<BackCardState> _frontCardKey = GlobalKey<BackCardState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.45)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0.0;
        });
      });
  }

  @override
  void didUpdateWidget(CharterStackBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dischargedCount > oldWidget.dischargedCount) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double sw = constraints.maxWidth;
        final double sh = constraints.maxHeight;

        final double baseW = sw * 0.65;
        final double baseH = sh * 0.75;

        final double scaleDocked = 0.12;
        final double cardW = baseW * scaleDocked;
        final double cardH = baseH * scaleDocked;

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              // --- CENTER GALLERY (The upcoming items in a PageView) ---
              // Shifted even higher to prevent collision with the bottom gift area
              Align(
                key: _centerTargetKey,
                alignment: const Alignment(0, -0.65),
                child: SizedBox(
                  height: baseH,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: math.max(0, 5 - widget.dischargedCount),
                    itemBuilder: (context, i) {
                      // Dynamic scaling based on distance from current page
                      final double scaleFactor = 1.0; // Keep uniform size
                      final double opacity = 1.0; // Keep uniform opacity

                      // Pick a model from dummy data (offset by dischargedCount)
                      final int modelIdx =
                          (i + widget.dischargedCount) % dummyTopsStars.length;
                      final model = dummyTopsStars[modelIdx];

                      return Center(
                        child: Transform.scale(
                          scale: scaleFactor,
                          child: BackCard(
                            // Using round() to target whichever card is most centered
                            key: i == _currentPage.round()
                                ? _frontCardKey
                                : null,
                            width: baseW * 0.9,
                            height: baseH * 0.9,
                            opacity: opacity,
                            color: widget.themeColor,
                            model: model,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfilePage(showBack: true),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // --- GALLERY SCROLL VIEW (The list of items and gifts) ---
              Positioned(
                bottom: 0, // Absolute bottom
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 60, // Tight height for horizontal gifts
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(left: 16, right: 120),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centered in the bottom bar
                      children: [
                        // 1. Discharged cards (The small pink cards)
                        ...List.generate(widget.dischargedCount, (i) {
                          final bool isUndocTop = (widget.undocTopIndex == i);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Opacity(
                              opacity: isUndocTop ? 0.0 : 1.0,
                              child: GestureDetector(
                                onTap: i == widget.undocTopIndex
                                    ? null
                                    : () => widget.onUndock?.call(i),
                                behavior: HitTestBehavior.opaque,
                                child: BackCard(
                                  width: cardW,
                                  height: cardH,
                                  opacity: 1.0,
                                  color: widget.themeColor,
                                ),
                              ),
                            ),
                          );
                        }),

                        // 2. Horizontal Gift Scroll (Replacing the dots)
                        SizedBox(
                          width: sw * 0.6, // Leave some room
                          child: HorizontalGiftScroll(
                            themeColor: widget.themeColor,
                            targetKey: _centerTargetKey,
                            onArrival: () {
                              _frontCardKey.currentState?.pulse();
                            },
                            onSeeAll: () {
                              debugPrint('See All Gifts tapped');
                            },
                            onGiftTap: (id) {
                              debugPrint('Gift tapped: $id');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}











