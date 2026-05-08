import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ManifestoGridWidget extends StatelessWidget {
  final List<String> imageUrls;
  final bool isVideo;

  const ManifestoGridWidget({
    super.key,
    required this.imageUrls,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isVideo ? "Featured Videos" : "Featured",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 200.h,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildMediaItem(imageUrls.isNotEmpty ? imageUrls[0] : null),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildMediaItem(imageUrls.length > 1 ? imageUrls[1] : null),
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildMediaItem(imageUrls.length > 2 ? imageUrls[2] : null)),
                            SizedBox(width: 8.w),
                            Expanded(child: _buildMediaItem(imageUrls.length > 3 ? imageUrls[3] : null)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(String? url) {
    if (url == null) return const SizedBox.shrink();
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: ChartImage(
            url: url,
            fit: BoxFit.cover,
          ),
        ),
        if (isVideo)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.black26,
              ),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 14.r,
                  child: Icon(
                    LucideIcons.play,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
