import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/posting/models/media_item.dart';

class FinalizeMediaPreview extends StatelessWidget {
  final List<MediaItem> selectedMedia;

  const FinalizeMediaPreview({super.key, required this.selectedMedia});

  ImageProvider _getImageProvider(MediaItem item) {
    if (item.thumbnailBytes != null) {
      return MemoryImage(item.thumbnailBytes!);
    } else if (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(item.thumbnailUrl!);
    } else if (item.type == MediaType.photo) {
      if (item.path.startsWith('http')) {
        return CachedNetworkImageProvider(item.path);
      } else {
        return FileImage(File(item.path));
      }
    }
    // Safe placeholder for raw video/audio without pre-generated thumbnails
    return const AssetImage('assets/icons/playstore.png');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        itemCount: selectedMedia.length,
        itemBuilder: (context, index) {
          final item = selectedMedia[index];
          return Container(
            width: 180.w,
            margin: EdgeInsets.only(right: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: _getImageProvider(item),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                if (item.type == MediaType.video)
                  Center(
                    child: Icon(
                      LucideIcons.playCircle,
                      color: Colors.white,
                      size: 36.sp,
                    ),
                  ),
                if (item.type == MediaType.audio)
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.music,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
