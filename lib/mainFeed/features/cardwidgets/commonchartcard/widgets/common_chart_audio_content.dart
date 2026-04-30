import 'package:flutter/material.dart';
import '../../../../../features/widgets/chartcard/card/media/audio_media.dart';

class CommonChartAudioContent extends StatefulWidget {
  final String audioUrl;
  final String? thumbnailUrl;
  final String? backgroundImageUrl;
  final String? creatorAvatarUrl;
  final String username;
  final String userProfileImageUrl;
  final String chartName;
  final int chartPoints;
  final int rank;
  final Color themeColor;
  final String id; // Track ID
  final PageController? controller;
  final double? aspectRatio;

  const CommonChartAudioContent({
    super.key,
    required this.audioUrl,
    this.thumbnailUrl,
    this.backgroundImageUrl,
    this.creatorAvatarUrl,
    required this.username,
    required this.userProfileImageUrl,
    required this.chartName,
    required this.chartPoints,
    required this.rank,
    required this.themeColor,
    required this.id,
    this.controller,
    this.aspectRatio,
  });

  @override
  State<CommonChartAudioContent> createState() => _CommonChartAudioContentState();
}

class _CommonChartAudioContentState extends State<CommonChartAudioContent> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio ?? 2.2, 
        child: AudioCardMedia(
          id: widget.id,
          url: widget.audioUrl,
          thumbnailUrl: widget.thumbnailUrl,
          backgroundImageUrl: widget.backgroundImageUrl,
          creatorAvatarUrl: widget.creatorAvatarUrl ?? widget.userProfileImageUrl,
          themeColor: widget.themeColor,
          username: widget.username,
          showThumbnail: false,
        ),
      ),
    );
  }
}





























