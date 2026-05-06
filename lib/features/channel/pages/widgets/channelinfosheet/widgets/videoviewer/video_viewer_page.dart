import 'dart:io';
import 'package:crown/features/feed/application/feed_controller.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/widgets/chart_image.dart';

class VideoViewerPage extends ConsumerStatefulWidget {
  final List<PostEntity> initialVideos;
  final int initialIndex;
  final String? channelId;

  const VideoViewerPage({
    super.key,
    required this.initialVideos,
    required this.initialIndex,
    this.channelId,
  });

  @override
  ConsumerState<VideoViewerPage> createState() => _VideoViewerPageState();
}

class _VideoViewerPageState extends ConsumerState<VideoViewerPage> {
  late List<PostEntity> _videos;
  late PageController _pageController;
  int _currentChannelPage = 2; // Assume we already have page 1
  int _currentGlobalPage = 1;
  bool _isLoadingMore = false;
  bool _reachedEndOfChannel = false;

  @override
  void initState() {
    super.initState();
    _videos = List.from(widget.initialVideos);
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  Future<void> _fetchMoreVideos() async {
    if (_isLoadingMore) return;
    if (!mounted) return;
    setState(() => _isLoadingMore = true);

    try {
      final repo = ref.read(feedRepositoryProvider);
      List<PostEntity> newVideos = [];

      if (!_reachedEndOfChannel && widget.channelId != null) {
        // 1. Try to fetch more from the channel
        final result = await repo.getChannelPosts(
          widget.channelId!,
          page: _currentChannelPage,
        );
        result.fold((l) => _reachedEndOfChannel = true, (posts) {
          final videosOnly = posts.where((p) => p.isVideo).toList();
          if (videosOnly.isEmpty) {
            _reachedEndOfChannel = true;
          } else {
            newVideos = videosOnly;
            _currentChannelPage++;
          }
        });
      }

      if (newVideos.isEmpty && mounted) {
        // 2. Channel exhausted, fetch from global feed
        final result = await repo.getFeed(page: _currentGlobalPage);
        result.fold((l) => null, (posts) {
          final videosOnly = posts.where((p) => p.isVideo).toList();
          newVideos = videosOnly;
          _currentGlobalPage++;
        });
      }

      if (newVideos.isNotEmpty && mounted) {
        setState(() {
          _videos.addAll(newVideos);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: _videos.length,
        onPageChanged: (index) {
          if (index >= _videos.length - 2) {
            _fetchMoreVideos();
          }
        },
        itemBuilder: (context, index) {
          return VerticalVideoItem(
            post: _videos[index],
            thumbnailUrl: _videos[index].thumbnailUrls.isNotEmpty
                ? _videos[index].thumbnailUrls.first
                : null,
            onBack: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}

class VerticalVideoItem extends StatefulWidget {
  final PostEntity post;
  final String? thumbnailUrl;
  final VoidCallback onBack;

  const VerticalVideoItem({
    super.key,
    required this.post,
    required this.onBack,
    this.thumbnailUrl,
  });

  @override
  State<VerticalVideoItem> createState() => _VerticalVideoItemState();
}

class _VerticalVideoItemState extends State<VerticalVideoItem> {
  late final player = Player();
  late final controller = VideoController(player);
  bool _initialized = false;
  bool _isPlaying = false; // 👑 Track actual playback

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.post.videoUrl == null) return;
    String url = widget.post.videoUrl!;

    // 👑 Robust Path Handling
    final media = url.startsWith('http')
        ? Media(url)
        : (url.startsWith('file://')
              ? Media(url)
              : Media(File(Uri.decodeComponent(url)).uri.toString()));

    try {
      await player.open(media, play: true);
      player.setPlaylistMode(PlaylistMode.loop);

      // 👑 Sync Playback State for Thumbnail Overlay
      player.stream.playing.listen((playing) {
        if (mounted) setState(() => _isPlaying = playing);
      });

      if (mounted) setState(() => _initialized = true);
    } catch (e) {
      debugPrint('Video Player error: $e');
    }
  }

  @override
  void dispose() {
    player.pause(); // 👑 Prevent "BufferQueue abandoned" error
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── 1. VIDEO CONTENT (Always present if initialized) ──
        if (_initialized)
          SizedBox.expand(
            child: Video(
              controller: controller,
              fit: BoxFit.cover,
              controls: NoVideoControls,
            ),
          ),

        // ── 2. SMART THUMBNAIL OVERLAY (Stays ON TOP until playing) ──
        // This prevents the "Black Screen" gap entirely!
        if (!_isPlaying && widget.thumbnailUrl != null)
          SizedBox.expand(
            child: ChartImage(
              url: widget.thumbnailUrl!.startsWith('http')
                  ? widget.thumbnailUrl
                  : Uri.decodeComponent(widget.thumbnailUrl!),
              fit: BoxFit.cover,
            ),
          ),

        // ── 3. OPTIONAL LOADING OVERLAY ──
        if (!_initialized)
          const Center(child: CircularProgressIndicator(color: Colors.white70)),

        // ── TOP ACTIONS ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  _buildHeaderIcon(LucideIcons.chevronLeft, widget.onBack),
                ],
              ),
            ),
          ),
        ),

        // ── BOTTOM INFO ──
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              16.w,
              80.h,
              16.w,
              24.h + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _buildAvatar(),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.authorDisplayName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                if (widget.post.authorTitle != null)
                                  Row(
                                    children: [
                                      Icon(
                                        LucideIcons.mapPin,
                                        size: 12.sp,
                                        color: Colors.yellow,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        widget.post.authorTitle!,
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        widget.post.caption,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.music,
                            size: 14.sp,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Original Sound - ${widget.post.authorUsername}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildEngagementIcon(
                        LucideIcons.heart,
                        widget.post.likes.toString(),
                        Colors.white,
                        isActive: widget.post.isLiked,
                      ),
                      _buildEngagementIcon(
                        LucideIcons.messageSquare,
                        widget.post.comments.toString(),
                        Colors.white,
                      ),
                      _buildEngagementIcon(
                        LucideIcons.share2,
                        context.tr('share_status'),
                        Colors.white,
                      ),
                      _buildChartAction(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      child: CircleAvatar(
        radius: 20.r,
        backgroundImage: widget.post.authorAvatarUrl != null
            ? CachedNetworkImageProvider(widget.post.authorAvatarUrl!)
            : null,
        child: widget.post.authorAvatarUrl == null
            ? const Icon(LucideIcons.user, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22.sp),
      ),
    );
  }

  Widget _buildEngagementIcon(
    IconData icon,
    String label,
    Color color, {
    bool isActive = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.redAccent : Colors.white,
            size: 30.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartAction(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.yellow.withValues(alpha: 0.5),
              width: 2,
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFF421E01), Color(0xFF1B0C00)],
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1B0C00),
            ),
            child: Icon(LucideIcons.hand, size: 24.sp, color: Colors.yellow),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          context.tr('chart'),
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
