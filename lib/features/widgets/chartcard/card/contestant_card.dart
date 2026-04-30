import 'package:flutter/material.dart';
import '../models/media_data.dart';
import 'media/image_media.dart';
import 'media/video_media.dart';
import 'media/audio_media.dart';
import '../chartbutton/contestant_add_button.dart';
import '../../../../core/utils/responsive_size.dart';

class ContestantCard extends StatelessWidget {
  final int index;
  final int? buttonIndex;
  final MediaData media;
  final Color borderColor;
  final String? displayName;
  final int? points;

  final GlobalKey? buttonKey;
  final ValueNotifier<int?>? selectedIndexNotifier;
  final VoidCallback? onTap;

  const ContestantCard({
    super.key,
    required this.index,
    this.buttonIndex,
    required this.media,
    required this.borderColor,
    this.displayName,
    this.points,
    this.buttonKey,
    this.selectedIndexNotifier,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              IgnorePointer(
                child: Container(
                  height: 260.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20.w),
                    border: Border.all(color: borderColor, width: 2.5.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17.w),
                    child: _buildMedia(),
                  ),
                ),
              ),
              Positioned(
                bottom: -5.h,
                right: -5.w,
                child: ContestantAddButton(
                  key: buttonKey,
                  cardColor: borderColor,
                  buttonIndex: buttonIndex ?? index,
                  selectedIndexNotifier: selectedIndexNotifier,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            displayName ?? 'Contestor ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          Text(
            points != null ? '${points}kp' : media.resolution,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia() {
    switch (media.type) {
      case MediaType.image:
        return ImageCardMedia(url: media.contentUrl);
      case MediaType.video:
        return VideoCardMedia(url: media.contentUrl);
      case MediaType.audio:
        return AudioCardMedia(
          id: media.postId ?? media.contentUrl,
          url: media.contentUrl,
          thumbnailUrl: media.thumbnailUrl,
          backgroundImageUrl: media.backgroundImageUrl,
          creatorAvatarUrl: media.creatorAvatarUrl,
        );
    }
  }
}





























