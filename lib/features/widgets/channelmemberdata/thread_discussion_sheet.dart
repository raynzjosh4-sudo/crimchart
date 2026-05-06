import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/channel/application/manifesto_comments_provider.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:crown/posting/pages/post_page.dart';
import 'package:crown/posting/models/media_item.dart';
import 'package:crown/commentingsheets/widgets/comment_input_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'manifesto_chat_bubble_shimmer.dart';
import 'manifesto_chat_bubble.dart';

class ThreadDiscussionSheet extends ConsumerStatefulWidget {
  final String threadId;
  final String? channelId;
  final String? channelName;

  const ThreadDiscussionSheet({
    super.key,
    required this.threadId,
    this.channelId,
    this.channelName,
  });

  @override
  ConsumerState<ThreadDiscussionSheet> createState() =>
      _ThreadDiscussionSheetState();
}

class _ThreadDiscussionSheetState extends ConsumerState<ThreadDiscussionSheet> {
  final TextEditingController _commentController = TextEditingController();
  late final PagingController<int, PostEntity> _pagingController;
  StreamSubscription? _connectivitySubscription;
  bool _isOffline = false;
  List<MediaItem> _selectedMedia = []; // 👑 ATTACHMENT STATE

  @override
  void initState() {
    super.initState();

    _pagingController = PagingController<int, PostEntity>(
      fetchPage: (pageKey) async {
        debugPrint(
          '🔄 [ThreadDiscussionSheet] fetchPage called for page: $pageKey',
        );
        await ref
            .read(manifestoCommentsProvider(widget.threadId).notifier)
            .loadMore();
        return [];
      },
      getNextPageKey: (state) {
        final commentsState = ref.read(
          manifestoCommentsProvider(widget.threadId),
        );
        return commentsState.value != null &&
                commentsState.value!.length % 15 == 0
            ? (commentsState.value!.length ~/ 15) + 1
            : null;
      },
    );
    _checkInitialConnection();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (results.isEmpty) return;
      final status = results.first;
      setState(() => _isOffline = status == ConnectivityResult.none);
      if (status != ConnectivityResult.none) {
        _pagingController.refresh();
      }
    });

    // ── INITIAL SYNC ──
    // ── INITIAL SYNC ──
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final initialState = ref.read(
        manifestoCommentsProvider(widget.threadId),
      );

      _pagingController.value = PagingState(
        pages: initialState.value != null && initialState.value!.isNotEmpty
            ? [initialState.value!]
            : [],
        keys: initialState.value != null && initialState.value!.isNotEmpty
            ? [1]
            : [],
        hasNextPage:
            (initialState.value?.isNotEmpty ?? false) &&
            (initialState.value!.length % 15 == 0),
        isLoading: initialState.isLoading,
        error: initialState.error,
      );

      // If NOT loading and NO data, trigger first fetch
      if (!initialState.isLoading && (initialState.value?.isEmpty ?? true)) {
        ref
            .read(manifestoCommentsProvider(widget.threadId).notifier)
            .fetchComments();
      }
    });

    // ── SYNC PAGING WITH PROVIDER ──
    ref.listenManual(manifestoCommentsProvider(widget.threadId), (
      previous,
      next,
    ) {
      if (!mounted) return;

      _pagingController.value = PagingState(
        pages: next.value != null && next.value!.isNotEmpty
            ? [next.value!]
            : [],
        keys: next.value != null && next.value!.isNotEmpty ? [1] : [],
        hasNextPage:
            (next.value?.isNotEmpty ?? false) && (next.value!.length % 15 == 0),
        isLoading: next.isLoading,
        error: next.error,
      );
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
    _pagingController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

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
      caption: text,
      isPending: 1,
    );

    notifier.addComment(
      optimisticPost.copyWith(
        imageUrls: _selectedMedia.map((m) => m.path).toList(),
      ),
    );

    // ── 2. PERSIST IN BACKGROUND ──
    try {
      await Supabase.instance.client.from('channel_post_comments').insert({
        'post_id': widget.threadId,
        'author_id': user?.id,
        'message': text,
        'channel_id': widget.channelId,
        'image_urls': _selectedMedia
            .map((m) => m.path)
            .toList(), // 👑 PERSIST PATHS
      });

      // ── 3. CLEANUP ──
      setState(() => _selectedMedia = []);
    } catch (e) {
      debugPrint('🚨 Failed to persist comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏗️ [ThreadDiscussionSheet] build() START');
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discussion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white60),
                ),
              ],
            ),
          ),

          // ── PAGINATED COMMENTS LIST ──
          Expanded(
            child: ValueListenableBuilder<PagingState<int, PostEntity>>(
              valueListenable: _pagingController,
              builder: (context, state, _) {
                return PagedListView<int, PostEntity>(
                  reverse: false, // 👑 Start from the top
                  state: state,
                  fetchNextPage: _pagingController.fetchNextPage,
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    12.h,
                    16.w,
                    80.h,
                  ), // 👑 More bottom padding for input
                  builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                    itemBuilder: (context, c, index) => ManifestoChatBubble(
                      username: c.authorUsername,
                      avatarUrl: c.authorAvatarUrl,
                      message: c.caption,
                      themeColor: const Color(0xFFFFD700),
                      isMe: c.authorId == currentUserId,
                      imageUrls: c.imageUrls,
                    ),
                    firstPageProgressIndicatorBuilder: (_) => Column(
                      children: List.generate(
                        6,
                        (_) => const ManifestoChatBubbleShimmer(),
                      ),
                    ),
                    newPageProgressIndicatorBuilder: (_) =>
                        const ManifestoChatBubbleShimmer(),
                    noItemsFoundIndicatorBuilder: (_) => _buildEmptyState(),
                    noMoreItemsIndicatorBuilder: (_) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: Text(
                          'End of discussion',
                          style: TextStyle(
                            color: Colors.white10,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
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

          // ── INPUT FIELD ──
          CommentInputField(
            controller: _commentController,
            onSend: _handleSend,
            userImageUrl: Supabase
                .instance
                .client
                .auth
                .currentUser
                ?.userMetadata?['avatar_url'],
            onImageTap: () async {
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
            },
          ),
        ],
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
}
