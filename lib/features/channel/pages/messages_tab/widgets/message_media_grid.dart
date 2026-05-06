import 'dart:io';

import 'package:crown/features/channel/application/channel_moments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/media_model.dart';
import '../bottom_sheets/media_gallery_bottom_sheet.dart';

class MessageMediaGrid extends ConsumerWidget {
  final List<MessageMediaItem> items;
  final String? channelId;

  const MessageMediaGrid({super.key, required this.items, this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();

    // 👑 Watch moments to show the "tick" if already shared
    final moments = channelId != null
        ? ref.watch(channelMomentsProvider(channelId!)).valueOrNull ?? []
        : <dynamic>[];

    if (items.length == 1) {
      return _buildSingleMedia(context, ref, items[0], moments);
    }

    // 👑 THE THREAD WAY: Horizontal scroll for multiple items
    return _buildThreadMedia(context, ref, moments);
  }

  Widget _buildSingleMedia(
    BuildContext context,
    WidgetRef ref,
    MessageMediaItem item,
    List<dynamic> moments,
  ) {
    final bool isLocal = !item.url.startsWith('http');
    final bool isShared = moments.any((m) => m.mediaUrl == item.url);

    return GestureDetector(
      onTap: () =>
          MediaGalleryBottomSheet.show(context, items, initialIndex: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          constraints: BoxConstraints(maxHeight: 400.h, minHeight: 150.h),
          child: AspectRatio(
            aspectRatio: 1.0, // Keeping square for single items for consistency
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                _buildMediaContent(item, isLocal),
                if (item.type == MessageMediaType.video) _buildPlayIcon(),

                // ── Share Moment Overlay ──
                if (channelId != null)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: _buildShareButton(context, ref, item, isShared),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThreadMedia(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> moments,
  ) {
    // Determine the height based on the items or a default
    final double threadHeight = 320.h;

    return SizedBox(
      height: threadHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final bool isLocal = !item.url.startsWith('http');
          final bool isShared = moments.any((m) => m.mediaUrl == item.url);

          return GestureDetector(
            onTap: () => MediaGalleryBottomSheet.show(
              context,
              items,
              initialIndex: index,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                width:
                    240.w, // Slightly less than bubble width to show "thread"
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildMediaContent(item, isLocal),
                    if (item.type == MessageMediaType.video)
                      _buildPlayIcon(small: true),

                    // ── Share Moment Overlay ──
                    if (channelId != null)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: _buildShareButton(context, ref, item, isShared),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaContent(MessageMediaItem item, bool isLocal) {
    if (isLocal) {
      return Image.file(
        File(item.url),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return CachedNetworkImage(
      imageUrl: item.thumbnail ?? item.url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorPlaceholder(),
    );
  }

  Widget _buildShareButton(
    BuildContext context,
    WidgetRef ref,
    MessageMediaItem item,
    bool isShared,
  ) {
    final theme = Theme.of(context);
    if (isShared) {
      return Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(color: theme.primaryColor, width: 1.5),
        ),
        child: Icon(Icons.check, color: theme.primaryColor, size: 16.sp),
      );
    }

    return GestureDetector(
      onTap: () {
        ref
            .read(channelMomentsProvider(channelId!).notifier)
            .shareMediaAsMoment(
              mediaUrl: item.url,
              mediaType: item.type == MessageMediaType.video
                  ? 'video'
                  : 'photo',
            );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              'Share Moment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayIcon({bool small = false}) {
    return Center(
      child: Container(
        width: small ? 36.w : 54.w,
        height: small ? 36.w : 54.w,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: small ? 24.sp : 36.sp,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05)),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.white.withValues(alpha: 0.05),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white.withValues(alpha: 0.2),
          size: 24.sp,
        ),
      ),
    );
  }
}
