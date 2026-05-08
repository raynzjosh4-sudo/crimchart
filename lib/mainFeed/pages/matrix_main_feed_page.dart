import 'package:crimchart/mainFeed/features/mainfeedcard/main_feed_card.dart';
import 'package:flutter/material.dart';
import '../dummydata/feed_dummy_data.dart';

/// A version of MainFeedPage that uses the 2D Matrix Feed architecture
/// This solves the "vertical in same vertical" conflict by maTop the whole 
/// feed a vertical PageView.
class MatrixMainFeedPage extends StatefulWidget {
  const MatrixMainFeedPage({super.key});

  @override
  State<MatrixMainFeedPage> createState() => _MatrixMainFeedPageState();
}

class _MatrixMainFeedPageState extends State<MatrixMainFeedPage> {
  late PageController _verticalController;

  @override
  void initState() {
    super.initState();
    _verticalController = PageController();
  }

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _verticalController,
        itemCount: FeedDummyData.feedItems.length,
        itemBuilder: (context, index) {
          final item = FeedDummyData.feedItems[index];

          // We wrap our existing MainFeedCard in the Matrix Transition logic
          // This allows each post (Video, Audio, etc.) to have the 'Peel' effect
          // While swiping up/down moves to the next full-screen card.
          return Container(
            color: Colors.black,
            child: MatrixCardPeelWrapper(
              foregroundContent: MainFeedCard(card: item),
              index: index,
            ),
          );
        },
      ),
    );
  }
}

/// The wrapper that provides the 2D Matrix "Peel" animation for any card
class MatrixCardPeelWrapper extends StatefulWidget {
  final Widget foregroundContent;
  final int index;

  const MatrixCardPeelWrapper({
    super.key,
    required this.foregroundContent,
    required this.index,
  });

  @override
  State<MatrixCardPeelWrapper> createState() => _MatrixCardPeelWrapperState();
}

class _MatrixCardPeelWrapperState extends State<MatrixCardPeelWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _peelController;
  final double _minScale = 0.85;
  final double _maxBorderRadius = 32.0;

  @override
  void initState() {
    super.initState();
    _peelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _peelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Layer 1: Background (Competitive Stats)
        Positioned.fill(
          child: _buildBackgroundStats(),
        ),

        // Layer 2: Foreground (The Card with Peel effect)
        Positioned.fill(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              // DRAG RIGHT to reveal stats on the left
              double delta = details.primaryDelta! / width;
              _peelController.value = (_peelController.value + delta).clamp(0.0, 1.0);
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 400 || _peelController.value > 0.4) {
                _peelController.animateTo(1.0, curve: Curves.easeOutQuart);
              } else {
                _peelController.animateTo(0.0, curve: Curves.easeOutQuart);
              }
            },
            child: AnimatedBuilder(
              animation: _peelController,
              builder: (context, child) {
                final double peel = _peelController.value;
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(width * 0.8 * peel) // Slide right
                    ..scale(1.0 - (1.0 - _minScale) * peel),
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_maxBorderRadius * peel),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: child,
                    ),
                  ),
                );
              },
              child: widget.foregroundContent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundStats() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('STATS', style: TextStyle(color: Colors.white24, fontSize: 40, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Text('RANK # ${widget.index + 1}', style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('LEADERBOARD DATA', style: TextStyle(color: Colors.white, fontSize: 16)),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('CHALLENGE', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}





























