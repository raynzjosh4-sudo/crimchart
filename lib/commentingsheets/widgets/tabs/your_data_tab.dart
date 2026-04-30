import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/newinsidechartstartpage/widgets/datacardwidget/data_card.dart';
import '../../../features/newinsidechartstartpage/widgets/datacardwidget/sample_media_data.dart';
import '../../../features/widgets/chartcard/models/media_data.dart';

class YourDataTab extends StatefulWidget {
  final List<int> selectedIndices;
  final Function(int index, MediaData item) onMediaTap;
  final SampleMediaData sampleData;
  final String? targetUserId;
  final bool onlyPublic;

  const YourDataTab({
    super.key,
    required this.selectedIndices,
    required this.onMediaTap,
    required this.sampleData,
    this.targetUserId,
    this.onlyPublic = false,
  });

  @override
  State<YourDataTab> createState() => _YourDataTabState();
}

class _YourDataTabState extends State<YourDataTab> {
  final ScrollController _scrollController = ScrollController();
  final List<MediaData> _displayedItems = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPageOffset = 0;
  final int _fetchLimit = 15;

  @override
  void initState() {
    super.initState();
    _fetchUserMedia();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50 && !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _fetchUserMedia({bool isLoadMore = false}) async {
    if (!mounted) return;
    if (isLoadMore) {
      setState(() => _isLoadingMore = true);
    } else {
      setState(() => _isLoading = true);
    }

    try {
      final supabase = Supabase.instance.client;
      final userId = widget.targetUserId ?? supabase.auth.currentUser?.id;
      
      if (userId == null) throw Exception('Not authenticated');

      var query = supabase
          .from('posts')
          .select()
          .eq('author_id', userId);

      if (widget.onlyPublic) {
        query = query.eq('privacy', 'public');
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(_currentPageOffset, _currentPageOffset + _fetchLimit - 1);

      final List<MediaData> loadedMedia = [];
      for (final post in response) {
         final imageUrls = post['image_urls'] as List<dynamic>? ?? [];
         final thumbUrls = post['thumbnail_urls'] as List<dynamic>? ?? [];
         final videoUrl = post['video_url'] as String?;
         final isVideo = post['is_video'] == true;
         final postId = post['id'].toString();

         String? mainContent;
         String? thumb;

         if (isVideo && videoUrl != null) {
            mainContent = videoUrl;
            thumb = thumbUrls.isNotEmpty ? thumbUrls.first.toString() : null;
         } else if (imageUrls.isNotEmpty) {
            mainContent = imageUrls.first.toString();
            thumb = thumbUrls.isNotEmpty ? thumbUrls.first.toString() : null;
         }

         if (mainContent != null) {
            loadedMedia.add(MediaData(
               type: isVideo ? MediaType.video : MediaType.image,
               contentUrl: mainContent,
               thumbnailUrl: thumb,
               postId: postId,
            ));
         }
      }

      if (mounted) {
        setState(() {
          if (isLoadMore) {
            _displayedItems.addAll(loadedMedia);
            _isLoadingMore = false;
          } else {
            _displayedItems.clear();
            _displayedItems.addAll(loadedMedia);
            _isLoading = false;
          }
          if (loadedMedia.isNotEmpty) {
            _currentPageOffset += _fetchLimit;
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching user media: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadMore() async => _fetchUserMedia(isLoadMore: true);

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _displayedItems.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    }

    if (_displayedItems.isEmpty) {
      return Center(
        child: Text(
          "No media available yet.\\nStart posting to see your gallery!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 100 / 160,
            ),
            itemCount: _displayedItems.length,
            itemBuilder: (context, index) {
              final item = _displayedItems[index];
              return DataCard(
                mediaData: item,
                isSelected: widget.selectedIndices.contains(index),
                onTap: () => widget.onMediaTap(index, item),
              );
            },
          ),
        ),
        if (_isLoadingMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}





























