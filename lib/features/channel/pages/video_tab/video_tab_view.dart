import 'package:crimchart/features/channel/application/channel_moments_provider.dart';
import 'package:crimchart/features/channel/application/channel_video_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'widgets/video_card.dart';
import 'widgets/video_promotion_banner.dart';
import 'package:crimchart/features/widgets/shimmer/videotabshimmer.dart';
import 'package:crimchart/features/widgets/offline/offline_view.dart';

class VideoTabView extends ConsumerStatefulWidget {
  final String? channelId;
  final String? channelName;
  final String? channelTitle;

  const VideoTabView({
    super.key,
    this.channelId,
    this.channelName,
    this.channelTitle,
  });

  @override
  ConsumerState<VideoTabView> createState() => _VideoTabViewState();
}

class _VideoTabViewState extends ConsumerState<VideoTabView> {
  static const List<double> _heights = [
    220,
    300,
    260,
    340,
    210,
    290,
    250,
    320,
    230,
    310,
    270,
    350,
  ];

  @override
  Widget build(BuildContext context) {
    final channelId = widget.channelId ?? 'general';
    final state = ref.watch(channelVideoProvider(channelId));
    final videos = state.videos;
    final momentsAsync = ref.watch(channelMomentsProvider(channelId));

    // 👑 SYNCED SHIMMER: Stay in shimmer until BOTH moments and initial videos are ready
    final isInitialVideosLoading = state.isLoading && videos.isEmpty;
    final isInitialMomentsLoading =
        momentsAsync.isLoading && (momentsAsync.valueOrNull == null);

    if (isInitialVideosLoading || isInitialMomentsLoading) {
      return const SliverFillRemaining(child: VideoTabShimmer());
    }

    if (state.errorMessage != null && videos.isEmpty) {
      return SliverFillRemaining(
        child: OfflineView(
          type: OfflinePageType.feed,
          onRetry: () => ref
              .read(channelVideoProvider(channelId).notifier)
              .loadVideos(refresh: true),
        ),
      );
    }

    return SliverSafeArea(
      top: false,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          VideoPromotionBanner(
            key: ValueKey('promo_banner_$channelId'),
            channelId: channelId,
            channelName: widget.channelName,
            channelTitle: widget.channelTitle,
          ),
          if (videos.isEmpty && !state.isLoading)
            SizedBox(
              height: 200.h,
              child: Center(
                child: Text(
                  'No videos yet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];

                  // Infinite scroll trigger
                  if (index >= videos.length - 2 &&
                      state.hasMore &&
                      !state.isLoading) {
                    Future.microtask(() {
                      ref
                          .read(channelVideoProvider(channelId).notifier)
                          .loadVideos();
                    });
                  }

                  return SizedBox(
                    height: _heights[index % _heights.length].h,
                    child: VideoCard(
                      video: video,
                      index: index,
                      allVideos: videos,
                    ),
                  );
                },
              ),
            ),
          ],
          if (state.isLoading && videos.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),

          if (!state.hasMore && videos.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(24.h),
              child: Center(
                child: Text(
                  "You've seen all videos!",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
