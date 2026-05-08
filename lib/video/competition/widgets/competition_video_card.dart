import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../../mainFeed/features/cardwidgets/models/channel_post_model.dart';
import '../../core/widgets/video_player_widget.dart';
import 'actions/like/competition_like_button.dart';
import 'actions/comment/competition_comment_button.dart';
import 'actions/share/competition_share_button.dart';
import 'actions/chart/competition_gift_button.dart';
import '../../../../gifts/dummydata/gift_dummy_data.dart';
import '../../../../profile/models/charter_model.dart';
import '../../../../gifts/widgets/gift_sheet.dart';
import '../../../../gifts/models/gift_recipient.dart';
import '../../../../gifts/models/gift_model.dart';
import '../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../features/channel/pages/channel_page.dart';

class CompetitionVideoCard extends StatefulWidget {
  final ChannelPostModel post;

  const CompetitionVideoCard({super.key, required this.post});

  @override
  State<CompetitionVideoCard> createState() => _CompetitionVideoCardState();
}

class _CompetitionVideoCardState extends State<CompetitionVideoCard> {
  late PageController _pageController;
  double _currentPage = 0;
  GiftModel? _selectedGift;
  final GlobalKey<CompetitionGiftButtonState> _giftButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _showGifts(BuildContext context, CharterModel? recipient) async {
    final gift = await showModalBottomSheet<GiftModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GiftSheet(
        themeColor: Theme.of(context).primaryColor,
        recipient: recipient != null
            ? GiftRecipient(
                id: recipient.id,
                name: recipient.displayName,
                avatarUrl: recipient.profileImageUrl,
                avatarKey: GlobalKey(),
              )
            : null,
      ),
    );

    if (gift != null && mounted) {
      setState(() {
        _selectedGift = gift;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _giftButtonKey.currentState?.showBurst();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int currentIndex = _currentPage.round();

    final currentUser = currentIndex == 0
        ? null
        : widget.post.chartedContestants[currentIndex - 1];

    final profileImageUrl =
        currentUser?.profileImageUrl ?? widget.post.userProfileImageUrl;
    final displayName = currentUser?.displayName ?? widget.post.username;
    final activeGift =
        _selectedGift ?? dummyGifts[currentIndex % dummyGifts.length];

    return Stack(
      children: [
        // Black base — ensures loading state is always dark, not theme-dependent
        const Positioned.fill(child: ColoredBox(color: Colors.black)),
        PageView.builder(
          controller: _pageController,
          itemCount: widget.post.chartedContestants.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return VideoPlayerWidget(videoUrl: widget.post.videoUrl ?? '');
            }
            final contestant = widget.post.chartedContestants[index - 1];
            return _CompetitorMediaDisplay(competitor: contestant);
          },
        ),

        // Top Actions
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Text(
                      "1.0x",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.15, 0.65, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Right Side Actions
        Positioned(
          right: 16.w,
          bottom: 20.h,
          child: Column(
            children: [
              CompetitionLikeButton(
                initialLikes: widget.post.likes,
                isLiked: widget.post.isLiked,
                onTap: () {},
              ),
              SizedBox(height: 16.h),
              CompetitionCommentButton(
                comments: widget.post.comments,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChannelPage(
                        contestants: widget.post.chartedContestants,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              CompetitionShareButton(onTap: () {}),
              SizedBox(height: 16.h),
              CompetitionGiftButton(
                key: _giftButtonKey,
                gift: activeGift,
                onTap: () {},
                onLongPress: () => _showGifts(context, currentUser),
              ),
            ],
          ),
        ),

        // Bottom Overlay
        Positioned(
          left: 16.w,
          right: 80.w,
          bottom: 24.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                   Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.yellow, width: 2),
                        ),
                        child: MemberImage(imageUrl: profileImageUrl, size: 40.w),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: const Offset(0, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.yellow,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                context.tr('warlord_status').toUpperCase(),
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                widget.post.caption,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 14.sp),
                  SizedBox(width: 6.w),
                  Text(
                    '${context.tr('original_sound')} - ${widget.post.channelName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompetitorMediaDisplay extends StatelessWidget {
  final CharterModel competitor;

  const _CompetitorMediaDisplay({required this.competitor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (competitor.isVideo && competitor.videoUrl != null) {
      return VideoPlayerWidget(videoUrl: competitor.videoUrl!);
    } else if (competitor.isAudio && competitor.audioUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            competitor.mediaThumbnailUrl ?? competitor.profileImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: Colors.black54),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.music_note,
                color: colorScheme.onSurface,
                size: 64.sp,
              ),
            ),
          ),
        ],
      );
    } else {
      return Image.network(
        competitor.profileImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Center(
          child: Icon(
            Icons.person,
            size: 100.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
      );
    }
  }
}











