import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/theme/design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../bottom_sheets/user_profile_bottom_sheet.dart';
import '../models/media_model.dart';
import 'message_media_grid.dart';
import 'voice_message_player.dart';
import 'package:crown/profile/chart/widgets/poll_carousel.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String? messageId;
  final String? channelId;
  final bool isMe;
  final String? time;
  final ChatUser? sender;
  final Map<String, dynamic>? replyTo;
  final List<MessageMediaItem> mediaItems;
  final Map<String, dynamic>? poll;

  const ChatBubble({
    super.key,
    required this.message,
    this.messageId,
    this.channelId,
    required this.isMe,
    this.time,
    this.sender,
    this.replyTo,
    this.mediaItems = const [],
    this.poll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: () => sender != null
                        ? UserProfileBottomSheet.show(context, sender!)
                        : null,
                    child: Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: sender != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  sender!.profileImageUrl,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: colorScheme.surfaceContainerHighest,
                        border: Border.all(
                          color: colorScheme.onSurface.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: sender == null
                          ? Icon(Icons.person, size: 20.sp)
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Content Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // Header: Username + Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection:
                              isMe ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Text(
                              sender?.name ?? 'Anonymous',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (time != null)
                              Text(
                                time!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        // Message content
                        GestureDetector(
                          onLongPress: () {
                            if (message.isNotEmpty) {
                              Clipboard.setData(ClipboardData(text: message));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied')),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (replyTo != null) ...[
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.03,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border(
                                      left: isMe
                                          ? BorderSide.none
                                          : BorderSide(
                                            color: theme.primaryColor
                                                .withValues(alpha: 0.5),
                                            width: 3.w,
                                          ),
                                      right: isMe
                                          ? BorderSide(
                                            color: theme.primaryColor
                                                .withValues(alpha: 0.5),
                                            width: 3.w,
                                          )
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        replyTo?['senderName'] ?? 'Member',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w900,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        replyTo?['text'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign:
                                            isMe
                                                ? TextAlign.right
                                                : TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (message.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.h),
                                  child: Text(
                                    message,
                                    textAlign:
                                        isMe ? TextAlign.right : TextAlign.left,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 15.sp,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              if (mediaItems.any(
                                (m) => m.type == MessageMediaType.audio,
                              )) ...[
                                VoiceMessagePlayer(
                                  url: mediaItems
                                      .firstWhere(
                                        (m) => m.type == MessageMediaType.audio,
                                      )
                                      .url,
                                  duration: mediaItems
                                      .firstWhere(
                                        (m) => m.type == MessageMediaType.audio,
                                      )
                                      .duration,
                                  isMe: isMe,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Media Items (Thread way) - MOVED OUT of Row to fill left gap
              if (mediaItems.isNotEmpty &&
                  !mediaItems.any((m) => m.type == MessageMediaType.audio)) ...[
                SizedBox(height: 12.h),
                MessageMediaGrid(
                  items: mediaItems,
                  channelId: channelId,
                ),
              ],
              // Polls - MOVED OUT of Row to fill left gap
              if (poll != null) ...[
                SizedBox(height: 12.h),
                PollCarousel(
                  isFullWidth: true,
                  title: poll!['title'] ?? 'Active Poll',
                  onPointAdd: (item) => debugPrint('Points added'),
                  items:
                      (poll!['items'] as List<Map<String, dynamic>>).map((
                        item,
                      ) {
                        return PollItem(
                          id: item['id'],
                          title: item['title'],
                          mediaUrl: item['mediaUrl'],
                          type:
                              item['type'] == 'image'
                                  ? PollMediaType.image
                                  : (item['type'] == 'video'
                                      ? PollMediaType.video
                                      : PollMediaType.text),
                          points: item['points'] ?? 0,
                          suggestedBy: item['suggestedBy'],
                        );
                      }).toList(),
                ),
              ],
            ],
          ),
        ),
        // Divider like Threads
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ],
    );
  }
}
