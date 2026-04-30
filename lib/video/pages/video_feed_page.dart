import 'package:flutter/material.dart';
import '../dummydata/video_feed_dummy_data.dart';
import '../competition/widgets/competition_video_card.dart';
import '../comment/widgets/comment_video_card.dart';

class VideoFeedPage extends StatefulWidget {
  const VideoFeedPage({super.key});

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for premium feel
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: VideoFeedDummyData.videoPosts.length,
        itemBuilder: (context, index) {
          final post = VideoFeedDummyData.videoPosts[index];
          
          if (post.thumbnailLinkUrl != null) {
            return CommentVideoCard(post: post);
          } else {
            return CompetitionVideoCard(post: post);
          }
        },
      ),
    );
  }
}





























