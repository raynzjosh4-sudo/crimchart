import 'dart:convert';

import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/features/newinsidechartstartpage/widgets/pagination_indicators.dart';
import 'package:crown/features/widgets/shimmer/shimmer_effect.dart';
import 'package:crown/mainFeed/dummydata/feed_dummy_data.dart';
import 'package:crown/mainFeed/features/bottomappbar/widgets/main_bottom_app_bar.dart';
import 'package:crown/mainFeed/features/cardwidgets/shimmer/discover_charts_shimmer.dart';
import 'package:crown/mainFeed/features/cardwidgets/shimmer/main_feed_card_shimmer.dart';
import 'package:crown/mainFeed/features/cardwidgets/shimmer/story_list_shimmer.dart';
import 'package:crown/mainFeed/features/mainfeedcard/main_feed_card.dart';
import 'package:crown/mainFeed/features/mainfeedcard/models/main_feed_card_type_model.dart';
import 'package:crown/posting/pages/post_page.dart';
import 'package:crown/profile/channels/pages/channels_page.dart';
import 'package:crown/profile/pages/profile_page.dart';
import 'package:crown/video/pages/video_feed_page.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:crown/mainFeed/pages/export.dart';
import 'package:flutter/material.dart';
import 'package:crown/core/db/feed_repository.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:crown/mainFeed/features/cardwidgets/models/channel_post_model.dart';
import 'package:crown/mainFeed/features/search/native_search_delegate.dart';

class MainFeedPage extends StatefulWidget {
  final int initialIndex;
  const MainFeedPage({super.key, this.initialIndex = 0});

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  late int _selectedIndex;
  final _feedRepo = FeedRepository();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  bool _isRefreshing = false;
  static const int _pageSize = 2;

  Map<String, dynamic> _dbRowFromChannelPost(ChannelPostModel post) {
    return {
      'id': post.id,
      'username': post.username,
      'userProfileImageUrl': post.userProfileImageUrl,
      'channelName': post.channelName,
      'channelId': post.channelId,
      'caption': post.caption,
      'videoUrl': post.videoUrl,
      'isVideo': post.isVideo ? 1 : 0,
      'aspectRatio': post.aspectRatio ?? 1.0,
      'likes': post.likes,
      'comments': post.comments,
      'timeAgo': post.timeAgo,
      'isLiked': post.isLiked ? 1 : 0,
      'chartedCount': post.chartedCount,
      'localFileCache': post.localFileCache,
      'isPending': post.isPending,
      'imageUrls': jsonEncode(post.imageUrls),
      'createdAt': DateTime.now().toIso8601String(),
      'shares': 0,
    };
  }

  MainFeedCardModel _cardFromPost(PostEntity post) {
    final mappedModel = ChannelPostModel(
      id: post.id,
      username: post.authorUsername,
      userProfileImageUrl:
          post.authorAvatarUrl ?? 'https://via.placeholder.com/150',
      channelName: post.channelName,
      channelId: post.channelId,
      imageUrls: post.imageUrls,
      caption: post.caption,
      videoUrl: post.videoUrl,
      isVideo: post.isVideo,
      likes: post.likes,
      comments: post.comments,
      timeAgo: post.timeAgo,
      isLiked: post.isLiked,
      isPending: post.isPending,
      localFileCache: post.localFileCache,
    );

    return MainFeedCardModel(
      id: post.id,
      cardType: MainFeedCardType.channelPost,
      scrollViewType: ScrollViewType.vertical,
      link: '/post/${post.id}',
      itemData: mappedModel,
    );
  }

  late final PagingController<int, MainFeedCardModel> _pagingController =
      PagingController<int, MainFeedCardModel>(
        fetchPage: (pageKey) async {
          final cachedPosts = await _feedRepo.getCachedPosts();
          final cachedCards = cachedPosts.map(_cardFromPost).toList();
          final feedItems = FeedDummyData.feedItems;

          List<MainFeedCardModel> combinedFeed = [];

          // 1. Stories at the absolute top
          final stories = feedItems
              .where((item) => item.cardType == MainFeedCardType.storyList)
              .toList();
          combinedFeed.addAll(stories);

          // 2. Add Dynamic Posts (From DB Cache or Fallback Dummy)
          if (cachedCards.isNotEmpty && !_isRefreshing) {
            combinedFeed.addAll(cachedCards);
          } else {
            if (_isRefreshing)
              await Future.delayed(const Duration(milliseconds: 1500));
            final dummyPosts = feedItems
                .where((item) => item.cardType == MainFeedCardType.channelPost)
                .toList();
            combinedFeed.addAll(dummyPosts);

            final toCache = dummyPosts
                .map((item) => item.itemData)
                .whereType<ChannelPostModel>()
                .map(_dbRowFromChannelPost)
                .toList();
            await _feedRepo.syncPosts(toCache);
          }

          // 3. Add supplemental widgets (Discover, Elite, Tops/Stars)
          final extraSections = feedItems
              .where(
                (item) =>
                    item.cardType != MainFeedCardType.storyList &&
                    item.cardType != MainFeedCardType.channelPost,
              )
              .toList();
          combinedFeed.addAll(extraSections);

          final start = pageKey;
          if (start >= combinedFeed.length) return [];
          final end = (start + _pageSize).clamp(0, combinedFeed.length);
          return combinedFeed.sublist(start, end);
        },
        getNextPageKey: (state) {
          final lastPage = state.pages?.last;
          if (lastPage != null && lastPage.length < _pageSize) {
            return null; // end of list
          }
          final totalRecords =
              state.pages?.fold(0, (sum, page) => sum + page.length) ?? 0;
          return totalRecords;
        },
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PostPage()),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Trigger the refresh on the paging controller
    _pagingController.refresh();

    // We wait for the paging controller to finish its first page load
    // Since fetchPage is async and already has a delay, we just need to wait for it.
    // However, the paging controller doesn't expose a 'completed' future easily.
    // We'll wait a bit longer than the delay to ensure UI transitions well.
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _selectedIndex == 0
          ? RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.transparent,
              backgroundColor: Colors.transparent,
              strokeWidth: 0,
              notificationPredicate: (notification) => true,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverChartAppBar(
                    title: 'Chart',
                    showBack: false,
                    centerTitle: false,
                    showBorder: false,
                    titleStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFB800), // Super gold
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(LucideIcons.search),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: NativeSearchDelegate(),
                          );
                        },
                      ),
                    ],
                  ),
                  if (_isRefreshing)
                    SliverToBoxAdapter(
                      child: ShimmerEffect(
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFB800), // Super gold
                          ),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  ValueListenableBuilder<PagingState<int, MainFeedCardModel>>(
                    valueListenable: _pagingController,
                    builder: (context, state, _) =>
                        PagedSliverList<int, MainFeedCardModel>(
                          state: state,
                          fetchNextPage: _pagingController.fetchNextPage,
                          builderDelegate:
                              PagedChildBuilderDelegate<MainFeedCardModel>(
                                itemBuilder: (context, item, index) {
                                  return MainFeedCard(card: item);
                                },
                                firstPageProgressIndicatorBuilder: (_) =>
                                    Column(
                                      children: const [
                                        StoryListShimmer(),
                                        mainfeedcardShimmer(),
                                        mainfeedcardShimmer(),
                                        discoverTopsShimmer(),
                                      ],
                                    ),
                                newPageProgressIndicatorBuilder: (_) =>
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: mainfeedcardShimmer(),
                                    ),
                                noMoreItemsIndicatorBuilder: (_) =>
                                    const EndOfListIndicator(),
                                firstPageErrorIndicatorBuilder: (_) =>
                                    ErrorIndicator(
                                      onRetry: _pagingController.refresh,
                                    ),
                                newPageErrorIndicatorBuilder: (_) =>
                                    ErrorIndicator(
                                      onRetry: _pagingController.fetchNextPage,
                                      compact: true,
                                    ),
                              ),
                        ),
                  ),
                ],
              ),
            )
          : _selectedIndex == 1
          ? const VideoFeedPage()
          : _selectedIndex == 2
          ? const PostPage()
          : _selectedIndex == 3
          ? const ChannelsPage()
          : _selectedIndex == 4
          ? const ProfilePage(showBack: false)
          : Center(
              child: Text(
                'Coming Soon',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
      bottomNavigationBar: MainBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}











