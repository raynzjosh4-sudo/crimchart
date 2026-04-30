import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/feed/application/feed_controller.dart';
import '../../features/feed/domain/entities/post_entity.dart';
import '../models/media_item.dart';

class MembersTab extends ConsumerStatefulWidget {
  final Map<String, MediaItem> selectedItems;
  final Function(String, MediaItem) onToggleSelection;

  const MembersTab({
    super.key,
    required this.selectedItems,
    required this.onToggleSelection,
  });

  @override
  ConsumerState<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends ConsumerState<MembersTab> {
  @override
  Widget build(BuildContext context) {
    // Borrow feeds from the main feed controller as "Members content" proxy
    final feedState = ref.watch(feedControllerProvider);
    
    if (feedState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<PostEntity> posts = feedState.posts;

    if (posts.isEmpty) {
      return const Center(
        child: Text("No member posts found.", style: TextStyle(color: Colors.grey)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final id = post.id;
        final isSelected = widget.selectedItems.containsKey(id);

        String? previewUrl;
        if (post.imageUrls.isNotEmpty) {
          previewUrl = post.imageUrls.first;
        } else if (post.videoUrl != null) {
          previewUrl = post.videoUrl;
        }

        return GestureDetector(
          onTap: () {
            final media = MediaItem(
              path: previewUrl ?? '',
              type: post.isVideo ? MediaType.video : MediaType.photo,
              source: MediaSource.members, // <--- Linkage source!
              linkedPostId: id,
              linkedAuthorId: post.authorId,
              linkChain: post.linkChain,
              linkDepth: post.linkDepth,
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
              
              if (post.isVideo)
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
