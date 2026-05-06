import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/allchannels/dummydata/channel_dummy_data.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/channel/application/channels_list_controller.dart';
import 'package:crown/features/newinsidechartstartpage/models/chart.dart';
import 'package:crown/mainFeed/features/cardwidgets/storychacrdwidget/status_page.dart';
import 'package:crown/profile/channels/widgets/active_channel_circle.dart';
import 'package:crown/profile/channels/widgets/create_channel_circle.dart';
import 'package:crown/profile/chart/dummydata/dummy_chart_data.dart'
    as chart_data;
import 'package:crown/profile/chart/models/chart_chart.dart';
import 'package:crown/profile/chart/pages/chart_detail_page.dart';
import 'package:crown/profile/chart/widgets/chart_list_item.dart';
import 'package:crown/profile/chart/widgets/sheets/inbox_options_sheet.dart';
import 'package:crown/profile/widgets/charters/channel_filter_chips.dart';
import 'package:crown/profile/widgets/charters/chart_channel_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChannelsPage extends ConsumerStatefulWidget {
  const ChannelsPage({super.key});

  @override
  ConsumerState<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends ConsumerState<ChannelsPage> {
  int _currentIndex = 0;
  late final PageController _pageController;

  final List<String> _filters = [
    'inbox',
    'channels',
    'all',
    'private',
    'public',
    'Chart_in',
    'favorite',
  ];

  static const _pageSize = 10;

  // Initial paging controller for 'Inbox' fallback
  late final PagingController<int, dynamic> _pagingController =
      PagingController<int, dynamic>(
        fetchPage: (pageKey) async {
          await Future.delayed(const Duration(milliseconds: 500));
          List<dynamic> sourceList = chart_data.dummyCharts;
          final startIndex = pageKey;
          final endIndex = (startIndex + _pageSize).clamp(0, sourceList.length);
          if (startIndex >= sourceList.length) return [];
          return sourceList.sublist(startIndex, endIndex);
        },
        getNextPageKey: (state) {
          final totalFetched =
              state.pages?.fold(0, (sum, page) => sum + page.length) ?? 0;
          if (totalFetched >= chart_data.dummyCharts.length) return null;
          return totalFetched;
        },
      );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void _updateFilter(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ChartAppBar(
        title: context.tr('channels_title'),
        showBack: false,
        backgroundColor: backgroundColor,
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 16.sp,
          letterSpacing: 0.5,
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          // 🏆 Filter Chips (STAYS FIXED)
          ChannelFilterChips(
            filters: _filters,
            activeFilter: _filters[_currentIndex],
            onFilterChanged: (filter) {
              final idx = _filters.indexOf(filter);
              if (idx != -1) _updateFilter(idx);
            },
            localize: true,
          ),

          // 🌊 Scrollable content: Paged Pages
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _filters.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return _PageContent(
                  filter: _filters[index],
                  pagingController: _pagingController,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PageContent extends ConsumerWidget {
  final String filter;
  final PagingController<int, dynamic> pagingController;

  const _PageContent({required this.filter, required this.pagingController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      key: PageStorageKey<String>(filter),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // 1. Horizontal Suggested/Active Channels
        SliverToBoxAdapter(child: _buildActiveChannels(context, ref)),

        const SliverToBoxAdapter(
          child: Divider(height: 1, thickness: 0.5, color: Colors.white10),
        ),

        // 2. The Main Conversations List
        _buildSliverChannelsList(context, ref, filter),
      ],
    );
  }

  Widget _buildSliverChannelsList(
    BuildContext context,
    WidgetRef ref,
    String filter,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUserId = ref.watch(authControllerProvider).user?.id;

    // === INBOX mode: (Mixed Dummy + Real Logic) ===
    if (filter == 'inbox') {
      return ValueListenableBuilder<PagingState<int, dynamic>>(
        valueListenable: pagingController,
        builder: (context, state, _) => PagedSliverList<int, dynamic>(
          state: state,
          fetchNextPage: pagingController.fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            itemBuilder: (context, item, index) =>
                ChartListItem(chart: item as ChartChart),
            noItemsFoundIndicatorBuilder: (context) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    context.tr('no_channels_found'),
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // === CHANNEL modes: driven by real Supabase data ===
    // 👑 ALWAYS fetch only the channels the user is joined in or owns
    final channelsState = ref.watch(channelsListControllerProvider('joined'));

    if (channelsState.status == ChannelsListStatus.loading &&
        channelsState.channels.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (channelsState.status == ChannelsListStatus.error &&
        channelsState.channels.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Text(
              channelsState.error ?? 'Something went wrong',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
            ),
          ),
        ),
      );
    }

    // Client-side filtering based on the selected tab
    final displayChannels = channelsState.channels.where((ch) {
      if (filter == 'private') return ch.isPrivate;
      if (filter == 'public') return !ch.isPrivate;
      return true; // 'all' or 'channels' show everything they joined
    }).toList();

    if (displayChannels.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Text(
              context.tr('no_channels_found'),
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final entity = displayChannels[index];
        final channel = Chart(
          id: entity.id,
          title: entity.name,
          description: entity.description,
          imageUrl: entity.avatarUrl.isNotEmpty ? entity.avatarUrl : null,
          memberCount: entity.memberCount,
          staterName: entity.creatorName ?? entity.name,
          staterAvatarUrl:
              entity.creatorAvatarUrl ??
              (entity.avatarUrl.isNotEmpty ? entity.avatarUrl : null),
          leaderAvatarUrl: entity.leaderAvatarUrl ?? entity.creatorAvatarUrl,
          unreadCount: entity.unreadCount,
          isOwnChannel: entity.creatorId == currentUserId,
          isCharted: entity.isCharted,
          isPrivate: entity.isPrivate,
        );

        return ChartChannelListItem(
          channel: channel,
          isChartedIn: entity.isCharted,
          index: index,
        );
      }, childCount: displayChannels.length),
    );
  }

  Widget _buildActiveChannels(BuildContext context, WidgetRef ref) {
    final personalChannels = dummyChannels
        .where((c) => c.isOwnChannel || c.isCharted)
        .toList();

    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: personalChannels.isEmpty && dummyChannels.isNotEmpty
            ? 1
            : personalChannels.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return const CreateChannelCircle();

          final channel = personalChannels[index - 1];
          final hasStatus = index % 4 == 0;
          final userName = channel.staterName?.split(' ').first ?? 'User';

          return ActiveChannelCircle(
            imageUrl: channel.staterAvatarUrl,
            name: userName,
            hasUpdate: hasStatus,
            onTap: () {
              final dummyChart = ChartChart(
                id: 'active_$index',
                senderName: userName,
                senderAvatarUrl: channel.staterAvatarUrl,
                lastMessage: 'Active recently',
                timestamp: DateTime.now(),
              );

              if (hasStatus) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => InboxOptionsSheet(
                    userName: userName,
                    userAvatar: channel.staterAvatarUrl,
                    onViewStatus: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatusPage(
                            username: userName,
                            userProfileImageUrl: channel.staterAvatarUrl ?? '',
                            statusImageUrl:
                                'https://picsum.photos/seed/status_$index/1080/1920',
                            isChartable: true,
                            isPublic: true,
                          ),
                        ),
                      );
                    },
                    onOpenChat: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChartDetailPage(chart: dummyChart),
                        ),
                      );
                    },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartDetailPage(chart: dummyChart),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
