import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/channel/application/channels_list_controller.dart';
import 'widgets/tag_card.dart';
import 'widgets/tag_carousel.dart';
import 'widgets/tag_shimmer.dart';
import 'widgets/tag_no_internet.dart';
import 'tag_discovery_page.dart';
import 'package:crimchart/features/channel/application/tag_controller.dart';

/// An Instagram-style floating overlay for Tagging with Pagination & Shimmers.
class TagOverlay extends ConsumerStatefulWidget {
  final String postId;
  final String sourceChannelId;
  final List<String> linkChain;
  final String? channelName;

  const TagOverlay({
    super.key,
    required this.postId,
    required this.sourceChannelId,
    required this.linkChain,
    this.channelName,
  });

  static Future<void> show(
    BuildContext context, {
    required String postId,
    required String sourceChannelId,
    required List<String> linkChain,
    String? channelName,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'TagOverlay',
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => TagOverlay(
        postId: postId,
        sourceChannelId: sourceChannelId,
        linkChain: linkChain,
        channelName: channelName,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curve),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  ConsumerState<TagOverlay> createState() => _TagOverlayState();
}

class _TagOverlayState extends ConsumerState<TagOverlay> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 👑 Pagination logic: Load more when reaching the end of the carousel
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.w) {
      ref.read(channelsListControllerProvider('').notifier).loadChannels();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final channelsState = ref.watch(channelsListControllerProvider(''));

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF121212)
                : colorScheme.surface,
            borderRadius: BorderRadius.zero,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.h),
              
              // ── HEADER ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tag Options',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),

              // ── CONTENT STATE HANDLER ──
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: _buildBody(channelsState),
              ),

              // ── FOOTER ──
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close overlay
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagDiscoveryPage(
                        postId: widget.postId,
                        sourceChannelId: widget.sourceChannelId,
                        linkChain: widget.linkChain,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Text(
                    'See all',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ChannelsListState state) {
    // 1. Initial Loading State -> Shimmer
    if (state.status == ChannelsListStatus.loading && state.channels.isEmpty) {
      return const TagShimmer();
    }

    // 2. Error State -> No Internet Widget
    if (state.status == ChannelsListStatus.error && state.channels.isEmpty) {
      return TagNoInternet(
        onRetry: () => ref.read(channelsListControllerProvider('').notifier).loadChannels(refresh: true),
      );
    }

    // 3. Loaded State -> Carousel with Pagination support
    return TagCarousel(
      scrollController: _scrollController,
      isLoadingMore: state.status == ChannelsListStatus.loading,
      cards: state.channels.map((channel) {
        return TagCard(
          title: channel.name,
          description: channel.description,
          imageUrl: channel.avatarUrl,
          buttonText: 'Tag',
          onTap: () {
            ref.read(tagControllerProvider.notifier).tagPost(
                  postId: widget.postId,
                  sourceChannelId: widget.sourceChannelId,
                  targetChannelId: channel.id,
                  linkChain: [...widget.linkChain, channel.id],
                );
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}
