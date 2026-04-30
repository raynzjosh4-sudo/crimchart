import 'package:crown/mainFeed/features/cardwidgets/models/channel_post_model.dart';
import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/commentingsheets/widgets/commenting_sheet.dart';
import '../memberimage/starter_image.dart';
import 'comment_card/media/comment_media.dart';
import 'comment_card/media/comment_media_type.dart';
import 'comment_card/text/comment_text.dart';
import 'comment_card/thumbnaillink/thumbnaillinkmedia/thumbnail_media_type.dart';
import 'comment_card/comment_action/comments/comment.dart';
import 'comment_card/comment_action/like/like.dart';
import 'comment_card/thumbnaillink/thumbnail_link.dart';
import '../../inforsheet/info_sheet.dart';
import '../../channel/channelsettings/channelinsidesettingspage/allow_charting_page.dart';
import '../../channel/pages/crownpoll/dynamic_crown_widget.dart';
import '../../channel/pages/widgets/channelinfosheet/widgets/dummy_data.dart';
import '../../channel/pages/widgets/channelinfosheet/widgets/audioplayer/audio_player_page.dart';

// 👑 Removed CommentCategory enum entirely!

class CommentCard extends StatelessWidget {
  final String memberName;
  final String messageText;
  final List<String> attachmentUrls;
  final int likes;
  final int comments;
  final String shares;
  final Color outlineColor;
  final ThumbnailMediaType mediaType;
  final CommentMediaType commentMediaType;
  final String? avatarUrl;
  final bool isMe;
  final String? referenceId;
  final String? thumbnailLinkUrl;
  final VoidCallback? onTapThumbnail;
  final void Function(int)? onTapMedia;
  final VoidCallback? onTapText;
  final QuotedPost? quotedPost; // ✅ THE NAVIGATION PASSPORT
  final String? channelId;
  final String? channelName;
  final String? thumbnailUrl;
  final VoidCallback? onDelete;
  final String? authorId; // ✅ For Profile navigation
  final bool isOnline; // 👑 Dynamic Indicators
  final bool hasStatus; // 👑 Dynamic Indicators
  final VoidCallback? onTapAvatar; // 👑 New: Smart Navigation

  const CommentCard({
    super.key,
    required this.memberName,
    required this.messageText,
    this.attachmentUrls = const [],
    this.likes = 1000,
    this.comments = 500,
    this.shares = 'share',
    required this.outlineColor,
    this.mediaType = ThumbnailMediaType.image,
    this.commentMediaType = CommentMediaType.image,
    this.avatarUrl,
    this.isMe = false,
    this.referenceId,
    this.thumbnailLinkUrl,
    this.onTapThumbnail,
    this.onTapMedia,
    this.onTapText,
    this.quotedPost,
    this.channelId,
    this.channelName,
    this.thumbnailUrl,
    this.onDelete,
    this.authorId,
    this.isOnline = false, // 👑 Live Presence (Removed Mock)
    this.hasStatus = false, // 👑 Live Presence (Removed Mock)
    this.onTapAvatar,
    this.audioUrl,
  }); // 👑 Removed category property

  final String? audioUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 👑 Premium Asymmetric Bubble BorderRadius
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isMe ? 22.w : 4.w),
      topRight: Radius.circular(isMe ? 4.w : 22.w),
      bottomLeft: Radius.circular(22.w),
      bottomRight: Radius.circular(22.w),
    );

    // 👑 Unified Glassmorphic Theme Color (Dynamic Contrast)
    final bubbleColor = theme.brightness == Brightness.dark
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.15)
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Container(
      width: double.infinity,
      color: theme.scaffoldBackgroundColor,
      child: Dismissible(
        key: ValueKey('${memberName}_${messageText.hashCode}'),
        direction: commentMediaType == CommentMediaType.poll
            ? DismissDirection.horizontal
            : DismissDirection.none,
        background: _buildDismissBackground(context, true),
        secondaryBackground: _buildDismissBackground(context, false),
        confirmDismiss: (direction) => _handleDismiss(context, direction),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👑 Left Avatar (Other People)
              if (!isMe) ...[
                MemberImage(
                  size: 32.w,
                  borderWidth: 1.w,
                  imageUrl:
                      avatarUrl ??
                      'https://picsum.photos/seed/user${memberName.hashCode}/100',
                  showActiveDot: isOnline,
                  showStatusRing: hasStatus,
                  onTap: onTapAvatar,
                ),
                SizedBox(width: 8.w),
              ],

              // ── THE MESSAGE BUBBLE ──
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 100.h,
                    maxWidth: MediaQuery.of(context).size.width * 0.85,
                  ),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: borderRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 👑 Author & Options
                      Row(
                        children: [
                          Text(
                            memberName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: isMe
                                  ? outlineColor
                                  : colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _showOptions(context),
                            child: Icon(
                              Icons.more_horiz,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      // 👑 Quoted Reference (Shared DNA)
                      if (quotedPost != null) ...[
                        ThumbnailLink(
                          username: quotedPost!.username,
                          text: quotedPost!.text,
                          mediaUrl: quotedPost!.mediaUrl,
                          mediaType: mediaType,
                          referenceId: quotedPost!.id,
                          channelId: quotedPost!.channelId,
                          themeColor: outlineColor,
                          onTap: onTapThumbnail,
                        ),
                        // 👑 Tight Gap Logic: Only space if something follows
                        if (messageText.isNotEmpty ||
                            attachmentUrls.isNotEmpty ||
                            commentMediaType == CommentMediaType.audio ||
                            commentMediaType == CommentMediaType.poll)
                          SizedBox(height: 10.h),
                      ],

                      // 👑 Message Body
                      if (messageText.isNotEmpty) ...[
                        CommentText(text: messageText, onTap: onTapText),
                        // 👑 Gap before media
                        if (attachmentUrls.isNotEmpty ||
                            commentMediaType == CommentMediaType.audio ||
                            commentMediaType == CommentMediaType.poll)
                          SizedBox(height: 10.h),
                      ],

                      // 👑 Media Content
                      if (commentMediaType == CommentMediaType.poll) ...[
                        DynamicCrownWidget(
                          pollModel: SheetDummyData.crownPoll,
                          themeColor: outlineColor,
                          fullBleed: false,
                        ),
                      ] else if (attachmentUrls.isNotEmpty ||
                          commentMediaType == CommentMediaType.audio) ...[
                        CommentMedia(
                          mediaUrls: attachmentUrls,
                          mediaType: commentMediaType,
                          themeColor: outlineColor,
                          audioUrl: audioUrl,
                          username: memberName,
                          referenceId: referenceId,
                          onTap: onTapMedia,
                          onTapThumbnail: onTapThumbnail,
                          thumbnailUrl: thumbnailUrl,
                          onOpenAudioPlayer: () {
                            // 👑 Navigation to Full Player
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AudioPlayerPage(
                                  audioUrl: attachmentUrls.isNotEmpty 
                                      ? attachmentUrls.first 
                                      : 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                                  title: messageText.isNotEmpty 
                                      ? (messageText.length > 20 
                                          ? '${messageText.substring(0, 20)}...' 
                                          : messageText) 
                                      : 'Audio Message',
                                  artist: memberName,
                                  likes: likes,
                                  userImageUrl: avatarUrl,
                                  coverUrl: thumbnailUrl,
                                ),
                              ),
                            );
                          },
                        ),
                      ],

                      // 👑 Interactions Row (Integrated into Bubble)
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LikeAction(
                            initialLikes: likes,
                            themeColor: outlineColor,
                          ),
                          SizedBox(width: 14.w),
                          CommentActionWidget(
                            initialComments: comments,
                            themeColor: outlineColor,
                            linkedPostId: referenceId,
                            linkedAuthorUsername: memberName,
                            linkedCaption: messageText,
                            linkedChannelId: quotedPost?.channelId,
                            linkedThumbnailUrl: attachmentUrls.isNotEmpty
                                ? attachmentUrls.first
                                : null,
                            channelId: channelId,
                            channelName: channelName,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 👑 Right Avatar (Me)
              if (isMe) ...[
                SizedBox(width: 8.w),
                MemberImage(
                  size: 32.w,
                  borderWidth: 1.w,
                  imageUrl:
                      avatarUrl ??
                      'https://picsum.photos/seed/user${memberName.hashCode}/100',
                  showActiveDot: isOnline,
                  showStatusRing: hasStatus,
                  onTap: onTapAvatar,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 👑 Helper: Dismiss Backgrounds
  Widget _buildDismissBackground(BuildContext context, bool isLeft) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      color: Colors.transparent,
      child: Icon(
        isLeft ? Icons.star_outline : Icons.chat_bubble_outline,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        size: 28.sp,
      ),
    );
  }

  // 👑 Helper: Handle Dismiss logic
  Future<bool?> _handleDismiss(
    BuildContext context,
    DismissDirection direction,
  ) async {
    if (direction == DismissDirection.endToStart) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => CommentingSheet(
          channelId: channelId,
          channelName: channelName,
          linkedPostId: referenceId,
          linkedAuthorUsername: memberName,
          linkedCaption: messageText,
          linkedChannelId: quotedPost?.channelId,
          linkedThumbnailUrl: attachmentUrls.isNotEmpty
              ? attachmentUrls.first
              : null,
        ),
      );
    } else if (direction == DismissDirection.startToEnd) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllowChartingPage()),
      );
    }
    return false;
  }

  // 👑 Helper: Show Info Sheet Options
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
