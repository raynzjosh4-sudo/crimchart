import 'package:crown/profile/models/charter_model.dart';

import '../features/cardwidgets/models/channel_post_model.dart';
import '../../../../features/widgets/channelmemberdata/comment_card/thumbnaillink/thumbnaillinkmedia/thumbnail_media_type.dart';

final List<ChannelPostModel> dummyChannelPosts = [
  const ChannelPostModel(
    id: 'cp_1',
    username: 'Riana B.',
    userProfileImageUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    channelName: 'Fashion Weekly',
    channelId: 'ch_fashion',
    imageUrls: [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600',
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600',
    ],
    caption: 'Loving the new collection from XYZ! #Fashion #Trends',
    thumbnailLinkUrl:
        'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=300',
    thumbnailLinkType: ThumbnailMediaType.image,
    referenceId: 'ref_1',
    referenceChannelId: 'ch_fashion',
    referenceContestants: [
      CharterModel(
        id: 'c1',
        username: 'riana_b',
        displayName: 'Riana B.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
        title: 'Star',
        category: 'Fashion',
      ),
    ],
    likes: 3400,
    comments: 156,
    timeAgo: '2h ago',
    isLiked: true,
    chartedContestants: [
      CharterModel(
        id: 'c1',
        username: 'riana_b',
        displayName: 'Riana B.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
        title: 'Star',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c2',
        username: 'jason_m',
        displayName: 'Jason M.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        title: 'Top',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c3',
        username: 'sarah_l',
        displayName: 'Sarah L.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
        title: 'Star',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c9',
        username: 'mike_r',
        displayName: 'Mike R.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
        title: 'Top',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c10',
        username: 'anna_w',
        displayName: 'Anna W.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
        title: 'Star',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c11',
        username: 'tom_h',
        displayName: 'Tom H.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
        title: 'Top',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c12',
        username: 'lucy_v',
        displayName: 'Lucy V.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
        title: 'Star',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c13',
        username: 'chris_p',
        displayName: 'Chris P.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        title: 'Top',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c14',
        username: 'megan_f',
        displayName: 'Megan F.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
        title: 'Star',
        category: 'Fashion',
      ),
      CharterModel(
        id: 'c15',
        username: 'eric_d',
        displayName: 'Eric D.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100',
        title: 'Top',
        category: 'Fashion',
      ),
    ],
    chartedCount: 24,
    aspectRatio: 9 / 16, // Extra Tall Portrait
    hasStatus: true,
    isActive: true,
  ),
  const ChannelPostModel(
    id: 'cp_2',
    username: 'Kevin S.',
    userProfileImageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    channelName: 'Tech Talk',
    channelId: 'ch_tech',
    imageUrls: [
      'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600',
    ],
    caption: 'The new Framework laptop is a game changer for repairability.',
    thumbnailLinkUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    thumbnailLinkType: ThumbnailMediaType.video,
    referenceId: 'ref_2',
    likes: 850,
    comments: 42,
    timeAgo: '5h ago',
    isLiked: false,
    chartedContestants: [
      CharterModel(
        id: 'c4',
        username: 'kevin_s',
        displayName: 'Kevin S.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        title: 'Top',
        category: 'Tech',
      ),
    ],
    chartedCount: 12,
    aspectRatio: 4 / 5,
  ),
  const ChannelPostModel(
    id: 'cp_3_video',
    username: 'Emma W.',
    userProfileImageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    channelName: 'Travel Vibes',
    channelId: 'ch_travel',
    imageUrls: [],
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    isVideo: true,
    caption: 'Discovering hidden gems in the city! 🦋 #Travel #Explore',
    thumbnailLinkUrl:
        'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=300',
    thumbnailLinkType: ThumbnailMediaType.image,
    referenceId: 'ref_3',
    likes: 5400,
    comments: 312,
    timeAgo: '1d ago',
    isLiked: true,
    chartedContestants: [
      CharterModel(
        id: 'c5',
        username: 'emma_w',
        displayName: 'Emma W.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
        title: 'Star',
        category: 'Travel',
      ),
      CharterModel(
        id: 'c16',
        username: 'travel_junkie',
        displayName: 'TJ',
        profileImageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
        title: 'Nomad',
        category: 'Travel',
      ),
      CharterModel(
        id: 'c17',
        username: 'globe_trotter',
        displayName: 'Globe',
        profileImageUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
        title: 'Explorer',
        category: 'Travel',
      ),
      CharterModel(
        id: 'c18',
        username: 'wanderer',
        displayName: 'Wanderer',
        profileImageUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
        title: 'Hiker',
        category: 'Travel',
      ),
      CharterModel(
        id: 'c19',
        username: 'pathfinder',
        displayName: 'Path',
        profileImageUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
        title: 'Guide',
        category: 'Travel',
      ),
      CharterModel(
        id: 'c20',
        username: 'voyager',
        displayName: 'Voyager',
        profileImageUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        title: 'Sailor',
        category: 'Travel',
      ),
      CharterModel(
        id: 'c21',
        username: 'adventurer',
        displayName: 'Adv',
        profileImageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
        title: 'Hero',
        category: 'Travel',
      ),
      CharterModel(
        id: 'c22',
        username: 'discoverer',
        displayName: 'Disc',
        profileImageUrl:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100',
        title: 'Seeker',
        category: 'Travel',
      ),
    ],
    chartedCount: 8,
    aspectRatio: 9 / 16, // Reel/Full-screen style
  ),
  const ChannelPostModel(
    id: 'cp_4_audio',
    username: 'David G.',
    userProfileImageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    channelName: 'Music Cafe',
    channelId: 'ch_music',
    imageUrls: [
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
    ],
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    isAudio: true,
    caption: 'New acoustic session just dropped! 🎸 #Music #Acoustic',
    thumbnailLinkUrl:
        'https://images.unsplash.com/photo-1514525253361-bee8a18742d1?w=300',
    thumbnailLinkType: ThumbnailMediaType.image,
    referenceId: 'ref_4',
    likes: 1200,
    comments: 89,
    timeAgo: '3h ago',
    isLiked: false,
    chartedContestants: [
      CharterModel(
        id: 'c6',
        username: 'david_g',
        displayName: 'David G.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
        title: 'Artist',
        category: 'Music',
      ),
    ],
    chartedCount: 5,
    aspectRatio: 4 / 5,
  ),
  const ChannelPostModel(
    id: 'cp_5_gif',
    username: 'Elena R.',
    userProfileImageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    channelName: 'Fashion Hub',
    channelId: 'ch_fashion',
    imageUrls: [
      'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHJmZzI5ZzFmZzI5ZzFmZzI5ZzFmZzI5ZzFmZzI5ZzFmZzI5ZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7TKMGpxVf7N5P9Xq/giphy.gif',
    ],
    gifUrl:
        'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHJmZzI5ZzFmZzI5ZzFmZzI5ZzFmZzI5ZzFmZzI5ZzFmZzI5ZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7TKMGpxVf7N5P9Xq/giphy.gif',
    isGif: true,
    caption: 'Check out this new trend! 👗✨ #Fashion #Style',
    thumbnailLinkUrl:
        'https://images.unsplash.com/photo-1529139513075-3317b289490f?w=300',
    thumbnailLinkType: ThumbnailMediaType.image,
    referenceId: 'ref_5',
    likes: 2500,
    comments: 120,
    timeAgo: '1h ago',
    isLiked: true,
    chartedContestants: [
      CharterModel(
        id: 'c7',
        username: 'elena_r',
        displayName: 'Elena R.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
        title: 'Influencer',
        category: 'Fashion',
      ),
    ],
    chartedCount: 12,
    aspectRatio: 4 / 5,
  ),
  const ChannelPostModel(
    id: 'cp_6_text',
    username: 'Marcus K.',
    userProfileImageUrl:
        'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?w=200',
    channelName: 'Tech Talk',
    channelId: 'ch_tech',
    imageUrls: [],
    isText: true,
    caption:
        'The future of AI is looTop brighter than ever. What do you all think? 🤖💡 #Tech #AI',
    thumbnailLinkUrl:
        'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=300',
    thumbnailLinkType: ThumbnailMediaType.image,
    referenceId: 'ref_6',
    likes: 850,
    comments: 45,
    timeAgo: '30m ago',
    isLiked: false,
    chartedContestants: [
      CharterModel(
        id: 'c8',
        username: 'marcus_k',
        displayName: 'Marcus K.',
        profileImageUrl:
            'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?w=100',
        title: 'Engineer',
        category: 'Tech',
      ),
    ],
    chartedCount: 3,
  ),
];











