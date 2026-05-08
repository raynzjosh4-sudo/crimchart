import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/newinsidechartstartpage/models/member.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:crimchart/profile/widgets/ratings/given_gifts_display.dart';
import 'package:flutter/material.dart';

class ScalingAvatarCarousel extends StatefulWidget {
  final List<Member> members;
  final double viewportFraction;
  final double minScale;
  final double maxScale;

  const ScalingAvatarCarousel({
    super.key,
    required this.members,
    this.viewportFraction = 0.65,
    this.minScale = 0.4,
    this.maxScale = 1.0,
  });

  @override
  State<ScalingAvatarCarousel> createState() => _ScalingAvatarCarouselState();
}

class _ScalingAvatarCarouselState extends State<ScalingAvatarCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget.members.length / 2).floor();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _currentIndex,
    );
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
    final currentMember =
        widget.members[_currentIndex.clamp(0, widget.members.length - 1)];

    // Localize 'Member' if name contains it (Handle dummy data)
    String displayName = currentMember.name;
    if (displayName.toLowerCase().contains('member')) {
      displayName = displayName
          .replaceAll('Member', context.tr('member'))
          .replaceAll('member', context.tr('member'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            pageSnapping: bool.fromEnvironment('pageSnapping'),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.members.length,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = index.toDouble() - (_pageController.page ?? 0);
                  } else {
                    value =
                        index.toDouble() -
                        ((widget.members.length / 2).floor().toDouble());
                  }

                  final scale = (1.0 - (value.abs() * 0.5)).clamp(
                    widget.minScale,
                    widget.maxScale,
                  );
                  final opacity = (1.0 - (value.abs() * 0.5)).clamp(0.4, 1.0);

                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: OverflowBox(
                          maxWidth: 240.w,
                          maxHeight: 240.h,
                          child: SizedBox(
                            width: 240.w,
                            height: 240.h,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: MemberImage(
                  size: 240.w,
                  imageUrl: widget.members[index].avatarUrl,
                  showStatusRing: true,
                  borderWidth: 4.0.w,
                  showActiveDot: false,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Member Details
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        if (currentMember.title != null) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              currentMember.title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
        if (currentMember.pointsDisplay != null) ...[
          SizedBox(height: 8.h),
          Text(
            currentMember.pointsDisplay!,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ],
        if (currentMember.receivedGifts.isNotEmpty) ...[
          SizedBox(height: 12.h),
          GivenGiftsDisplay(gifts: currentMember.receivedGifts),
        ],
      ],
    );
  }
}











