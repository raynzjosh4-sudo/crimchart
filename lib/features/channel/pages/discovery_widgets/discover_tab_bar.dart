import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class DiscoverTabBar extends StatefulWidget {
  const DiscoverTabBar({super.key});

  @override
  State<DiscoverTabBar> createState() => _DiscoverTabBarState();
}

class _DiscoverTabBarState extends State<DiscoverTabBar> {
  final List<String> _tabs = [
    'Popular',
    'Latest',
    'Sports',
    'Traveling',
    'News',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Container(
      height: 48.h,
      margin: EdgeInsets.only(bottom: 16.h, top: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 24.w),
              decoration: BoxDecoration(
                border: isSelected
                    ? Border(
                        bottom: BorderSide(color: primaryColor, width: 2.h),
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isSelected
                        ? primaryColor
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 15.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
