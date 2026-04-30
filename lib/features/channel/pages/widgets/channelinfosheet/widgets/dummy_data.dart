import 'package:crown/features/channel/pages/crownpoll/crown_option_model.dart';
import 'package:crown/features/channel/pages/crownpoll/widgets/mediatype/crown_media_type.dart';

class SheetDummyData {
  static final String crownTitle = "What should our next event be? We have so many options and we really need the community to come together and decide on this critical matter because it will dictate the next entire year of our trajectory! " * 5;

  static const List<String> categories = [
    "All",
    "Popular",
    "Featured",
    "Community",
    "Manifestos",
  ];

  static const List<Map<String, dynamic>> photos = [
    {"url": "https://picsum.photos/seed/p1/800/1200", "type": "tall", "likes": 124},
    {"url": "https://picsum.photos/seed/p2/600/600", "type": "square", "likes": 56},
    {"url": "https://picsum.photos/seed/p3/600/600", "type": "square", "likes": 89},
    {"url": "https://picsum.photos/seed/p4/800/1200", "type": "tall", "likes": 201},
    {"url": "https://picsum.photos/seed/p5/900/600", "type": "wide", "likes": 150},
    {"url": "https://picsum.photos/seed/p6/600/900", "type": "tall", "likes": 34},
    {"url": "https://picsum.photos/seed/p7/600/600", "type": "square", "likes": 12},
    {"url": "https://picsum.photos/seed/p8/800/1200", "type": "tall", "likes": 45},
    {"url": "https://picsum.photos/seed/p9/700/700", "type": "square", "likes": 78},
    {"url": "https://picsum.photos/seed/p10/900/1200", "type": "tall", "likes": 92},
    {"url": "https://picsum.photos/seed/p11/800/800", "type": "square", "likes": 110},
    {"url": "https://picsum.photos/seed/p12/1000/600", "type": "wide", "likes": 67},
  ];

  static const List<Map<String, dynamic>> videos = [
    {
      "url": "https://picsum.photos/seed/v1/800/1400",
      "type": "tall",
      "likes": 892,
      "authorName": "Crown Official",
      "caption": "The grand opening ceremony highlights! #Crown #Event",
    },
    {
      "url": "https://picsum.photos/seed/v2/600/600",
      "type": "square",
      "likes": 451,
      "authorName": "Music Team",
      "caption": "Behind the scenes recording the new anthem.",
    },
    {
      "url": "https://picsum.photos/seed/v3/1200/800",
      "type": "wide",
      "likes": 230,
      "authorName": "Director X",
      "caption": "Exclusive look at the cinematography of our upcoming manifesto.",
    },
    {
      "url": "https://picsum.photos/seed/v4/800/1200",
      "type": "tall",
      "likes": 1205,
      "authorName": "The Collective",
      "caption": "Community takeover was a massive success!",
    },
    {"url": "https://picsum.photos/seed/v5/600/900", "type": "tall", "likes": 67},
    {"url": "https://picsum.photos/seed/v6/900/600", "type": "wide", "likes": 89},
    {"url": "https://picsum.photos/seed/v7/600/600", "type": "square", "likes": 120},
    {"url": "https://picsum.photos/seed/v8/800/1400", "type": "tall", "likes": 340},
    {"url": "https://picsum.photos/seed/v9/600/900", "type": "tall", "likes": 15},
    {"url": "https://picsum.photos/seed/v10/1000/600", "type": "wide", "likes": 450},
  ];

  static const List<Map<String, dynamic>> audio = [
    {
      "title": "Midnight Echoes",
      "author": "Lofi Crown",
      "duration": "3:45",
      "coverUrl": "https://picsum.photos/seed/a1/300/300",
      "likes": 1200,
    },
    {
      "title": "Neon Horizon",
      "author": "Synth Knight",
      "duration": "4:20",
      "coverUrl": "https://picsum.photos/seed/a2/300/300",
      "likes": 850,
    },
    {
      "title": "Starlight Manifesto",
      "author": "Crown Collective",
      "duration": "2:15",
      "coverUrl": "https://picsum.photos/seed/a3/300/300",
      "likes": 3400,
    },
    {
      "title": "The Awakening",
      "author": "Symphony X",
      "duration": "5:30",
      "coverUrl": "https://picsum.photos/seed/a4/300/300",
      "likes": 670,
    },
    {
      "title": "Pulse",
      "author": "Beat Maker",
      "duration": "3:10",
      "coverUrl": "https://picsum.photos/seed/a5/300/300",
      "likes": 210,
    },
    {
      "title": "Deep Ocean",
      "author": "Ambient Waves",
      "duration": "6:00",
      "coverUrl": "https://picsum.photos/seed/a6/300/300",
      "likes": 450,
    },
    {
      "title": "Urban Jungle",
      "author": "Street King",
      "duration": "2:45",
      "coverUrl": "https://picsum.photos/seed/a7/300/300",
      "likes": 890,
    },
    {
      "title": "Golden Era",
      "author": "The Legends",
      "duration": "4:05",
      "coverUrl": "https://picsum.photos/seed/a8/300/300",
      "likes": 1500,
    },
    {
      "title": "Future Wave",
      "author": "Digital Native",
      "duration": "3:30",
      "coverUrl": "https://picsum.photos/seed/a9/300/300",
      "likes": 300,
    },
    {
      "title": "Serenity",
      "author": "Peaceful Mind",
      "duration": "8:00",
      "coverUrl": "https://picsum.photos/seed/a10/300/300",
      "likes": 920,
    },
  ];

  static const List<Map<String, dynamic>> members = [
    {
      "id": "1",
      "name": "Alice Johnson",
      "avatar": "https://i.pravatar.cc/150?u=alice",
      "status": "Diamond Elite",
      "level": 45,
      "text":
          "This channel has amazing energy! The community is very welcoming and I love the content shared here.",
      "time": "2 days ago",
    },
    {
      "id": "2",
      "name": "Bob Smith",
      "avatar": "https://i.pravatar.cc/150?u=bob",
      "status": "Gold Member",
      "level": 32,
      "text":
          "The latest manifesto was mind-blowing. Can't wait for the next drop!",
      "time": "4 hours ago",
    },
    {
      "id": "3",
      "name": "Charlie Brown",
      "avatar": "https://i.pravatar.cc/150?u=charlie",
      "status": "Silver Contender",
      "level": 15,
      "text": "Does anyone know when the next crowning ceremony starts?",
      "time": "1 week ago",
    },
    {
      "id": "4",
      "name": "Diana Ross",
      "avatar": "https://i.pravatar.cc/150?u=diana",
      "status": "Rising Star",
      "level": 8,
      "text": "Just joined! Super hyped for the community events.",
      "time": "Just now",
    },
  ];

  static final CrownModel crownPoll = CrownModel(
    id: "poll_admin_123",
    title: "What should our next event be? We have so many options and we really need the community to come together and decide on this critical matter because it will dictate the next entire year of our trajectory! " * 5,
    description: "Please help us decide what to focus on next month!",
    crownerId: "admin_user_01",
    crownerName: "Crown System",
    crownerImage: "https://i.pravatar.cc/150?u=admin",
    isActive: true,
    hasStatus: true,
    options: [
      CrownOptionModel(
        id: "1",
        description: "Release new merch collection including hoodies, t-shirts, caps, and exclusive vinyls! We want to make sure the quality is top-notch. Everything uses premium cotton and sustainable materials. " * 20,
        mediaUrl: "https://picsum.photos/seed/merch/200/200",
        mediaType: CrownMediaType.image,
        crowns: 145,
      ),
      CrownOptionModel(
        id: "2",
        description: "Behind the scenes vlog",
        mediaUrl: "https://picsum.photos/seed/vlog/200/200",
        mediaType: CrownMediaType.video,
        crowns: 89,
        isMe: true,
      ),
      CrownOptionModel(
        id: "3", 
        description: "Q&A Livestream", 
        mediaType: CrownMediaType.none,
        crowns: 56,
      ),
      CrownOptionModel(
        id: "4",
        description: "Invite guest for next pod",
        mediaUrl: "https://picsum.photos/seed/guest/200/200",
        mediaType: CrownMediaType.image,
        crowns: 32,
      ),
      CrownOptionModel(
        id: "5",
        description: "New intro track sneak peek",
        mediaType: CrownMediaType.audio,
        crowns: 21,
      ),
    ],
  );
}
