import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/media_item.dart';
import '../functioning/edit_post_controller.dart';
import 'combined_video_trimmer.dart';
import 'edit_action_button.dart';
import 'video_timeline.dart';

class EditBottomBar extends StatelessWidget {
  final List<MediaItem> selectedMedia;
  final int currentIndex;
  final PageController pageController;
  final VoidCallback onStory;
  final VoidCallback onSendTo;
  final VoidCallback onAddMore;
  final ValueChanged<int> onRemove;
  final MediaEditState activeState;
  final int currentMode;
  final EditPostController controller; // added to access global progress

  const EditBottomBar({
    super.key,
    required this.selectedMedia,
    required this.currentIndex,
    required this.pageController,
    required this.onStory,
    required this.onSendTo,
    required this.onAddMore,
    required this.onRemove,
    required this.activeState,
    required this.currentMode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo = activeState.item.type == MediaType.video;
    final isShortVideoMode = currentMode == 1;

    return Container(
      // Subtle dark gradient so buttons are readable over the video
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.55),
            Colors.black.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // ── Combined Frame Strip (Widget 2 -> 4) ────────────────────────
            if (isShortVideoMode) ...[
              const SizedBox(height: 4),
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return CombinedVideoTrimmer(
                    states: controller.mediaStates,
                    globalProgress: controller.getGlobalProgress(),
                    onSeekGlobal: (val) => controller.seekToGlobalProgress(val),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],

            // Individual Video Scrubber (only shown in Story/Post if it's a video)
            if (!isShortVideoMode && isVideo) ...[
              const SizedBox(height: 12),
              VideoTimeline(state: activeState),
            ],

            const SizedBox(height: 12),

            // ── Action buttons ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  // Story
                  SizedBox(
                    width: 100,
                    child: EditActionButton(
                      icon:  LucideIcons.users,
                      label: 'Story',
                      style: EditActionButtonStyle.plain,
                      onTap: onStory,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send To (Now takes most Space)
                  Expanded(
                    child: EditActionButton(
                      icon:   LucideIcons.send,
                      label:  'Just Share',
                      style:  EditActionButtonStyle.filled,
                      onTap:  onSendTo,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
