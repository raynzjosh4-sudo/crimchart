import 'package:crimchart/features/allchannels/models/chart_channel.dart';
import 'package:crimchart/features/channel/application/common_channels_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crimchart/core/theme/design_system.dart';
import '../models/user_model.dart';

class UserProfileBottomSheet extends StatelessWidget {
  final ChatUser user;

  const UserProfileBottomSheet({super.key, required this.user});

  static void show(BuildContext context, ChatUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserProfileBottomSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Profile Image
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.3),
                width: 3.w,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(user.profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Name
          Text(
            user.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),

          // Stats Row
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat(context, '${user.followersCount}', 'Followers'),
              Container(
                height: 24.h,
                width: 1,
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                color: colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              _buildStat(context, '${user.channelsCount}', 'Channels'),
            ],
          ),

          SizedBox(height: 24.h),

          // Side-by-side Actions
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  label: 'Follow',
                  icon: Icons.person_add_outlined,
                  onTap: () => Navigator.pop(context),
                  isPrimary: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  label: 'View Account',
                  icon: Icons.account_circle_outlined,
                  onTap: () => Navigator.pop(context),
                  isPrimary: false,
                ),
              ),
            ],
          ),

          // Common Channels Section
          SizedBox(height: 32.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Common Channels',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 100.h,
            child: Consumer(
              builder: (context, ref, _) {
                final commonChannelsAsync = ref.watch(
                  commonChannelsProvider(user.id),
                );
                return commonChannelsAsync.when(
                  data: (channels) {
                    if (channels.isEmpty) {
                      return Center(
                        child: Text(
                          'No common channels',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: channels.length,
                      itemBuilder: (context, index) {
                        final channel = channels[index];
                        return _buildChannelItem(context, channel);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(
                    child: Text(
                      'Failed to load common channels',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 24.h),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelItem(BuildContext context, ChartChannel channel) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: CachedNetworkImageProvider(channel.imageUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            channel.title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: AppShapes.buttonSquircle,
        child: Container(
          height: 50.h,
          decoration: ShapeDecoration(
            color: isPrimary
                ? theme.primaryColor
                : colorScheme.surfaceContainerHighest,
            shape: AppShapes.buttonSquircle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isPrimary ? Colors.black : colorScheme.onSurface,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isPrimary ? Colors.black : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
