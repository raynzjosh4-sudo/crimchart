import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/features/channel/channelsettings/channel_edit_page.dart';

class ChannelHeader extends StatelessWidget {
  final String channelId;
  final String title;
  final String? avatarUrl;
  final String description;
  final String followerCountText;
  final DateTime createdAt;

  const ChannelHeader({
    super.key,
    required this.channelId,
    required this.title,
    this.avatarUrl,
    required this.followerCountText,
    required this.createdAt,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 54.w,
                backgroundImage: CachedNetworkImageProvider(
                  (avatarUrl != null && avatarUrl!.isNotEmpty) 
                      ? avatarUrl! 
                      : 'https://picsum.photos/seed/babies/200',
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Channel • $followerCountText • Joined ${DateFormat('MMMM yyyy').format(createdAt)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 16.w,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChannelEditPage(
                    channelId: channelId,
                    initialTitle: title,
                    initialAvatarUrl: avatarUrl,
                    initialDescription: description,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
