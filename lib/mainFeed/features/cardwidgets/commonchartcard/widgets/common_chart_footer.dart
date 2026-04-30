import 'package:flutter/material.dart';
import '../../../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../../../features/widgets/channelmemberdata/comment_card/comment_action/like/like.dart';
import '../../../../../../features/widgets/channelmemberdata/comment_card/comment_action/comments/comment.dart';
import '../../../../../../features/widgets/channelmemberdata/comment_card/comment_action/comment_action.dart';
import '../../../../../features/chartbutton/chart_button.dart';
import '../../../../../../core/utils/responsive_size.dart';

class CommonChartFooter extends StatelessWidget {
  final String username;
  final String chartName;
  final List<String> mutualFriends;
  final int mutualCount;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isCharted;
  final int chartPoints;
  final Color themeColor;
  final VoidCallback onChartTap;

  const CommonChartFooter({
    super.key,
    required this.username,
    required this.chartName,
    required this.mutualFriends,
    required this.mutualCount,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isCharted,
    required this.chartPoints,
    required this.themeColor,
    required this.onChartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Social Actions Row
          Row(
            children: [
              LikeAction(
                initialLikes: likes,
                initialIsLiked: isLiked,
                themeColor: themeColor,
                iconSize: 22.sp, // Reduced slightly
              ),
              SizedBox(width: 12.w),
              CommentActionWidget(
                initialComments: comments,
                themeColor: themeColor,
                iconSize: 22.sp,
              ),
              SizedBox(width: 12.w),
              CommentAction(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  // TODO: Implement Share functionality
                },
              ),
              const Spacer(),
              // Chart Quick-Nav Button
              ChartButton(
                onTap: onChartTap,
                color: themeColor,
                isCharted: isCharted,
                chartPoints: chartPoints,
                iconSize: 22.sp,
                fontSize: 12.sp,
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Mutual Friends Row
          if (mutualFriends.isNotEmpty)
            Row(
              children: [
                _buildAvatarStack(context),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${mutualFriends.length} mutuals in this Chart',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: themeColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context) {
    final double size = 20.0.w;
    final displayList = mutualFriends.take(3).toList();

    return SizedBox(
      height: size,
      width: size + (displayList.length - 1) * 12.0.w,
      child: Stack(
        children: List.generate(displayList.length, (index) {
          return Positioned(
            left: index * 12.0.w,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: MemberImage(
                size: size - 4.w,
                imageUrl: displayList[index],
                showStatusRing: false,
                showActiveDot: false,
              ),
            ),
          );
        }),
      ),
    );
  }
}











