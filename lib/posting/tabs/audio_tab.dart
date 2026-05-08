import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/media_item.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioTab extends StatefulWidget {
  final Map<String, MediaItem> selectedItems;
  final void Function(String, MediaItem) onToggleSelection;

  const AudioTab({
    super.key,
    required this.selectedItems,
    required this.onToggleSelection,
  });

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> {
  final ScrollController _scrollController = ScrollController();

  final List<AssetEntity> _realAssets = [];

  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadDeviceAudio();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadDeviceAudio();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDeviceAudio() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    try {
      if (kIsWeb || Platform.isWindows || Platform.isLinux) {
        throw Exception('Gallery access is only available on mobile devices.');
      }

      final PermissionState ps = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(
          iosAccessLevel: IosAccessLevel.readWrite,
          androidPermission: AndroidPermission(
            type: RequestType.audio,
            mediaLocation: false,
          ),
        ),
      );
      if (!ps.isAuth && !ps.hasAccess) {
        throw Exception('Permission denied for Audio');
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.audio,
      );
      if (albums.isEmpty)
        throw Exception('No local audio albums found on device');

      final List<AssetEntity> audios = await albums[0].getAssetListPaged(
        page: _page,
        size: 30,
      );

      if (mounted) {
        setState(() {
          _realAssets.addAll(audios);
          _page++;
          _isLoadingMore = false;
          if (audios.length < 30) _hasMore = false;
        });
      }
    } catch (e) {
      debugPrint('[AudioTab] Error loading audio: $e');
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _hasMore = false;
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final int min = seconds ~/ 60;
    final int sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final int listLength = _realAssets.length;

    return listLength == 0 && !_isLoadingMore
        ? Center(
            child: Text(
              'No audio files found',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          )
        : ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: listLength + (_isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => Divider(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              height: 1,
            ),
            itemBuilder: (context, index) {
              if (index == listLength) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                );
              }

              final String mediaId = _realAssets[index].id;
              final isSelected = widget.selectedItems.containsKey(mediaId);

              String title = "Unknown";
              String artist = "Unknown Artist";
              String durationStr = "0:00";

              final asset = _realAssets[index];
              title = asset.title ?? "Unknown";
              durationStr = _formatDuration(asset.duration);

              return ListTile(
                onTap: () async {
                  final file = await _realAssets[index].file;
                  if (file != null) {
                    widget.onToggleSelection(
                      mediaId,
                      MediaItem(
                        path: file.path,
                        type: MediaType.audio,
                        title: title,
                        artist: artist,
                      ),
                    );
                  }
                },
                leading: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: isSelected
                      ? Container(
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.check,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Center(
                          child: Icon(
                            LucideIcons.music,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            size: 20.sp,
                          ),
                        ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  artist,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  durationStr,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          );
  }
}
