import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MainBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MainBottomAppBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).iconTheme.color,
        unselectedItemColor: Theme.of(
          context,
        ).iconTheme.color?.withOpacity(0.5),
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: _BadgeIcon(icon: LucideIcons.home, count: 9), // ✅ HOME: Show Number
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _BadgeIcon(icon: LucideIcons.playSquare, count: 5), // ✅ SHORTS: Show Number
            label: 'Short',
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.plusSquare),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: _BadgeIcon(icon: LucideIcons.messageCircle, showDot: true), // ✅ MESSAGES: Indicator Only
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool showDot;

  const _BadgeIcon({
    required this.icon,
    this.count = 0,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0 || showDot)
          Positioned(
            top: -4.w, // ✅ RESPONSIVE POSITIONING
            right: -8.w,
            child: Container(
              padding: EdgeInsets.all(count > 0 ? 4.w : 6.w),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.4),
                    blurRadius: 8.w,
                    spreadRadius: 1.w,
                  ),
                ],
              ),
              constraints: BoxConstraints(
                minWidth: 22.w, // ✅ DYNAMIC DIAMETER
                minHeight: 22.w,
              ),
              child: count > 0
                  ? Center(
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp, // ✅ SCALABLE TYPOGRAPHY
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}





























