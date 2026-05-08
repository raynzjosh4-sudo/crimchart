import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/commentingsheets/widgets/commenting_sheet.dart';
import '../crown_option_model.dart';
import '../../../../widgets/chartbutton/chart_button.dart';
import '../../../../widgets/channelmemberdata/comment_card.dart';
import '../widgets/crown_button.dart';
import '../widgets/crown_poll_card.dart';
import '../widgets/expandable_crown_text.dart';
import '../widgets/mediatype/crown_media_type.dart';
import '../../widgets/channelinfosheet/widgets/imageviewer/image_viewer_page.dart';
import '../../widgets/channelinfosheet/widgets/videoviewer/video_viewer_page.dart';
import '../../widgets/channelinfosheet/widgets/audioplayer/audio_player_page.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CrownDetailPage extends StatefulWidget {
  final CrownModel pollModel;
  final CrownOptionModel option;
  final Color themeColor;
  final VoidCallback onCrown;

  const CrownDetailPage({
    super.key,
    required this.pollModel,
    required this.option,
    required this.themeColor,
    required this.onCrown,
  });

  @override
  State<CrownDetailPage> createState() => _CrownDetailPageState();
}

class _CrownDetailPageState extends State<CrownDetailPage> {
  late bool _isMe;
  late int _crowns;
  late ScrollController _scrollController;
  bool _showTitleInAppBar = false;
  late final PagingController<int, Map<String, dynamic>> _pagingController;

  @override
  void initState() {
    super.initState();
    _isMe = widget.option.isMe;
    _crowns = widget.option.crowns;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 80 && !_showTitleInAppBar) {
        setState(() => _showTitleInAppBar = true);
      } else if (_scrollController.offset <= 80 && _showTitleInAppBar) {
        setState(() => _showTitleInAppBar = false);
      }
    });

    _pagingController = PagingController<int, Map<String, dynamic>>(
      fetchPage: (pageKey) async {
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate net
        final newItems = List.generate(
          10,
          (index) => {
            "id": "comment_${pageKey}_$index",
            "name": "User ${pageKey * 10 + index + 1}",
            "text": "This is a comment about this option! Super interesting.",
          },
        );
        return newItems;
      },
      getNextPageKey: (state) {
        final pageKey = state.pages?.length ?? 0;
        if (pageKey > 2) return null; // simulate 3 pages total
        return pageKey + 1;
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void _handleCrown() {
    setState(() {
      if (!_isMe) {
        _isMe = true;
        _crowns++;
      } else {
        _isMe = false;
        _crowns--;
      }
    });
    widget.onCrown();
  }

  PageRouteBuilder _slideUpRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeOutQuart));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  void _handleMediaTap() {
    if (widget.option.mediaType == CrownMediaType.image) {
      Navigator.push(
        context,
        _slideUpRoute(
          ImageViewerPage(
            imageUrls: [widget.option.mediaUrl ?? ""],
            initialIndex: 0,
            likes: _crowns,
          ),
        ),
      );
    } else if (widget.option.mediaType == CrownMediaType.video) {
      Navigator.push(
        context,
        _slideUpRoute(
          VideoViewerPage(
            initialVideos: [
              PostEntity.original(
                id: widget.option.id,
                authorId: widget.pollModel.crownerId,
                authorUsername: widget.pollModel.crownerName,
                authorDisplayName: widget.pollModel.crownerName,
                authorAvatarUrl: widget.pollModel.crownerImage,
                createdAt: DateTime.now(),
                channelId: widget.pollModel.id,
                channelName: widget.pollModel.title,
                caption: widget.option.description,
                videoUrl: widget.option.mediaUrl,
                isVideo: true,
                likes: _crowns,
              ),
            ],
            initialIndex: 0,
            channelId: widget.pollModel.id,
          ),
        ),
      );
    } else if (widget.option.mediaType == CrownMediaType.audio) {
      Navigator.push(
        context,
        _slideUpRoute(
          AudioPlayerPage(
            audioUrl: widget.option.mediaUrl ?? "",
            likes: _crowns,
            title: widget.option.description.isNotEmpty
                ? widget.option.description
                : widget.pollModel.title,
            artist: widget.pollModel.crownerName.isNotEmpty
                ? widget.pollModel.crownerName
                : "Unknown Artist",
            userImageUrl: widget.pollModel.crownerImage,
            coverUrl:
                "https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=500&auto=format&fit=crop", // placeholder art!
          ),
        ),
      );
    }
  }

  void _openCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentingSheet(
        linkedPostId: widget.option.id,
        linkedAuthorUsername: widget.pollModel.crownerName,
        linkedCaption: widget.option.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,
      floatingActionButton: ChartButton(
        onTap: _openCommentSheet,
        currentColor: widget.themeColor,
      ),
      appBar: ChartAppBar(
        title: widget.pollModel.title,
        backgroundColor: theme.scaffoldBackgroundColor,
        titleWidget: AnimatedOpacity(
          opacity: _showTitleInAppBar ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.pollModel.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              Text(
                widget.option.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ExpandableCrownText(
                            text: widget.pollModel.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ExpandableCrownText(
                            text: widget.option.description,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // 2 & 3. Row with Poll Card and Button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // 3. CrownPollCard (The widget carrying media and data)
                              CrownPollCard(
                                option: widget.option.copyWith(
                                  crowns: _crowns,
                                  isMe: _isMe,
                                ),
                                themeColor: widget.themeColor,
                                onTap: _handleMediaTap,
                                width: 140, // Larger size for detail page
                                height: 200,
                              ),
                              SizedBox(width: 20.w),

                              // 2. Crown Button
                              Expanded(
                                child: CrownButton(
                                  isMe: _isMe,
                                  crowns: _crowns,
                                  themeColor: widget.themeColor,
                                  onTap: _handleCrown,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 100.h),
                  sliver:
                      ValueListenableBuilder<
                        PagingState<int, Map<String, dynamic>>
                      >(
                        valueListenable: _pagingController,
                        builder: (context, state, _) =>
                            PagedSliverList<int, Map<String, dynamic>>(
                              state: state,
                              fetchNextPage: _pagingController.fetchNextPage,
                              builderDelegate:
                                  PagedChildBuilderDelegate<
                                    Map<String, dynamic>
                                  >(
                                    itemBuilder: (context, item, index) =>
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            20.w,
                                            0,
                                            20.w,
                                            20.h,
                                          ),
                                          child: CommentCard(
                                            memberName: item["name"],
                                            messageText: item["text"],
                                            outlineColor: widget.themeColor,
                                            likes: 12 + (index * 3),
                                            comments: 2,
                                          ),
                                        ),
                                  ),
                            ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
