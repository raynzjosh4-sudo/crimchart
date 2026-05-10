import 'dart:async';
import 'package:crimchart/features/widgets/channelmemberdata/thread_discussion_sheet.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/commentingsheets/widgets/comment_input_field.dart';
import 'package:crimchart/features/channel/application/manifesto_comments_provider.dart';
import 'package:crimchart/features/channel/application/channel_feed_provider.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:uuid/uuid.dart';
import 'package:crimchart/posting/pages/post_page.dart';
import 'package:crimchart/posting/models/media_item.dart';
import '../core/widgets/tiktok_video_card.dart';
import '../core/models/feed_video_item.dart';

enum VideoFeedTab { explore, channel, friends }

class VideoFeedPage extends ConsumerStatefulWidget {
  final List<FeedVideoItem>? videos;
  final int initialIndex;
  final VideoFeedTab initialTab;
  final bool showBack;

  const VideoFeedPage({
    super.key,
    this.videos,
    this.initialIndex = 0,
    this.initialTab = VideoFeedTab.explore,
    this.showBack = true,
  });

  @override
  ConsumerState<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends ConsumerState<VideoFeedPage> {
  late final PageController _pageController;
  late final List<FeedVideoItem> _videos;
  late int _currentIndex;
  late VideoFeedTab _currentTab;
  bool _isCommentsOpen = false;

  // media_kit player pool — 3 players for prev/current/next
  final List<Player> _players = [];
  final List<VideoController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _currentTab = widget.initialTab;
    _pageController = PageController(initialPage: _currentIndex);

    if (widget.videos == null || widget.videos!.isEmpty) {
      _videos = [];
    } else {
      _videos = widget.videos!;
    }

    _initPlayerPool();
  }

  Future<void> _initPlayerPool() async {
    if (_videos.isEmpty) return;

    // Create 3 players for the pool
    for (int i = 0; i < 3; i++) {
      final player = Player();
      final controller = VideoController(player);
      _players.add(player);
      _controllers.add(controller);
    }

    // Start from the tapped/initial index, not always from 0
    final startPool = _poolIndex(_currentIndex);
    final currentUrl = _videos[_currentIndex].videoUrl;

    // Open and immediately play the tapped video
    await _players[startPool].open(Media(currentUrl));
    _players[startPool].setPlaylistMode(PlaylistMode.loop);

    // Preload next video if available
    if (_currentIndex + 1 < _videos.length) {
      final nextPool = _poolIndex(_currentIndex + 1);
      await _players[nextPool].open(Media(_videos[_currentIndex + 1].videoUrl));
      await _players[nextPool].pause();
    }

    // Preload previous video if available
    if (_currentIndex - 1 >= 0) {
      final prevPool = _poolIndex(_currentIndex - 1);
      await _players[prevPool].open(Media(_videos[_currentIndex - 1].videoUrl));
      await _players[prevPool].pause();
    }

    if (mounted) setState(() {});
  }

  int _poolIndex(int globalIndex) => globalIndex % 3;

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);

    final pool = _poolIndex(index);
    final prevPool = _poolIndex(index - 1 < 0 ? 0 : index - 1);
    final nextPool = _poolIndex(index + 1);

    // Play current
    _players[pool].play();

    // Pause previous
    if (index > 0) _players[prevPool].pause();

    // Preload next in background
    Future.microtask(() async {
      if (!mounted) return;
      if (index + 1 < _videos.length) {
        final nextUrl = _videos[index + 1].videoUrl;
        final nextPlayer = _players[nextPool];
        // Only reload if different URL
        if (nextPlayer.state.playlist.medias.isEmpty ||
            nextPlayer.state.playlist.medias.first.uri != nextUrl) {
          await nextPlayer.open(Media(nextUrl));
          await nextPlayer.pause();
        }
      }
      // Reload current if needed
      final currentUrl = _videos[index % _videos.length].videoUrl;
      final currentPlayer = _players[pool];
      if (currentPlayer.state.playlist.medias.isEmpty ||
          currentPlayer.state.playlist.medias.first.uri != currentUrl) {
        await currentPlayer.open(Media(currentUrl));
        currentPlayer.setPlaylistMode(PlaylistMode.loop);
      }
    });
  }

  void _onTabTapped(VideoFeedTab tab) {
    if (_currentTab == tab) return;
    setState(() => _currentTab = tab);
  }

  void _toggleComments() {
    setState(() => _isCommentsOpen = !_isCommentsOpen);
  }

  // 👑 NEW: Shows a dedicated modal sheet for comment input
  void _showCommentInputSheet() {
    final TextEditingController inputController = TextEditingController();
    final currentVideo = _videos[_currentIndex];

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
              // Drag handle
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
                controller: inputController,
                isTikTokStyle: true,
                autoFocus: true,
                onSend: (String text) async {
                  if (text.trim().isEmpty) return;

                  final user = Supabase.instance.client.auth.currentUser;
                  if (user == null) return;

                  // 1. Add comment to provider (Optimistic UI)
                  final optimisticComment = PostEntity.original(
                    id: const Uuid().v4(),
                    authorId: user.id,
                    authorUsername: user.userMetadata?['username'] ?? 'User',
                    authorDisplayName:
                        user.userMetadata?['display_name'] ?? 'User',
                    authorAvatarUrl: user.userMetadata?['avatar_url'],
                    caption: text,
                    createdAt: DateTime.now(),
                    channelId: currentVideo.channelId ?? 'unknown',
                    channelName: 'Manifesto',
                    isPending: 1,
                  );

                  ref
                      .read(manifestoCommentsProvider(currentVideo.id).notifier)
                      .addComment(optimisticComment);

                  // 2. Increment count in feed
                  if (currentVideo.channelId != null) {
                    ref
                        .read(
                          channelFeedProvider(currentVideo.channelId!).notifier,
                        )
                        .incrementCommentCount(currentVideo.id);
                  }

                  inputController.clear();
                  Navigator.pop(context);
                },
                onImageTap: () async {
                  await Navigator.push<List<MediaItem>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(
                        targetChannelId: currentVideo.channelId,
                        isManifestoContext: true,
                      ),
                    ),
                  );
                },
                userImageUrl: Supabase.instance.client.auth.currentUser
                    ?.userMetadata?['avatar_url'],
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final p in _players) {
      p.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. The Infinite Vertical Feed (with TikTok Shrink Effect)
          AnimatedAlign(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            alignment: _isCommentsOpen ? Alignment.topCenter : Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              width: _isCommentsOpen
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.width,
              height: _isCommentsOpen
                  ? MediaQuery.of(context).size.height * 0.3
                  : MediaQuery.of(context).size.height,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_isCommentsOpen ? 16.r : 0),
                boxShadow: [
                  if (_isCommentsOpen)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _videos.isEmpty ? 1 : _videos.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final pool = _poolIndex(index);
                  final isPlaying = index == _currentIndex;
                  final item = _videos[index % _videos.length];

                  return MkVideoCard(
                    item: item,
                    controller: _controllers.isNotEmpty
                        ? _controllers[pool]
                        : null,
                    isPlaying: isPlaying,
                    showBottomBuffer: widget.showBack,
                    currentTab: _currentTab,
                    onCommentTap: _toggleComments,
                    onShrunkenTap: _showCommentInputSheet, // 👑 ADDED CALLBACK
                    isShrunken: _isCommentsOpen,
                  );
                },
              ),
            ),
          ),

          // 2. Top Header Overlay
          if (!_isCommentsOpen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.showBack)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(
                              LucideIcons.chevronLeft,
                              color: Colors.white,
                              size: 28.sp,
                              shadows: const [
                                Shadow(color: Colors.black54, blurRadius: 8),
                              ],
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNavText("Friends", VideoFeedTab.friends),
                          SizedBox(width: 20.w),
                          _buildNavText("Channel", VideoFeedTab.channel),
                          SizedBox(width: 20.w),
                          _buildNavText("Explore", VideoFeedTab.explore),
                        ],
                      ),
                      if (!widget.showBack)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: Icon(
                              LucideIcons.search,
                              color: Colors.white,
                              size: 26.sp,
                              shadows: const [
                                Shadow(color: Colors.black54, blurRadius: 8),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // 5. TikTok Comment Sheet Overlay
          if (_isCommentsOpen)
            GestureDetector(
              onTap: _toggleComments,
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: _isCommentsOpen
                ? 0
                : -MediaQuery.of(context).size.height * 0.75,
            height: MediaQuery.of(context).size.height * 0.75,
            child: ThreadDiscussionSheet(
              threadId: _videos[_currentIndex].id,
              channelId: _videos[_currentIndex].channelId,
              channelName: _videos[_currentIndex].title,
              onClose: _toggleComments,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavText(String text, VideoFeedTab tab) {
    final isActive = _currentTab == tab;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () => _onTabTapped(tab),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isActive ? primaryColor : Colors.white,
              fontSize: isActive ? 18.sp : 16.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              shadows: [
                Shadow(
                  color: isActive
                      ? primaryColor.withOpacity(0.6)
                      : Colors.black54,
                  blurRadius: isActive ? 12 : 4,
                ),
              ],
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 20.w,
              height: 2.5,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.8),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
