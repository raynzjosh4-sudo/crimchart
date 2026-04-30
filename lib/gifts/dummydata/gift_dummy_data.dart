import 'package:crown/gifts/models/gift_model.dart';

final List<GiftModel> dummyGifts = [
  // --- 7 FREE GIFTS (0 Coins) ---
  const GiftModel(
    id: 'f1',
    name: 'Wave',
    coinPrice: 0,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Waving%20Hand.png',
  ),
  const GiftModel(
    id: 'f2',
    name: 'Clap',
    coinPrice: 0,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Clapping%20Hands.png',
  ),
  const GiftModel(
    id: 'f3',
    name: 'Smile',
    coinPrice: 0,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Grinning%20Face.png',
  ),
  const GiftModel(
    id: 'f4',
    name: 'Like',
    coinPrice: 0,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Thumbs%20Up.png',
  ),
  const GiftModel(
    id: 'f5',
    name: 'Fire',
    coinPrice: 0,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Fire.png',
  ),
  const GiftModel(
    id: 'f6',
    name: 'Cool',
    coinPrice: 0,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Smiling%20Face%20with%20Sunglasses.png',
  ),
  const GiftModel(
    id: 'f7',
    name: 'Nice',
    coinPrice: 0,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/OK%20Hand.png',
  ),

  // --- 7 PAID GIFTS (Needs Coins) ---
  const GiftModel(
    id: 'p1',
    name: 'Hand Heart',
    coinPrice: 100,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Heart%20Hands.png',
    badge: 'Popular',
  ),
  const GiftModel(
    id: 'p2',
    name: 'GG',
    coinPrice: 10,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Video%20Game.png',
  ),
  const GiftModel(
    id: 'p3',
    name: 'TikTok',
    coinPrice: 20,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Musical%20Note.png',
  ),
  const GiftModel(
    id: 'p4',
    name: 'Pop',
    coinPrice: 15,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Food%20and%20drink/Popcorn.png',
  ),
  const GiftModel(
    id: 'p5',
    name: 'GOAT',
    coinPrice: 50,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals%20and%20nature/Goat.png',
    badge: 'Hot',
  ),
  const GiftModel(
    id: 'p6',
    name: 'Cake',
    coinPrice: 5,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Food%20and%20drink/Birthday%20Cake.png',
  ),
  const GiftModel(
    id: 'p7',
    name: 'Diamond',
    coinPrice: 500,
    imageUrl:
        'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Gem%20Stone.png',
    badge: 'Elite',
  ),

  // --- Extended Paginated Gifts (30+ additional) ---
  ...List.generate(
    35,
    (index) => GiftModel(
      id: 'ext_${index + 1}',
      name: 'Gift ${index + 8}',
      coinPrice: (index + 1) * 5,
      imageUrl:
          'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Activities/Gift%20Heart.png',
    ),
  ),
];











