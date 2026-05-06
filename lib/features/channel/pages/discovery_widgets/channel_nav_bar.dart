import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChannelNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const ChannelNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const List<Map<String, dynamic>> _tabs = [
    {'icon': LucideIcons.compass, 'badge': null},
    {'icon': LucideIcons.messageCircle, 'badge': null},
    {'icon': LucideIcons.monitorPlay, 'badge': '15'},
    {'icon': LucideIcons.users, 'badge': '6'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 56.h,
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
          final String? badge = tab['badge'];
          
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTabSelected(index),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab['icon'],
                        size: 34.sp,
                        color: isSelected 
                            ? theme.primaryColor // Replaced specific FB Blue with theme primary color
                            : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                  
                  // Notification Badge
                  if (badge != null)
                    Positioned(
                      top: 4.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE41E3F), // Red badge
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
