import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Top bar — Snapchat style:
/// [X]  ♫ "Song title... | +"  [↗ download icon]
class EditTopBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onAddSound;
  final String? songTitle;
  final VoidCallback? onDownload;
  final int currentMode;
  final ValueChanged<int>? onModeChanged;

  const EditTopBar({
    super.key,
    required this.onClose,
    required this.onAddSound,
    required this.currentMode,
    this.onModeChanged,
    this.songTitle,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  // ── Close ────────────────────────────────────────────────────
                  GestureDetector(
                    onTap: onClose,
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),

                  const SizedBox(width: 8),

                  // ── Song chip ─────────────────────────────────────────────────
                  Expanded(
                    child: GestureDetector(
                      onTap: onAddSound,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.music,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                songTitle ?? 'Add sound',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Vertical divider
                            Container(
                              width: 1,
                              height: 12,
                              color: Colors.white38,
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.add, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ── Download icon (top-right, bare) ──────────────────────────
                  GestureDetector(
                    onTap: onDownload,
                    child: const Icon(
                      LucideIcons.download,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 14),

            // ── Mode Selector (Post, Short Video, Story) ───────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModeItem(
                  label: 'Post', 
                  isActive: currentMode == 0,
                  onTap: () => onModeChanged?.call(0),
                ),
                const SizedBox(width: 24),
                _ModeItem(
                  label: 'Short Video', 
                  isActive: currentMode == 1,
                  onTap: () => onModeChanged?.call(1),
                ),
                const SizedBox(width: 24),
                _ModeItem(
                  label: 'Story', 
                  isActive: currentMode == 2,
                  onTap: () => onModeChanged?.call(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const _ModeItem({required this.label, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontSize: 12,
              letterSpacing: 0.8,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
