import 'package:crown/features/newinsidechartstartpage/models/member.dart';

class AggregatedGift {
  final ReceivedGift sample;
  int count;

  AggregatedGift(this.sample, this.count);
}

class GiverGroup {
  final String giverName;
  final String giverAvatarUrl;
  final List<ReceivedGift> gifts;

  int _totalCoins = 0;
  int get totalCoins => _totalCoins;
  int get totalGifts => gifts.length;

  GiverGroup(this.giverName, this.giverAvatarUrl, this.gifts);

  void addGift(ReceivedGift gift) {
    gifts.add(gift);
    _totalCoins += gift.gift.coinPrice;
  }

  List<AggregatedGift> get aggregatedGifts {
    final map = <String, AggregatedGift>{};
    for (final gift in gifts) {
      final key = gift.gift.id;
      if (map.containsKey(key)) {
        map[key]!.count++;
      } else {
        map[key] = AggregatedGift(gift, 1);
      }
    }
    return map.values.toList();
  }
}











