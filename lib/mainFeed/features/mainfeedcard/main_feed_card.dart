import 'package:crimchart/mainFeed/features/cardwidgets/models/hiness_model.dart';
import 'package:crimchart/mainFeed/features/charts_stars/charts_and_stars_widget.dart';
import 'package:crimchart/mainFeed/features/cardwidgets/hiness/hiness_card_widget.dart';
import 'package:flutter/material.dart';
import '../../../features/channel/pages/channel_page.dart';
import '../cardwidgets/storychacrdwidget/story_list_widget.dart';
import '../../../profile/widgets/discover_charts.dart';
import '../../../profile/pages/discover_charts_page.dart';
import '../cardwidgets/models/story_model.dart';
import '../../../profile/models/charter_model.dart';
import '../cardwidgets/models/common_chart_model.dart';
import '../cardwidgets/models/channel_post_model.dart';
import '../cardwidgets/commonchartcard/common_chart_card_widget.dart';
import '../cardwidgets/channelcardwidgets/channel_image_card_widget.dart';
import '../cardwidgets/channelcardwidgets/channel_video_card_widget.dart';
import '../cardwidgets/channelcardwidgets/channel_audio_card_widget.dart';
import '../cardwidgets/channelcardwidgets/channel_gif_card_widget.dart';
import '../cardwidgets/channelcardwidgets/channel_text_card_widget.dart';

import 'models/main_feed_card_type_model.dart';

/// Renders the correct card widget based on [card.cardType].
/// Tapping the card navigates to [card.link].
class MainFeedCard extends StatelessWidget {
  final MainFeedCardModel card;

  const MainFeedCard({super.key, required this.card});

  void _navigate(BuildContext context) {
    if (card.cardType == MainFeedCardType.channelPost) {
      final data = card.itemData as ChannelPostModel;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChannelPage(
            contestants: data.chartedContestants,
            initialMessageId: data.id,
          ),
        ),
      );
    } else {
      Navigator.pushNamed(context, card.link);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (card.cardType) {
      case MainFeedCardType.storyList:
        final stories = card.itemData as List<StoryModel>;
        return StoryListWidget(key: ValueKey(card.id), stories: stories);

      case MainFeedCardType.TopsStars:
        final topsStars = card.itemData as List<CharterModel>;
        return TopsAndStarsWidget(
          key: ValueKey(card.id),
          models: topsStars,
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const discoverTopsPage()),
            );
          },
        );

      case MainFeedCardType.commonChart:
        final chart = card.itemData as CommonChartModel;
        return CommonChartCardWidget(key: ValueKey(card.id), data: chart);

      case MainFeedCardType.channelPost:
        final channelPost = card.itemData as ChannelPostModel;

        Widget postWidget;
        if (channelPost.isVideo) {
          postWidget = ChannelVideoCardWidget(
            key: ValueKey(card.id),
            data: channelPost,
            onTap: () => _navigate(context),
          );
        } else if (channelPost.isAudio) {
          postWidget = ChannelAudioCardWidget(
            key: ValueKey(card.id),
            data: channelPost,
            onTap: () => _navigate(context),
          );
        } else if (channelPost.isGif) {
          postWidget = ChannelGifCardWidget(
            key: ValueKey(card.id),
            data: channelPost,
            onTap: () => _navigate(context),
          );
        } else if (channelPost.isText) {
          postWidget = ChannelTextCardWidget(
            key: ValueKey(card.id),
            data: channelPost,
            onTap: () => _navigate(context),
          );
        } else {
          postWidget = ChannelImageCardWidget(
            key: ValueKey(card.id),
            data: channelPost,
            onTap: () => _navigate(context),
          );
        }

        return postWidget;

      case MainFeedCardType.Elite:
        final elite = card.itemData as EliteModel;
        return EliteCardWidget(
          key: ValueKey(card.id),
          data: elite,
          onTap: () => _navigate(context),
        );

      case MainFeedCardType.discoverTops:
        return discoverTops(
          key: ValueKey(card.id),
          suggestions: (card.itemData as List<CharterModel>?) ?? [],
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const discoverTopsPage()),
            );
          },
        );

      case MainFeedCardType.discoverStars:
      case MainFeedCardType.commonChannel:
        return const SizedBox.shrink();
    }
  }
}





