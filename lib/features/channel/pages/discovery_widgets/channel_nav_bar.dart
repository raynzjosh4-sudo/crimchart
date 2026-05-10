import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChannelNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  
  // 👑 DYNAMIC COUNTS
  final int unreadMessages;
  final int unreadMoments;
  final int totalMembers;

  const ChannelNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.unreadMessages = 0,
    this.unreadMoments = 0,
    this.totalMembers = 0,
  });

  List<Map<String, dynamic>> get _tabs => [
    {'icon': LucideIcons.compass, 'badge': null},
    {
      'icon': LucideIcons.messageCircle, 
      'badge': unreadMessages > 0 ? unreadMessages.toString() : null
    },
    {
      'icon': LucideIcons.monitorPlay, 
      'badge': unreadMoments > 0 ? unreadMoments.toString() : null
    },
    {
      'icon': LucideIcons.users, 
      'badge': totalMembers > 0 ? totalMembers.toString() : null
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 72.h, // 👑 Even more presence
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor == Colors.transparent 
            ? Colors.transparent 
            : theme.scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == selectedIndex;
          final tab = _tabs[index];
          final String? badgeValue = tab['badge'];
          
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTabSelected(index),
              child: Center(
                child: Badge(
                  // 👑 NATIVE MATERIAL 3 BADGE
                  isLabelVisible: badgeValue != null,
                  label: badgeValue != null 
                    ? Text(
                        badgeValue,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp, // 👑 Larger native font
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      )
                    : null,
                  backgroundColor: const Color(0xFFE41E3F), // Premium Red
                  largeSize: 22.h, // 👑 Larger native badge
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Icon(
                    tab['icon'],
                    size: 44.sp, // 👑 Maximum presence
                    color: isSelected 
                        ? theme.primaryColor 
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
