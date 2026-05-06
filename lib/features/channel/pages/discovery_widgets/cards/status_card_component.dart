import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/sdui/feed_component.dart';

class StatusCardComponent extends FeedComponent {
  final String imageUrl;
  final String views;

  const StatusCardComponent({
    required this.imageUrl,
    required this.views,
  }) : super('status_card_item');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.w,
      height: 250.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey.shade900),
              errorWidget: (context, url, error) => Container(color: Colors.grey.shade900),
            ),
            
            // Gradient Overlay for text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60.h,
              child: DecoratedBox(
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
              ),
            ),
            
            // Views Text
            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: Text(
                views,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
