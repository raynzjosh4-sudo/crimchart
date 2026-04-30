import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../newinsidechartstartpage/models/member.dart';
import '../widgets/charters/charters_list_tile.dart';

class AllChartersPage extends StatefulWidget {
  final List<Member> members;
  final String title;

  const AllChartersPage({
    super.key,
    required this.members,
    required this.title,
  });

  @override
  State<AllChartersPage> createState() => _AllChartersPageState();
}

class _AllChartersPageState extends State<AllChartersPage> {
  static const _pageSize = 15;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";

  late final PagingController<int, Member> _pagingController =
      PagingController<int, Member>(
        fetchPage: (pageKey) async {
          await Future.delayed(const Duration(milliseconds: 300));
          final allFiltered = widget.members
              .where(
                (m) => m.name.toLowerCase().contains(_searchTerm.toLowerCase()),
              )
              .toList();

          final start = pageKey;
          final end = (start + _pageSize).clamp(0, allFiltered.length);

          if (start >= allFiltered.length) {
            return [];
          }
          return allFiltered.sublist(start, end);
        },
        getNextPageKey: (state) {
          final totalRecords =
              state.pages?.fold<int>(0, (sum, page) => sum + page.length) ?? 0;
          final allFilteredCount = widget.members
              .where(
                (m) => m.name.toLowerCase().contains(_searchTerm.toLowerCase()),
              )
              .length;

          if (totalRecords >= allFilteredCount) return null;
          return totalRecords;
        },
      );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchTerm != _searchController.text) {
        setState(() {
          _searchTerm = _searchController.text;
        });
        _pagingController.refresh();
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: widget.title, showBack: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search ${widget.title.toLowerCase()}...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 18.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.1,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<PagingState<int, Member>>(
              valueListenable: _pagingController,
              builder: (context, state, _) => PagedListView<int, Member>(
                state: state,
                fetchNextPage: _pagingController.fetchNextPage,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                builderDelegate: PagedChildBuilderDelegate<Member>(
                  itemBuilder: (context, member, index) {
                    return ChartersListTile(member: member);
                  },
                  firstPageProgressIndicatorBuilder: (_) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  noItemsFoundIndicatorBuilder: (_) =>
                      _buildEmptyState(colorScheme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.users,
            size: 48.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          SizedBox(height: 16.h),
          Text(
            'No matches found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}











