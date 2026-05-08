import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/media_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class VideosTab extends StatefulWidget {
  final Map<String, MediaItem> selectedItems;
  final void Function(String, MediaItem) onToggleSelection;

  const VideosTab({
    super.key,
    required this.selectedItems,
    required this.onToggleSelection,
  });

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  final ScrollController _scrollController = ScrollController();

  final List<AssetEntity> _realAssets = [];

  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadDeviceVideos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadDeviceVideos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDeviceVideos() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    try {
      if (kIsWeb || Platform.isWindows || Platform.isLinux) {
        throw Exception('Gallery access is only available on mobile devices.');
      }

      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth && !ps.hasAccess) {
        throw Exception('Permission denied');
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
      );
      if (albums.isEmpty) throw Exception('No albums found');

      final List<AssetEntity> videos = await albums[0].getAssetListPaged(
        page: _page,
        size: 30,
      );

      if (mounted) {
        setState(() {
          _realAssets.addAll(videos);
          _page++;
          _isLoadingMore = false;
          if (videos.length < 30) _hasMore = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading videos: $e');
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _hasMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_realAssets.isEmpty && !_isLoadingMore) {
      return Center(
        child: Text(
          'No videos found',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
        ),
      );
    }


    return MasonryGridView.count(
      controller: _scrollController,
      padding: EdgeInsets.all(1.w),
      crossAxisCount: 3,
      mainAxisSpacing: 1.5.w,
      crossAxisSpacing: 1.5.w,
      itemCount: _realAssets.length + 1 + (_isLoadingMore ? 3 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    LucideIcons.video,
                    color: colorScheme.primary,
                    size: 26.sp,
                  ),
                ),
              ),
            ),
          );
        }

        final int listLength = _realAssets.length;

        if (index > listLength) {
          return AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
            ),
          );
        }

        final mediaIndex = index - 1;
        final String mediaId = _realAssets[mediaIndex].id;
        final isSelected = widget.selectedItems.containsKey(mediaId);
        final double aspectRatio = (index % 5 == 1 || index % 7 == 3)
            ? 0.7
            : 1.0;

        return GestureDetector(
          onTap: () async {
            final file = await _realAssets[mediaIndex].file;
            if (file != null) {
              final asset = _realAssets[mediaIndex];
              final thumb = await asset.thumbnailDataWithSize(const ThumbnailSize(500, 500));

              // 📏 Calculate the real "Real Data" ratio
              final double ratio = asset.width / asset.height.clamp(1, 10000);

              widget.onToggleSelection(
                mediaId,
                MediaItem(
                  path: file.path,
                  type: MediaType.video,
                  thumbnailBytes: thumb,
                  aspectRatio: ratio,
                ),
              );
            }
          },
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _MediaThumbnailWidget(
                  asset: _realAssets[mediaIndex],
                  colorScheme: colorScheme,
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Icon(
                    LucideIcons.playCircle,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 20.sp,
                  ),
                ),
                if (isSelected)
                  Container(
                    color: Colors.black.withValues(alpha: 0.25),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Icon(
                          Icons.check,
                          color: colorScheme.onPrimary,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MediaThumbnailWidget extends StatefulWidget {
  final AssetEntity asset;
  final ColorScheme colorScheme;

  const _MediaThumbnailWidget({required this.asset, required this.colorScheme});

  @override
  State<_MediaThumbnailWidget> createState() => _MediaThumbnailWidgetState();
}

class _MediaThumbnailWidgetState extends State<_MediaThumbnailWidget> {
  Future<Uint8List?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = widget.asset.thumbnailDataWithSize(
      const ThumbnailSize(200, 200),
    );
  }

  @override
  void didUpdateWidget(covariant _MediaThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id) {
      _thumbnailFuture = widget.asset.thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: widget.colorScheme.onSurface.withValues(alpha: 0.1),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          );
        }
        return Container(
          color: widget.colorScheme.error.withValues(alpha: 0.1),
        );
      },
    );
  }
}











