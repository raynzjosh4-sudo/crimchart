import 'package:crimchart/gifts/dummydata/gift_dummy_data.dart';

import '../models/member.dart';

List<ReceivedGift> generateDummyReceivedGifts(int memberIndex) {
  final massiveGifts = <ReceivedGift>[];
  // 3 givers for everyone, but for Member 28 (index 27), generate 20 givers as requested!
  final totalGivers = memberIndex == 27 ? 20 : 3;

  for (int g = 1; g <= totalGivers; g++) {
    final typesCount = dummyGifts.length > 22
        ? 22
        : dummyGifts.length; // Over 20 types
    for (int typeIndex = 0; typeIndex < typesCount; typeIndex++) {
      final giftType = dummyGifts[typeIndex];
      // Over 20 of each type
      for (int count = 0; count < 25; count++) {
        massiveGifts.add(
          ReceivedGift(
            gift: giftType,
            giverName: 'Generous User $g',
            giverAvatarUrl:
                'https://picsum.photos/seed/generous_${memberIndex}_$g/50/50',
            receivedAt: DateTime.now().subtract(
              Duration(minutes: massiveGifts.length),
            ),
          ),
        );
      }
    }
  }
  return massiveGifts;
}











