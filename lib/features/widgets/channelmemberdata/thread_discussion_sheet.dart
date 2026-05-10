import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/channel/application/manifesto_comments_provider.dart';
import 'package:crimchart/features/channel/application/channel_feed_provider.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:crimchart/posting/pages/post_page.dart';
import 'package:crimchart/posting/models/media_item.dart';
import 'package:crimchart/commentingsheets/widgets/comment_input_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'manifesto_chat_bubble_shimmer.dart';
import 'tiktok_comment_tile.dart';
import 'package:crimchart/profile/pages/profile_page.dart';

class ThreadDiscussionSheet extends ConsumerStatefulWidget {
  final String threadId;
  final String? channelId;
  final String? channelName;
  final VoidCallback? onClose;

  const ThreadDiscussionSheet({
    super.key,
    required this.threadId,
    this.channelId,
    this.channelName,
    this.onClose,
  });

  @override
  ConsumerState<ThreadDiscussionSheet> createState() =>
      _ThreadDiscussionSheetState();
}

class _ThreadDiscussionSheetState extends ConsumerState<ThreadDiscussionSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _connectivitySubscription;
  bool _isOffline = false;
  List<MediaItem> _selectedMedia = [];

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (results.isEmpty) return;
      final status = results.first;
      setState(() => _isOffline = status == ConnectivityResult.none);
    });

    // Load comments on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(manifestoCommentsProvider(widget.threadId));
      if (!state.isLoading && (state.value?.isEmpty ?? true)) {
        ref
            .read(manifestoCommentsProvider(widget.threadId).notifier)
            .fetchComments();
      }
    });

    // Pagination on scroll-to-top
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 80) {
        ref
            .read(manifestoCommentsProvider(widget.threadId).notifier)
            .loadMore();
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    if (results.isNotEmpty) {
      setState(() => _isOffline = results.first == ConnectivityResult.none);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleSend(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final authState = ref.read(authControllerProvider);
    final user = authState.user;
    final notifier = ref.read(
      manifestoCommentsProvider(widget.threadId).notifier,
    );

    _commentController.clear();

    // ── 1. OPTIMISTIC INJECTION (Instant Feedback) ──
    final optimisticPost = PostEntity.original(
      id: const Uuid().v4(),
      authorId: user?.id ?? 'unknown',
      authorUsername: user?.username ?? 'Me',
      authorDisplayName: user?.displayName ?? 'Me',
      authorAvatarUrl: user?.profileImageUrl,
      createdAt: DateTime.now(),
      channelId: widget.channelId ?? 'unknown',
      channelName: widget.channelName ?? 'Channel',
      caption: trimmedText,
      isPending: 1,
    );

    notifier.addComment(
      optimisticPost.copyWith(
        imageUrls: _selectedMedia.map((m) => m.path).toList(),
      ),
    );

    // ── 2. OPTIMISTIC COUNT INCREMENT ──
    // Immediately update the ManifestoCard count on the feed without waiting for the server.
    if (widget.channelId != null) {
      ref
          .read(channelFeedProvider(widget.channelId!).notifier)
          .incrementCommentCount(widget.threadId);
    }

    // ── 3. PERSIST IN BACKGROUND ──
    try {
      await Supabase.instance.client.from('channel_post_comments').insert({
        'post_id': widget.threadId,
        'author_id': user?.id,
        'message': trimmedText,
        'channel_id': widget.channelId,
        'image_urls': _selectedMedia.map((m) => m.path).toList(),
      });

      // ── 4. RECORD IN COMMENT COUNTS TABLE (triggers Realtime for other users) ──
      Supabase.instance.client
          .rpc(
            'increment_post_comment_count',
            params: {'target_post_id': widget.threadId},
          )
          .then((_) => debugPrint('✅ [Comment Count] RPC success'))
          .catchError((e) => debugPrint('🚨 [Comment Count] RPC failed: $e'));

      setState(() => _selectedMedia = []);
    } catch (e) {
      debugPrint('🚨 Failed to persist comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final commentsAsync = ref.watch(manifestoCommentsProvider(widget.threadId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // ── DRAG HANDLE ──
          Container(
            margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // ── OFFLINE INDICATOR ──
          if (_isOffline)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 14.sp, color: Colors.redAccent),
                  SizedBox(width: 8.w),
                  Text(
                    'Offline Mode',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // ── HEADER ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    commentsAsync.when(
                      data: (c) => '${c.length} comments',
                      loading: () => 'Comments',
                      error: (_, __) => 'Discussion',
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      if (widget.onClose != null) {
                        widget.onClose!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.close, color: Colors.white70, size: 22.sp),
                  ),
                ),
              ],
            ),
          ),

          // ── COMMENTS LIST ──
          Expanded(
            child: commentsAsync.when(
              loading: () => Column(
                children: List.generate(
                  6,
                  (_) => const ManifestoChatBubbleShimmer(),
                ),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Failed to load comments',
                  style: TextStyle(color: Colors.white38, fontSize: 14.sp),
                ),
              ),
              data: (comments) {
                if (comments.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(0, 12.h, 0, 80.h),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    return TikTokCommentTile(
                      username: c.authorUsername,
                      avatarUrl: c.authorAvatarUrl,
                      message: c.caption ?? '',
                      likes: c.likes,
                      isLiked: c.isLiked ?? false,
                      // 👑 Long-press → delete sheet (only for own messages)
                      onAvatarTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfilePage(userId: c.authorId),
                        ),
                      ),
                      onLike: () {
                        // Implement like logic here if needed
                      },
                      onReply: () {
                        // Implement reply logic here if needed
                      },
                    );
                  },
                );
              },
            ),
          ),

          // ── MEDIA PREVIEW TRAY ──
          if (_selectedMedia.isNotEmpty)
            Container(
              height: 80.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedMedia.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final item = _selectedMedia[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: item.path.startsWith('http')
                            ? Image.network(
                                item.path,
                                width: 64.h,
                                height: 64.h,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(item.path),
                                width: 64.h,
                                height: 64.h,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedMedia.removeAt(index)),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          CommentInputField(
            controller: _commentController,
            onSend: (String text) => _handleSend(text),
            isTikTokStyle: true,
            onTap: () => _triggerInputModal(context), // 👑 TRIGGER MODAL
            onImageTap: _openImagePicker, // 👑 ADDED CAMERA SUPPORT
            userImageUrl: Supabase
                .instance
                .client
                .auth
                .currentUser
                ?.userMetadata?['avatar_url'],
          ),
        ],
      ),
    );
  }

  // 👑 NEW: Open specialized image/media picker
  Future<void> _openImagePicker() async {
    final result = await Navigator.push<List<MediaItem>>(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(
          targetChannelId: widget.channelId,
          isManifestoContext: true,
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _selectedMedia = [..._selectedMedia, ...result]);
    }
  }

  // 👑 NEW: Trigger specialized input modal
  void _triggerInputModal(BuildContext context) {
    final TextEditingController modalController = TextEditingController();
    modalController.text = _commentController.text;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              CommentInputField(
                controller: modalController,
                isTikTokStyle: true,
                autoFocus: true,
                onSend: (String text) {
                  _commentController.text = text;
                  _handleSend(text);
                  Navigator.pop(context);
                },
                onImageTap: _openImagePicker, // 👑 ADDED CAMERA SUPPORT
                userImageUrl: Supabase
                    .instance
                    .client
                    .auth
                    .currentUser
                    ?.userMetadata?['avatar_url'],
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48.sp, color: Colors.white10),
          SizedBox(height: 12.h),
          Text(
            'Be the first to speak',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // 👑 Shows a premium bottom sheet with a delete action for own messages
  void _showDeleteSheet(BuildContext context, String commentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── DRAG HANDLE ──
            Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // ── DELETE BUTTON ──
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
              ),
              title: Text(
                'Delete Comment',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'This cannot be undone',
                style: TextStyle(color: Colors.white30, fontSize: 12.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteComment(commentId);
              },
            ),
            // ── CANCEL ──
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 👑 Deletes the comment from Supabase and removes it from the local state
  Future<void> _deleteComment(String commentId) async {
    // 1. Optimistic removal from local state
    ref
        .read(manifestoCommentsProvider(widget.threadId).notifier)
        .removeComment(commentId);

    // 1.5 👑 OPTIMISTIC COUNT DECREMENT
    if (widget.channelId != null) {
      ref
          .read(channelFeedProvider(widget.channelId!).notifier)
          .decrementCommentCount(widget.threadId);
    }

    // 2. Persist deletion to Supabase
    try {
      await Supabase.instance.client
          .from('channel_post_comments')
          .delete()
          .eq('id', commentId);
      debugPrint('✅ [Comment] Deleted: $commentId');
    } catch (e) {
      debugPrint('🚨 [Comment] Delete failed: $e');
    }
  }
}
