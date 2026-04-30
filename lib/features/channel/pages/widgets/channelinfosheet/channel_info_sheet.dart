import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'widgets/sheetgrid/pinterest_grid_widget.dart';
import 'widgets/channelcommentslisttile/channel_comment_model.dart';
import 'widgets/dummy_data.dart';
import 'package:crown/features/newinsidechartstartpage/models/channel_post.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:crown/posting/pages/post_page.dart';
import 'package:crown/core/widgets/chart_image.dart';

class ChannelInfoSheet extends StatefulWidget {
  final String? channelId;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? description;
  final List<String?> memberAvatarUrls;
  final ChannelPost? manifesto;
  final List<PostEntity> channelPosts;
  final ScrollController scrollController;
  final ValueListenable<double> sheetExtent;
  final VoidCallback? onDirections;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final VoidCallback? onClose;

  const ChannelInfoSheet({
    super.key,
    this.channelId,
    required this.title,
    required this.scrollController,
    required this.sheetExtent,
    this.subtitle,
    this.imageUrl,
    this.description,
    this.memberAvatarUrls = const [],
    this.manifesto,
    this.channelPosts = const [],
    this.onDirections,
    this.onSave,
    this.onShare,
    this.onClose,
  });

  @override
  State<ChannelInfoSheet> createState() => _ChannelInfoSheetState();
}

class _ChannelInfoSheetState extends State<ChannelInfoSheet> {
  late final PagingController<int, ChannelComment> _commentsPagingController;

  @override
  void initState() {
    super.initState();

    _commentsPagingController = PagingController<int, ChannelComment>(
      fetchPage: (pageKey) async {
        final newItems = SheetDummyData.members
            .map(
              (data) => ChannelComment(
                id: data["id"],
                userName: data["name"],
                userAvatar: data["avatar"],
                userStatus: data["status"],
                level: data["level"],
                commentText: data["text"],
                timeAgo: data["time"],
              ),
            )
            .toList();
        return newItems;
      },
      getNextPageKey: (state) {
        final pageKey = state.pages?.length ?? 0;
        if (pageKey > 2) return null; // Simulate limit
        return pageKey + 1;
      },
    );
  }

  @override
  void dispose() {
    _commentsPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = context.read<ThemeProvider>().currentColor;

    return ValueListenableBuilder<double>(
      valueListenable: widget.sheetExtent,
      builder: (context, extent, child) {
        final double radiusT = ((extent - 0.9) / 0.1).clamp(0.0, 1.0);
        final double radius = (28 * (1.0 - radiusT)).r;

        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            boxShadow: [
              if (extent < 1.0)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
            ],
          ),
          child: CustomScrollView(
            controller: widget.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(top: 6.h, bottom: 2.h),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: ValueListenableBuilder<double>(
                  valueListenable: widget.sheetExtent,
                  builder: (context, extent, child) {
                    final double t = ((extent - 0.14) / 0.14).clamp(0.0, 1.0);
                    if (t == 0) return const SizedBox.shrink();

                    return Opacity(
                      opacity: t,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: _buildPinterestHeader(colorScheme, activeColor),
                      ),
                    );
                  },
                ),
              ),

              // 👑 THE PINTEREST GALLERY
              PinterestGridWidget(
                posts: widget.channelPosts,
                scrollController: widget.scrollController,
              ),

              SliverPadding(
                padding: EdgeInsets.only(bottom: 100.h),
                sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPinterestHeader(ColorScheme colorScheme, Color activeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionChip(
          context.tr("post"),
          LucideIcons.camera,
          true,
          colorScheme,
          activeColor,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PostPage(
                  targetChannelId: widget.channelId,
                  isManifestoContext: false,
                ),
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.x,
              size: 20.sp,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberAvatarStack(ColorScheme colorScheme) {
    final urls = widget.memberAvatarUrls.take(5).toList();
    return SizedBox(
      height: 22.h,
      child: Stack(
        children: [
          for (int i = 0; i < urls.length; i++)
            Positioned(
              left: i * 16.0.w,
              child: CircleAvatar(
                radius: 11.r,
                backgroundImage: urls[i] != null
                    ? CachedNetworkImageProvider(urls[i]!) as ImageProvider
                    : null,
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: urls[i] == null
                    ? Icon(LucideIcons.user, size: 10.sp)
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildManifestoCard(
    ChannelPost manifesto,
    ColorScheme colorScheme,
    Color activeColor,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: activeColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  context.tr("manifesto"),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: activeColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            manifesto.content,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.45,
            ),
          ),

          // 👑 MULTI-IMAGE GALLERY SUPPORT
          if (manifesto.imageUrls.isNotEmpty) ...[
            SizedBox(height: 10.h),
            SizedBox(
              height: 160.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: manifesto.imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl = manifesto.imageUrls[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: SizedBox(
                        width: 140.w,
                        child: ChartImage(url: imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(
    IconData icon,
    ColorScheme colorScheme, {
    bool isClose = false,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 18.sp,
        color: colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildActionChip(
    String label,
    IconData icon,
    bool primary,
    ColorScheme colorScheme,
    Color activeColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: primary ? activeColor : activeColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: primary
              ? null
              : Border.all(color: activeColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: primary ? Colors.white : activeColor,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: primary ? Colors.white : activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverTabDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) => false;
}
