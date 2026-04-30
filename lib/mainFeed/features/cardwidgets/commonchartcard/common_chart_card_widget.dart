import 'package:flutter/material.dart';
import '../models/common_chart_model.dart';
import '../storychacrdwidget/status_page.dart';
import '../../../../profile/pages/profile_page.dart';
import '../../../menu/main_feed_menu.dart';
import 'widgets/common_chart_video_content.dart';
import 'widgets/common_chart_audio_content.dart';
import 'widgets/common_chart_footer.dart';
import '../../../../features/channel/pages/channel_page.dart';
import '../../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../../core/utils/responsive_size.dart';
import '../../../../../features/widgets/chartcard/card/media/image_media.dart';
import 'pages/common_chart_details_page.dart';

class CommonChartCardWidget extends StatefulWidget {
  final CommonChartModel data;
  final bool isFeedView;

  const CommonChartCardWidget({
    super.key,
    required this.data,
    this.isFeedView = true,
  });

  @override
  State<CommonChartCardWidget> createState() => _CommonChartCardWidgetState();
}

class _CommonChartCardWidgetState extends State<CommonChartCardWidget> {
  late PageController _pageController;
  late bool _isCharted;
  late int _currentPoints;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isCharted = widget.data.isCharted;
    _currentPoints = widget.data.chartPoints;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onChartTap() {
    setState(() {
      if (_isCharted) {
        _currentPoints--;
        _isCharted = false;
      } else {
        _currentPoints++;
        _isCharted = true;
      }
    });

    // Also navigate to the channel page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChannelPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final data = widget.data;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post-style Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              MemberImage(
                size: 42.w,
                imageUrl: data.userProfileImageUrl,
                showStatusRing: data.hasStatus,
                showActiveDot: data.isActive,
                borderWidth: 2,
                onTap: () {
                  if (data.hasStatus) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StatusPage(
                          username: data.username,
                          userProfileImageUrl: data.userProfileImageUrl,
                          statusImageUrl: data.userProfileImageUrl,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  }
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.username,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: themeColor,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            data.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: themeColor.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => MainFeedMenu.show(context),
              ),
            ],
          ),
        ),

        // Content (Dynamic switch between Image, Video, and Audio)
        _buildContent(data, themeColor),

        // Footer Content
        CommonChartFooter(
          username: data.username,
          chartName: data.chartName,
          mutualFriends: data.mutualFriends,
          mutualCount: data.mutualCount,
          likes: data.likes,
          comments: data.comments,
          isLiked: data.isLiked,
          isCharted: _isCharted,
          chartPoints: _currentPoints,
          themeColor: themeColor,
          onChartTap: _onChartTap,
        ),

        // Separator matching feed posts if needed
        const SizedBox(height: 8),
      ],
    );
  }

  List<Map<String, String>> _buildCarouselItems(CommonChartModel post) {
    List<Map<String, String>> carouselList = [];

    // 1. Add all the images first
    for (String imgUrl in post.imageUrls) {
      carouselList.add({'type': 'image', 'url': imgUrl});
    }

    // 2. Add the video as the next page
    if (post.isVideo && post.videoUrl != null && post.videoUrl!.isNotEmpty) {
      carouselList.add({'type': 'video', 'url': post.videoUrl!});
    }

    // 3. Add the audio as the final page
    if (post.isAudio && post.audioUrl != null && post.audioUrl!.isNotEmpty) {
      carouselList.add({'type': 'audio', 'url': post.audioUrl!});
    }

    return carouselList;
  }

  Widget _buildCoverArt(CommonChartModel post, Color themeColor) {
    // 1. Is there a Video? Show its thumbnail with a Play icon.
    if (post.isVideo && post.videoUrl != null && post.videoUrl!.isNotEmpty) {
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          ImageCardMedia(
            url: post.thumbnailUrl ?? '',
            creatorAvatarUrl: post.userProfileImageUrl,
            themeColor: themeColor,
            username: post.username,
            subtitle: post.chartName,
            showThumbnail: false,
          ),
          const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
        ],
      );
    }

    // 2. Are there Images? Show the first one.
    if (post.imageUrls.isNotEmpty) {
      return ImageCardMedia(
        url: post.imageUrls.first,
        creatorAvatarUrl: post.userProfileImageUrl,
        themeColor: themeColor,
        username: post.username,
        subtitle: post.chartName,
        showThumbnail: false,
      );
    }

    // 3. Is it just Audio? Show a cool equalizer/mic graphic.
    if (post.isAudio) {
      return Container(
        color: const Color(0xFF1E1E1E),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.graphic_eq, color: Colors.amber, size: 50),
              const SizedBox(height: 10),
              Text(
                "Audio Track",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMultiMediaIndicator(CommonChartModel post) {
    int mediaCount =
        post.imageUrls.length + (post.isVideo ? 1 : 0) + (post.isAudio ? 1 : 0);

    if (mediaCount > 1) {
      return Positioned(
        top: 12,
        right: 12,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.layers, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                '1/$mediaCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildContent(CommonChartModel data, Color themeColor) {
    if (widget.isFeedView) {
      final mediaCount =
          data.imageUrls.length +
          (data.isVideo ? 1 : 0) +
          (data.isAudio ? 1 : 0);
      return GestureDetector(
        onTap: () {
          // Launch the full screen Carousel passing just this single post
          // (or modify to pass more context if needed in the future)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CommonChartDetailsPage(Charts: [data], initialIndex: 0),
            ),
          );
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 150, maxHeight: 650.0),
          child: AspectRatio(
            aspectRatio: data.aspectRatio ?? 0.8,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildCoverArt(data, themeColor),
                if (mediaCount > 1) _buildMultiMediaIndicator(data),
              ],
            ),
          ),
        ),
      );
    }

    final carouselItems = _buildCarouselItems(data);

    if (carouselItems.isEmpty) return const SizedBox.shrink();

    if (carouselItems.length == 1) {
      return _buildMediaPlayer(carouselItems.first, data, themeColor);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150, maxHeight: 650.0),
      child: AspectRatio(
        aspectRatio: data.aspectRatio ?? 0.8,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: carouselItems.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildMediaPlayer(
                  carouselItems[index],
                  data,
                  themeColor,
                );
              },
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  carouselItems.length,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? themeColor
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPlayer(
    Map<String, String> item,
    CommonChartModel data,
    Color themeColor,
  ) {
    final type = item['type'];
    final url = item['url']!;

    if (type == 'video') {
      return CommonChartVideoContent(
        controller: _pageController,
        videoUrl: url,
        thumbnailUrl: data.thumbnailUrl,
        username: data.username,
        userProfileImageUrl: data.userProfileImageUrl,
        chartName: data.chartName,
        chartPoints: _currentPoints,
        rank: data.rank,
        themeColor: themeColor,
        aspectRatio: data.aspectRatio,
      );
    }

    if (type == 'audio') {
      return CommonChartAudioContent(
        id: data.id,
        controller: _pageController,
        audioUrl: url,
        thumbnailUrl: data.thumbnailUrl,
        backgroundImageUrl: data.backgroundImageUrl,
        creatorAvatarUrl: data.creatorAvatarUrl,
        username: data.username,
        userProfileImageUrl: data.userProfileImageUrl,
        chartName: data.chartName,
        chartPoints: _currentPoints,
        rank: data.rank,
        themeColor: themeColor,
        aspectRatio: data.aspectRatio,
      );
    }

    // Default to ImageCardMedia
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150),
      child: AspectRatio(
        aspectRatio: data.aspectRatio ?? 0.8,
        child: ImageCardMedia(
          url: url,
          creatorAvatarUrl: data.userProfileImageUrl,
          themeColor: themeColor,
          username: data.username,
          subtitle: data.chartName,
          showThumbnail: false,
        ),
      ),
    );
  }
}
