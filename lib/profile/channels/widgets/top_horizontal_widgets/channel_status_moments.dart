import 'package:crimchart/features/newinsidechartstartpage/models/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/channel/application/channels_list_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:crimchart/mainFeed/features/cardwidgets/storychacrdwidget/status_page.dart';
import 'package:crimchart/channelcreatepage/channel_create_page.dart';
import 'package:crimchart/features/channel/application/channel_moments_provider.dart';
import 'package:crimchart/features/channel/domain/entities/channel_moment_entity.dart';
import 'package:crimchart/features/channel/domain/entities/channel_status_entity.dart';

class ChannelStatusMoments extends ConsumerWidget {
  const ChannelStatusMoments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final channelsState = ref.watch(channelsListControllerProvider('joined'));
    final momentsAsync = ref.watch(joinedMomentsProvider);

    return momentsAsync.when(
      data: (allMoments) {
        // Group moments by channelId
        final groupedMoments = <String, List<ChannelMomentEntity>>{};
        for (final m in allMoments) {
          groupedMoments.putIfAbsent(m.channelId, () => []).add(m);
        }

        final channelIdsWithMoments = groupedMoments.keys.toList();
        final joinedChannels = channelsState.channels;

        return Container(
          height: 175.h,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: ListView.builder(
            key: const ValueKey('channel_moments_list'),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: channelIdsWithMoments.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCreateCard(context, user?.profileImageUrl);
              }

              final channelId = channelIdsWithMoments[index - 1];
              final channelMoments = groupedMoments[channelId]!;

              // Find the channel entity to get the name/avatar
              final channelEntity = joinedChannels.cast<dynamic>().firstWhere(
                (c) => c.id == channelId,
                orElse: () => null,
              );

              return _buildChannelMomentCard(
                context,
                channelEntity,
                channelMoments,
              );
            },
          ),
        );
      },
      loading: () => _buildShimmer(context),
      error: (e, st) => const SizedBox.shrink(),
    );
  }

  Widget _buildCreateCard(BuildContext context, String? userAvatarUrl) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const ChannelCreatePage(),
            ),
          );
        },
        child: Container(
          width: 100.w,
          height: 160.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: const Color(0xFF1A1A1A),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(
                                0xFFFFB800,
                              ).withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundColor: Colors.grey[900],
                            backgroundImage:
                                (userAvatarUrl != null &&
                                    userAvatarUrl.isNotEmpty &&
                                    Uri.tryParse(
                                          userAvatarUrl,
                                        )?.hasAbsolutePath ==
                                        true)
                                ? CachedNetworkImageProvider(userAvatarUrl)
                                : null,
                            child:
                                (userAvatarUrl == null ||
                                    userAvatarUrl.isEmpty ||
                                    Uri.tryParse(
                                          userAvatarUrl,
                                        )?.hasAbsolutePath !=
                                        true)
                                ? Icon(
                                    Icons.person,
                                    color: Colors.white24,
                                    size: 30.sp,
                                  )
                                : null,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB800),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 12.h,
                left: 0,
                right: 0,
                child: Text(
                  'Create',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelMomentCard(
    BuildContext context,
    dynamic channel,
    List<ChannelMomentEntity> moments,
  ) {
    final latestMoment = moments.first;
    final channelName = channel?.name ?? latestMoment.authorName ?? 'Channel';
    final avatarUrl = channel?.avatarUrl ?? latestMoment.authorAvatarUrl;

    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: () {
          final statusEntity = ChannelStatusEntity(
            id: latestMoment.id,
            channelId: latestMoment.channelId,
            authorId: latestMoment.authorId,
            authorUsername: channelName,
            authorAvatarUrl: avatarUrl,
            imageUrls: moments.map((m) => m.mediaUrl).toList(),
            videoUrl: latestMoment.mediaType == 'video'
                ? latestMoment.mediaUrl
                : null,
            isVideo: latestMoment.mediaType == 'video',
            caption: latestMoment.caption,
            createdAt: latestMoment.createdAt,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatusPage(
                status: statusEntity,
                username: channelName,
                userProfileImageUrl: avatarUrl,
                isChartable: true,
                isPublic: true,
              ),
            ),
          );
        },
        child: Container(
          width: 100.w,
          height: 160.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if ((latestMoment.thumbnailUrl?.isNotEmpty == true &&
                      Uri.tryParse(
                            latestMoment.thumbnailUrl!,
                          )?.hasAbsolutePath ==
                          true) ||
                  (latestMoment.mediaUrl.isNotEmpty &&
                      Uri.tryParse(latestMoment.mediaUrl)?.hasAbsolutePath ==
                          true))
                CachedNetworkImage(
                  imageUrl:
                      (latestMoment.thumbnailUrl?.isNotEmpty == true &&
                          Uri.tryParse(
                                latestMoment.thumbnailUrl!,
                              )?.hasAbsolutePath ==
                              true)
                      ? latestMoment.thumbnailUrl!
                      : latestMoment.mediaUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.white10),
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.white10),
                )
              else
                Container(color: Colors.white10),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: CustomPaint(
                  painter: StatusRingPainter(
                    color: const Color(0xFFFFB800),
                    segmentCount: moments.length,
                    borderWidth: 2.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundImage:
                          (avatarUrl != null &&
                              avatarUrl.isNotEmpty &&
                              Uri.tryParse(avatarUrl)?.hasAbsolutePath == true)
                          ? CachedNetworkImageProvider(avatarUrl)
                          : null,
                      backgroundColor: Colors.grey[800],
                      child:
                          (avatarUrl == null ||
                              avatarUrl.isEmpty ||
                              Uri.tryParse(avatarUrl)?.hasAbsolutePath != true)
                          ? Text(
                              channelName[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Text(
                  channelName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 175.h,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Shimmer.fromColors(
        baseColor: colorScheme.onSurface.withValues(alpha: 0.05),
        highlightColor: colorScheme.onSurface.withValues(alpha: 0.1),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            width: 100.w,
            height: 160.h,
            margin: EdgeInsets.only(right: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusRingPainter extends CustomPainter {
  final Color color;
  final int segmentCount;
  final double borderWidth;

  StatusRingPainter({
    required this.color,
    required this.segmentCount,
    this.borderWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    if (segmentCount <= 1) {
      canvas.drawCircle(center, radius, paint);
    } else {
      const double gap = 0.15; // Gap between segments in radians
      double sweepAngle = (2 * 3.141592653589793 / segmentCount) - gap;

      for (int i = 0; i < segmentCount; i++) {
        double startAngle =
            (i * (2 * 3.141592653589793 / segmentCount)) -
            (3.141592653589793 / 2);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + (gap / 2),
          sweepAngle,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
