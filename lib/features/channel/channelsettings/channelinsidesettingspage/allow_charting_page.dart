import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/widgets/chart_linear_loader.dart';
import 'package:crown/features/allchannels/dummydata/channel_dummy_data.dart';
import 'package:crown/features/allchannels/models/chart_channel.dart';
import 'package:crown/features/widgets/chartcard/models/media_data.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../newinsidechartstartpage/models/member.dart';
import '../../../newinsidechartstartpage/dummydata/dummy_data.dart';
import '../../../newinsidechartstartpage/widgets/membermediadata/member_media_data_sheet.dart';

class _SelectedChartItem {
  final Member member;
  final MediaData media;
  _SelectedChartItem(this.member, this.media);
}

class AllowChartingPage extends StatefulWidget {
  const AllowChartingPage({super.key});

  @override
  State<AllowChartingPage> createState() => _AllowChartingPageState();
}

class _AllowChartingPageState extends State<AllowChartingPage> {
  static const int _pageSize = 10;

  late PagingController<int, ChartChannel> _channelPagingController;

  final List<_SelectedChartItem> _selectedItems = [];
  final TextEditingController _titleController = TextEditingController();

  String _searchQuery = '';
  bool _isCharting = false;

  Future<void> _submitChart() async {
    setState(() => _isCharting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isCharting = false);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _channelPagingController = PagingController<int, ChartChannel>(
      fetchPage: _fetchChannelPage,
      getNextPageKey: (state) {
        final total = state.pages?.fold(0, (s, p) => s + p.length) ?? 0;
        final filteredCount = _searchQuery.isEmpty
            ? dummyChannels.length
            : dummyChannels
                  .where((c) => c.title.toLowerCase().contains(_searchQuery))
                  .length;
        return total >= filteredCount ? null : total;
      },
    );
  }

  Future<List<ChartChannel>> _fetchChannelPage(int pageKey) async {
    final start = pageKey;
    final filteredList = dummyChannels
        .where((c) => c.title.toLowerCase().contains(_searchQuery))
        .toList();
    final end = (start + _pageSize).clamp(0, filteredList.length);
    if (start >= filteredList.length) return [];
    return filteredList.sublist(start, end);
  }

  @override
  void dispose() {
    _channelPagingController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (_selectedItems.isNotEmpty) {
      setState(() {
        _selectedItems.clear();
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverChartAppBar(
            title: _selectedItems.isNotEmpty ? 'NEW Chart' : 'Chart',
            centerTitle: false,
            pinned: true,
            showBack: true,
            onBack: _onBack,
            titleStyle: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),

          if (_isCharting)
            SliverToBoxAdapter(
              child: ChartLinearLoader(
                color: colorScheme.primary,
                height: 3,
                isLoading: false,
              ),
            ),

          if (_selectedItems.isNotEmpty) ...[
            // ── Final Customization View Header ──
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.h),
                  // Horizontal Selections List
                  SizedBox(
                    height: 80.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final item = _selectedItems[index];
                        return Container(
                          width: 200.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surfaceContainerHighest
                                .withOpacity(0.5),
                            border: Border.all(
                              color: colorScheme.onSurface.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Small Media
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(11),
                                  bottomLeft: Radius.circular(11),
                                ),
                                child: Image.network(
                                  item.media.thumbnailUrl ??
                                      item.media.contentUrl,
                                  width: 60.w,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60.w,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MemberImage(
                                      size: 24.h,
                                      imageUrl: item.member.avatarUrl,
                                      showActiveDot: false,
                                      showStatusRing: false,
                                      borderWidth: 0,
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      item.member.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 18.h,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(
                                    () => _selectedItems.removeAt(index),
                                  );
                                },
                              ),
                              SizedBox(width: 8.w),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Setup Form
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Chart TITLE',
                          style: TextStyle(
                            color: colorScheme.primary.withOpacity(0.8),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: _titleController,
                          maxLength: 250,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter a creative title...',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.3),
                              fontSize: 18.sp,
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest
                                .withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Confirm Button
                        ElevatedButton(
                          onPressed: _isCharting ? null : _submitChart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            disabledBackgroundColor: colorScheme.primary
                                .withOpacity(0.7),
                            foregroundColor: colorScheme.onPrimary,
                            padding: EdgeInsets.zero,
                            minimumSize: Size(double.infinity, 56.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Chart',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Subtle Divider
            SliverToBoxAdapter(
              child: Divider(
                color: colorScheme.onSurface.withOpacity(0.05),
                height: 32.h,
                thickness: 8.h,
              ),
            ),
          ],

          // ── Persistent Channel/Member Selection List ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
              child: ListTile(
                onTap: () async {
                  final selfMember = Member(
                    id: 'self',
                    name: 'Charting Myself',
                    avatarUrl:
                        'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
                  );
                  final selectedMedia = await showModalBottomSheet<MediaData>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) =>
                        MemberMediaDataSheet(member: selfMember),
                  );

                  if (selectedMedia != null && mounted) {
                    setState(() {
                      _selectedItems.add(
                        _SelectedChartItem(selfMember, selectedMedia),
                      );
                    });
                  }
                },
                contentPadding: EdgeInsets.zero,
                leading: MemberImage(
                  size: 44.h,
                  imageUrl:
                      'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
                  borderWidth: 1.5,
                  showStatusRing: false,
                  showActiveDot: false,
                ),
                title: Text(
                  'Charting Myself',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Container(
                  width: 24.h,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.onSurface.withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Channels Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 24.h, 16.w, 12.h),
              child: Text(
                'CHOOSE FROM CHANNELS',
                style: TextStyle(
                  color: colorScheme.primary.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Search Field
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 12.h),
              child: SizedBox(
                height: 48.h,
                child: TextField(
                  onChanged: (value) {
                    _searchQuery = value;
                    _channelPagingController.refresh();
                  },
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search channel or Charter...',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorScheme.onSurface.withOpacity(0.4),
                      size: 20.h,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withOpacity(
                      0.3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ),
          ),

          // Expandable Channels List
          ValueListenableBuilder<PagingState<int, ChartChannel>>(
            valueListenable: _channelPagingController,
            builder: (context, state, _) => PagedSliverList<int, ChartChannel>(
              state: state,
              fetchNextPage: _channelPagingController.fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<ChartChannel>(
                itemBuilder: (context, channel, index) =>
                    _buildChannelTile(channel, index),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                noItemsFoundIndicatorBuilder: (_) => const SizedBox.shrink(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildChannelTile(ChartChannel channel, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    // Simulate real member dispersion based on channel index
    final startIndex = (index * 3) % dummyMembers.length;
    final channelMembers = dummyMembers.skip(startIndex).take(5).toList();
    if (channelMembers.length < 5) {
      channelMembers.addAll(dummyMembers.take(5 - channelMembers.length));
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey('channel_${channel.title}'),
        tilePadding: const EdgeInsets.symmetric(horizontal: 18),
        leading: MemberImage(
          size: 44.h,
          imageUrl: channel.imageUrl,
          borderWidth: 1.5,
          showStatusRing: false,
          showActiveDot: false,
        ),
        title: Text(
          channel.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        subtitle: Text(
          '${channel.memberCount} members',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
            fontSize: 13.sp,
          ),
        ),
        childrenPadding: EdgeInsets.only(bottom: 8.h),
        children: channelMembers
            .map((member) => _buildMemberTile(member))
            .toList(),
      ),
    );
  }

  Widget _buildMemberTile(Member member) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () async {
        final selectedMedia = await showModalBottomSheet<MediaData>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MemberMediaDataSheet(member: member),
        );

        if (selectedMedia != null && mounted) {
          setState(() {
            _selectedItems.add(_SelectedChartItem(member, selectedMedia));
          });
        }
      },
      contentPadding: EdgeInsets.only(left: 64.w, right: 18.w),
      leading: MemberImage(
        size: 30.h,
        imageUrl: member.avatarUrl,
        borderWidth: 1.5,
        showStatusRing: false,
        showActiveDot: false,
      ),
      title: Text(
        member.name,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
      trailing: Container(
        width: 20.h,
        height: 20.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.15),
            width: 2,
          ),
        ),
      ),
    );
  }
}











