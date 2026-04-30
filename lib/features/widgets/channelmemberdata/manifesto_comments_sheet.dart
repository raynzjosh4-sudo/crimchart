import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/channel/application/manifesto_comments_provider.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'comment_card.dart';
import 'package:crown/commentingsheets/widgets/commenting_sheet.dart';
import 'package:crown/features/channel/application/channel_feed_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../manifestowidgets/manifesto_media_router.dart';
import 'comment_card/media/comment_media_type.dart';

class ManifestoCommentsSheet extends ConsumerStatefulWidget {
  final String manifestoId;
  final String? channelId;
  final String? channelName;
  final Color themeColor;
  
  // 👑 Media & Author Params (for Immersive Mode)
  final List<String> attachmentUrls;
  final List<String> videoUrls;
  final List<String> thumbnailUrls;
  final String? authorAvatarUrl;
  final String? authorUsername;
  final String? authorCategory;
  final int initialLikes;
  final int initialComments;

  const ManifestoCommentsSheet({
    super.key,
    required this.manifestoId,
    this.channelId,
    this.channelName,
    required this.themeColor,
    this.attachmentUrls = const [],
    this.videoUrls = const [],
    this.thumbnailUrls = const [],
    this.authorAvatarUrl,
    this.authorUsername,
    this.authorCategory,
    this.initialLikes = 0,
    this.initialComments = 0,
  });

  @override
  ConsumerState<ManifestoCommentsSheet> createState() => _ManifestoCommentsSheetState();
}

class _ManifestoCommentsSheetState extends ConsumerState<ManifestoCommentsSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _openFullComposer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentingSheet(
        channelId: widget.channelId,
        channelName: widget.channelName,
        linkedPostId: widget.manifestoId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final commentsAsync = ref.watch(manifestoCommentsProvider(widget.manifestoId));
    final comments = commentsAsync.when(
      data: (list) => list,
      loading: () => <PostEntity>[],
      error: (_, __) => <PostEntity>[],
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.black, // Immersive mode usually has black background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        child: Stack(
          children: [
            // ── LAYER 0: IMMERSIVE MEDIA BACKGROUND ──
            Positioned.fill(
              child: Opacity(
                opacity: 0.8, // Slightly dimmed to make UI pop
                child: ManifestoMediaRouter(
                  mediaType: widget.videoUrls.isNotEmpty 
                      ? CommentMediaType.video 
                      : CommentMediaType.image,
                  mediaUrls: widget.attachmentUrls,
                  videoUrls: widget.videoUrls,
                  thumbnailUrls: widget.thumbnailUrls,
                  themeColor: widget.themeColor,
                  username: widget.authorUsername,
                ),
              ),
            ),

            // ── LAYER 1: THE COMMENTS OVERLAY (Transparent List) ──
            // We use a Column to keep the list below the header
            Column(
              children: [
                SizedBox(height: 80.h), // Space for header
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
                        stops: [0.0, 0.1, 0.85, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: comments.isEmpty
                        ? const SizedBox.shrink()
                        : ListView.builder(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 200.h),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final c = comments[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Opacity(
                                  opacity: 0.9,
                                  child: CommentCard(
                                    memberName: c.authorUsername,
                                    avatarUrl: c.authorAvatarUrl,
                                    messageText: c.caption,
                                    outlineColor: widget.themeColor,
                                    likes: c.likes,
                                    comments: 0,
                                    referenceId: c.id,
                                    isOnline: c.authorIsOnline,
                                    hasStatus: c.authorHasStatus,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),

            // ── LAYER 2: IMMERSIVE HEADER (X, MORE, BACK) ──
            Positioned(
              top: 16.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircularButton(
                    theme,
                    LucideIcons.chevronLeft,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.channelName ?? 'Manifesto',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: const [Shadow(blurRadius: 10, color: Colors.black45)],
                    ),
                  ),
                  Row(
                    children: [
                      _buildCircularButton(theme, LucideIcons.moreVertical, onTap: () {}),
                      SizedBox(width: 12.w),
                      _buildCircularButton(theme, LucideIcons.x, onTap: () => Navigator.pop(context)),
                    ],
                  ),
                ],
              ),
            ),

            // ── LAYER 3: FLOATING IDENTITY (Bottom Left) ──
            Positioned(
              bottom: 120.h,
              left: 20.w,
              child: _buildProfilePill(theme),
            ),

            // ── LAYER 4: IMMERSIVE INTERACTION BAR (Bottom Center) ──
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: _buildInteractionBar(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton(ThemeData theme, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _buildProfilePill(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundImage: widget.authorAvatarUrl != null ? NetworkImage(widget.authorAvatarUrl!) : null,
            child: widget.authorAvatarUrl == null ? const Icon(LucideIcons.user) : null,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.authorUsername ?? 'Anonymous',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (widget.authorCategory != null)
                Text(
                  widget.authorCategory!,
                  style: TextStyle(fontSize: 11.sp, color: Colors.white70),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: const BoxDecoration(color: Color(0xFFC0FF00), shape: BoxShape.circle),
            child: Icon(LucideIcons.arrowUpRight, size: 12.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionBar(ThemeData theme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionCircle(LucideIcons.messageSquare, onTap: _openFullComposer),
          SizedBox(width: 24.w),
          _buildActionCircle(
            LucideIcons.heart, 
            isLarge: true, 
            isBlack: true, 
            onTap: () {
              // 👑 Like Toggle Logic
              ref.read(channelFeedProvider(widget.channelId ?? 'general').notifier)
                 .toggleLike(widget.manifestoId, true);
            },
          ),
          SizedBox(width: 24.w),
          _buildActionCircle(LucideIcons.send, onTap: () {
             // 👑 Share Logic (Placeholder)
          }),
        ],
      ),
    );
  }

  Widget _buildActionCircle(IconData icon, {bool isLarge = false, bool isBlack = false, VoidCallback? onTap}) {
    final double size = isLarge ? 64.r : 48.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isBlack ? Colors.black : Colors.white12,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
          boxShadow: isBlack ? [const BoxShadow(color: Colors.black26, blurRadius: 10)] : null,
        ),
        child: Icon(icon, color: Colors.white, size: (isLarge ? 28 : 22).sp),
      ),
    );
  }
}
