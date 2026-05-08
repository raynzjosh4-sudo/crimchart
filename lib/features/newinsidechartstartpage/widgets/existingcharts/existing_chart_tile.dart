import 'package:crimchart/features/newinsidechartstartpage/models/chart.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class ExistingChartTile extends StatelessWidget {
  final Chart chart;
  final VoidCallback onTap;

  const ExistingChartTile({
    super.key,
    required this.chart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUnread = chart.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUnread ? colorScheme.primary.withValues(alpha: 0.05) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AVATAR ──
            _buildAvatar(colorScheme),
            SizedBox(width: 16.w),

            // ── CONTENT ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Sender Name + Date/Time + Unread Dot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chart.staterName ?? 'Unnamed Sender',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16.sp,
                            fontWeight: isUnread ? FontWeight.w900 : FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '3:44 AM', // Mocked for design, could use chart.createdAt
                            style: TextStyle(
                              color: isUnread ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 12.sp,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isUnread) ...[
                            SizedBox(width: 6.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Row 2: Subject (Channel Title)
                  Text(
                    chart.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14.sp,
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Row 3: Snippet (Description) + Star Icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chart.description ?? 'No preview available',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.star_border,
                        size: 20.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) {
    if (chart.staterAvatarUrl != null) {
      return MemberImage(
        size: 40.w,
        imageUrl: chart.staterAvatarUrl,
        showStatusRing: false,
        showActiveDot: false,
      );
    }

    final initial = (chart.staterName?.isNotEmpty ?? false)
        ? chart.staterName![0].toUpperCase()
        : '?';

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: _getAvatarColor(initial),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(String initial) {
    final colors = [
      const Color(0xFFF44336), // Red
      const Color(0xFFE91E63), // Pink
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF673AB7), // Deep Purple
      const Color(0xFF3F51B5), // Indigo
      const Color(0xFF2196F3), // Blue
      const Color(0xFF03A9F4), // Light Blue
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFF009688), // Teal
      const Color(0xFF4CAF50), // Green
      const Color(0xFF8BC34A), // Light Green
      const Color(0xFFCDDC39), // Lime
      const Color(0xFFFFC107), // Amber
      const Color(0xFFFF9800), // Orange
      const Color(0xFFFF5722), // Deep Orange
    ];
    return colors[initial.codeUnitAt(0) % colors.length];
  }
}
