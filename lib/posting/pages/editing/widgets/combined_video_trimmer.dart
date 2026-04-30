import 'package:flutter/material.dart';
import '../functioning/edit_post_controller.dart';

class CombinedVideoTrimmer extends StatelessWidget {
  final List<MediaEditState> states;
  final double globalProgress; // 0.0 to 1.0 for the entire timeline
  final void Function(double) onSeekGlobal;

  const CombinedVideoTrimmer({
    super.key,
    required this.states,
    required this.globalProgress,
    required this.onSeekGlobal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => _handleSeek(context, details.localPosition),
      onPanUpdate: (details) => _handleSeek(context, details.localPosition),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            children: [
              // ── The Frame Strip ───────────────────────────────────────────
              Row(
                children: states.map((s) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10, width: 0.5),
                      ),
                      child: _buildThumb(s),
                    ),
                  );
                }).toList(),
              ),

              // ── The Moving Line (Number 4) ────────────────────────────────
              Align(
                alignment: Alignment(lerpDouble(-1, 1, globalProgress)!, 0),
                child: Container(
                  width: 3,
                  height: 60,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSeek(BuildContext context, Offset localPosition) {
    // Total width is roughly total screen width minus margins (16*2)
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final width = box.size.width;
      final dx = localPosition.dx.clamp(0.0, width);
      onSeekGlobal(dx / width);
    }
  }

  Widget _buildThumb(MediaEditState state) {
    if (state.item.thumbnailBytes != null) {
      return Image.memory(state.item.thumbnailBytes!, fit: BoxFit.cover);
    }
    return const Center(child: Icon(Icons.movie, color: Colors.white24, size: 20));
  }

  double? lerpDouble(num a, num b, double t) {
    return a + (b - a) * t;
  }
}
