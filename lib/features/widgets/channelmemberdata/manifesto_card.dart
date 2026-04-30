import 'package:crown/features/widgets/channelmemberdata/comment_card/comment_action/comments/comment.dart';
import 'package:crown/features/widgets/channelmemberdata/comment_card/comment_action/like/like.dart';
import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/mainFeed/features/cardwidgets/models/channel_post_model.dart';
import '../manifestowidgets/manifesto_media_router.dart';
import 'comment_card/media/comment_media_type.dart';
import '../../inforsheet/info_sheet.dart';
import 'widgets/chat_bubble_painter.dart';
import '../pending_media_overlay.dart';

class ManifestoCard extends StatelessWidget {
  final String memberName;
  final String? avatarUrl;
  final String messageText;
  final List<String> attachmentUrls;
  final List<String> videoUrls;    // 👑 Plural videos (2x / 4x grid)
  final List<String> thumbnailUrls; // 👑 Multi-media thumbnails
  final int likes;
  final int comments;
  final Color outlineColor;
  final CommentMediaType commentMediaType;
  final String? referenceId;
  final QuotedPost? quotedPost;
  final void Function(int)? onTapMedia;
  final VoidCallback? onTapThumbnail;
  final String? channelId;
  final String? channelName;
  final String? thumbnailUrl;
  final bool isMe;
  final VoidCallback? onDelete;
  final bool showStatusRing;
  final bool showActiveDot;
  final VoidCallback? onTapAvatar;
  final String? audioUrl;
  final List<String> commenterAvatars;
  final VoidCallback? onTapCommenters;
  final bool allowComments;
  final bool isPending;
  final double? uploadProgress;
  final String? uploadedSize;
  final String? totalSize;
  final bool isOffline;
  final ValueChanged<bool>? onLikeChanged;

  const ManifestoCard({
    super.key,
    required this.memberName,
    this.avatarUrl,
    required this.messageText,
    this.attachmentUrls = const [],
    this.videoUrls = const [],
    this.thumbnailUrls = const [],
    this.likes = 0,
    this.comments = 0,
    required this.outlineColor,
    this.commentMediaType = CommentMediaType.image,
    this.referenceId,
    this.quotedPost,
    this.onTapMedia,
    this.onTapThumbnail,
    this.channelId,
    this.channelName,
    this.thumbnailUrl,
    this.isMe = false,
    this.onDelete,
    this.showStatusRing = false,
    this.showActiveDot = false,
    this.onTapAvatar,
    this.audioUrl,
    this.commenterAvatars = const [],
    this.onTapCommenters,
    this.allowComments = true,
    this.isPending = false,
    this.uploadProgress,
    this.uploadedSize,
    this.totalSize,
    this.isOffline = false,
    this.onLikeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 👑 AUTO-HIDE: Treat 100% progress as effectively done
    final isDone = uploadProgress != null && uploadProgress! >= 1.0;
    final isActuallyPending = isPending && !isDone;

    // 👑 Premium WhatsApp-style Bubble Color (Dynamic Contrast)
    final bubbleColor = theme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.15)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── AUTHOR IDENTITY (Hidden for Admins/isMe) ──
          if (!isMe && (avatarUrl != null || memberName.isNotEmpty))
            Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 6.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onTapAvatar,
                    child: CircleAvatar(
                      radius: 12.r,
                      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                      child: avatarUrl == null 
                          ? Icon(LucideIcons.user, size: 14.sp, color: theme.colorScheme.primary)
                          : null,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          memberName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ── THE BUBBLE ──
          CustomPaint(
            painter: ChatBubblePainter(color: bubbleColor, isLeft: true),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: 150.h),
              padding: EdgeInsets.fromLTRB(18.w, 18.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👑 THE CONTENT STACK (with Pending Overlay)
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 👑 Caption Text
                          if (messageText.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Text(
                                messageText,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),

                          // 👑 Media Content
                          if (attachmentUrls.isNotEmpty || videoUrls.isNotEmpty || audioUrl != null)
                             ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: ManifestoMediaRouter(
                                  mediaUrls: attachmentUrls,
                                  videoUrls: videoUrls,
                                  thumbnailUrls: thumbnailUrls,
                                  mediaType: commentMediaType,
                                  themeColor: outlineColor,
                                  audioUrl: audioUrl,
                                  username: memberName,
                                  onTap: onTapMedia,
                                  thumbnailUrl: thumbnailUrl,
                                ),
                              ),
                        ],
                      ),
                      
                      // 👑 FULL-BUBBLE OVERLAY IF PENDING (WhatsApp Style)
                      if (isActuallyPending)
                        Positioned.fill(
                          child: PendingMediaOverlay(
                            progress: uploadProgress,
                            uploadedSize: uploadedSize ?? '',
                            totalSize: totalSize ?? '',
                            isOffline: isOffline,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── INTERACTION AREA (Floating Alignment) ──
          Transform.translate(
            offset: Offset(0, -14.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 👑 PENDING STATUS BAR (Unified)
                  ...[
                    // 👑 LEFT: Like & Management
                    Flexible(
                      child: _buildInteractionPill(
                        theme,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LikeAction(
                              initialLikes: likes, 
                              themeColor: outlineColor,
                              onLikeChanged: onLikeChanged,
                            ),
                            SizedBox(width: 14.w),
                            GestureDetector(
                              onTap: () => _showOptions(context),
                              child: Icon(
                                LucideIcons.moreHorizontal,
                                size: 20.sp,
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // 👑 RIGHT: Comment Count & Avatars (Conditional)
                    if (allowComments)
                      Flexible(
                        child: _buildInteractionPill(
                          theme,
                          GestureDetector(
                            onTap: onTapCommenters,
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (commenterAvatars.isNotEmpty) ...[
                                  _buildCommenterStack(theme),
                                  SizedBox(width: 8.w),
                                ],
                                Flexible(
                                  child: CommentActionWidget(
                                    initialComments: comments,
                                    themeColor: outlineColor,
                                    iconSize: 18.sp,
                                    showIcon: true,
                                    showLabel: true,
                                    onTap: onTapCommenters,
                                    linkedPostId: referenceId,
                                    linkedAuthorUsername: memberName,
                                    linkedCaption: messageText,
                                    linkedThumbnailUrl: attachmentUrls.isNotEmpty
                                        ? attachmentUrls.first
                                        : null,
                                    channelId: channelId,
                                    channelName: channelName,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommenterStack(ThemeData theme) {
    const double size = 20.0;
    const double overlap = 12.0;
    final displayAvatars = commenterAvatars.take(3).toList();

    final double width = (displayAvatars.length * overlap) + size;

    return SizedBox(
      height: size,
      width: width,
      child: Stack(
        children: [
          ...displayAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final url = entry.value;
            return Positioned(
              left: index * overlap,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      child: Icon(
                        LucideIcons.user,
                        size: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // 👑 The "+" Icon (indicates more or just interactive)
          Positioned(
            left: displayAvatars.length * overlap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionPill(ThemeData theme, Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InfoSheet(
        title: memberName,
        themeColor: outlineColor,
        isAuthor: isMe,
        onDelete: onDelete,
      ),
    );
  }
}
