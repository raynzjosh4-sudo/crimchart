import 'package:crown/chartdialog/chart_options_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../profile/pages/profile_page.dart';
import '../../../../features/channel/domain/entities/channel_status_entity.dart';
import '../../../../features/inforsheet/info_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../video/core/widgets/video_player_widget.dart';
import 'package:crown/core/utils/responsive_size.dart';

class StatusPage extends StatefulWidget {
  final ChannelStatusEntity? status;
  final String? username;
  final String? userProfileImageUrl;
  final String? statusImageUrl;
  final bool isChartable;
  final bool isPublic;
  final String? heroTag;

  const StatusPage({
    super.key,
    this.status,
    this.username,
    this.userProfileImageUrl,
    this.statusImageUrl,
    this.isChartable = true,
    this.isPublic = true,
    this.heroTag,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextMedia();
      }
    });

    _controller.forward();
  }

  void _nextMedia() {
    final imagesCount = widget.status?.imageUrls.length ?? 1;
    if (_currentIndex < imagesCount - 1) {
      setState(() {
        _currentIndex++;
        _controller.reset();
        _controller.forward();
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousMedia() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _controller.reset();
        _controller.forward();
      });
    } else {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showChartOptions(BuildContext context) {
    _controller.stop();

    final String displayImageUrl = (widget.status?.imageUrls.isNotEmpty == true)
        ? widget.status!.imageUrls[_currentIndex]
        : (widget.statusImageUrl ?? '');

    ChartOptionsDialog.show(
      context,
      username: widget.status?.authorUsername ?? widget.username ?? 'Member',
      userProfileImageUrl:
          widget.status?.authorAvatarUrl ?? widget.userProfileImageUrl ?? '',
      statusImageUrl: displayImageUrl,
      isChartable: widget.isChartable,
      themeColor: Theme.of(context).primaryColor,
      onChartTap: () {
        _showChannelSelector(context);
      },
    ).then((_) {
      if (mounted) _controller.forward();
    });
  }

  void _showChannelSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'SELECT CHANNEL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const CircleAvatar(child: Text('G')),
              title: const Text('Global Arena'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const CircleAvatar(child: Text('D')),
              title: const Text('Discovery Channel'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> mediaList = widget.status != null
        ? (widget.status!.imageUrls.isNotEmpty
              ? widget.status!.imageUrls
              : [widget.status!.authorAvatarUrl ?? ''])
        : [widget.statusImageUrl ?? ''];

    final String? currentImageUrl = mediaList.isNotEmpty
        ? mediaList[_currentIndex]
        : null;
    final String displayUsername =
        widget.status?.authorUsername ?? widget.username ?? 'Member';
    final String displayProfileImage =
        widget.status?.authorAvatarUrl ?? widget.userProfileImageUrl ?? '';
    final bool isVideo = widget.status?.isVideo ?? false;
    final String? videoUrl = widget.status?.videoUrl;
    final String? caption = widget.status?.caption;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressStart: (_) => _controller.stop(),
        onLongPressEnd: (_) => _controller.forward(),
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 3) {
            _previousMedia();
          } else {
            _nextMedia();
          }
        },
        child: Stack(
          children: [
            // 👑 MEDIA CONTENT (Image or Video)
            Positioned.fill(
              child: isVideo && videoUrl != null
                  ? VideoPlayerWidget(videoUrl: videoUrl)
                  : Hero(
                      tag: _currentIndex == 0 && widget.heroTag != null
                          ? widget.heroTag!
                          : 'none',
                      child: currentImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: currentImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white24,
                                ),
                              ),
                            )
                          : Container(color: Colors.black),
                    ),
            ),

            // Top Gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // UI Layer
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    // Segmented Progress Bar
                    Row(
                      children: List.generate(mediaList.length, (index) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                double value = 0;
                                if (index < _currentIndex) {
                                  value = 1.0;
                                } else if (index == _currentIndex) {
                                  value = _controller.value;
                                }
                                return LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                  minHeight: 2,
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        MemberImage(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          size: 40,
                          imageUrl: displayProfileImage,
                          showStatusRing: false,
                          showActiveDot: false,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayUsername,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${_currentIndex + 1} of ${mediaList.length}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => _showChartOptions(context),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 👑 CAPTION LAYER
            if (caption?.isNotEmpty == true)
              Positioned(
                bottom: 60.h,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
