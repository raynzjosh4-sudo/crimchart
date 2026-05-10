import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:crimchart/video/core/models/feed_video_item.dart';
import 'package:crimchart/mainFeed/features/cardwidgets/storychacrdwidget/status_page.dart';

class ProfileMiniSheet extends StatelessWidget {
  final FeedVideoItem user;

  const ProfileMiniSheet({super.key, required this.user});

  static void show(BuildContext context, FeedVideoItem user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileMiniSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // 1. Header with Background & Avatar
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Background Banner
                    Container(
                      height: 160.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.8),
                            colorScheme.secondary.withValues(alpha: 0.6),
                            colorScheme.tertiary.withValues(alpha: 0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32.r),
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.3,
                        child: user.thumbnailUrl != null
                            ? Image.network(
                                user.thumbnailUrl!,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),

                    // Top Drag Indicator
                    Positioned(
                      top: 12.h,
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),

                    // Avatar Row (Centered Avatar)
                    Positioned(
                      bottom: -40.h,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: MemberImage(
                          imageUrl: user.authorAvatarUrl,
                          size: 100.r,
                          borderWidth: 4.r,
                          showStatusRing: false,
                          showActiveDot: false,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50.h),

                // 2. Channel Name & Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Text(
                        user.title.isNotEmpty
                            ? user.title
                            : '@${user.authorName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        user.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.7,
                          ),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // 3. Action Buttons (Follow + Followers Count)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      // Follow Button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            elevation: 0,
                            minimumSize: Size(0, 52.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                          ),
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Followers Count Display
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 52.h,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(26.r),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1.2k',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // 4. Moments Header & Masonry Grid
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        'Moments',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: theme.textTheme.titleMedium?.color?.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // 👑 High-Fidelity Irregular Grid (Themed Container)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: StaggeredGrid.count(
                          crossAxisCount: 6,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 4,
                              child: _buildGalleryImage(
                                'https://picsum.photos/400/600',
                                0,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 2,
                              child: _buildGalleryImage(
                                'https://picsum.photos/400/300',
                                1,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 2,
                              child: _buildGalleryImage(
                                'https://picsum.photos/400/301',
                                2,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 3,
                              child: _buildGalleryImage(
                                'https://picsum.photos/400/500',
                                3,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 3,
                              child: _buildGalleryImage(
                                'https://picsum.photos/400/501',
                                4,
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 3,
                              child: _buildGalleryImage(
                                'https://picsum.photos/400/502',
                                5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 👑 Helper for Gallery Images with Full-Screen Status Viewer
  Widget _buildGalleryImage(String url, int index) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatusPage(
                statusImageUrl: url,
                username: user.authorName,
                userProfileImageUrl: user.authorAvatarUrl,
                isChartable: true,
                isPublic: true,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.network(url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
