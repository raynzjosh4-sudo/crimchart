import 'package:crown/mainFeed/features/cardwidgets/hiness/hiness_card_widget.dart';
import 'package:crown/mainFeed/features/cardwidgets/models/hiness_model.dart';

import '../../../features/feed/domain/entities/post_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/content_entity.dart';
import '../../../core/widgets/feed_item_widget.dart';
import '../../../features/channel/pages/channel_page.dart';
import '../cardwidgets/storychacrdwidget/story_list_widget.dart';
import '../../../profile/widgets/discover_charts.dart';
import '../cardwidgets/models/story_model.dart';
import '../cardwidgets/models/channel_post_model.dart';
import '../../../profile/dummydata/profile_dummy_data.dart';
import '../cardwidgets/models/common_chart_model.dart';
import '../cardwidgets/commonchartcard/common_chart_card_widget.dart';
import '../cardwidgets/channelcardwidgets/channel_image_card_widget.dart';
import '../cardwidgets/channelcardwidgets/channel_text_card_widget.dart';

import 'models/main_feed_card_type_model.dart';
import '../../../profile/models/charter_model.dart';

/// Enhanced MainFeedCard with ThumbnailLink integration.
/// Now supports content lineage tracTop and unified content display.
class MainFeedCard extends ConsumerWidget {
  final MainFeedCardModel card;

  const MainFeedCard({super.key, required this.card});

  void _navigateToContent(BuildContext context, ContentEntity content) {
    // Navigate based on content type and thumbnail link
    final originalContentId = content.thumbnailLink.originalContentId;

    // For now, navigate to channel page with the original content
    // In the future, this could navigate to specific content viewers
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChannelPage(initialMessageId: originalContentId),
      ),
    );
  }

  void _navigateToThumbnailLink(BuildContext context, ThumbnailLink link) {
    // Navigate to the original content that started the link chain
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChannelPage(initialMessageId: link.originalContentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if this card contains ContentEntity data
    if (card.itemData is ContentEntity) {
      final content = card.itemData as ContentEntity;

      // Use the new unified FeedItemWidget
      return FeedItemWidget(
        content: content,
        onTap: () => _navigateToContent(context, content),
        onThumbnailLinkTap: () =>
            _navigateToThumbnailLink(context, content.thumbnailLink),
        compact: false,
      );
    }

    // Fallback to original implementation for legacy data types
    return _buildLegacyCard(context);
  }

  Widget _buildLegacyCard(BuildContext context) {
    switch (card.cardType) {
      case MainFeedCardType.storyList:
        final stories = card.itemData as List<StoryModel>;
        return StoryListWidget(stories: stories);

      case MainFeedCardType.discoverTops:
        return discoverTops(suggestions: suggestedCharts);

      case MainFeedCardType.TopsStars:
        final TopsStars = card.itemData as List<CharterModel>;
        return discoverTops(suggestions: TopsStars);

      case MainFeedCardType.commonChart:
        final Chart = card.itemData as CommonChartModel;
        return CommonChartCardWidget(data: Chart);

      case MainFeedCardType.channelPost:
        final post = card.itemData as ChannelPostModel;
        return _buildChannelPostCard(context, post);

      case MainFeedCardType.Elite:
        final Elite = card.itemData as EliteModel;
        return EliteCardWidget(data: Elite);
      case MainFeedCardType.commonChannel:
        // TODO: Handle this case.
        throw UnimplementedError();
      case MainFeedCardType.discoverStars:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Widget _buildChannelPostCard(BuildContext context, ChannelPostModel post) {
    // Determine the appropriate card widget based on content
    if (post.imageUrls.isNotEmpty) {
      return ChannelImageCardWidget(
        data: post,
        onTap: () => _navigateLegacy(context, post),
      );
    } else if (post.caption.isNotEmpty) {
      return ChannelTextCardWidget(
        data: post,
        onTap: () => _navigateLegacy(context, post),
      );
    } else {
      // Default fallback
      return ChannelTextCardWidget(
        data: post,
        onTap: () => _navigateLegacy(context, post),
      );
    }
  }

  void _navigateLegacy(BuildContext context, ChannelPostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChannelPage(
          contestants: post.chartedContestants,
          initialMessageId: post.id,
        ),
      ),
    );
  }
}

/// Extension methods to help migrate legacy models to ContentEntity
extension ContentEntityConversion on ChannelPostModel {
  /// Converts a legacy ChannelPostModel to PostEntity with ThumbnailLink
  PostEntity toPostEntity() {
    return PostEntity.original(
      id: id,
      authorId: 'legacy_author_$id', // Would need proper author ID
      authorUsername: 'legacy_user', // Would need proper username
      authorDisplayName: 'Legacy User', // Would need proper display name
      createdAt: DateTime.now(), // Fallback for legacy data
      channelId: 'legacy_channel', // Would need proper channel ID
      channelName: 'Legacy Channel', // Would need proper channel name
      caption: caption,
      imageUrls: imageUrls,
    );
  }
}











