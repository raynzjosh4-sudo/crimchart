import 'package:crown/profile/models/charter_model.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';

final CharterModel currentUserProfile = CharterModel(
  id: 'u_1',
  username: 'raynzjosh4',
  displayName: 'Raynz Josh',
  profileImageUrl:
      'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200',
  title: 'Alpha Member',
  category: 'Tech Enthusiast',
  chartCount: 1250,
  giftsEarned: 1200,
  coinsEarned: 450000,
  currentChartName: 'The Silicon Valley Chart',
  bio: 'Building the future of Chart. Tech enthusiast and coffee lover.',
  competitors: [
    const CharterModel(
      id: 'c_1',
      username: 'rival_1',
      displayName: 'Rival One',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      title: 'Contender',
      category: 'Tech',
      chartCount: 800,
      giftsEarned: 150,
      coinsEarned: 5000,
    ),
    const CharterModel(
      id: 'c_2',
      username: 'rival_2',
      displayName: 'Rival Two',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      title: 'Contender',
      category: 'Tech',
      chartCount: 750,
      giftsEarned: 200,
      coinsEarned: 12000,
    ),
    const CharterModel(
      id: 'c_2',
      username: 'rival_2',
      displayName: 'Rival Two',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      title: 'Contender',
      category: 'Tech',
      chartCount: 750,
      giftsEarned: 200,
      coinsEarned: 12000,
    ),
    const CharterModel(
      id: 'c_2',
      username: 'rival_2',
      displayName: 'Rival Two',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      title: 'Contender',
      category: 'Tech',
      chartCount: 750,
      giftsEarned: 200,
      coinsEarned: 12000,
    ),
    const CharterModel(
      id: 'c_2',
      username: 'rival_2',
      displayName: 'Rival Two',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      title: 'Contender',
      category: 'Tech',
      chartCount: 750,
      giftsEarned: 200,
      coinsEarned: 12000,
    ),
  ],
);

// Mock Media Data for Tabs
final List<CharterModel> userImagePosts = List.generate(
  12,
  (index) => CharterModel(
    id: 'img_$index',
    username: 'raynzjosh4',
    displayName: 'Raynz Josh',
    profileImageUrl: currentUserProfile.profileImageUrl,
    title: 'Post $index',
    category: 'Tech',
    mediaThumbnailUrl: 'https://picsum.photos/id/${index + 10}/300/300',
  ),
);

final List<CharterModel> userVideoPosts = List.generate(
  8,
  (index) => CharterModel(
    id: 'vid_$index',
    username: 'raynzjosh4',
    displayName: 'Raynz Josh',
    profileImageUrl: currentUserProfile.profileImageUrl,
    title: 'Video $index',
    category: 'Tech',
    isVideo: true,
    mediaThumbnailUrl: 'https://picsum.photos/id/${index + 50}/300/300',
  ),
);

final List<CharterModel> userAudioPosts = List.generate(
  6,
  (index) => CharterModel(
    id: 'audio_$index',
    username: 'raynzjosh4',
    displayName: 'Raynz Josh',
    profileImageUrl: currentUserProfile.profileImageUrl,
    title: 'Audio $index',
    category: 'Music',
    isAudio: true,
    mediaThumbnailUrl: 'https://picsum.photos/id/${index + 80}/300/300',
  ),
);

final List<CharterModel> suggestedCharts = [
  const CharterModel(
    id: 's_1',
    username: 'iam_kelloy_aloys',
    displayName: 'Kelloy Aloys',
    profileImageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    title: 'The Great Chart Master and Pioneer',
    category: 'Music',
    chartCount: 500,
    bio: 'Joined by kevinbanks667 + 2 others',
    hasStatus: true,
    isActive: true,
    competitors: [
      CharterModel(
        id: 'sc_1_1',
        username: 'musician_1',
        displayName: 'Musician One',
        profileImageUrl: 'https://i.pravatar.cc/150?img=11',
        title: 'Contender',
        category: 'Music',
      ),
      CharterModel(
        id: 'sc_1_2',
        username: 'musician_2',
        displayName: 'Musician Two',
        profileImageUrl: 'https://i.pravatar.cc/150?img=12',
        title: 'Contender',
        category: 'Music',
      ),
    ],
  ),
  const CharterModel(
    id: 's_2',
    username: 'minister_yusuf',
    displayName: 'Minister Yusuf',
    profileImageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    title: 'Supreme Minister of Universal Peace',
    category: 'Community',
    chartCount: 1200,
    bio: 'Suggested for you',
    hasStatus: true,
    competitors: [],
  ),
  const CharterModel(
    id: 's_3',
    username: 'elaine_p',
    displayName: 'Elaine P',
    profileImageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    title: 'Visionary Lead Artist of the New Age',
    category: 'Art',
    chartCount: 850,
    bio: 'Joined by your Chart',
    competitors: [],
  ),
  // ── NEW TYPES: IMAGE, VIDEO, AUDIO ──
  const CharterModel(
    id: 's_type_image',
    username: 'visual_creator',
    displayName: 'Gallery Master',
    profileImageUrl: 'https://i.pravatar.cc/150?img=32',
    title: 'High-Res Digital Art Showcase',
    category: 'Visuals',
    chartCount: 15400,
    bio: 'Premium image-based channel',
    isActive: true,
  ),
  const CharterModel(
    id: 's_type_video',
    username: 'cinema_hub',
    displayName: 'Action Hub',
    profileImageUrl: 'https://i.pravatar.cc/150?img=35',
    title: 'Cinematic Daily Reels',
    category: 'Entertainment',
    chartCount: 8900,
    isVideo: true,
    videoUrl: 'https://example.com/video.mp4',
    bio: 'High-quality video stream',
  ),
  const CharterModel(
    id: 's_type_audio',
    username: 'sonic_pulse',
    displayName: 'The Pulse',
    profileImageUrl: 'https://i.pravatar.cc/150?img=47',
    title: 'Daily High-Fidelity Podcasting',
    category: 'Audio',
    chartCount: 4200,
    isAudio: true,
    audioUrl: 'https://example.com/audio.mp3',
    bio: 'Immersive sound experience',
    hasStatus: true,
  ),
];
final List<PostEntity> dummyChannelPosts = [
  // 👑 1. THE OWNER MANIFESTO (IMAGE)
  PostEntity.original(
    id: 'manifesto_1',
    authorId: 'admin_owner',
    authorUsername: 'Owner',
    authorDisplayName: 'Channel Owner',
    authorAvatarUrl: null, // No avatar for manifesto
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    channelId: 'general',
    channelName: 'GENERAL',
    caption:
        'AI Art: The beginning of a new creative era. Meet our top contenders.',
    imageUrls: [
      'https://picsum.photos/seed/ai1/800/600',
      'https://picsum.photos/seed/ai2/800/600',
      'https://picsum.photos/seed/ai3/800/600',
      'https://picsum.photos/seed/ai4/800/600',
    ],
    postType: 'manifesto', // 👑 TRIGGERS MANIFESTO CARD
    likes: 1500,
    comments: 200,
  ),

  // 👑 2. THE OWNER MANIFESTO (VIDEO)
  PostEntity.original(
    id: 'manifesto_2',
    authorId: 'admin_owner',
    authorUsername: 'Owner',
    authorDisplayName: 'Channel Owner',
    authorAvatarUrl: null,
    createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    channelId: 'general',
    channelName: 'GENERAL',
    caption: 'Check out the process behind the neural network generation.',
    isVideo: true,
    videoUrl:
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    thumbnailUrls: ['https://picsum.photos/seed/vid_thumb/800/600'],
    postType: 'manifesto', // 👑 TRIGGERS MANIFESTO CARD
  ),

  // 💬 3. REGULAR MEMBER CHAT
  PostEntity.original(
    id: 'msg_1',
    authorId: 'user_alex',
    authorUsername: 'Alex',
    authorDisplayName: 'Alex',
    authorAvatarUrl: 'https://picsum.photos/seed/user_1/100',
    createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    channelId: 'general',
    channelName: 'GENERAL',
    caption: 'Check out how the grid handles 5 images!',
    imageUrls: [
      'https://picsum.photos/seed/p1/800/600',
      'https://picsum.photos/seed/p2/800/600',
      'https://picsum.photos/seed/p3/800/600',
      'https://picsum.photos/seed/p4/800/600',
      'https://picsum.photos/seed/p5/800/600',
    ],
    likes: 91000,
    comments: 1200,
  ),

  // 💬 4. REGULAR MEMBER CHAT (WITH QUOTE)
  PostEntity.original(
    id: 'msg_4',
    authorId: 'my_account',
    authorUsername: 'my_account',
    authorDisplayName: 'My Account',
    authorAvatarUrl: 'https://picsum.photos/seed/me/100',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    channelId: 'general',
    channelName: 'GENERAL',
    caption: 'Response to the Owner Manifesto #1',
    likes: 45,
    comments: 2,
    linkedPostId: 'manifesto_1',
    linkedAuthorUsername: 'Owner',
    linkedCaption: 'AI Art: The beginning of a new creative era.',
    thumbnailUrls: ['https://picsum.photos/seed/ai1/800/600'],
  ),
];
