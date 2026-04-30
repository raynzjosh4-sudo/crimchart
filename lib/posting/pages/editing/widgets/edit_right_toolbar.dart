import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Vertical icon rail on the right — matches the reference image exactly.
/// Icons are rendered bare (no circle background) with white color.
class EditRightToolbar extends StatelessWidget {
  final VoidCallback onDraw;
  final VoidCallback onSticker;
  final VoidCallback onScissors;
  final VoidCallback onMusic;
  final VoidCallback onVolume;
  final VoidCallback onEmoji;
  final VoidCallback onQuote;
  final VoidCallback onMic;
  final VoidCallback onMagic;
  final VoidCallback onRotate;
  final VoidCallback onUndo;

  const EditRightToolbar({
    super.key,
    required this.onDraw,
    required this.onSticker,
    required this.onScissors,
    required this.onMusic,
    required this.onVolume,
    required this.onEmoji,
    required this.onQuote,
    required this.onMic,
    required this.onMagic,
    required this.onRotate,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final tools = [
      _Tool(icon: LucideIcons.pencil,         onTap: onDraw),
      _Tool(icon: LucideIcons.sticker,          onTap: onSticker),
      _Tool(icon: LucideIcons.scissors,         onTap: onScissors),
      _Tool(icon: LucideIcons.music,            onTap: onMusic),
      _Tool(icon: LucideIcons.volume2,          onTap: onVolume),
      _Tool(icon: LucideIcons.smile,            onTap: onEmoji),
      _Tool(icon: LucideIcons.messageSquare,    onTap: onQuote,   label: '99'),
      _Tool(icon: LucideIcons.mic,              onTap: onMic),
      _Tool(icon: LucideIcons.sparkles,         onTap: onMagic),
      _Tool(icon: LucideIcons.rotateCcw,        onTap: onRotate),
      _Tool(icon: LucideIcons.cornerUpLeft,     onTap: onUndo),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tools.map((t) => _ToolBtn(tool: t)).toList(),
    );
  }
}

class _Tool {
  final IconData icon;
  final VoidCallback onTap;
  final String? label;
  const _Tool({required this.icon, required this.onTap, this.label});
}

class _ToolBtn extends StatelessWidget {
  final _Tool tool;
  const _ToolBtn({required this.tool});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tool.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: tool.label != null
            ? Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(tool.icon, color: Colors.white, size: 32),
                  Positioned(
                    bottom: -2,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        tool.label!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Icon(tool.icon, color: Colors.white, size: 32),
      ),
    );
  }
}
