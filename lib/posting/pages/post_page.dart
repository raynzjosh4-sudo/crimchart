import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../tabs/photos_tab.dart';
import '../tabs/videos_tab.dart';
import '../tabs/audio_tab.dart';
import '../pages/finalpostpage/finalize_post_page.dart';
import 'package:crimchart/backicon/custom_back_button.dart';

// EditPostPage is commented out (editing tools pending implementation):
// import 'editing/edit_post_page.dart';

class PostPage extends StatefulWidget {
  final String? targetChannelId;
  final bool isManifestoContext;

  const PostPage({
    super.key,
    this.targetChannelId,
    this.isManifestoContext = false,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, MediaItem> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    // 3 tabs now: [Photos, Videos, Audio]
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSelection(String id, MediaItem item) {
    setState(() {
      if (_selectedItems.containsKey(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems[id] = item;
      }
    });
  }

  Future<void> _onNext() async {
    final List<MediaItem> selectedMediaItems = _selectedItems.values.toList();

    if (widget.isManifestoContext) {
      Navigator.pop(context, selectedMediaItems);
      return;
    }

    // Skip editing — go straight to the share/finalize page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinalizePostPage(
          selectedMedia: selectedMediaItems,
          targetChannelId: widget.targetChannelId,
          isManifestoContext: widget.isManifestoContext,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: CustomBackButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          context.tr('recents'),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (_selectedItems.isNotEmpty)
            TextButton(
              onPressed: _onNext,
              child: Text(
                context.tr('next'),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          dividerColor: Colors.transparent,
          isScrollable: true,
          labelColor: colorScheme.onSurface,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.4),
          labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5.sp),
          tabs: [
            Tab(text: context.tr('photos_tab')),
            Tab(text: context.tr('videos_tab')),
            Tab(text: context.tr('audio_tab')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PhotosTab(
            selectedItems: _selectedItems,
            onToggleSelection: _toggleSelection,
          ),
          VideosTab(
            selectedItems: _selectedItems,
            onToggleSelection: _toggleSelection,
          ),
          AudioTab(
            selectedItems: _selectedItems,
            onToggleSelection: _toggleSelection,
          ),
        ],
      ),
    );
  }
}
