import 'package:crimchart/profile/chart/pages/chart_detail_page.dart';
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
    final bool isUnread = chart.unreadCount > 0;

    return InkWell(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChartDetailPage(chart: chart)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── AVATAR ──
            MemberImage(
              size: 52.w,
              imageUrl: chart.senderAvatarUrl,
              showStatusRing: false,
              showActiveDot: false,
            ),
            SizedBox(width: 12.w),

            // ── CONTENT ──
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Sender Name + Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chart.senderName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              timeStr,
                              style: TextStyle(
                                color: isUnread ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 12.sp,
                                fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // Row 2: Last Message + Unread Badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                chart.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 14.sp,
                                  fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isUnread) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 20.w,
                                  minHeight: 20.w,
                                ),
                                child: Center(
                                  child: Text(
                                    chart.unreadCount.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
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
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: colorScheme.onSurface.withValues(alpha: 0.08),
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
