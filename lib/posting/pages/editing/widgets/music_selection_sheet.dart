import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_size.dart';
import '../../../models/media_item.dart';
import '../../../tabs/music_search_tab.dart';
import '../../../tabs/audio_tab.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MusicSelectionSheet extends StatefulWidget {
  final Function(MediaItem) onMusicSelected;

  const MusicSelectionSheet({super.key, required this.onMusicSelected});

  @override
  State<MusicSelectionSheet> createState() => _MusicSelectionSheetState();
}

class _MusicSelectionSheetState extends State<MusicSelectionSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _searchQuery = query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 580.h,
      decoration: BoxDecoration(
        color: const Color(0xFF121212), // Deep black background
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Header with Tabs and Search Icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white38,
                    indicatorColor: Colors.white,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    dividerColor: Colors.transparent,
                    labelStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: const [
                      Tab(text: 'Device'),
                      Tab(text: 'Music'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) _searchQuery = '';
                    });
                  },
                  icon: Icon(
                    _isSearching ? LucideIcons.x : LucideIcons.search,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(color: Colors.white10, height: 1),

          // Search Bar (Conditional)
          if (_isSearching)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  autofocus: true,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search songs',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(LucideIcons.search, color: Colors.white38, size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  ),
                ),
              ),
            ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AudioTab(
                  selectedItems: const {},
                  onToggleSelection: (id, item) {
                    widget.onMusicSelected(item);
                    Navigator.pop(context);
                  },
                ),
                MusicSearchTab(
                  searchQuery: _searchQuery,
                  onSelect: (item) {
                    widget.onMusicSelected(item);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          
          // Bottom Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 1.5),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Original sound',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'Volume',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
