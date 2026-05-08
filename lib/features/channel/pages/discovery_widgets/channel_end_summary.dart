import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChannelEndSummary extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final int postCount;
  final int followerCount;
  final int tagsCount;
  final int likesCount;
  final String? handle;

  const ChannelEndSummary({
    super.key,
    required this.title,
    this.imageUrl,
    this.postCount = 0,
    this.followerCount = 0,
    this.tagsCount = 0,
    this.likesCount = 0,
    this.handle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          // Profile Header with overlapping avatar
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Header Background (Channel Image)
              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: imageUrl != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(imageUrl!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.4),
                            BlendMode.darken,
                          ),
                        )
                      : null,
                  gradient: imageUrl == null
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                            colorScheme.surfaceContainerHighest.withValues(alpha: 0.05),
                          ],
                        )
                      : null,
                ),
              ),
              
              // Profile Image
              Positioned(
                top: 70.h,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    backgroundImage: imageUrl != null
                        ? CachedNetworkImageProvider(imageUrl!)
                        : null,
                    child: imageUrl == null
                        ? Icon(Icons.group, size: 40.sp, color: colorScheme.onSurface)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 60.h),
          
          // Title & Handle
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            handle ?? "@${title.toLowerCase().replaceAll(' ', '')}",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          
          SizedBox(height: 50.h),
          
          // Stats Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Posts", _formatCount(postCount)),
                _buildDivider(),
                _buildStatItem("Followers", _formatCount(followerCount)),
                _buildDivider(),
                _buildStatItem("Tags", _formatCount(tagsCount)),
                _buildDivider(),
                _buildStatItem("Likes", _formatCount(likesCount)),
              ],
            ),
          ),
          
          SizedBox(height: 40.h),
          
          // End of feed text
          Text(
            "You've caught up with everything!",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}K";
    }
    return count.toString();
  }
}
