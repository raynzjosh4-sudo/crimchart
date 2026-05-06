import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../features/widgets/chartcard/models/media_data.dart';

class DeviceMediaTab extends StatefulWidget {
  final Function(int, MediaData) onMediaTap;
  final List<int> selectedIndices;
  final ScrollController? scrollController;

  const DeviceMediaTab({
    super.key, 
    required this.onMediaTap,
    required this.selectedIndices,
    this.scrollController,
  });

  @override
  State<DeviceMediaTab> createState() => _DeviceMediaTabState();
}

class _DeviceMediaTabState extends State<DeviceMediaTab> {
  final List<AssetEntity> _assets = [];
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _selectedAlbum;
  bool _isLoading = true;
  bool _hasPermission = false;
  int _currentPage = 0;
  late final ScrollController _scrollController;
  late final bool _ownsController;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.scrollController == null;
    _scrollController = widget.scrollController ?? ScrollController();
    _requestPermissionAndLoad();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadAssets();
      }
    });
  }

  @override
  void dispose() {
    if (_ownsController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  Future<void> _requestPermissionAndLoad() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      if (mounted) setState(() => _hasPermission = true);
      await _loadInitialData();
    } else {
      PhotoManager.openSetting();
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadInitialData() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.common);
    if (albums.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    if (mounted) {
      setState(() {
        _albums = albums;
        _selectedAlbum = albums[0];
      });
      await _loadAssets();
    }
  }

  void _onAlbumSelected(AssetPathEntity album) {
    if (_selectedAlbum == album) return;
    setState(() {
      _selectedAlbum = album;
      _assets.clear();
      _currentPage = 0;
      _isLoading = true;
    });
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    if (_isFetchingMore || _selectedAlbum == null) return;
    _isFetchingMore = true;
    
    final List<AssetEntity> newAssets = await _selectedAlbum!.getAssetListPaged(page: _currentPage, size: 30);
    
    if (mounted) {
      setState(() {
        _assets.addAll(newAssets);
        _isLoading = false;
        if (newAssets.isNotEmpty) _currentPage++;
      });
    }
    _isFetchingMore = false;
  }

  Future<void> _handleAssetTap(int index, AssetEntity asset) async {
    final file = await asset.file;
    if (file == null) return;

    final type = asset.type == AssetType.video ? MediaType.video : MediaType.image;
    final double aspectRatio = (asset.width > 0 && asset.height > 0) 
        ? asset.width / asset.height 
        : 1.0;
    
    widget.onMediaTap(
      1000 + index, 
      MediaData(
        type: type,
        contentUrl: file.path, 
        aspectRatio: aspectRatio,
      ),
    );
  }

  Widget _buildGrid() {
    if (_isLoading && _assets.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    }

    if (!_hasPermission) {
      return const Center(child: Text("Please grant gallery access via Settings."));
    }

    if (_assets.isEmpty) {
      return const Center(child: Text("No media found on device for this album."));
    }

    return GridView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        final asset = _assets[index];
        final isSelected = widget.selectedIndices.contains(1000 + index);

        return GestureDetector(
          onTap: () => _handleAssetTap(index, asset),
          child: Container(
            decoration: BoxDecoration(
              border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3) : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSelected ? 0 : 4),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FutureBuilder<Uint8List?>(
                    future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: Theme.of(context).colorScheme.surfaceContainerHighest);
                      }
                      if (snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                      return const Icon(Icons.error);
                    },
                  ),
                  if (asset.type == AssetType.video)
                    const Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.play_circle_outline, color: Colors.white, size: 24),
                    ),
                  if (isSelected)
                    Container(
                      color: Colors.black38,
                      child: const Center(
                        child: Icon(Icons.check_circle, color: Colors.white, size: 28),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_albums.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _albums.length,
              itemBuilder: (context, index) {
                final album = _albums[index];
                final isSelected = album == _selectedAlbum;
                final name = album.name.isEmpty ? "Recent" : album.name;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimary 
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (selected) {
                      if (selected) _onAlbumSelected(album);
                    },
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: _buildGrid(),
        ),
      ],
    );
  }
}
