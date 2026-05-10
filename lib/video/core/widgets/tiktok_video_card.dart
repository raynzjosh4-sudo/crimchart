import 'dart:async';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit/media_kit.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';

import '../models/feed_video_item.dart';
import '../../pages/video_feed_page.dart';
import 'package:crimchart/features/widgets/channelmemberdata/comment_card/comment_action/like/like.dart';
import 'package:crimchart/features/widgets/channelmemberdata/comment_card/comment_action/comment_action.dart';
import 'package:crimchart/features/channel/pages/tag/tag_overlay.dart';
import 'package:crimchart/features/widgets/channelmemberdata/thread_discussion_sheet.dart';
import 'package:crimchart/commentingsheets/widgets/comment_input_field.dart';
import 'profile_mini_sheet.dart';

class MkVideoCard extends StatefulWidget {
  final FeedVideoItem item;
  final VideoController? controller;
  final bool isPlaying;
  final bool showBottomBuffer;
  final VideoFeedTab? currentTab;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShrunkenTap;
  final bool isShrunken;

  const MkVideoCard({
    super.key,
    required this.item,
    this.controller,
    this.isPlaying = false,
    this.showBottomBuffer = false,
    this.currentTab,
    this.onCommentTap,
    this.onShrunkenTap,
    this.isShrunken = false,
  });

  @override
  State<MkVideoCard> createState() => _MkVideoCardState();
}

class _MkVideoCardState extends State<MkVideoCard> {
  bool _isPaused = false;
  bool _showIcon = false;
  Timer? _iconTimer;

  Player? get _player => widget.controller?.player;

  void _onTap() {
    if (widget.isShrunken) {
      if (widget.onShrunkenTap != null) widget.onShrunkenTap!();
      return;
    }
    if (_player == null) return;
    setState(() {
      _isPaused = !_isPaused;
      _showIcon = true;
    });
    if (_isPaused) {
      _player!.pause();
    } else {
      _player!.play();
    }
    _iconTimer?.cancel();
    _iconTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showIcon = false);
    });
  }

  @override
  void dispose() {
    _iconTimer?.cancel();
    super.dispose();
  }

  /// Builds the video display respecting the stored aspect ratio.
  /// - Portrait (≤ 0.75): fills edge-to-edge (TikTok style)
  /// - Landscape / Square: shown at correct size, centered on black bg
  Widget _buildVideoContent() {
    final ar = widget.item.aspectRatio;
    // Portrait or unknown → cover fills the screen
    final isPortrait = ar == null || ar <= 0.8;
    final videoFit = widget.isShrunken
        ? BoxFit.contain
        : BoxFit.contain; // 👑 Ensure full frame visibility, no cropping

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        // Thumbnail backdrop (shown while video loads)
        if (widget.item.thumbnailUrl != null)
          Image.network(
            widget.item.thumbnailUrl!,
            fit: videoFit,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),

        // Actual video player
        if (widget.controller != null)
          isPortrait
              ? Video(
                  controller: widget.controller!,
                  controls: NoVideoControls,
                  fit: BoxFit.cover,
                )
              : Center(
                  child: AspectRatio(
                    aspectRatio: ar!,
                    child: Video(
                      controller: widget.controller!,
                      controls: NoVideoControls,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
      ],
    );
  }

  bool _isSeeking = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Video + Thumbnail Backdrop
          Container(color: Colors.black, child: _buildVideoContent()),

          if (!widget.isShrunken) ...[
            // 2. Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 30.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Right side action column
            Positioned(
              right: 4.w,
              bottom: widget.showBottomBuffer ? 100.h : 22.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => ProfileMiniSheet.show(context, widget.item),
                      child: MemberImage(
                        imageUrl: widget.item.authorAvatarUrl,
                        size: 55.w,
                        useHexagon: false,
                        showStatusRing: false,
                        showActiveDot: false,
                        borderWidth: 2.0,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    LikeAction(
                      initialLikes: widget.item.likesCount,
                      initialIsLiked: widget.item.isLiked,
                      themeColor: Colors.redAccent,
                      inactiveColor: Colors.white,
                      iconSize: 38.sp,
                      isVertical: true,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        shadows: const [
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CommentAction(
                      icon: LucideIcons.messageCircle,
                      label: widget.item.commentsCount.toString(),
                      color: Colors.white,
                      iconSize: 38.sp,
                      fontSize: 14.sp,
                      isVertical: true,
                      onTap: () {
                        if (widget.onCommentTap != null) {
                          widget.onCommentTap!();
                        } else {
                          // Fallback if not provided
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ThreadDiscussionSheet(
                              threadId: widget.item.id,
                              channelId: widget.item.channelId,
                              channelName: widget.item.title,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 12.h),
                    CommentAction(
                      icon: LucideIcons.tag,
                      label: widget.item.tagsCount.toString(),
                      color: colorScheme.primary,
                      iconSize: 38.sp,
                      fontSize: 14.sp,
                      isVertical: true,
                      onTap: () {
                        TagOverlay.show(
                          context,
                          postId: widget.item.id,
                          sourceChannelId: widget.item.channelId ?? 'general',
                          linkChain: widget.item.linkChain,
                          channelName: widget.item.title,
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    CommentAction(
                      icon: LucideIcons.bookmark,
                      label:
                          "58", // Not currently in PostEntity, kept as placeholder
                      color: Colors.white,
                      iconSize: 38.sp,
                      fontSize: 14.sp,
                      isVertical: true,
                    ),
                  ],
                ),
              ),
            ),

            // 4. Bottom info overlay (Author & Description)
            Positioned(
              left: 12.w,
              bottom: 100.h,
              right: 70.w, // Leave room for action icons
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.currentTab != VideoFeedTab.friends)
                    if (widget.item.isChannelPost)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            MemberImage(
                              imageUrl: widget.item.authorAvatarUrl,
                              size: 28.w,
                              showActiveDot: false,
                              showStatusRing: false,
                              onTap: () =>
                                  ProfileMiniSheet.show(context, widget.item),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              widget.item.authorName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                                shadows: const [
                                  Shadow(color: Colors.black54, blurRadius: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          widget.item.authorName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                  if (widget.item.description != null &&
                      widget.item.description!.isNotEmpty)
                    Text(
                      widget.item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                        shadows: const [
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // 5. TikTok Bottom Bar (Progress + Comment Input)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 👑 Dynamic Draggable Seeker (Stealth Mode)
                  StreamBuilder<Duration>(
                    stream: _player?.stream.position,
                    builder: (context, posSnap) {
                      return StreamBuilder<Duration>(
                        stream: _player?.stream.duration,
                        builder: (context, durSnap) {
                          final pos =
                              posSnap.data?.inMilliseconds.toDouble() ?? 0.0;
                          final dur =
                              durSnap.data?.inMilliseconds.toDouble() ?? 1.0;

                          // Ensure value is within bounds
                          final sliderValue = pos.clamp(0.0, dur);

                          return SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: _isSeeking ? 4 : 2,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: _isSeeking ? 6 : 0,
                                elevation: 0,
                                pressedElevation: 0,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 0,
                              ),
                              activeTrackColor: colorScheme.primary,
                              inactiveTrackColor: Colors.white.withOpacity(0.2),
                              thumbColor: colorScheme.primary,
                              trackShape: const RectangularSliderTrackShape(),
                            ),
                            child: SizedBox(
                              height: _isSeeking ? 16.h : 2.h,
                              child: Slider(
                                value: sliderValue,
                                min: 0.0,
                                max: dur,
                                onChangeStart: (_) {
                                  setState(() => _isSeeking = true);
                                },
                                onChangeEnd: (_) {
                                  setState(() => _isSeeking = false);
                                },
                                onChanged: (value) {
                                  _player?.seek(
                                    Duration(milliseconds: value.toInt()),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Edge-to-edge Comment Field
                  CommentInputField(
                    controller: TextEditingController(),
                    onSend: (_) {},
                    onTap: () {
                      if (widget.onCommentTap != null) {
                        widget.onCommentTap!();
                      }
                    },
                    isTikTokStyle: true,
                    userImageUrl: widget.item.authorAvatarUrl,
                  ),
                ],
              ),
            ),

            // 6. Tap play/pause icon
            if (_showIcon)
              Center(
                child: AnimatedOpacity(
                  opacity: _showIcon ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPaused ? LucideIcons.pause : LucideIcons.play,
                      color: Colors.white,
                      size: 34.sp,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
