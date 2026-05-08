import 'dart:io';

import 'package:crimchart/features/showcase/chart_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:photo_manager/photo_manager.dart';
import 'media_caption_bottom_sheet.dart';

/// Bottom sheet for selecting media to send in a channel chat.
/// Tabs: Gallery | Videos
class SelectMediaBottomSheet extends ConsumerStatefulWidget {
  final String channelId;

  /// Called when multiple media items are confirmed.
  final Function(List<Map<String, String>> items)? onMediaSubmitted;

  const SelectMediaBottomSheet({
    super.key,
    required this.channelId,
    this.onMediaSubmitted,
  });

  static void show(
    BuildContext context, {
    required String channelId,
    Function(List<Map<String, String>> items)? onMediaSubmitted,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => SelectMediaBottomSheet(
        channelId: channelId,
        onMediaSubmitted: onMediaSubmitted,
      ),
    );
  }

  @override
  ConsumerState<SelectMediaBottomSheet> createState() =>
      _SelectMediaBottomSheetState();
}

class _SelectMediaBottomSheetState extends ConsumerState<SelectMediaBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isResolvingFiles = false;

  static const _tabs = ['Gallery', 'Videos'];

  // Selection state
  final List<AssetEntity> _selectedImages = [];
  AssetEntity? _selectedVideo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    try {
      if (!defaultTargetPlatform.toString().contains('windows')) {
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps == PermissionState.denied || ps == PermissionState.restricted) {
          // Permission denied
        }
      }
    } catch (e) {
      debugPrint(
        '👑 [SelectMedia] PhotoManager not supported on this platform: $e',
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 16.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Header row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select Media',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    // Close button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.x,
                          size: 22.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Tabs
              TabBar(
                controller: _tabController,
                isScrollable: false,
                dividerColor: Colors.transparent,
                labelColor: theme.primaryColor,
                unselectedLabelColor: colorScheme.onSurface.withValues(
                  alpha: 0.4,
                ),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: theme.primaryColor, width: 2.5),
                  insets: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MediaPickerTab(
                      type: RequestType.image,
                      selectedAssets: _selectedImages,
                      isMultiSelect: true,
                      onSelectionChanged: (assets) {
                        setState(() {
                          _selectedImages.clear();
                          _selectedImages.addAll(assets);
                        });
                      },
                    ),
                    _MediaPickerTab(
                      type: RequestType.video,
                      selectedAssets: _selectedVideo != null
                          ? [_selectedVideo!]
                          : [],
                      isMultiSelect: false,
                      onSelectionChanged: (assets) {
                        setState(() {
                          _selectedVideo = assets.isNotEmpty
                              ? assets.first
                              : null;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Send button
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: (_selectedImages.isNotEmpty || _selectedVideo != null)
                    ? _buildSendButton(theme)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSendButton(ThemeData theme) {
    final count = _selectedImages.length + (_selectedVideo != null ? 1 : 0);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: _isResolvingFiles
              ? null
              : () async {
                  setState(() => _isResolvingFiles = true);
                  try {
                    final List<String> paths = [];
                    final List<String> types = [];

                    for (var asset in _selectedImages) {
                      debugPrint(
                        '👑 [SelectMedia] Resolving asset: ${asset.id}',
                      );
                      ChartToast.showInfo(
                        context,
                        title: 'Picker',
                        message:
                            'Downloading image ${paths.length + 1}/${_selectedImages.length}...',
                      );

                      File? file;
                      try {
                        // Try standard file fetch with a 10-second timeout
                        file = await asset.file.timeout(
                          const Duration(seconds: 10),
                        );
                        if (file == null) {
                          debugPrint(
                            '👑 [SelectMedia] asset.file was null, trying originFile',
                          );
                          file = await asset.originFile.timeout(
                            const Duration(seconds: 10),
                          );
                        }
                      } catch (e) {
                        debugPrint('👑 [SelectMedia] Error fetching file: $e');
                      }

                      if (file != null) {
                        debugPrint(
                          '👑 [SelectMedia] Resolved file: ${file.path}',
                        );
                        paths.add(file.path);
                        types.add('image');
                      } else {
                        debugPrint(
                          '👑 [SelectMedia] ❌ Failed to resolve asset: ${asset.id}',
                        );
                      }
                    }
                    if (_selectedVideo != null) {
                      final file = await _selectedVideo!.file;
                      if (file != null) {
                        paths.add(file.path);
                        types.add('video');
                      }
                    }

                    if (widget.onMediaSubmitted != null) {
                      final items = <Map<String, String>>[];
                      for (int i = 0; i < paths.length; i++) {
                        items.add({'url': paths[i], 'type': types[i]});
                      }
                      
                      if (mounted) {
                        Navigator.pop(context); // Close selection sheet
                        MediaCaptionBottomSheet.show(
                          context,
                          items: items,
                          onSend: (caption, finalItems) {
                            // Pass items with caption back
                            widget.onMediaSubmitted!(finalItems.map((item) {
                              return {
                                ...item,
                                'caption': caption,
                              };
                            }).toList());
                          },
                        );
                      }
                    }
                  } catch (e) {
                    ChartToast.showError(
                      context,
                      title: 'Error',
                      message: 'Resolution failed: $e',
                    );
                    debugPrint('❌ [SelectMedia] Error resolving files: $e');
                  } finally {
                    if (mounted) setState(() => _isResolvingFiles = false);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 8,
            shadowColor: theme.primaryColor.withValues(alpha: 0.3),
          ),
          child: _isResolvingFiles
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send ($count)',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(LucideIcons.send, size: 18.sp),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Unified Media Picker Tab ────────────────────────────────────────────────

class _MediaPickerTab extends StatefulWidget {
  final RequestType type;
  final List<AssetEntity> selectedAssets;
  final bool isMultiSelect;
  final Function(List<AssetEntity>) onSelectionChanged;

  const _MediaPickerTab({
    required this.type,
    required this.selectedAssets,
    required this.isMultiSelect,
    required this.onSelectionChanged,
  });

  @override
  State<_MediaPickerTab> createState() => _MediaPickerTabState();
}

class _MediaPickerTabState extends State<_MediaPickerTab> {
  AssetPathEntity? _selectedFolder;
  List<AssetPathEntity> _folders = [];
  List<AssetEntity> _assets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: widget.type,
      );
      // Filter out empty folders
      final List<AssetPathEntity> validPaths = [];
      for (var path in paths) {
        if (await path.assetCountAsync > 0) {
          validPaths.add(path);
        }
      }

      if (mounted) {
        setState(() {
          _folders = validPaths;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('👑 [MediaPickerTab] Error loading folders: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAssets(AssetPathEntity folder) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final List<AssetEntity> assets = await folder.getAssetListRange(
      start: 0,
      end: 1000,
    );
    if (mounted) {
      setState(() {
        _assets = assets;
        _selectedFolder = folder;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_selectedFolder == null) {
      return _buildFolderGrid();
    } else {
      return _buildAssetGrid();
    }
  }

  Widget _buildFolderGrid() {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: _folders.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final folder = _folders[index];
        return ListTile(
          onTap: () => _loadAssets(folder),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          tileColor: theme.colorScheme.surfaceContainerLow,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              width: 54.w,
              height: 54.w,
              child: FutureBuilder<List<AssetEntity>>(
                future: folder.getAssetListRange(start: 0, end: 1),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return _AssetThumbnail(
                      asset: snapshot.data!.first,
                      size: 120,
                    );
                  }
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      widget.type == RequestType.video
                          ? LucideIcons.video
                          : LucideIcons.folder,
                      color: theme.primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          title: Text(
            folder.name,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          subtitle: FutureBuilder<int>(
            future: folder.assetCountAsync,
            builder: (context, snapshot) => Text(
              '${snapshot.data ?? 0} items',
              style: TextStyle(
                fontSize: 13.sp,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          trailing: Icon(
            LucideIcons.chevronRight,
            size: 20.sp,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }

  Widget _buildAssetGrid() {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Back to folders
        ListTile(
          onTap: () => setState(() => _selectedFolder = null),
          leading: Icon(LucideIcons.arrowLeft, size: 20.sp),
          title: Text(
            _selectedFolder!.name,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
          ),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(12.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
            ),
            itemCount:
                _assets.length + (widget.type == RequestType.image ? 1 : 0),
            itemBuilder: (context, index) {
              if (widget.type == RequestType.image && index == 0) {
                return _buildCameraTile(theme);
              }
              final asset =
                  _assets[index - (widget.type == RequestType.image ? 1 : 0)];
              final isSelected = widget.selectedAssets.contains(asset);

              return GestureDetector(
                onTap: () {
                  if (widget.isMultiSelect) {
                    final newSelection = List<AssetEntity>.from(
                      widget.selectedAssets,
                    );
                    if (isSelected) {
                      newSelection.remove(asset);
                    } else {
                      newSelection.add(asset);
                    }
                    widget.onSelectionChanged(newSelection);
                  } else {
                    widget.onSelectionChanged([asset]);
                  }
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: _AssetThumbnail(asset: asset, size: 250),
                      ),
                    ),
                    if (isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: theme.primaryColor,
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.check,
                                size: 16.sp,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (asset.type == AssetType.video)
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.play,
                                size: 10.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDuration(asset.duration),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCameraTile(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement camera logic
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.camera,
                size: 24.sp,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Camera',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;
  final int size;

  const _AssetThumbnail({required this.asset, required this.size});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          );
        }
        final bytes = snapshot.data;
        if (bytes == null) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              asset.type == AssetType.video
                  ? LucideIcons.video
                  : LucideIcons.image,
              size: 24.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }
        return Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
      },
    );
  }
}
