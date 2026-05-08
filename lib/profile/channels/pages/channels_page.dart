import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/channel/application/channels_list_controller.dart';
import 'package:crimchart/features/newinsidechartstartpage/models/chart.dart';
import 'package:crimchart/profile/chart/dummydata/dummy_chart_data.dart'
    as chart_data;
import 'package:crimchart/profile/chart/models/chart_chart.dart';
import 'package:crimchart/profile/chart/widgets/chart_list_item.dart';
import 'package:crimchart/profile/widgets/charters/channel_filter_chips.dart';
import 'package:crimchart/profile/widgets/charters/chart_channel_list_item.dart';
import 'package:crimchart/profile/channels/widgets/top_horizontal_widgets/inbox_active_circles.dart';
import 'package:crimchart/profile/channels/widgets/top_horizontal_widgets/channel_status_moments.dart';
import 'package:crimchart/profile/widgets/charters/skeleton_channel_list_item.dart';
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
        // 1. Moments (Horizontal Status/Moments)
        if (filter == 'inbox')
          const SliverToBoxAdapter(child: InboxActiveCircles()),
        
        if (filter == 'channels') ...[
          _buildSectionHeader(context, 'Moments', showAction: false),
          const SliverToBoxAdapter(child: ChannelStatusMoments()),
        ],

        if (filter == 'inbox' || filter == 'channels')
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Colors.white10),
          ),

        // 2. Channels (Main Conversations List)
        if (filter == 'channels')
          _buildSectionHeader(context, 'Channels', actionText: 'Explore'),

        _buildSliverChannelsList(context, ref, filter),

        if (filter == 'channels') ...[
          _buildSectionHeader(context, 'Find channels to follow', showAction: false),
          _buildSliverSuggestedChannelsList(context, ref),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    bool showAction = true,
    String actionText = 'See all',
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 8.h),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            if (showAction)
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverSuggestedChannelsList(BuildContext context, WidgetRef ref) {
    // This would ideally use a different provider for discovery
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Center(
          child: Text(
            'Explore more channels to find new moments',
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
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
          ),
        ),
      );
    }

    // === CHANNEL modes: driven by real Supabase data ===
    // 👑 ALWAYS fetch only the channels the user is joined in or owns
    final channelsState = ref.watch(channelsListControllerProvider('joined'));

    if (channelsState.status == ChannelsListStatus.loading &&
        channelsState.channels.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const SkeletonChannelListItem(),
          childCount: 5,
        ),
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
}
