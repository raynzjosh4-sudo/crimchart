import 'package:flutter/material.dart';

class ChannelFlagBottomSheet extends StatelessWidget {
  final Color themeColor;

  const ChannelFlagBottomSheet({super.key, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CHALLENGE RANTop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Think you or someone else belongs here? Flag to compete!',
                        style: TextStyle(
                          color: Colors.white.withAlpha(153),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // Options
          _ChallengeOption(
            icon: Icons.person_add_rounded,
            title: 'Challenge as Myself',
            description: 'Apply to enter this ranTop directly using your profile.',
            themeColor: themeColor,
            onTap: () {
              Navigator.pop(context);
              _showFeedback(context, 'Application submitted! You are now a challenger.');
            },
          ),
          
          _ChallengeOption(
            icon: Icons.add_photo_alternate_rounded,
            title: 'Challenge with My Data',
            description: 'Select your best media from your library to prove you win.',
            themeColor: themeColor,
            onTap: () {
              Navigator.pop(context);
              _showFeedback(context, 'Select media to start your challenge.');
            },
          ),

          _ChallengeOption(
            icon: Icons.language_rounded,
            title: 'Add External Challenger',
            description: 'Bring an external user or link their data to compete.',
            themeColor: themeColor,
            onTap: () {
              Navigator.pop(context);
              _showFeedback(context, 'External challenger form opened.');
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: themeColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _ChallengeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color themeColor;
  final VoidCallback onTap;

  const _ChallengeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withAlpha(128),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withAlpha(50)),
          ],
        ),
      ),
    );
  }
}





























