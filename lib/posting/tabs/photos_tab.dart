import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/media_item.dart';
import 'dummydata/photos_dummy_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class PhotosTab extends StatefulWidget {
  final Map<String, MediaItem> selectedItems;
  final void Function(String, MediaItem) onToggleSelection;

  const PhotosTab({
    super.key,
    required this.selectedItems,
    required this.onToggleSelection,
  });

  @override
  State<PhotosTab> createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  final ScrollController _scrollController = ScrollController();

  // Real assets fetched from Device Camera Roll
  final List<AssetEntity> _realAssets = [];
  // Dummy assets fallback for Windows/Web testing
  final List<String> _displayedItems = [];

  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 0;
  bool _useDummyFallback = false;

  @override
  void initState() {
    super.initState();
    _loadDevicePhotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadDevicePhotos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDevicePhotos() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    try {
      // PhotoManager mobile plugin throws on Windows/Web
      if (kIsWeb || Platform.isWindows || Platform.isLinux) {
        throw Exception('Not running on mobile device');
      }

      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth && !ps.hasAccess) {
        throw Exception('Permission denied');
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      if (albums.isEmpty) throw Exception('No albums found');

      final List<AssetEntity> photos = await albums[0].getAssetListPaged(
        page: _page,
        size: 30,
      );

      if (mounted) {
        setState(() {
          _realAssets.addAll(photos);
          _page++;
          _isLoadingMore = false;
          if (photos.length < 30) _hasMore = false;
        });
      }
    } catch (e) {
      // Graceful fallback to UI Dummy Data so the developer can keep building Windows UI natively!
      _useDummyFallback = true;
      if (mounted) {
        setState(() {
          _displayedItems.addAll(photosDummyData);
          _page++;
          _isLoadingMore = false;
          if (_page >= 3) _hasMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasonryGridView.count(
      controller: _scrollController,
      padding: EdgeInsets.all(1.w),
      crossAxisCount: 3,
      mainAxisSpacing: 1.5.w,
      crossAxisSpacing: 1.5.w,
      itemCount:
          (_useDummyFallback ? _displayedItems.length : _realAssets.length) +
          1 +
          (_isLoadingMore ? 3 : 0),
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
                    LucideIcons.camera,
                    color: colorScheme.primary,
                    size: 26.sp,
                  ),
                ),
              ),
            ),
          );
        }

        final int listLength = _useDummyFallback
            ? _displayedItems.length
            : _realAssets.length;

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
        final String mediaId = _useDummyFallback
            ? _displayedItems[mediaIndex]
            : _realAssets[mediaIndex].id;
        final isSelected = widget.selectedItems.containsKey(mediaId);
        final double aspectRatio = (index % 5 == 1 || index % 7 == 3)
            ? 0.7
            : 1.0;

        return GestureDetector(
          onTap: () async {
            if (_useDummyFallback) {
              widget.onToggleSelection(
                mediaId,
                MediaItem(path: mediaId, type: MediaType.photo),
              );
            } else {
              final file = await _realAssets[mediaIndex].file;
              if (file != null) {
                final asset = _realAssets[mediaIndex];
                final thumb = await asset.thumbnailDataWithSize(
                  const ThumbnailSize(500, 500),
                );

                // 📏 Calculate the real "Real Data" ratio
                final double ratio = asset.width / asset.height.clamp(1, 10000);

                widget.onToggleSelection(
                  mediaId,
                  MediaItem(
                    path: file.path,
                    type: MediaType.photo,
                    thumbnailBytes: thumb,
                    aspectRatio: ratio,
                  ),
                );
              }
            }
          },
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_useDummyFallback)
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          _displayedItems[mediaIndex],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  _MediaThumbnailWidget(
                    asset: _realAssets[mediaIndex],
                    colorScheme: colorScheme,
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
