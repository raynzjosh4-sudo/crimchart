import 'package:flutter/material.dart';

enum EditActionButtonStyle { outlined, filled, plain }

class EditActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final EditActionButtonStyle style;
  final VoidCallback onTap;
  final Widget? trailing;

  const EditActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.style,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = style == EditActionButtonStyle.filled;
    final isPlain = style == EditActionButtonStyle.plain;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isFilled
              ? Theme.of(context).colorScheme.primary
              : isPlain
                  ? Colors.black.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(22),
          border: isFilled || isPlain
              ? null
              : Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.2,
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 2), trailing!],
          ],
        ),
      ),
    );
  }
}
