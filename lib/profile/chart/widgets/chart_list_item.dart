import 'package:crown/profile/chart/pages/chart_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/chart_chart.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../features/widgets/memberimage/starter_image.dart';
import 'package:intl/intl.dart';

class ChartListItem extends StatelessWidget {
  final ChartChart chart;
  final VoidCallback? onTap;

  const ChartListItem({super.key, required this.chart, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = DateFormat.Hm().format(chart.timestamp);

    return InkWell(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChartDetailPage(chart: chart)),
            );
          },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // User Avatar (MemberImage)
            MemberImage(
              size: 58.w,
              imageUrl: chart.senderAvatarUrl,
              showStatusRing: false,
              showActiveDot: chart.isOnline,
            ),
            SizedBox(width: 16.w),

            // Message Body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chart.senderName,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chart.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 14.sp,
                            fontWeight: chart.unreadCount > 0
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (chart.unreadCount > 0) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18.w,
                            minHeight: 18.w,
                          ),
                          child: Center(
                            child: Text(
                              '${chart.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}











