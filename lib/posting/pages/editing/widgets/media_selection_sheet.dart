import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/utils/responsive_size.dart';
import '../../../models/media_item.dart';
import '../../../tabs/photos_tab.dart';
import '../../../tabs/videos_tab.dart';
import '../../../tabs/audio_tab.dart';
import '../../../tabs/music_search_tab.dart';

class MediaSelectionSheet extends StatefulWidget {
  final Function(MediaItem) onMediaSelected;

  const MediaSelectionSheet({
    super.key,
    required this.onMediaSelected,
  });

  @override
  State<MediaSelectionSheet> createState() => _MediaSelectionSheetState();
}

class _MediaSelectionSheetState extends State<MediaSelectionSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, MediaItem> _selectedItems = {}; // Temporary local selection

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onToggle(String id, MediaItem item) {
    widget.onMediaSelected(item);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 700.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('select_media'),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.x, color: colorScheme.onSurface),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.4),
            indicatorColor: colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900),
            unselectedLabelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
            dividerColor: Colors.transparent,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: context.tr('photos_tab')),
              Tab(text: context.tr('videos_tab')),
              Tab(text: context.tr('audio_tab')),
              const Tab(text: 'Music'),
            ],
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PhotosTab(
                  selectedItems: _selectedItems,
                  onToggleSelection: _onToggle,
                ),
                VideosTab(
                  selectedItems: _selectedItems,
                  onToggleSelection: _onToggle,
                ),
                AudioTab(
                  selectedItems: _selectedItems,
                  onToggleSelection: _onToggle,
                ),
                MusicSearchTab(onSelect: (item) => widget.onMediaSelected(item)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
