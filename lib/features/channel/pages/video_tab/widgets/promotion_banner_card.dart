import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/video/core/widgets/video_player_widget.dart';
import '../../../domain/entities/channel_moment_entity.dart';

class PromotionBannerCard extends StatelessWidget {
  final ChannelMomentEntity moment;

  const PromotionBannerCard({super.key, required this.moment});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 45,
            offset: const Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Media Content ──
          moment.mediaType == 'video'
              ? VideoPlayerWidget(
                  videoUrl: moment.mediaUrl,
                  autoPlay: false,
                )
              : CachedNetworkImage(
                  imageUrl: moment.mediaUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: colorScheme.surfaceContainer,
                  ),
                  errorWidget: (_, __, ___) => const Center(
                    child: Icon(Icons.error_outline),
                  ),
                ),

          // ── Bottom Gradient for Readability ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),

          // ── Author Info Overlay ──
          Positioned(
            left: 12.w,
            bottom: 12.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: moment.authorAvatarUrl ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: colorScheme.primary.withValues(alpha: 0.8),
                        child: Icon(
                          Icons.person,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      moment.authorName ?? 'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    if (moment.caption != null && moment.caption!.isNotEmpty)
                      Text(
                        moment.caption!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
