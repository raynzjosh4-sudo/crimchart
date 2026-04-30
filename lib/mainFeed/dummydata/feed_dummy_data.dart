import 'charter_star_dummy_data.dart';
import 'common_channel_dummy_data.dart';
import 'channel_post_dummy_data.dart';
import 'elite_dummy_data.dart';
import 'package:crown/mainFeed/features/mainfeedcard/models/main_feed_card_type_model.dart';

/// Composes all feed items into a single typed list for the main feed.
/// Each item carries its [MainFeedCardType], its [ScrollViewType],
/// a [link] to navigate to the relevant page, and the raw [itemData].
class FeedDummyData {
  static List<MainFeedCardModel> get feedItems {
    final List<MainFeedCardModel> items = [];

    // Tops & Stars — horizontal row card at the top (replacing status)
    if (dummyTopsStars.isNotEmpty) {
      items.add(
        MainFeedCardModel(
          id: 'Tops_Stars_top',
          cardType: MainFeedCardType.TopsStars,
          scrollViewType: ScrollViewType.horizontal,
          link: TopsStarsLink,
          itemData: dummyTopsStars,
        ),
      );
    }

    // WINNERS CIRCLE - Highest Points (Elite)
    for (final h in dummyEliteItems) {
      items.add(
        MainFeedCardModel(
          id: h.id,
          cardType: MainFeedCardType.Elite,
          scrollViewType: ScrollViewType.vertical,
          link: '/Elite/${h.id}',
          itemData: h,
        ),
      );
    }

    // Collect all vertical content cards
    final List<MainFeedCardModel> verticalCards = [];
    
    // Common channels — individual vertical cards
    for (final channel in dummyCommonChannels) {
      verticalCards.add(
        MainFeedCardModel(
          id: channel.id,
          cardType: MainFeedCardType.commonChannel,
          scrollViewType: ScrollViewType.vertical,
          link: '/common-channel/${channel.id}',
          itemData: channel,
        ),
      );
    }

    // Channel Posts — individual vertical cards
    for (final cp in dummyChannelPosts) {
      verticalCards.add(
        MainFeedCardModel(
          id: cp.id,
          cardType: MainFeedCardType.channelPost,
          scrollViewType: ScrollViewType.vertical,
          link: '/channel-post/${cp.id}',
          itemData: cp,
        ),
      );
    }

    // Now assemble the final items list
    // 1. First, show some initial vertical items (e.g., first 2)
    final int initialItemsCount = verticalCards.length > 2 ? 2 : verticalCards.length;
    items.addAll(verticalCards.take(initialItemsCount));



    // 3. Finally, add the remaining vertical items
    if (verticalCards.length > initialItemsCount) {
      items.addAll(verticalCards.skip(initialItemsCount));
    }

    return items;
  }
}





























