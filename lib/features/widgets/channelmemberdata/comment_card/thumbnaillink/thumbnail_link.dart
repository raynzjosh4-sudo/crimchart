import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'thumbnaillinkmedia/thumbnail_media.dart';
import 'thumbnaillinkmedia/thumbnail_media_type.dart';

class ThumbnailLink extends StatelessWidget {
  final String? username;
  final String? text;
  final String? mediaUrl;
  final ThumbnailMediaType mediaType;
  final String? referenceId;
  final String? channelId;
  final VoidCallback? onTap;
  final Color themeColor;
  final double width;
  final double height;

  const ThumbnailLink({
    super.key,
    this.username,
    this.text,
    this.mediaUrl,
    this.mediaType = ThumbnailMediaType.image,
    this.referenceId,
    this.channelId,
    this.onTap,
    this.themeColor = Colors.blueAccent,
    this.width = 36,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: themeColor.withValues(alpha: 0.08), // ✅ DYNAMIC TINTED GLASS
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // 1. WhatsApp-Style Vertical Accent Bar
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // 2. Text Content (Username + Snippet)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        username ?? 'Contestant',
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 13.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (text != null && text!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          text!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // 3. Media Thumbnail (if exists)
              if (mediaUrl != null)
                Container(
                  width: 44.w,
                  height: 44.h,
                  margin: EdgeInsets.all(4.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.w),
                    child: ThumbnailMedia(
                      mediaUrl: mediaUrl!,
                      mediaType: mediaType,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
