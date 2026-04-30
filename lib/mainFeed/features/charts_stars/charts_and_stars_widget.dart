import 'package:flutter/material.dart';
import '../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../core/utils/responsive_size.dart';
import '../../../../features/channel/pages/channel_page.dart';
import '../../../../features/newinsidechartstartpage/models/chart.dart';
import '../../../../profile/models/charter_model.dart';

class TopsAndStarsWidget extends StatelessWidget {
  final List<CharterModel> models;
  final VoidCallback? onSeeAll;

  const TopsAndStarsWidget({super.key, required this.models, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 250.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TopS & StarS'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    letterSpacing: 1.5,
                  ),
                ),
                if (onSeeAll != null)
                  GestureDetector(
                    onTap: onSeeAll,
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: models.length,
              itemBuilder: (context, index) {
                final model = models[index];
                return _TopStarItem(id: model.id, model: model);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopStarItem extends StatelessWidget {
  final String id;
  final CharterModel model;

  const _TopStarItem({required this.id, required this.model});

  /// Builds a minimal [Chart] channel shell for this Top/Star so we can
  /// navigate to [ChannelPage] without a real backend yet.
  Chart _buildChannelShell() {
    return Chart(
      id: model.id,
      title:
          '${model.title} of ${model.category}${model.currentChartName != null ? ' — ${model.currentChartName}' : ''}',
      imageUrl: model.mediaThumbnailUrl ?? model.profileImageUrl,
      staterName: model.displayName,
      staterAvatarUrl: model.profileImageUrl,
      leaderAvatarUrl: model.profileImageUrl,
      memberCount: model.chartCount,
      isPrivate: false,
      isActive: model.isActive,
      contestants: [model, ...model.competitors],
    );
  }

  void _navigateToChannel(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChannelPage(
          channel: _buildChannelShell(),
          contestants: [model, ...model.competitors],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isStar = model.title.toLowerCase().contains('Star');

    return GestureDetector(
      onTap: () => _navigateToChannel(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                MemberImage(
                  imageUrl: model.profileImageUrl,
                  size: 90.w,
                  useHexagon: false,
                  showStatusRing: true,
                  ringColor: isStar
                      ? Colors.pinkAccent
                      : const Color(0xFFFFB800),
                  borderWidth: 3.w,
                ),
                Positioned(
                  bottom: 2.w,
                  right: 2.w,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isStar
                          ? Colors.pinkAccent
                          : const Color(0xFFFFB800),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2.5,
                      ),
                    ),
                    child: Text(
                      '😃',
                      style: TextStyle(fontSize: 24.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              model.displayName,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              '${(model.chartCount / 1000).toStringAsFixed(1)}k pts',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFFFB800).withValues(alpha: 0.9),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}























