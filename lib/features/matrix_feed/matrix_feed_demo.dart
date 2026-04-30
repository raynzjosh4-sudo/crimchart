import 'package:flutter/material.dart';

class MatrixFeedDemo extends StatelessWidget {
  const MatrixFeedDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: VerticalFeedView(),
    );
  }
}

/// The Main Vertical Feed using a PageView.builder
class VerticalFeedView extends StatelessWidget {
  const VerticalFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (context, index) {
        return PeelableCardItem(index: index);
      },
    );
  }
}

/// A Single Feed Item that implements the "Card Peel" interaction
class PeelableCardItem extends StatefulWidget {
  final int index;
  const PeelableCardItem({super.key, required this.index});

  @override
  State<PeelableCardItem> createState() => _PeelableCardItemState();
}

class _PeelableCardItemState extends State<PeelableCardItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Configuration for the "Peel" effect
  final double _minScale = 0.85;
  final double _maxBorderRadius = 32.0;
  final double _revealSliverWidth = 60.0; // The sliver of the video card left visible

  @override
  void initState() {
    super.initState();
    // 0.0 = fully covered (foreground active)
    // 1.0 = fully peeled (background stats visible)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double screenWidth) {
    // Only track left drags (revealing stats on the right/underneath)
    // dragExtent represents the percentage of peel: 0.0 (no peel) to 1.0 (max peel)
    double delta = -details.primaryDelta! / (screenWidth - _revealSliverWidth);
    _controller.value = (_controller.value + delta).clamp(0.0, 1.0);
  }

  void _onHorizontalDragEnd(DragEndDetails details, double screenWidth) {
    double velocity = details.primaryVelocity! / screenWidth;
    
    // Snap logic based on position and velocity
    if (velocity < -0.5 || (_controller.value > 0.4 && velocity < 0.5)) {
      // Snapping to "Peeled" state
      _controller.animateTo(1.0, curve: Curves.easeOutQuart);
    } else {
      // Snapping back to "Covered" state
      _controller.animateTo(0.0, curve: Curves.easeOutQuart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Layer 1: The Background (Competitor Stats)
        Positioned.fill(
          child: _buildStatsBackground(),
        ),

        // Layer 2: The Foreground (Video Card)
        Positioned.fill(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) => _onHorizontalDragUpdate(details, size.width),
            onHorizontalDragEnd: (details) => _onHorizontalDragEnd(details, size.width),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double peelValue = _controller.value;
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(-(size.width - _revealSliverWidth) * peelValue)
                    ..scale(1.0 - (1.0 - _minScale) * peelValue),
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_maxBorderRadius * peelValue),
                    child: child,
                  ),
                );
              },
              child: _buildVideoCard(),
            ),
          ),
        ),
      ],
    );
  }

  /// Placeholder for the Background Stats UI
  Widget _buildStatsBackground() {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Rank #${widget.index + 1}',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Voice of the Chart',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 40),
          _buildActionButton(Icons.favorite, '4.5k'),
          _buildActionButton(Icons.comment, '120'),
          _buildActionButton(Icons.share, 'Share'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 12),
          Icon(icon, color: Colors.amber, size: 28),
        ],
      ),
    );
  }

  /// Placeholder for the Video Content
  Widget _buildVideoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[800]!,
            Colors.grey[900]!,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated Video Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_outline, size: 80, color: Colors.white54),
                const SizedBox(height: 16),
                Text(
                  'Video Content Block ${widget.index}',
                  style: const TextStyle(color: Colors.white24),
                ),
              ],
            ),
          ),
          
          // Basic UI Overlay
          const Positioned(
            bottom: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@creator_name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Participating in #MainFight event', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





























