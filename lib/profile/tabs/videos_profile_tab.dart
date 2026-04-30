import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/charter_model.dart';
import '../widgets/media_grid_item.dart';
import '../../mainFeed/features/cardwidgets/commonchartcard/pages/common_chart_details_page.dart';
import '../../mainFeed/features/cardwidgets/models/common_chart_model.dart';
import '../../features/feed/application/feed_controller.dart';
import '../../features/auth/application/auth_controller.dart';

class ProfileVideosTab extends ConsumerStatefulWidget {
  final String? userId;
  
  const ProfileVideosTab({super.key, this.userId});

  @override
  ConsumerState<ProfileVideosTab> createState() => _ProfileVideosTabState();
}

class _ProfileVideosTabState extends ConsumerState<ProfileVideosTab> {
  static const _pageSize = 12;

  List<String> _folders = [];
  String? _selectedFolder;
  bool _foldersLoaded = false;

  late final PagingController<int, CharterModel> _pagingController =
      PagingController<int, CharterModel>(
    fetchPage: (pageKey) async {
      final targetUserId = widget.userId ?? ref.read(authControllerProvider).user?.id;
      if (targetUserId == null) return [];

      final repo = ref.read(feedRepositoryProvider);
      final res = await repo.getUserPosts(
        targetUserId,
        isVideo: true,
        folderName: _selectedFolder,
        page: pageKey,
        limit: _pageSize,
      );

      return res.fold(
        (fail) {
          print("🎬 [VideosTab] DB Fetch Failed: ${fail.message}");
          throw fail.message;
        },
        (posts) {
          return posts.map((p) => CharterModel(
            id: p.id,
            username: p.authorUsername,
            displayName: p.authorDisplayName,
            profileImageUrl: p.authorAvatarUrl ?? '',
            title: p.authorTitle ?? 'Chart Status',
            category: p.authorCategory ?? 'Unspecified',
            mediaThumbnailUrl: p.thumbnailUrls.isNotEmpty 
                ? p.thumbnailUrls.first 
                : (p.imageUrls.isNotEmpty ? p.imageUrls.first : null),
            imageUrls: p.imageUrls,
            isVideo: p.isVideo,
            videoUrl: p.videoUrl,
            bio: '',
            folderName: p.folderName,
            currentChartName: p.channelName,
            isPending: p.isPending,
            localFileCache: p.localFileCache,
          )).toList();
        },
      );
    },
    getNextPageKey: (state) {
      if (state.pages == null || state.pages!.isEmpty) return 1;
      final lastPage = state.pages!.last;
      if (lastPage.length < _pageSize) return null;
      return state.pages!.length + 1;
    },
  );

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  // _loadFolders moved down

  Future<void> _loadFolders() async {
    final targetUserId = widget.userId ?? ref.read(authControllerProvider).user?.id;
    print("🎬 [VideosTab] Loading video folders for user: $targetUserId");
    
    if (targetUserId == null) return;

    final repo = ref.read(feedRepositoryProvider);
    final res = await repo.getUserPostFolders(targetUserId, isVideo: true);

    res.fold(
      (fail) => print("🎬 [VideosTab] Folder Fetch Error: ${fail.message}"),
      (folders) {
        print("🎬 [VideosTab] Found ${folders.length} video folders in DB: $folders");
        if (mounted) {
          setState(() {
            _folders = folders;
            _foldersLoaded = true;
          });
        }
      },
    );
  }

  void _onFolderSelected(String? folder) {
    print("🎬 [VideosTab] Folder selected: $folder");
    if (_selectedFolder == folder) return;
    setState(() {
      _selectedFolder = folder;
    });
    // Trigger a refresh of the existing controller
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🏗️🏗️🏗️ [VideosTab] build CALLED. Folders loaded: $_foldersLoaded, Count: ${_folders.length}");
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // ── Folder Chips Row ──
        if (_foldersLoaded && _folders.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _folders.length + 1, // +1 for "All" chip
              itemBuilder: (context, index) {
                final isAllChip = index == 0;
                final folder = isAllChip ? null : _folders[index - 1];
                final isSelected = _selectedFolder == folder;
                final label = isAllChip ? 'All' : _formatFolderName(folder!);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 12,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: colorScheme.primary,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (selected) {
                      if (selected) _onFolderSelected(folder);
                    },
                  ),
                );
              },
            ),
          ),

        // ── Video Grid ──
        Expanded(
          child: ValueListenableBuilder<PagingState<int, CharterModel>>(
            valueListenable: _pagingController,
            builder: (context, state, _) {
              return CustomScrollView(
                slivers: [
                  PagedSliverMasonryGrid.count(
                    state: state,
                    fetchNextPage: _pagingController.fetchNextPage,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    builderDelegate: PagedChildBuilderDelegate<CharterModel>(
                      itemBuilder: (context, item, index) =>
                          MediaGridItem(
                            post: item,
                            onTap: () {
                              final allCharts = state.pages?.expand((page) => page).map((item) {
                                return CommonChartModel(
                                  id: item.id,
                                  userId: 'user_${item.username}',
                                  username: item.username,
                                  userProfileImageUrl: item.profileImageUrl,
                                   title: item.title,
                                   category: item.category,
                                   imageUrls: item.isVideo || item.isAudio ? [] : item.imageUrls,
                                   videoUrl: item.videoUrl,
                                  audioUrl: item.audioUrl,
                                  thumbnailUrl: item.mediaThumbnailUrl,
                                  isVideo: item.isVideo,
                                  isAudio: item.isAudio,
                                  chartName: item.currentChartName ?? 'Chart Chart',
                                  likes: 3400,
                                  comments: 156,
                                  mutualCount: 12,
                                );
                              }).toList() ?? [];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommonChartDetailsPage(
                                    Charts: allCharts,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                          ),
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Icon(Icons.video_library_outlined, size: 64, color: colorScheme.onSurface.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFolder != null
                                  ? "No videos in ${_formatFolderName(_selectedFolder!)}."
                                  : "No videos yet.",
                              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Formats a folder_name like "public_posts" into "Public Posts".
  String _formatFolderName(String raw) {
    return raw
        .split('_')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}





























