import 'package:crimchart/features/channel/pages/discovery_widgets/feed_post_shimmer.dart';
import 'package:crimchart/features/channel/pages/messages_tab/widgets/chat_bubble_shimmer.dart';
import 'package:crimchart/features/channel/pages/widgets/pagination_error_footer.dart';
import 'package:crimchart/features/showcase/chart_toast.dart';
import 'package:intl/intl.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/db/chart_native_db.dart';
import 'package:crimchart/core/di/injection.dart';
import 'package:crimchart/features/channel/application/channel_members_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/typing_bubble.dart';
import 'widgets/date_divider.dart';
import 'models/user_model.dart';
import 'models/media_model.dart';
import '../widgets/channel_gatekeeper.dart';

import 'dart:async';
import '../../data/sources/channel_remote_source.dart';
import '../../application/channel_messages_provider.dart';
import '../../domain/entities/channel_message_entity.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../../profile/models/charter_model.dart';

/// Watches presence data for a channel from the local presence table.
/// Returns a map of userId -> isTyping
final channelPresenceProvider = StreamProvider.autoDispose
    .family<Map<String, bool>, String>((ref, channelId) {
      return getIt<ChartNativeDB>().watchOnlineUsers(channelId).map((rows) {
        final Map<String, bool> typingMap = {};
        for (final row in rows) {
          final userId = row['userId'] as String;
          final isTyping = (row['isTyping'] == 1 || row['isTyping'] == true);
          typingMap[userId] = isTyping;
        }
        return typingMap;
      });
    });

class MessagesTabView extends ConsumerStatefulWidget {
  final String channelId;
  final List<CharterModel> members;
  final bool initialIsMember;

  const MessagesTabView({
    super.key,
    required this.channelId,
    this.members = const [],
    this.initialIsMember = false,
  });

  @override
  ConsumerState<MessagesTabView> createState() => _MessagesTabViewState();
}

class _MessagesTabViewState extends ConsumerState<MessagesTabView> {
  ChannelMessageEntity? _replyingTo;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _presenceSubscription;

  @override
  void initState() {
    super.initState();
    // Mark self as online when entering the chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(authControllerProvider).user;
      if (currentUser != null) {
        // 1. Update Local
        getIt<ChartNativeDB>().markUserOnline(
          channelId: widget.channelId,
          userId: currentUser.id,
          displayName: currentUser.username,
          avatarUrl: currentUser.profileImageUrl,
        );

        // 2. Update Remote
        getIt<ChannelRemoteSource>().setPresence(
          channelId: widget.channelId,
          userId: currentUser.id,
          isOnline: true,
          isTyping: false,
          displayName: currentUser.username,
          avatarUrl: currentUser.profileImageUrl,
        );
      }

      // 3. Sync Remote Presence to Local DB
      _presenceSubscription = getIt<ChannelRemoteSource>()
          .streamPresence(widget.channelId)
          .listen((presenceList) {
            for (final presence in presenceList) {
              // Don't sync yourself back (to avoid loops or stale state)
              if (presence['user_id'] == currentUser?.id) continue;
              getIt<ChartNativeDB>().upsertPresence(presence);
            }
          });
    });
  }

  @override
  void dispose() {
    // Mark self as offline when leaving the chat
    final currentUser = ref.read(authControllerProvider).user;
    if (currentUser != null) {
      // 1. Update Local
      getIt<ChartNativeDB>().markUserOffline(
        channelId: widget.channelId,
        userId: currentUser.id,
      );

      // 2. Update Remote
      getIt<ChannelRemoteSource>().setPresence(
        channelId: widget.channelId,
        userId: currentUser.id,
        isOnline: false,
        isTyping: false,
      );
    }
    _presenceSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String text) {
    ref
        .read(channelMessagesProvider(widget.channelId).notifier)
        .sendMessage(text: text, replyToId: _replyingTo?.id);

    setState(() {
      _replyingTo = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _handleSendMultiMedia(List<Map<String, String>> items) {
    if (items.isEmpty) return;

    final firstItemType = items.first['type'];
    final caption = items.first['caption'];

    ChannelMessageType msgType;
    if (firstItemType == 'video') {
      msgType = ChannelMessageType.video;
    } else if (firstItemType == 'audio') {
      msgType = ChannelMessageType.voice;
    } else {
      msgType = ChannelMessageType.image;
    }

    ref
        .read(channelMessagesProvider(widget.channelId).notifier)
        .sendMessage(
          text: caption,
          mediaItems: items,
          type: msgType,
          replyToId: _replyingTo?.id,
        );

    setState(() {
      _replyingTo = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _handleSendMedia(String url, String type) {
    _handleSendMultiMedia([
      {'url': url, 'type': type},
    ]);
  }

  void _onReply(ChannelMessageEntity message) {
    setState(() {
      _replyingTo = message;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(authControllerProvider).user;
    final messagesAsync = ref.watch(channelMessagesProvider(widget.channelId));
    
    debugPrint('🖼️ [ChatUI] Building MessagesTabView. Status: ${messagesAsync.isLoading ? "Loading" : "Ready"}');

    if (messagesAsync.hasValue) {
      debugPrint('🖼️ [ChatUI] Data received by UI: ${messagesAsync.value?.length} messages');
    }

    final membersAsync = ref.watch(channelMembersProvider(widget.channelId));
    final rawMembers = widget.members.isNotEmpty
        ? widget.members
        : membersAsync.maybeWhen(
            data: (m) => m,
            orElse: () => <CharterModel>[],
          );

    final List<ChatUser> activeUsers = rawMembers
        .map(
          (m) => ChatUser(
            id: m.id,
            name: m.displayName,
            profileImageUrl: m.profileImageUrl,
            isVerified: m.title == 'Top' || m.title == 'Star',
            followersCount: m.chartCount,
            channelsCount: m.channelCount,
          ),
        )
        .toList();

    final presenceMap = ref
        .watch(channelPresenceProvider(widget.channelId))
        .maybeWhen(data: (map) => map, orElse: () => <String, bool>{});

    final onlineUserIds = presenceMap.keys.toSet();
    final typingUserIds = presenceMap.entries
        .where((e) => e.value && e.key != currentUser?.id)
        .map((e) => e.key)
        .toList();
    final typingNames = activeUsers
        .where((u) => typingUserIds.contains(u.id))
        .map((u) => u.name)
        .toList();
    final typingUsers = activeUsers
        .where((u) => typingUserIds.contains(u.id))
        .toList();

    // 👑 SMART SCROLL: Only auto-scroll if we're already near the bottom
    ref.listen(channelPresenceProvider(widget.channelId), (prev, next) {
      final isSomeoneTyping =
          next.value?.values.any((isTyping) => isTyping) ?? false;

      if (isSomeoneTyping && _scrollController.hasClients) {
        final pos = _scrollController.position;
        final isNearBottom = pos.pixels > pos.maxScrollExtent - 200.h;

        if (isNearBottom) {
          _scrollToBottom();
        }
      }
    });

    return SliverFillRemaining(
      hasScrollBody: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  messagesAsync.when(
                    data: (messages) {
                      if (messages.isEmpty) {
                        return Center(
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48.sp,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        );
                      }
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          // 👑 STRICT AXIS ISOLATION: Only listen to the main vertical scroll, ignore horizontal image carousels
                          if (notification is ScrollUpdateNotification &&
                              notification.metrics.axis == Axis.vertical &&
                              notification.depth == 0) {
                            // STABLE PAGINATION: Only trigger if we're actually scrolling up and hit the top
                            if (notification.metrics.pixels < 100.h &&
                                notification.scrollDelta != null &&
                                notification.scrollDelta! < 0) {
                              ref
                                  .read(
                                    channelMessagesProvider(
                                      widget.channelId,
                                    ).notifier,
                                  )
                                  .loadMore();
                            }
                          }
                          return false;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.fromLTRB(
                            0,
                            16,
                            0,
                            140.h +
                                MediaQuery.of(context).viewInsets.bottom +
                                MediaQuery.of(context).padding.bottom,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              messages.length +
                              typingUsers.length +
                              1, // +1 for pagination header
                          itemBuilder: (context, index) {
                            final isLoading = ref.watch(
                              channelMessagesLoadingProvider(widget.channelId),
                            );
                            final error = ref.watch(
                              channelMessagesErrorProvider(widget.channelId),
                            );
                            final hasMore = ref.watch(
                              channelMessagesHasMoreProvider(widget.channelId),
                            );
                            final notifier = ref.read(
                              channelMessagesProvider(
                                widget.channelId,
                              ).notifier,
                            );

                            // 👑 PAGINATION HEADER
                            if (index == 0) {
                              if (!hasMore) return const SizedBox.shrink();
                              if (error != null) {
                                return PaginationErrorFooter(
                                  error: error,
                                  onRetry: () => notifier.loadMore(),
                                );
                              }
                              if (isLoading) {
                                return const ChatBubbleShimmer();
                              }
                              return const SizedBox.shrink();
                            }

                            final messageIndex = index - 1;

                            if (messageIndex >= messages.length) {
                              final typingUser =
                                  typingUsers[messageIndex - messages.length];
                              return TypingBubble(sender: typingUser);
                            }
                            final msg = messages[messageIndex];
                            final isMe = msg.senderId == currentUser?.id;

                            // Lookup the actual user from the channel members list
                            final member = activeUsers
                                .where((u) => u.id == msg.senderId)
                                .firstOrNull;

                            // Convert to ChatUser format for the bubble
                            final sender = ChatUser(
                              id: msg.senderId,
                              name: member?.name ?? msg.senderUsername,
                              profileImageUrl:
                                  member?.profileImageUrl ??
                                  msg.senderAvatarUrl ??
                                  'https://i.pravatar.cc/150?u=${msg.senderId}',
                              isVerified: member?.isVerified ?? false,
                            );

                            final List<MessageMediaItem> mediaItems = [];

                            // 1. Add primary mediaUrl
                            if (msg.mediaUrl != null &&
                                msg.mediaUrl!.isNotEmpty) {
                              mediaItems.add(
                                MessageMediaItem(
                                  url: msg.mediaUrl!,
                                  type:
                                      msg.messageType ==
                                          ChannelMessageType.video
                                      ? MessageMediaType.video
                                      : msg.messageType ==
                                            ChannelMessageType.voice
                                      ? MessageMediaType.audio
                                      : MessageMediaType.image,
                                ),
                              );
                            }

                            if (mediaItems.isNotEmpty) {
                              // Media found
                            }

                            // 2. Add extra media items from metadata
                            if (msg.metadata != null &&
                                msg.metadata!['media_items'] != null) {
                              try {
                                final List<dynamic> extraItems =
                                    msg.metadata!['media_items'];
                                for (final item in extraItems) {
                                  final url = item['url'] as String;
                                  if (url == msg.mediaUrl) continue;

                                  final type = item['type'] as String;
                                  mediaItems.add(
                                    MessageMediaItem(
                                      url: url,
                                      type: type == 'video'
                                          ? MessageMediaType.video
                                          : MessageMediaType.image,
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint('Error parsing extra media: $e');
                              }
                            }

                            Map<String, dynamic>? pollData;
                            if (msg.messageType == ChannelMessageType.poll &&
                                msg.metadata != null) {
                              pollData = msg.metadata;
                            }

                            Map<String, dynamic>? replyData;
                            if (msg.replyToId != null) {
                              // Ideally, we'd look up the actual reply message from the list
                              final replyMsg = messages
                                  .where((m) => m.id == msg.replyToId)
                                  .firstOrNull;
                              if (replyMsg != null) {
                                replyData = {
                                  'text': replyMsg.textContent ?? 'Media',
                                  'senderName': replyMsg.senderUsername,
                                };
                              }
                            }

                            final bool showDateDivider =
                                messageIndex == 0 ||
                                !_isSameDay(
                                  messages[messageIndex].createdAt,
                                  messages[messageIndex - 1].createdAt,
                                );

                            return Column(
                              children: [
                                if (showDateDivider)
                                  DateDivider(date: msg.createdAt),
                                GestureDetector(
                                  onDoubleTap: () => _onReply(msg),
                                  child: ChatBubble(
                                    message: msg.textContent ?? '',
                                    messageId: msg.id,
                                    channelId: widget.channelId,
                                    isMe: isMe,
                                    time: DateFormat.jm().format(
                                      msg.createdAt.toLocal(),
                                    ),
                                    sender: sender,
                                    replyTo: replyData,
                                    mediaItems: mediaItems,
                                    poll: pollData,
                                    onDelete: () => _deleteMessage(
                                      msg,
                                    ), // 👑 Wired directly to popup menu
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const ChatBubbleShimmer(),
                    error: (e, st) => PaginationErrorFooter(
                      error: e.toString(),
                      onRetry: () => ref.invalidate(
                        channelMessagesProvider(widget.channelId),
                      ),
                    ),
                  ),

                  // Fixed Input at bottom — wrapped in SafeArea to avoid
                  // phone home indicator / gesture nav bar dead zones
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_replyingTo != null)
                                _buildReplyPreview(theme, colorScheme),
                              ChatInputField(
                                channelId: widget.channelId,
                                onSubmitted: _handleSendMessage,
                                onMultiMediaSubmitted: _handleSendMultiMedia,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyPreview(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // 👑 SOLID BACKGROUND
        border: Border(
          top: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _replyingTo?.senderUsername ?? 'Member',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  _replyingTo?.textContent ?? 'Media message',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _cancelReply,
            icon: Icon(Icons.close, size: 20.sp),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  // 👑 Direct Delete Action (Triggered by PopupMenuButton)
  void _deleteMessage(ChannelMessageEntity msg) {
    // Trigger full end-to-end deletion (Memory -> Local DB -> Remote DB)
    ref
        .read(channelMessagesProvider(widget.channelId).notifier)
        .deleteMessage(msg.id);

    ChartToast.showSuccess(
      context,
      title: 'Deleted',
      message: 'Message has been removed.',
    );
  }
}
