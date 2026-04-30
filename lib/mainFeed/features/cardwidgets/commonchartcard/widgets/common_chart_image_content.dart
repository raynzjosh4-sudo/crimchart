import 'package:flutter/material.dart';
import '../../../../../features/widgets/chartcard/card/media/image_media.dart';

class CommonChartImageContent extends StatefulWidget {
  final List<String> imageUrls;
  final String username;
  final String userProfileImageUrl;
  final String chartName;
  final int chartPoints;
  final int rank;
  final Color themeColor;
  final PageController? controller;
  final double? aspectRatio;

  const CommonChartImageContent({
    super.key,
    required this.imageUrls,
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
  State<CommonChartImageContent> createState() =>
      _CommonChartImageContentState();
}

class _CommonChartImageContentState extends State<CommonChartImageContent> {
  late int _currentPage;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ?? PageController();
    _currentPage = _pageController.hasClients
        ? _pageController.page?.round() ?? 0
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    // Only includes images, no Chart slide
    final int totalCount = widget.imageUrls.length;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150, maxHeight: 500.0),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio ?? 2.2, 
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: totalCount,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return ImageCardMedia(
                  url: widget.imageUrls[index],
                  creatorAvatarUrl: widget.userProfileImageUrl,
                  themeColor: widget.themeColor,
                  username: widget.username,
                  subtitle: widget.chartName,
                  showThumbnail: false,
                );
              },
            ),

            if (totalCount > 1)
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    totalCount,
                    (index) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? widget.themeColor
                            : Colors.white.withOpacity(0.4),
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
}





























