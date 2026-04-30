import 'package:crown/features/allchannels/dummydata/channel_dummy_data.dart';
import 'package:crown/features/allchannels/models/chart_channel.dart';
import 'package:crown/profile/widgets/charters/channel_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'channel_create_page.dart';

class ChannelIntroPage extends StatefulWidget {
  const ChannelIntroPage({super.key});

  @override
  State<ChannelIntroPage> createState() => _ChannelIntroPageState();
}

class _ChannelIntroPageState extends State<ChannelIntroPage> {
  String _activeFilter = 'all';
  final List<String> _filters = [
    'all',
    'private',
    'public',
    'Chart_in',
    'favorite',
  ];

  void _onFilterChanged(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: 'CHANNELS',
        showBack: true,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              LucideIcons.search,
              size: 22.w,
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChannelCreatePage(),
                ),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                LucideIcons.plus,
                size: 20.w,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          ChannelFilterChips(
            filters: _filters,
            activeFilter: _activeFilter,
            onFilterChanged: _onFilterChanged,
            localize: false,
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Horizontal Suggested/Active Channels (TikTok Stories Style)
                _buildActiveChannels(context),

                const Divider(height: 1, thickness: 0.5, color: Colors.white10),

                // Main Channels List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: 15, // Showing first 15 for demo
                  itemBuilder: (context, index) {
                    return _buildChannelItem(
                      context,
                      dummyChannels[index],
                      index,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChannels(BuildContext context) {
    return Container(
      height: 135.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 8,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Create Channel Button (TikTok Style)
            return _buildActiveItem(
              context,
              label: 'Create',
              isCreate: true,
              imageUrl: null,
            );
          }
          final channel = dummyChannels[index % dummyChannels.length];
          return _buildActiveItem(
            context,
            label: channel.title.split(' ').first,
            imageUrl: channel.staterAvatarUrl,
            hasUpdate: index % 3 == 0,
          );
        },
      ),
    );
  }

  Widget _buildActiveItem(
    BuildContext context, {
    required String label,
    bool isCreate = false,
    String? imageUrl,
    bool hasUpdate = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          Stack(
            children: [
              MemberImage(
                size: 65.w,
                imageUrl: imageUrl,
                showStatusRing: isCreate || hasUpdate,
                showActiveDot: !isCreate && hasUpdate,
                borderWidth: 2.5,
              ),
              if (isCreate)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      LucideIcons.plus,
                      size: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChannelItem(
    BuildContext context,
    ChartChannel channel,
    int index,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final onlineCount = (channel.memberCount / 4).floor();
    final hasUnread = index % 4 == 0;
    final unreadCount = index + 5;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            MemberImage(
              size: 58.w,
              imageUrl: channel.staterAvatarUrl,
              showStatusRing: false,
              showActiveDot: true,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$onlineCount Online',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: colorScheme
                              .primary, // Yellow/Gold "Online" text from Image 1
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        '${channel.memberCount} members',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (hasUnread)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
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
}











