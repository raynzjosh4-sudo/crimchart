import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/db/chart_native_db.dart';
import '../../features/auth/application/auth_controller.dart';
import '../models/media_item.dart';

class GalleryTab extends ConsumerStatefulWidget {
  final Map<String, MediaItem> selectedItems;
  final Function(String, MediaItem) onToggleSelection;

  const GalleryTab({
    super.key,
    required this.selectedItems,
    required this.onToggleSelection,
  });

  @override
  ConsumerState<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends ConsumerState<GalleryTab> {
  List<Map<String, dynamic>> _myPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) return;

    // Load instantly from high-performance SQLite
    final posts = await ChartNativeDB.instance.getOwnerPosts(user.id);
    if (mounted) {
      setState(() {
        _myPosts = posts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_myPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.image, size: 48, color: Colors.grey.withAlpha(100)),
            const SizedBox(height: 16),
            const Text("Your profile is empty. Post something first!", 
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _myPosts.length,
      itemBuilder: (context, index) {
        final post = _myPosts[index];
        final id = post['id']?.toString() ?? '';
        final isSelected = widget.selectedItems.containsKey(id);

        // Get preview image (first image or video thumbnail)
        String? previewUrl;
        if (post['imageUrls'] != null) {
          // In SQLite, imageUrls is a JSON string
          // (assuming ChartNativeDB stores it as string if from Supabase)
          // or List if just inserted. Handle both.
          // For simplicity, we assume we follow PostEntity.fromMap logic.
          // BUT here we have raw Map from SQLite.
        }

        // Using a simpler approach for the UI mockup/Logic:
        // Assume post['imageUrls'] is a JSON list string.
        final List<String> images = (post['imageUrls'] as String?)?.isNotEmpty == true 
            ? (List<String>.from(jsonDecode(post['imageUrls']))) : [];
        
        previewUrl = images.isNotEmpty ? images.first : post['videoUrl'];

        return GestureDetector(
          onTap: () {
            final media = MediaItem(
              path: previewUrl ?? '',
              type: (post['isVideo'] == 1) ? MediaType.video : MediaType.photo,
              source: MediaSource.gallery,
              linkedPostId: id,
              linkedAuthorId: post['authorId']?.toString(),
              // For re-post linkage
              linkChain: (post['link_chain'] as String?)?.isNotEmpty == true 
                  ? List<String>.from(jsonDecode(post['link_chain']!)) : [],
              linkDepth: (post['link_depth'] as int?) ?? 0,
            );
            widget.onToggleSelection(id, media);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (previewUrl != null && previewUrl.startsWith('http'))
                CachedNetworkImage(
                  imageUrl: previewUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => const Icon(LucideIcons.alertCircle),
                )
              else
                Container(color: Colors.grey[900], child: const Icon(LucideIcons.image)),
              
              if (post['isVideo'] == 1)
                const Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(LucideIcons.playCircle, size: 16, color: Colors.white),
                ),

              if (isSelected)
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.check, size: 14, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
