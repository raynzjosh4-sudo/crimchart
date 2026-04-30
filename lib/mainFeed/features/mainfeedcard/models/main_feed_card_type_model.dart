enum MainFeedCardType {
  storyList,

  TopsStars,
  commonChart,
  channelPost,
  Elite,
  discoverTops,
  discoverStars,
  commonChannel,
  // Add more types: reels, ads, suggestedUsers, etc.
}

enum ScrollViewType { horizontal, vertical, none }

/// Holds the type information, scroll layout, and navigation link
/// for each item in the feed. The [MainFeedCard] widget uses the
/// [cardType] to render the correct widget, and the [link] to
/// navigate to the appropriate detail page.
class MainFeedCardModel {
  final String id;
  final MainFeedCardType cardType;
  final ScrollViewType scrollViewType;

  /// Named route or path this card navigates to on tap.
  /// e.g. '/post/p1' or '/stories'
  final String link;

  final dynamic itemData; // Holds List<StoryModel>, PostModel, etc.

  const MainFeedCardModel({
    required this.id,
    required this.cardType,
    this.scrollViewType = ScrollViewType.vertical,
    required this.link,
    required this.itemData,
  });
}















