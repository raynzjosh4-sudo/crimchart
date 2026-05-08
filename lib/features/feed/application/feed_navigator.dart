import 'package:flutter/material.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:crimchart/features/channel/pages/channel_page.dart';
import 'package:crimchart/features/allchannels/models/chart_channel.dart';
import 'package:crimchart/profile/pages/profile_page.dart';
import 'package:crimchart/posting/models/media_item.dart';
import 'package:crimchart/features/channel/pages/channel_post_detail_page.dart';
import 'package:crimchart/mainFeed/features/cardwidgets/models/channel_post_model.dart';

class FeedNavigator {
  FeedNavigator._();

  /// Opens the detailed post view with comments
  static void openPostDetail(
    BuildContext context, 
    PostEntity post, 
    List<PostEntity> allEntities,
    ChannelPostModel Function(PostEntity) mapper,
  ) {
    final allLegacy = allEntities.map((e) => mapper(e)).toList();
    final initialIndex = allEntities.indexOf(post);
    if (initialIndex == -1) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChannelPostDetailPage(
          allPosts: allLegacy, 
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  /// The master switchboard for ThumbnailLink routing
  static void handleLinkTap(
    BuildContext context, 
    PostEntity sourcePost, 
    List<PostEntity> currentFeed,
    ScrollController? scrollController,
  ) {
    if (sourcePost.linkedPostId == null) return;
    
    final linkedIndex = currentFeed.indexWhere((p) => p.id == sourcePost.linkedPostId);

    // 👑 OPTION B: Router Switch Board (Cross-content routing)
    // 🏷️ ROUTING DNA: If item is missing from memory, infer the type from metadata
    final targetPost = linkedIndex != -1 ? currentFeed[linkedIndex] : null;
    final type = sourcePost.linkedChannelId != null 
        ? PostType.channel 
        : (targetPost?.postType ?? PostType.profile);

    switch (type) {
      case PostType.channel:
        if (sourcePost.linkedChannelId == null) return;
        
        // 🛡️ Prevent navigation loops if already in this channel
        // In a real app, we'd check against a 'currentChannelId' from a provider
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChannelPage(
              channel: ChartChannel(
                id: sourcePost.linkedChannelId!,
                title: sourcePost.linkedAuthorUsername ?? 'Channel',
              ),
            ),
          ),
        );
        break;
      case PostType.profile:
      default:
        // By design, shared profile posts take the user to the author's profile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(userId: sourcePost.authorId),
          ),
        );
        break;
    }
  }
}
