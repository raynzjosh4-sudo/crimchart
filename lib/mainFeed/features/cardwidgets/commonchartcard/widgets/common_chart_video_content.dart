import 'package:flutter/material.dart';
import '../../../../../features/widgets/chartcard/card/media/video_media.dart';

class CommonChartVideoContent extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final String username;
  final String userProfileImageUrl;
  final String chartName;
  final int chartPoints;
  final int rank;
  final Color themeColor;
  final PageController? controller;
  final double? aspectRatio;

  const CommonChartVideoContent({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.username,
    required this.userProfileImageUrl,
    required this.chartName,
    required this.chartPoints,
    required this.rank,
    required this.themeColor,
    this.controller,
    this.aspectRatio,
  });

  @override
  State<CommonChartVideoContent> createState() => _CommonChartVideoContentState();
}

class _CommonChartVideoContentState extends State<CommonChartVideoContent> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio ?? 0.8, 
        child: VideoCardMedia(
          url: widget.videoUrl,
          creatorAvatarUrl: widget.userProfileImageUrl,
          themeColor: widget.themeColor,
          username: widget.username,
          subtitle: widget.chartName,
          showThumbnail: false,
        ),
      ),
    );
  }
}





























