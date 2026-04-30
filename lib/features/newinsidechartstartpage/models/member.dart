import 'package:crown/features/widgets/chartcard/models/media_data.dart';
import 'package:crown/gifts/models/gift_model.dart';

class ReceivedGift {
  final GiftModel gift;
  final String giverName;
  final String giverAvatarUrl;
  final DateTime receivedAt;

  ReceivedGift({
    required this.gift,
    required this.giverName,
    required this.giverAvatarUrl,
    required this.receivedAt,
  });
}

class Member {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isFrequentlyContacted;
  final String? title;
  final String? pointsDisplay;
  final int receivedCoins;
  final List<ReceivedGift> receivedGifts;
  final int channelsCount;
  MediaData? selectedMedia;

  Member({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isFrequentlyContacted = false,
    this.title,
    this.pointsDisplay,
    this.receivedCoins = 0,
    this.receivedGifts = const [],
    this.channelsCount = 0,
    this.selectedMedia,
  });
}











