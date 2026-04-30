import 'package:crown/backicon/custom_back_button.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../widgets/explore_grid_item.dart';
import '../models/explore_item_model.dart';
import '../../mainFeed/dummydata/explore_dummy_data.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const int _pageSize = 10;
  late final PagingController<int, ExploreItemModel> _pagingController =
      PagingController<int, ExploreItemModel>(
        fetchPage: (pageKey) async {
          await Future.delayed(const Duration(milliseconds: 1500));
          final allSuggestions = dummyExploreItems;
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
          if (totalRecords >= dummyExploreItems.length) return null;
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar Area
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    CustomBackButton(
                      onPressed: () => Navigator.pop(context),
                      size: 28.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(25.w),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.search,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: context.tr('search_hint'),
                                  hintStyle: TextStyle(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      context.tr('search_button'),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid Content
            SliverPadding(
              padding: EdgeInsets.all(12.w),
              sliver:
                  ValueListenableBuilder<PagingState<int, ExploreItemModel>>(
                    valueListenable: _pagingController,
                    builder: (context, state, _) =>
                        PagedSliverMasonryGrid<int, ExploreItemModel>.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.w,
                          crossAxisSpacing: 10.w,
                          state: state,
                          fetchNextPage: _pagingController.fetchNextPage,
                          builderDelegate:
                              PagedChildBuilderDelegate<ExploreItemModel>(
                                itemBuilder: (context, item, index) {
                                  return ExploreGridItem(item: item);
                                },
                                firstPageProgressIndicatorBuilder: (_) =>
                                    SingleChildScrollView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: Wrap(
                                        spacing: 12.w,
                                        runSpacing: 12.w,
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: List.generate(10, (index) {
                                          final ratios = [
                                            1.2,
                                            0.8,
                                            1.4,
                                            0.9,
                                            1.1,
                                            1.3,
                                            0.7,
                                            1.5,
                                            1.0,
                                            1.2,
                                          ];
                                          return SizedBox(
                                            width:
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.width -
                                                    40.w) /
                                                2,
                                            child:
                                                SkeletonExploreGrid_item_FIX_ME(
                                                  aspectRatio: ratios[index],
                                                ),
                                          );
                                        }),
                                      ),
                                    ),
                                newPageProgressIndicatorBuilder: (_) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// Temporary helper until Skeleton item is updated or fixed
class SkeletonExploreGrid_item_FIX_ME extends StatelessWidget {
  final double aspectRatio;
  const SkeletonExploreGrid_item_FIX_ME({super.key, required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }
}











