class GiftModel {
  final String id;
  final String name;
  final int coinPrice;
  final String imageUrl;
  final String? badge; // e.g., 'Hot', 'New'
  final bool isAnimated;

  const GiftModel({
    required this.id,
    required this.name,
    required this.coinPrice,
    required this.imageUrl,
    this.badge,
    this.isAnimated = false,
  });
}





























