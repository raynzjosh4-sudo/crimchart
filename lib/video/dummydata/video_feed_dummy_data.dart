import 'package:crimchart/profile/models/charter_model.dart';

import '../../../mainFeed/features/cardwidgets/models/channel_post_model.dart';
import '../../../features/widgets/channelmemberdata/comment_card/thumbnaillink/thumbnaillinkmedia/thumbnail_media_type.dart';

class VideoFeedDummyData {
  static final List<ChannelPostModel> videoPosts = [
    // Competition Video
    const ChannelPostModel(
      id: 'v_comp_1',
      username: 'Alex R.',
      userProfileImageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      channelName: 'Dance Battle',
      channelId: 'ch_dance',
      imageUrls: [],
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-light-31291-large.mp4',
      isVideo: true,
      caption: 'Round 1! Who did it better? #Dance #Chart',
      likes: 12500,
      comments: 450,
      timeAgo: '1h ago',
      chartedContestants: [
        CharterModel(
          id: 'k1',
          username: 'alex_r',
          displayName: 'Alex R.',
          profileImageUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
          title: 'Top',
          category: 'Dance',
        ),
        CharterModel(
          id: 'k2',
          username: 'sarah_j',
          displayName: 'Sarah J.',
          profileImageUrl:
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
          title: 'Star',
          category: 'Dance',
        ),
      ],
      chartedCount: 45,
    ),

    // Comment/Message Video (with Thumbnail Reference)
    const ChannelPostModel(
      id: 'v_comm_1',
      username: 'Mia K.',
      userProfileImageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      channelName: 'Art Critique',
      channelId: 'ch_art',
      imageUrls: [],
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-leaves-low-angle-shot-4752-large.mp4',
      isVideo: true,
      caption:
          'I totally agree with your points on the lighting here! Great job.',
      likes: 320,
      comments: 12,
      timeAgo: '30m ago',
      thumbnailLinkUrl:
          'https://images.unsplash.com/photo-1514525253361-bee8a18742d1?w=300',
      thumbnailLinkType: ThumbnailMediaType.image,
      chartedContestants: [
        CharterModel(
          id: 'k3',
          username: 'mia_k',
          displayName: 'Mia K.',
          profileImageUrl:
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
          title: 'Judge',
          category: 'Art',
        ),
      ],
    ),

    // Another Competition Video
    const ChannelPostModel(
      id: 'v_comp_2',
      username: 'Leo M.',
      userProfileImageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      channelName: 'CooTop Chart',
      channelId: 'ch_cook',
      imageUrls: [],
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
      isVideo: true,
      caption: 'Final showdown! Who is the Master Chef? #CooTop #Competition',
      likes: 8900,
      comments: 230,
      timeAgo: '5h ago',
      chartedContestants: [
        CharterModel(
          id: 'k4',
          username: 'leo_m',
          displayName: 'Leo M.',
          profileImageUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
          title: 'Chef Top',
          category: 'CooTop',
        ),
        CharterModel(
          id: 'k5',
          username: 'elena_v',
          displayName: 'Elena V.',
          profileImageUrl:
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
          title: 'Chef Star',
          category: 'CooTop',
        ),
      ],
      chartedCount: 150,
    ),
  ];
}











