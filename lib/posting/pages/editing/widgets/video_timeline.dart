import 'package:flutter/material.dart';
import '../functioning/edit_post_controller.dart';

class VideoTimeline extends StatelessWidget {
  final MediaEditState state;

  const VideoTimeline({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final controller = state.videoController;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox(height: 60);
    }

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          // ── Background frames (placeholder or real thumbnails) ──────────
          const Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Row(
                children: [
                  Expanded(child: Icon(Icons.movie, color: Colors.white30)),
                  Expanded(child: Icon(Icons.movie, color: Colors.white30)),
                  Expanded(child: Icon(Icons.movie, color: Colors.white30)),
                  Expanded(child: Icon(Icons.movie, color: Colors.white30)),
                ],
              ),
            ),
          ),

          // ── Scrubber ───────────────────────────────────────────────────
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final progress = controller.value.duration.inMilliseconds > 0
                  ? controller.value.position.inMilliseconds /
                      controller.value.duration.inMilliseconds
                  : 0.0;
              
              return Align(
                alignment: Alignment(lerpDouble(-1, 1, progress)!, 0),
                child: Container(
                  width: 3,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: const Offset(1, 0),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // ── Scrubbing Gesture ─────────────────────────────────────────
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox;
              final localPos = box.globalToLocal(details.globalPosition);
              final relative = (localPos.dx / box.size.width).clamp(0.0, 1.0);
              
              final target = Duration(
                milliseconds: (controller.value.duration.inMilliseconds * relative).toInt(),
              );
              controller.seekTo(target);
            },
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  double? lerpDouble(num a, num b, double t) {
    return a + (b - a) * t;
  }
}
