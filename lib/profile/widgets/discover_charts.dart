import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/profile/dummydata/profile_dummy_data.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:crown/profile/widgets/ChartCard/channelcard.dart';
import 'package:crown/profile/widgets/skeleton_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class discoverTops extends StatefulWidget {
  final List<CharterModel> suggestions;
  final VoidCallback? onSeeAll;

  const discoverTops({super.key, required this.suggestions, this.onSeeAll});

  @override
  State<discoverTops> createState() => _discoverTopsState();
}

class _discoverTopsState extends State<discoverTops> {
  static const int _pageSize = 3;
  late final PagingController<int, CharterModel> _pagingController =
      PagingController<int, CharterModel>(
        fetchPage: (pageKey) async {
          await Future.delayed(const Duration(milliseconds: 1500));
          final allSuggestions = suggestedCharts;
          final start = pageKey;
          final end = (start + _pageSize).clamp(0, allSuggestions.length);
          if (start >= allSuggestions.length) {
            return allSuggestions.take(_pageSize).toList();
          }
          return allSuggestions.sublist(start, end);
        },
        getNextPageKey: (state) {
          final totalRecords =
              state.pages?.fold(0, (sum, page) => sum + page.length) ?? 0;
          if (totalRecords >= 15) return null;
          return totalRecords;
        },
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('channels'), // Plural header label
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 15.sp,
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: widget.onSeeAll,
                child: Text(
                  context.tr('see_all'),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260.h,
          child: ValueListenableBuilder<PagingState<int, CharterModel>>(
            valueListenable: _pagingController,
            builder: (context, state, _) => PagedListView<int, CharterModel>(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              state: state,
              fetchNextPage: _pagingController.fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<CharterModel>(
                itemBuilder: (context, item, index) {
                  return DiscoverCard(
                    model: item,
                    width: 220.w,
                    onRemove: () {
                      suggestedCharts.removeWhere(
                        (element) => element.id == item.id,
                      );
                      _pagingController.refresh();
                    },
                  );
                },
                firstPageProgressIndicatorBuilder: (_) => Row(
                  children: List.generate(
                    3,
                    (_) => SkeletonChartCard(width: 220.w),
                  ),
                ),
                newPageProgressIndicatorBuilder: (_) =>
                    SkeletonChartCard(width: 220.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}











