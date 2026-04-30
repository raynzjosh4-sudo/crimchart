import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/profile/dummydata/profile_dummy_data.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:crown/profile/widgets/ChartCard/channelcard.dart';
import 'package:crown/profile/widgets/skeleton_chart_card.dart';
import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class discoverTopsPage extends StatefulWidget {
  const discoverTopsPage({super.key});

  @override
  State<discoverTopsPage> createState() => _discoverTopsPageState();
}

class _discoverTopsPageState extends State<discoverTopsPage> {
  static const int _pageSize = 10;
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
          if (totalRecords >= suggestedCharts.length) return null;
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const ChartAppBar(title: 'Discover Channels', showBack: true),
      body: ValueListenableBuilder<PagingState<int, CharterModel>>(
        valueListenable: _pagingController,
        builder: (context, state, _) =>
            PagedMasonryGridView<int, CharterModel>.extent(
              maxCrossAxisExtent: 220.w,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              state: state,
              fetchNextPage: _pagingController.fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<CharterModel>(
                itemBuilder: (context, item, index) {
                  return DiscoverCard(
                    model: item,
                    width: null, // Let grid assign width dynamically
                    onRemove: () {
                      suggestedCharts.removeWhere((e) => e.id == item.id);
                      _pagingController.refresh();
                    },
                  );
                },
                firstPageProgressIndicatorBuilder: (_) => SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Wrap(
                    spacing: 16.w,
                    runSpacing: 16.h,
                    alignment: WrapAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width:
                            (MediaQuery.of(context).size.width - 48.w) /
                            2, // roughly half width accounting for padding
                        child: const SkeletonChartCard(width: null),
                      ),
                    ),
                  ),
                ),
                newPageProgressIndicatorBuilder: (_) =>
                    const SkeletonChartCard(width: null),
              ),
            ),
      ),
    );
  }
}











