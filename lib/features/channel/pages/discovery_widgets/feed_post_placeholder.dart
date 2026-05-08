import 'package:crimchart/core/db/chart_db.dart';
import 'package:crimchart/video/core/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' show Value;
import 'package:crimchart/core/db/chart_native_db.dart';
import '../widgets/channelinfosheet/widgets/imageviewer/image_viewer_page.dart';
import '../widgets/channelinfosheet/widgets/videoviewer/video_viewer_page.dart';

class FeedPostPlaceholder extends StatefulWidget {
  final String authorName;
  final String content;
  final String timeAgo;
  final String? imageUrl;
  final List<String>? imageUrls;
  final String? videoUrl;
  final String? authorImageUrl;
  final double? aspectRatio;
  final String? type;
  final int likesCount;
  final int commentsCount;
  final int tagsCount;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final String? inviteChannelId; // 👑 Source of truth for live fetch
  final String? inviteChannelName;
  final String? inviteChannelImage;
  final String? inviteChannelTitle;
  final VoidCallback? onJoinPressed;
  final VoidCallback? onTagTap; // 👑 NEW: For Tag/Repost logic

  final String? taggerName;
  final String? taggerAvatar;
  final String? sourceChannelName;
  final String? sourceChannelAvatar;
  final String? currentChannelAvatar;

  const FeedPostPlaceholder({
    super.key,
    required this.authorName,
    required this.content,
    required this.timeAgo,
    this.imageUrl,
    this.imageUrls,
    this.videoUrl,
    this.authorImageUrl,
    this.aspectRatio,
    this.type,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.tagsCount = 0,
    this.isLiked = false,
    this.onLikeTap,
    this.onCommentTap,
    this.inviteChannelId,
    this.inviteChannelName,
    this.inviteChannelImage,
    this.inviteChannelTitle,
    this.onJoinPressed,
    this.onTagTap,
    this.taggerName,
    this.taggerAvatar,
    this.sourceChannelName,
    this.sourceChannelAvatar,
    this.currentChannelAvatar,
  });

  @override
  State<FeedPostPlaceholder> createState() => _FeedPostPlaceholderState();
}

class _FeedPostPlaceholderState extends State<FeedPostPlaceholder> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  bool _isLiked = false;

  // 👑 Live-fetched invite channel data
  String? _resolvedChannelName;
  String? _resolvedChannelImage;
  String? _resolvedChannelTitle;
  bool _isFetchingChannel = false;

  // 👑 Membership state
  bool _isMember = false;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'invite' && widget.inviteChannelId != null) {
      _fetchChannelData();
    }
  }

  /// 👑 PROFESSIONAL: Fetch channel data + membership status live from Supabase.
  Future<void> _fetchChannelData() async {
    final channelId = widget.inviteChannelId;
    if (channelId == null || channelId.isEmpty) return;

    setState(() => _isFetchingChannel = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      // 1. Fetch channel info
      final data = await supabase
          .from('channels')
          .select('id, name, description, avatar_url')
          .eq('id', channelId)
          .maybeSingle();

      // 2. Check membership status
      bool isMember = false;
      if (userId != null) {
        final memberRow = await supabase
            .from('channel_members')
            .select('user_id')
            .eq('channel_id', channelId)
            .eq('user_id', userId)
            .maybeSingle();
        isMember = memberRow != null;
      }

      if (mounted) {
        setState(() {
          if (data != null) {
            _resolvedChannelName = data['name']?.toString();
            _resolvedChannelImage = data['avatar_url']?.toString();
            _resolvedChannelTitle = data['description']?.toString();
          }
          _isMember = isMember;
          _isFetchingChannel = false;
        });
      }
    } catch (e) {
      debugPrint('⚠️ [InviteCard] Failed to fetch channel data: $e');
      if (mounted) setState(() => _isFetchingChannel = false);
    }
  }

  /// 👑 Join the channel: insert to Supabase + persist locally.
  Future<void> _joinChannel() async {
    final channelId = widget.inviteChannelId;
    if (channelId == null || channelId.isEmpty || _isMember || _isJoining)
      return;

    setState(() => _isJoining = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() => _isJoining = false);
        return;
      }

      // 1. 👑 CRITICAL: Insert into Supabase channel_members
      await supabase.from('channel_members').upsert({
        'channel_id': channelId,
        'user_id': userId,
        'role': 'member',
      }, onConflict: 'channel_id,user_id');

      // ✅ Supabase succeeded — update UI immediately
      if (mounted)
        setState(() {
          _isMember = true;
          _isJoining = false;
        });
      debugPrint('✅ [InviteCard] Joined channel: $channelId');

      // 2. 👑 BEST-EFFORT: Persist to local DB (fails silently if FK missing)
      try {
        final db = ChartNativeDB.instance;
        // Ensure channel placeholder exists to satisfy FK constraint
        await db.db
            .into(db.db.channels)
            .insertOnConflictUpdate(ChannelsCompanion(id: Value(channelId)));
        await db.db
            .into(db.db.channelMembers)
            .insertOnConflictUpdate(
              ChannelMembersCompanion(
                channelId: Value(channelId),
                userId: Value(userId),
                role: const Value('member'),
                joinedAt: Value(DateTime.now()),
              ),
            );
        debugPrint('💾 [InviteCard] Membership cached locally');
      } catch (localErr) {
        debugPrint('⚠️ [InviteCard] Local cache skipped: $localErr');
      }
    } catch (e) {
      debugPrint('❌ [InviteCard] Join failed: $e');
      if (mounted) setState(() => _isJoining = false);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _allImages {
    final images = <String>[];
    if (widget.imageUrl != null) images.add(widget.imageUrl!);
    if (widget.imageUrls != null) images.addAll(widget.imageUrls!);
    return images.toSet().toList(); // Unique images
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final images = _allImages;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor == Colors.transparent
            ? Colors.transparent
            : theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 8.h,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                if (widget.sourceChannelAvatar != null)
                  SizedBox(
                    width: 48.w,
                    height: 40.r,
                    child: Stack(
                      children: [
                        // Target Channel (Main) - Current Channel
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          backgroundImage: widget.currentChannelAvatar != null
                              ? CachedNetworkImageProvider(
                                  widget.currentChannelAvatar!,
                                )
                              : null,
                          child: widget.currentChannelAvatar == null
                              ? Icon(
                                  LucideIcons.users,
                                  size: 20.sp,
                                  color: colorScheme.onSurface,
                                )
                              : null,
                        ),
                        // Source Channel (Overlapping)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 2.w,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 12.r,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              backgroundImage: CachedNetworkImageProvider(
                                widget.sourceChannelAvatar!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    backgroundImage:
                        widget.authorImageUrl != null &&
                            widget.authorImageUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(widget.authorImageUrl!)
                        : null,
                    child:
                        (widget.authorImageUrl == null ||
                            widget.authorImageUrl!.isEmpty)
                        ? Icon(
                            LucideIcons.user,
                            size: 20.sp,
                            color: colorScheme.onSurface,
                          )
                        : null,
                  ),
                SizedBox(
                  width: widget.sourceChannelAvatar != null ? 8.w : 12.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.authorName,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.sourceChannelName != null)
                        Text(
                          'Tagged from ${widget.sourceChannelName}',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              widget.content,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Media Attachment (Video or Image Carousel)
          if (widget.videoUrl != null)
            _buildVideoPlayer()
          else if (images.isNotEmpty)
            _buildImageCarousel(images),

          if (widget.type == 'invite') _buildInviteSection(),

          // 👑 MOVED: Tagger Attribution (Social Proof)
          if (widget.taggerName != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: Row(
                children: [
                  // Tagger Avatar with optional "+" badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundImage: widget.taggerAvatar != null
                            ? CachedNetworkImageProvider(widget.taggerAvatar!)
                            : null,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        child: widget.taggerAvatar == null
                            ? Icon(LucideIcons.user, size: 12.sp)
                            : null,
                      ),
                      if (widget.tagsCount > 3)
                        Positioned(
                          right: -4.w,
                          bottom: -4.h,
                          child: Container(
                            padding: EdgeInsets.all(1.r),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 2.w,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 8.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: widget.taggerName,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (widget.tagsCount > 1) ...[
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: '${widget.tagsCount - 1} others ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ] else
                            const TextSpan(text: ' '),
                          const TextSpan(text: 'tagged this post'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Actions Row
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
            child: Row(
              children: [
                if (widget.type != 'invite') ...[
                  _AnimatedActionButton(
                    icon: widget.isLiked ? Icons.favorite : LucideIcons.heart,
                    label: _formatCount(widget.likesCount),
                    color: widget.isLiked
                        ? theme.primaryColor
                        : colorScheme.onSurface,
                    onTap: widget.onLikeTap ?? () {},
                  ),
                  SizedBox(width: 24.w),
                  _AnimatedActionButton(
                    icon: LucideIcons.messageSquare,
                    label: _formatCount(widget.commentsCount),
                    color: colorScheme.onSurface,
                    onTap: widget.onCommentTap ?? () {},
                  ),
                  SizedBox(width: 24.w),
                ],
                _AnimatedActionButton(
                  icon: LucideIcons.tag,
                  label: _formatCount(widget.tagsCount),
                  color: colorScheme.onSurface,
                  onTap: widget.onTagTap ?? () {},
                ),
                const Spacer(),
                Text(
                  widget.timeAgo,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // 👑 Channel Avatar
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHighest,
            ),
            clipBehavior: Clip.antiAlias,
            child: _isFetchingChannel
                ? const SizedBox.shrink()
                : (_resolvedChannelImage?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: _resolvedChannelImage!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Icon(
                            LucideIcons.users,
                            size: 24.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : Icon(
                          LucideIcons.users,
                          size: 24.sp,
                          color: colorScheme.onSurfaceVariant,
                        )),
          ),
          SizedBox(width: 12.w),
          // 👑 Channel Name & Description
          Expanded(
            child: _isFetchingChannel
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 10.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _resolvedChannelName ??
                            widget.inviteChannelName ??
                            'Channel',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if ((_resolvedChannelTitle ?? widget.inviteChannelTitle)
                              ?.isNotEmpty ==
                          true)
                        Text(
                          _resolvedChannelTitle ?? widget.inviteChannelTitle!,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
          ),
          // 👑 Smart JOIN / JOINED Button
          _isJoining
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: _isMember ? null : _joinChannel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isMember
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : theme.primaryColor,
                    foregroundColor: _isMember
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Colors.white,
                    disabledBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    disabledForegroundColor: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    _isMember ? 'JOINED' : 'JOIN',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        // 👑 Navigate to TikTok-style VideoViewerPage
        final dummyPost = PostEntity.original(
          id: 'video_${widget.videoUrl.hashCode}',
          authorId: 'author_${widget.authorName.hashCode}',
          authorUsername: widget.authorName.toLowerCase().replaceAll(' ', '_'),
          authorDisplayName: widget.authorName,
          authorAvatarUrl: widget.authorImageUrl,
          createdAt: DateTime.now(),
          channelId: 'feed_channel',
          channelName: 'Channel Feed',
          caption: widget.content,
          videoUrl: widget.videoUrl,
          isVideo: true,
          likes: 3400,
          comments: 156,
          shares: 845,
          timeAgo: widget.timeAgo,
        );

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                VideoViewerPage(initialVideos: [dummyPost], initialIndex: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
          ),
        );
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 250.h,
          maxHeight: 700.h, // Increased for taller vertical videos
        ),
        child: VideoPlayerWidget(
          key: ValueKey(widget.videoUrl),
          videoUrl: widget.videoUrl!,
          autoPlay: false,
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    // 👑 For carousels, use a consistent ratio so swiping doesn't jump.
    // For single images, let them render at their NATURAL size — no cropping.
    final double carouselRatio = widget.aspectRatio ?? 0.75;
    final screenWidth = MediaQuery.of(context).size.width;

    if (images.length == 1) {
      final String url = images[0];
      // 👑 SINGLE IMAGE: No AspectRatio box. The image renders at full width
      // and its natural height. ConstrainedBox caps it so ultra-tall images
      // don't swallow the whole feed.
      return GestureDetector(
        onTap: () => _openImageViewer(images, 0),
        child: Hero(
          tag: 'image_hero_${widget.hashCode}_$url',
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenWidth * 1.6, // Cap at ~9:16 portrait
            ),
            child: CachedNetworkImage(
              imageUrl: url,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => SizedBox(
                height: screenWidth, // Placeholder square while loading
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
              ),
              errorWidget: (context, url, error) => SizedBox(
                height: screenWidth * 0.5,
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: carouselRatio,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              final String url = images[index];
              return GestureDetector(
                onTap: () => _openImageViewer(images, index),
                child: Hero(
                  tag: 'image_hero_${widget.hashCode}_$url',
                  child: CachedNetworkImage(
                    imageUrl: url,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    placeholder: (context, url) => Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return Container(
                  width: 6.w,
                  height: 6.w,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == entry.key
                        ? Theme.of(context).primaryColor
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _openImageViewer(List<String> images, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ImageViewerPage(
              imageUrls: images,
              initialIndex: index,
              likes: 3500, // Dummy like count
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 🌸 SOFT NATIVE TRANSITION
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.05, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// A self-contained animated action button with a scale bounce on tap.
class _AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.75), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.75, end: 1.15), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Row(
          children: [
            Icon(widget.icon, size: 24.sp, color: widget.color),
            SizedBox(width: 8.w),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.color.withValues(alpha: 0.8),
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
