import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/allchannels/models/chart_channel.dart';
import 'package:crown/features/channel/pages/channel_page.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';

class ChartedInChannel extends StatelessWidget {
  final ChartChannel channel;
  final bool isSubChannel;
  final int? index;

  const ChartedInChannel({
    super.key,
    required this.channel,
    this.isSubChannel = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final onlineCount = (channel.memberCount / 5).floor();
    final onlineText = '$onlineCount ${context.tr('online')}';
    final memberText = '${channel.memberCount} ${context.tr('members')}';
    final isUnread = channel.unreadCount > 0;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChannelPage(
            channel: channel,
            contestants: const [], // Mocked for now
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── AVATAR ──
            MemberImage(
              size: 52.w,
              imageUrl: channel.imageUrl,
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
                        // TITLE + ONLINE STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                channel.title,
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
                              onlineText,
                              style: TextStyle(
                                color: isUnread
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withOpacity(0.5),
                                fontSize: 12.sp,
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // DESCRIPTION + UNREAD BADGE
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                channel.description ??
                                    'No description provided',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 14.sp,
                                  fontWeight: isUnread
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isUnread) ...[
                              SizedBox(width: 8.w),
                              _buildUnreadBadge(channel.unreadCount),
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

  Widget _buildUnreadBadge(int count) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: const BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
      constraints: BoxConstraints(minWidth: 20.w, minHeight: 20.w),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
