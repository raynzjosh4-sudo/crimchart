import 'package:flutter/material.dart';

class FlagBottomSheet extends StatelessWidget {
  final Color themeColor;

  const FlagBottomSheet({super.key, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    // Flagging categories for a standard report flow
    final List<Map<String, dynamic>> categories = [
      {'label': 'Spam', 'icon': Icons.mail_outline, 'desc': 'Unwanted commercial content or repetitive messages.'},
      {'label': 'Inappropriate', 'icon': Icons.visibility_off_outlined, 'desc': 'Contains content that is offensive or unsuitable.'},
      {'label': 'Harassment', 'icon': Icons.person_off_outlined, 'desc': 'Targets or bullies an individual or group.'},
      {'label': 'Misleading', 'icon': Icons.info_outline, 'desc': 'Spreads false information or deceptive tactics.'},
      {'label': 'Prohibited Goods', 'icon': Icons.shopping_bag_outlined, 'desc': 'Promotion of illegal or restricted items.'},
      {'label': 'Other', 'icon': Icons.more_horiz, 'desc': 'Anything else that violates our community standards.'},
    ];

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Balance
                const Text(
                  'REPORT CONTENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // Instruction Text
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Why are you flagging this content? Your report is anonymous, except if you\'re reporting an intellectual property infringement.',
              style: TextStyle(
                color: Colors.white.withAlpha(153),
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Categories List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1, indent: 60),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cat['icon'], color: themeColor, size: 20),
                  ),
                  title: Text(
                    cat['label'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    cat['desc'],
                    style: TextStyle(
                      color: Colors.white.withAlpha(102),
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
                  onTap: () {
                    // Simulate report submission
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thank you for reporting. We will review this shortly.'),
                        backgroundColor: Colors.grey[900],
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





























