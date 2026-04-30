import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/allchannels/models/chart_channel.dart';
import 'package:crown/features/channel/pages/channel_page.dart';
import 'package:crown/features/widgets/memberimage/channel_avatar.dart';
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
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.onSurface.withOpacity(0.05),
              width: 0.5.h,
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
                            fontWeight: isUnread ? FontWeight.w900 : FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (isUnread) ...[
                            _buildUnreadBadge(channel.unreadCount),
                            SizedBox(width: 8.w),
                          ],
                          Text(
                            onlineText,
                            style: TextStyle(
                              color: isUnread ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 12.sp,
                              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // DESCRIPTION (Line 2 - Subject style)
                  Text(
                    channel.description ?? 'No description provided',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14.sp,
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // STATS (Line 3 - Snippet style)
                  Text(
                    memberText,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
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
    if (channel.imageUrl != null && channel.imageUrl!.isNotEmpty) {
      return ChannelAvatar(
        size: 48.w,
        imageUrl: channel.imageUrl,
        leaderAvatarUrl: channel.leaderAvatarUrl,
        isActive: true,
      );
    }

    final initial = (channel.title.isNotEmpty)
        ? channel.title[0].toUpperCase()
        : '?';

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: _getAvatarColor(initial),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
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
      const Color(0xFFCDDC39), // Amber
      const Color(0xFFFF9800), // Orange
      const Color(0xFFFF5722), // Deep Orange
    ];
    return colors[initial.codeUnitAt(0) % colors.length];
  }

  Widget _buildUnreadBadge(int count) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1.w),
      ),
      child: Text(
        '$count+ new',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
