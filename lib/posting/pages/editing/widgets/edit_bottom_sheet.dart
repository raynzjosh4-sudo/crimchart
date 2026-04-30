import 'package:flutter/material.dart';

class EditBottomSheet extends StatelessWidget {
  final TabController tabController;
  final List<String> tabLabels;
  final List<Widget> tabViews;
  final VoidCallback onClose;

  const EditBottomSheet({
    super.key,
    required this.tabController,
    required this.tabLabels,
    required this.tabViews,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.90),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Tab bar
          Material(
            color: Colors.transparent,
            child: TabBar(
              controller: tabController,
              indicatorColor: cs.primary,
              dividerColor: Colors.transparent,
              indicatorWeight: 2,
              labelColor: cs.primary,
              unselectedLabelColor: Colors.white38,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 1.2,
              ),
              tabs: tabLabels.map((l) => Tab(text: l)).toList(),
            ),
          ),

          // Tab views
          SizedBox(
            height: 260,
            child: TabBarView(
              controller: tabController,
              children: tabViews,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
