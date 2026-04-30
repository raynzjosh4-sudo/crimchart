import '../models/member.dart';
import '../models/chart.dart';
import 'givengifts.dart';

final List<Member> dummyMembers = List.generate(50, (index) {
  final id = (index + 1).toString();
  String name;
  String? avatarUrl;

  if (index == 0) {
    name = '~ Mama Africa';
  } else if (index == 1) name = 'Madam Masaka';
  else if (index == 2) name = 'Vyani';
  else if (index == 3) name = 'Benitah Masaka';
  else if (index == 4) name = 'Vincent📝📝📝';
  else if (index == 5) name = 'Eron Musoke Customer';
  else if (index == 6) name = '+256709727053';
  else if (index == 7) name = '1 Unkwn';
  else name = 'Member $id';

  // Add some random avatars to demonstrate the look
  if (index % 3 == 0) {
    avatarUrl = 'https://picsum.photos/seed/member$id/100/100';
  }

  return Member(
    id: id,
    name: name,
    avatarUrl: avatarUrl,
    isFrequentlyContacted: index < 6,
    title: index == 0
        ? 'The Great Chart Master and Pioneer of Music'
        : 'Elite Member & Strategy Specialist',
    pointsDisplay: index == 0 ? '1.2Me' : '${(index + 1) * 120}kp',
    receivedCoins: (index + 1) * 15,
    receivedGifts: generateDummyReceivedGifts(index),
    channelsCount: (index * 3) % 12 + 1,
  );
});

final List<Chart> dummyCharts = [
  Chart(
    id: 'a',
    title: 'Top Performers Chart',
    memberCount: 24,
    staterName: 'Vincent📝📝📝',
    staterAvatarUrl: 'https://picsum.photos/seed/v1/100/100',
    memberAvatarUrls: [
      'https://picsum.photos/seed/u1/100/100',
      'https://picsum.photos/seed/u2/100/100',
      'https://picsum.photos/seed/u3/100/100',
      null,
    ],
  ),
  Chart(
    id: 'b',
    title: 'Loyal Customers Chart',
    memberCount: 57,
    staterName: 'Mama Africa',
    staterAvatarUrl: 'https://picsum.photos/seed/ma1/100/100',
    memberAvatarUrls: [
      'https://picsum.photos/seed/u4/100/100',
      'https://picsum.photos/seed/u5/100/100',
      null,
    ],
  ),
  Chart(
    id: 'c',
    title: 'VIP Exclusive Chart',
    memberCount: 12,
    staterName: 'Madam Masaka',
    staterAvatarUrl: 'https://picsum.photos/seed/mm1/100/100',
    memberAvatarUrls: [
      'https://picsum.photos/seed/u6/100/100',
      null,
      null,
    ],
  ),
];





























