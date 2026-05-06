import 'package:crown/commentingsheets/widgets/commenting_sheet.dart';
import 'package:crown/features/channel/application/channel_moments_provider.dart';
import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'native_button.dart';
import 'promotion_banner_card.dart';

class VideoPromotionBanner extends ConsumerStatefulWidget {
  final String? channelId;
  final String? channelName;
  final String? channelTitle;

  const VideoPromotionBanner({
    super.key,
    this.channelId,
    this.channelName,
    this.channelTitle,
  });

  @override
  ConsumerState<VideoPromotionBanner> createState() =>
      _VideoPromotionBannerState();
}

class _VideoPromotionBannerState extends ConsumerState<VideoPromotionBanner> {
  late final PageController _pageController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.65, initialPage: 500);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final momentsAsync = ref.watch(
      channelMomentsProvider(widget.channelId ?? ''),
    );
    final moments = momentsAsync.valueOrNull ?? [];
    final isEmpty = moments.isEmpty;
    final isLooping = moments.isNotEmpty;
    final itemCount = isEmpty ? 0 : (isLooping ? 1000 : moments.length);

    // The initialPage: 500 in the controller handles the starting position
    // when data arrives and itemCount becomes 1000.

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 12.h, top: 4.h),
            child: Text(
              'Moments',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
                fontFamily: theme.textTheme.displayLarge?.fontFamily,
              ),
            ),
          ),
          if (isEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                    height: 1.2,
                    fontFamily: theme.textTheme.displayLarge?.fontFamily,
                  ),
                  children: [
                    const TextSpan(text: 'Share moments with friends on '),
                    TextSpan(
                      text: widget.channelName ?? 'this channel',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h),
          ] else ...[
            // ── The Responsive Carousel ──
            SizedBox(
              height: 400.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: itemCount,
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.04)).clamp(0.0, 1.0);
                      }
                      return Center(
                        child: Transform.scale(
                          scale: Curves.easeInOutCubic.transform(value),
                          child: child,
                        ),
                      );
                    },
                    child: PromotionBannerCard(
                      moment: moments[index % moments.length],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8.h),

            // ── Headline ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                widget.channelName ?? 'Stay connected',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  letterSpacing: -1.2,
                  height: 1.0,
                  fontFamily: theme.textTheme.displayLarge?.fontFamily,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // ── Subtext ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                widget.channelTitle ??
                    'Share your special moments and find new inspiration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
            ),
          ],

          SizedBox(height: 12.h),

          // ── ACTION BUTTON ──
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: NativeButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CommentingSheet(
                      channelId: widget.channelId,
                      channelName: widget.channelName,
                      showInputField: false,
                      isMoment: true,
                    ),
                  );
                },
                text: 'Post a Moment',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
