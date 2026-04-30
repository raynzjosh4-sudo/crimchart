import 'package:crown/features/allchannels/models/chart_channel.dart';
import 'package:crown/features/newinsidechartstartpage/models/channel_post.dart';

final List<ChartChannel> dummyChannels = List.generate(60, (index) {
  final id = (index + 1).toString();

  // Rotating stats for diversity
  final memberCount = (index + 1) * 12 + (index % 5) * 7;
  final staterNames = [
    'Vincent📝📝📝',
    'Mama Africa',
    'Madam Masaka',
    'Sudo Developer',
    'John Doe',
  ];
  final staterName = staterNames[index % staterNames.length];

  // Channels 0, 1, 3 are "own" channels. Channel index=3 has gifts hidden as example.
  final isOwnChannel = index == 0 || index == 1 || index == 3;
  final giftsVisible = index != 3; // Channel Title 4 has gifts hidden

  return ChartChannel(
    id: id,
    title: 'Channel Title ${index + 1}: Modern AI Discussion',
    memberCount: memberCount,
    staterName: staterName,
    staterAvatarUrl: 'https://picsum.photos/seed/stater$index/100/100',
    memberAvatarUrls: [
      'https://picsum.photos/seed/u${index}1/100/100',
      'https://picsum.photos/seed/u${index}2/100/100',
      index % 2 == 0 ? 'https://picsum.photos/seed/u${index}3/100/100' : null,
      null,
    ],
    isOwnChannel: isOwnChannel,
    giftsVisible: giftsVisible,
    isPrivate: index % 2 == 0,
    isActive: index % 3 != 0,
    imageUrl: 'https://picsum.photos/seed/chlogo$index/100/100',
    leaderAvatarUrl:
        'https://picsum.photos/seed/leader$index/100/100', // Unique Leader per channel
    subChannels: index < 2
        ? [
            ChartChannel(
              id: '${id}_sub1',
              title: 'Sub Channel 1 of ${index + 1}',
              memberCount: (memberCount / 3).floor(),
              staterName: 'Sub Stater',
              isOwnChannel: false,
              isPrivate: true,
              isActive: true,
            ),
          ]
        : [],
    posts: [
      ChannelPost(
        id: 'p1',
        authorName: 'boombaname 1',
        content:
            'member\'s massage here. This is a longer message showing how the text wraps inside the bordered bubble.',
        timestamp: DateTime.now(),
        imageUrls: [
          'https://picsum.photos/seed/post1/400/400',
          'https://picsum.photos/seed/post2/400/400',
        ],
      ),
    ],
  );
});











