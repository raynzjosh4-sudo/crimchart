import 'package:flutter/material.dart';
import '../functioning/edit_post_controller.dart';

class StoryProgressBar extends StatefulWidget {
  final List<MediaEditState> states;
  final int currentIndex;

  const StoryProgressBar({
    super.key,
    required this.states,
    required this.currentIndex,
  });

  @override
  State<StoryProgressBar> createState() => _StoryProgressBarState();
}

class _StoryProgressBarState extends State<StoryProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: List.generate(widget.states.length, (index) {
          final isPast = index < widget.currentIndex;
          final isActive = index == widget.currentIndex;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: _Segment(
                state: widget.states[index],
                isPast: isPast,
                isActive: isActive,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final MediaEditState state;
  final bool isPast;
  final bool isActive;

  const _Segment({
    required this.state,
    required this.isPast,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 3.5; // Thicker as requested
    final borderRadius = BorderRadius.circular(2);

    if (isPast) {
      return Container(
        height: barHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      );
    }

    if (isActive) {
      final controller = state.videoController;
      // If no video or not playing, show full for photos
      if (controller == null) {
        return Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
          ),
        );
      }

      return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final progress = controller.value.duration.inMilliseconds > 0
              ? controller.value.position.inMilliseconds /
                  controller.value.duration.inMilliseconds
              : 0.0;
          
          return Stack(
            children: [
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: borderRadius,
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: borderRadius,
      ),
    );
  }
}
