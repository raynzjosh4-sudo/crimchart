import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/mainFeed/features/cardwidgets/models/channel_post_model.dart';
import 'package:crimchart/mainFeed/features/mainfeedcard/main_feed_card.dart';
import 'package:crimchart/mainFeed/features/mainfeedcard/models/main_feed_card_type_model.dart';
import 'package:flutter/material.dart';

class ChannelPostDetailPage extends StatefulWidget {
  final List<ChannelPostModel> allPosts;
  final int initialIndex;

  const ChannelPostDetailPage({
    super.key,
    required this.allPosts,
    required this.initialIndex,
  });

  @override
  State<ChannelPostDetailPage> createState() => _ChannelPostDetailPageState();
}

class _ChannelPostDetailPageState extends State<ChannelPostDetailPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Use a small delay to ensure the layout is ready before scrolling
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Approximate height calculation for scrolling to item
        // Each card is roughly 600-700px tall.
        // For a true jump, we'd use a more precise method, but this restore uses simple offset.
        _scrollController.jumpTo(widget.initialIndex * 600.0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ChartAppBar(
        title: 'Posts',
        showBack: true,
        backgroundColor: backgroundColor,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: widget.allPosts.length,
        itemBuilder: (context, index) {
          final post = widget.allPosts[index];
          // Wrap the model into the expected MainFeedCardModel
          final cardModel = MainFeedCardModel(
            id: post.id,
            cardType: MainFeedCardType.channelPost,
            itemData: post,
            link: '', // Not used for direct rendering
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: MainFeedCard(card: cardModel),
          );
        },
      ),
    );
  }
}











