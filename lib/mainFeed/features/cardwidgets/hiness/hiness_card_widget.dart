import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/mainFeed/features/cardwidgets/models/hiness_model.dart';
import 'package:flutter/material.dart';
import '../../../../features/widgets/memberimage/starter_image.dart';

import '../../../../features/chartbutton/chart_button.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/like/like.dart';
import '../../../../../features/widgets/channelmemberdata/comment_card/comment_action/comments/comment.dart';
import '../../../menu/main_feed_menu.dart';
import '../../../../features/channel/pages/channel_page.dart';

class EliteCardWidget extends StatefulWidget {
  final EliteModel data;
  final VoidCallback? onTap;

  const EliteCardWidget({super.key, required this.data, this.onTap});

  @override
  State<EliteCardWidget> createState() => _EliteCardWidgetState();
}

class _EliteCardWidgetState extends State<EliteCardWidget> {
  late bool _isCharted;
  late int _currentPoints;

  @override
  void initState() {
    super.initState();
    _isCharted = widget.data.isCharted;
    _currentPoints = widget.data.totalPoints;
  }

  void _onChartTap() {
    setState(() {
      if (_isCharted) {
        _currentPoints--;
        _isCharted = false;
      } else {
        _currentPoints++;
        _isCharted = true;
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChannelPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildWinnerHeader(context, themeColor, data),
        _buildMediaContent(data),
        _buildPostFooter(context, themeColor, data),
      ],
    );
  }

  Widget _buildWinnerHeader(
    BuildContext context,
    Color themeColor,
    EliteModel data,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          MemberImage(
            imageUrl: data.winnerAvatar,
            size: 40.w,
            showStatusRing: true,
            borderWidth: 1.5,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data.winnerName.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.stars_rounded, color: themeColor, size: 16.sp),
                  ],
                ),
                Text(
                  data.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: themeColor.withValues(alpha: 0.8),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () => MainFeedMenu.show(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(EliteModel data) {
    switch (data.mediaType) {
      case EliteMediaType.audio:
        return Container(
          height: 300.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.4),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note_rounded,
                size: 80.sp,
                color: const Color(0xFFFFB800),
              ),
              SizedBox(height: 16.h),
              Text(
                'PREMIUM AUDIO CONTENT',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      case EliteMediaType.video:
        return Container(
          height: 300.h,
          width: double.infinity,
          color: Colors.black,
          child: Center(
            child: Icon(
              Icons.play_circle_filled_rounded,
              size: 80.sp,
              color: Colors.white,
            ),
          ),
        );
      case EliteMediaType.image:
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 500.h,
            minWidth: double.infinity,
          ),
          child: Image.network(
            data.mediaUrl,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 300.h,
                color: Colors.grey.withValues(alpha: 0.1),
                child: const Center(
                  child: Icon(Icons.image_not_supported_rounded),
                ),
              );
            },
          ),
        );
    }
  }

  Widget _buildPostFooter(
    BuildContext context,
    Color themeColor,
    EliteModel data,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LikeAction(
                initialLikes: data.likes,
                initialIsLiked: data.isLiked,
                themeColor: Colors.yellow,
                iconSize: 24.sp,
              ),
              SizedBox(width: 16.w),
              CommentActionWidget(
                initialComments: data.comments,
                themeColor: Colors.yellow,
                iconSize: 24.sp,
              ),
              const Spacer(),
              ChartButton(
                onTap: _onChartTap,
                chartPoints: _currentPoints,
                isCharted: _isCharted,
                iconSize: 24.sp,
                fontSize: 11.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              MemberImage(
                imageUrl: data.channelCreatorAvatar,
                size: 24.w,
                borderWidth: 1,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Created by ${data.channelCreatorName} in ${data.channelName}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}











