import 'package:crown/core/application/audio_controller.dart';
import 'package:crown/core/widgets/chart_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/charter_model.dart';
import '../../mainFeed/features/cardwidgets/commonchartcard/pages/common_chart_details_page.dart';
import '../../mainFeed/features/cardwidgets/models/common_chart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/feed/application/feed_controller.dart';
import '../../features/auth/application/auth_controller.dart';

class ProfileAudioTab extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileAudioTab({super.key, this.userId});

  @override
  ConsumerState<ProfileAudioTab> createState() => _ProfileAudioTabState();
}

class _ProfileAudioTabState extends ConsumerState<ProfileAudioTab> {
  static const _pageSize = 12;
  List<String> _folders = [];
  String? _selectedFolder;
  bool _foldersLoaded = false;

  late final PagingController<int, CharterModel> _pagingController =
      PagingController<int, CharterModel>(
        fetchPage: (pageKey) async {
          final targetUserId =
              widget.userId ?? ref.read(authControllerProvider).user?.id;
          if (targetUserId == null) return [];

          final repo = ref.read(feedRepositoryProvider);
          final res = await repo.getUserPosts(
            targetUserId,
            isAudio: true,
            folderName: _selectedFolder,
            page: pageKey,
            limit: _pageSize,
          );

          return res.fold(
            (fail) {
              print("🎵 [AudioTab] DB Fetch Failed: ${fail.message}");
              throw fail.message;
            },
            (posts) {
              return posts
                  .map(
                    (p) => CharterModel(
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
                      isAudio: p.isAudio,
                      audioUrl: p.audioUrl,
                      bio: '',
                      folderName: p.folderName,
                      currentChartName: p.channelName,
                      isPending: p.isPending,
                      localFileCache: p.localFileCache,
                    ),
                  )
                  .toList();
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

  Future<void> _loadFolders() async {
    final targetUserId =
        widget.userId ?? ref.read(authControllerProvider).user?.id;
    if (targetUserId == null) return;

    final repo = ref.read(feedRepositoryProvider);
    final res = await repo.getUserPostFolders(targetUserId, isAudio: true);

    res.fold(
      (fail) => print("🎵 [AudioTab] Folder Fetch Error: ${fail.message}"),
      (folders) {
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
    if (_selectedFolder == folder) return;
    setState(() {
      _selectedFolder = folder;
    });
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;
    final audioState = ref.watch(audioControllerProvider);

    return Column(
      children: [
        if (_foldersLoaded && _folders.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _folders.length + 1,
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
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (selected) {
                      if (selected) _onFolderSelected(folder);
                    },
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: ValueListenableBuilder<PagingState<int, CharterModel>>(
            valueListenable: _pagingController,
            builder: (context, state, _) {
              return CustomScrollView(
                slivers: [
                  PagedSliverList<int, CharterModel>(
                    state: state,
                    fetchNextPage: _pagingController.fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate<CharterModel>(
                      itemBuilder: (context, track, index) {
                        final isPlaying =
                            audioState.isPlaying &&
                            audioState.currentTrackId == track.id;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  // Cover Art (with Play/Pause toggle)
                                  GestureDetector(
                                    onTap: () {
                                      if (track.audioUrl != null) {
                                        ref
                                            .read(
                                              audioControllerProvider.notifier,
                                            )
                                            .toggle(track.audioUrl!, track.id);
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.08),
                                        ),
                                        child: Stack(
                                          children: [
                                            if (track.mediaThumbnailUrl != null)
                                              ChartImage(
                                                url: track.mediaThumbnailUrl!,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    const SizedBox.shrink(),
                                              ),
                                            Center(
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isPlaying
                                                      ? theme
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.8)
                                                      : Colors.black38,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  isPlaying
                                                      ? LucideIcons.pause
                                                      : LucideIcons.play,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  // Info
                                  Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        final allCharts =
                                            state.pages
                                                ?.expand((page) => page)
                                                .map((t) {
                                                  return CommonChartModel(
                                                    id: t.id,
                                                    userId:
                                                        'user_${t.username}',
                                                    username: t.username,
                                                    userProfileImageUrl:
                                                        t.profileImageUrl,
                                                    title: t.title,
                                                    category: t.category,
                                                    imageUrls: const [],
                                                    videoUrl: t.videoUrl,
                                                    audioUrl: t.audioUrl,
                                                    thumbnailUrl:
                                                        t.mediaThumbnailUrl,
                                                    isVideo: t.isVideo,
                                                    isAudio: t.isAudio,
                                                    chartName:
                                                        t.currentChartName ??
                                                        'Chart Chart',
                                                    likes: 3400,
                                                    comments: 156,
                                                    mutualCount: 12,
                                                  );
                                                })
                                                .toList() ??
                                            [];

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommonChartDetailsPage(
                                                  Charts: allCharts,
                                                  initialIndex: index,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            track.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            track.displayName,
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.5),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (index <
                                (state.pages?.fold(0, (s, p) => s + p.length) ??
                                        0) -
                                    1)
                              Padding(
                                padding: const EdgeInsets.only(left: 84),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.05),
                                ),
                              ),
                          ],
                        );
                      },
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Icon(
                              Icons.audiotrack_outlined,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFolder != null
                                  ? "No audio in ${_formatFolderName(_selectedFolder!)}."
                                  : "No audio tracks yet.",
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
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

  String _formatFolderName(String raw) {
    return raw
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}











