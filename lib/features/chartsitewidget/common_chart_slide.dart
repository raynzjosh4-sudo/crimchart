import 'package:crown/mainFeed/dummydata/charter_star_dummy_data.dart';
import 'package:crown/mainFeed/features/cardwidgets/chartsandstars/widgets/charter_star_avatar_stack.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';

import '../channel/pages/channel_page.dart';
import '../../core/utils/responsive_size.dart';

class CommonChartChartSlide extends StatefulWidget {
  final String username;
  final String userProfileImageUrl;
  final String chartName;
  final int chartPoints;
  final int rank;
  final Color themeColor;

  const CommonChartChartSlide({
    super.key,
    required this.username,
    required this.userProfileImageUrl,
    required this.chartName,
    required this.chartPoints,
    required this.rank,
    required this.themeColor,
  });

  @override
  State<CommonChartChartSlide> createState() => _CommonChartChartSlideState();
}

class _CommonChartChartSlideState extends State<CommonChartChartSlide> {
  final GlobalKey _avatarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Positioned(
            top: 40.h,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.themeColor.withOpacity(0.12),
                    blurRadius: 80,
                    spreadRadius: 10.w,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
            child: Column(
              children: [
                // Top: Top/Star Avatar Stack
                TopStarAvatarStack(
                  person: CharterModel(
                    id: 'current',
                    username: widget.username,
                    displayName: widget.username,
                    profileImageUrl: widget.userProfileImageUrl,
                    title: 'Top',
                    category: widget.chartName,
                    chartCount: widget.chartPoints,
                  ),
                  competitors: dummyTopsStars.take(2).toList(),
                  gold: widget.themeColor,
                  onSwap: (_) {},
                  width: 160.w,
                  height: 120.h,
                  mainSize: 85.w,
                  spacing: 20.w,
                  recipientKey: _avatarKey,
                  onLeaderTap: () {
                    final user = CharterModel(
                      id: 'current',
                      username: widget.username,
                      displayName: widget.username,
                      profileImageUrl: widget.userProfileImageUrl,
                      title: 'Top',
                      category: widget.chartName,
                      chartCount: widget.chartPoints,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChannelPage(contestants: [user]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











