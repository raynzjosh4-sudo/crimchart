import 'package:crown/commentingsheets/widgets/commenting_sheet.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:crown/mainFeed/features/cardwidgets/models/channel_post_model.dart';
import 'package:crown/video/comment/widgets/thumbnail_reference_overlay.dart';
import 'package:crown/video/competition/widgets/actions/share/competition_share_button.dart';
import 'package:crown/video/core/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';

import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class CommentVideoCard extends StatefulWidget {
  final ChannelPostModel post;

  const CommentVideoCard({super.key, required this.post});

  @override
  State<CommentVideoCard> createState() => _CommentVideoCardState();
}

class _CommentVideoCardState extends State<CommentVideoCard> {
  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CommentingSheet(commentCount: '${widget.post.comments}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        // Black base — ensures loading state is always dark, not theme-dependent
        const Positioned.fill(child: ColoredBox(color: Colors.black)),
        // Video Player
        Positioned.fill(
          child: VideoPlayerWidget(videoUrl: widget.post.videoUrl ?? ''),
        ),

        // Top Actions
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Text(
                      "1.0x",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.15, 0.65, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Right Side Actions
        Positioned(
          right: 16.w,
          bottom: 20.h,
          child: Column(
            children: [
              if (widget.post.thumbnailLinkUrl != null) ...[
                ThumbnailReferenceOverlay(
                  thumbnailUrl: widget.post.thumbnailLinkUrl!,
                  mediaType: widget.post.thumbnailLinkType,
                ),
                SizedBox(height: 20.h),
              ],
              _ActionButton(
                icon: LucideIcons.heart,
                label: '${widget.post.likes}',
                onTap: () {},
              ),
              SizedBox(height: 20.h),
              _ActionButton(
                icon: LucideIcons.messageSquare,
                label: '${widget.post.comments}',
                onTap: () => _showComments(context),
              ),
              SizedBox(height: 20.h),
              CompetitionShareButton(onTap: () {}),
            ],
          ),
        ),

        // Bottom Overlay
        Positioned(
          left: 16.w,
          right: 80.w,
          bottom: 24.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.yellow, width: 2),
                        ),
                        child: MemberImage(
                          imageUrl: widget.post.userProfileImageUrl,
                          size: 36.w,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '@${widget.post.username}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.sp,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: const Offset(0, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.yellow,
                              size: 13.sp,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                context.tr(
                                  widget.post.channelName.toLowerCase().replaceAll(
                                    ' ',
                                    '_',
                                  ),
                                ).toUpperCase(),
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                widget.post.caption,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 14.sp),
                  SizedBox(width: 6.w),
                  Text(
                    context.tr('original_sound'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 1),
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
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 26.sp,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.4),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











