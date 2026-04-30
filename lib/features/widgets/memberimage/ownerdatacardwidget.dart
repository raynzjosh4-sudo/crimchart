import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';

class OwnerDataCardWidget extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> videoUrls;
  final String? audioUrl;
  final String? messageText;

  const OwnerDataCardWidget({
    super.key,
    this.imageUrls = const [],
    this.videoUrls = const [],
    this.audioUrl,
    this.messageText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ── ONLY SHOW IF THERE IS CONTENT ──
    if (imageUrls.isEmpty && videoUrls.isEmpty && audioUrl == null && (messageText == null || messageText!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 1. MESSAGE TEXT ( Manifesto / Prompt ) ──
          if (messageText != null && messageText!.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                messageText!,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

          // ── 2. IMAGE GALLERY ( Grid Logic ) ──
          if (imageUrls.isNotEmpty)
            _buildImageGrid(context, imageUrls),

          // ── 3. VIDEO SHOWCASE ──
          if (videoUrls.isNotEmpty)
            _buildVideoGrid(context, videoUrls),

          // ── 4. AUDIO BAR ──
          if (audioUrl != null)
            _buildAudioPlayer(context, audioUrl!),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> urls) {
    // 🎭 SMART GRID LOGIC 🏁
    if (urls.length == 1) {
      return _buildHeroMedia(urls.first);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: AspectRatio(
        aspectRatio: urls.length >= 2 ? 1.5 : 1.0,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: urls.length >= 2 ? 2 : 1,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1.2,
          ),
          itemCount: urls.length.clamp(1, 4), // Cap nicely at 4 for this preview
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                urls[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoGrid(BuildContext context, List<String> urls) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        children: urls.map((url) => Container(
          height: 180.h,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 48.sp,
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildHeroMedia(String url) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250.h,
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(BuildContext context, String url) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.audiotrack, color: const Color(0xFFFFD700), size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Channel Theme Audio',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '0:00 / 3:45',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.sp),
        ],
      ),
    );
  }
}
