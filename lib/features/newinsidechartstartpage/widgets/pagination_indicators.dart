import 'package:flutter/material.dart';

// ─── End of list indicator ───────────────────────────────────────────────────

class EndOfListIndicator extends StatelessWidget {
  const EndOfListIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
      child: Opacity(
        opacity: 0.5,
        child: Row(
          children: [
            Expanded(child: Divider(color: colorScheme.onSurface)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'END OF LIST',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}

// ─── Error indicator ─────────────────────────────────────────────────────────

class ErrorIndicator extends StatelessWidget {
  final VoidCallback onRetry;
  final bool compact;
  const ErrorIndicator({super.key, required this.onRetry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (compact) {
      return Center(
        child: TextButton.icon(
          onPressed: onRetry,
          icon: Icon(Icons.refresh_rounded, size: 18, color: colorScheme.primary),
          label: Text('Retry', style: TextStyle(color: colorScheme.primary)),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 64, color: colorScheme.primary.withOpacity(0.2)),
            const SizedBox(height: 24),
            const Text(
              'Connection Lost',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t load members. Please check your data connection.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





























