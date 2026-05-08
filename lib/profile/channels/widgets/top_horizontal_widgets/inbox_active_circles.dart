import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/profile/channels/widgets/active_channel_circle.dart';
import 'package:crimchart/profile/channels/widgets/create_channel_circle.dart';
import 'package:crimchart/profile/chart/models/chart_chart.dart';
import 'package:crimchart/profile/chart/pages/chart_detail_page.dart';
import 'package:crimchart/profile/chart/widgets/sheets/inbox_options_sheet.dart';
import 'package:crimchart/mainFeed/features/cardwidgets/storychacrdwidget/status_page.dart';
import 'package:crimchart/features/channel/application/channels_list_controller.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:shimmer/shimmer.dart';

class InboxActiveCircles extends ConsumerWidget {
  const InboxActiveCircles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final channelsState = ref.watch(channelsListControllerProvider('joined'));
    final userChannels = channelsState.channels;

    if (channelsState.status == ChannelsListStatus.loading &&
        userChannels.isEmpty) {
      return _buildShimmer(context);
    }

    final personalChannels = userChannels
        .where((c) => c.creatorId == user?.id || c.isCharted)
        .toList();

    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: personalChannels.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return const CreateChannelCircle();

          final entity = personalChannels[index - 1];
          final hasStatus = index % 4 == 0;
          final userName = entity.creatorName?.split(' ').first ?? entity.name;

          return ActiveChannelCircle(
            imageUrl: entity.creatorAvatarUrl ?? entity.avatarUrl,
            name: userName,
            hasUpdate: hasStatus,
            onTap: () {
              final dummyChart = ChartChart(
                id: 'active_inbox_${entity.id}',
                senderName: userName,
                senderAvatarUrl: entity.creatorAvatarUrl ?? entity.avatarUrl,
                lastMessage: 'Active recently',
                timestamp: DateTime.now(),
              );

              if (hasStatus) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => InboxOptionsSheet(
                    userName: userName,
                    userAvatar: entity.creatorAvatarUrl ?? entity.avatarUrl,
                    onViewStatus: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatusPage(
                            username: userName,
                            userProfileImageUrl:
                                entity.creatorAvatarUrl ??
                                entity.avatarUrl ??
                                '',
                            statusImageUrl:
                                'https://picsum.photos/seed/status_inbox_${entity.id}/1080/1920',
                            isChartable: true,
                            isPublic: true,
                          ),
                        ),
                      );
                    },
                    onOpenChat: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChartDetailPage(chart: dummyChart),
                        ),
                      );
                    },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartDetailPage(chart: dummyChart),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Shimmer.fromColors(
        baseColor: colorScheme.onSurface.withValues(alpha: 0.05),
        highlightColor: colorScheme.onSurface.withValues(alpha: 0.1),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            width: 72.w,
            height: 72.w,
            margin: EdgeInsets.only(right: 18.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
