class BuyerProductModel {
  final String id;
  final String title;
  final String farmName;
  final bool isFarmVerified;
  final double price;
  final String unit;
  final double rating;
  final int ratingCount;
  final String category;
  final List<String> badges;
  final String imageUrl;
  final String fallbackEmoji;

  const BuyerProductModel({
    required this.id,
    required this.title,
    required this.farmName,
    this.isFarmVerified = true,
    required this.price,
    required this.unit,
    required this.rating,
    required this.ratingCount,
    required this.category,
    this.badges = const [],
    required this.imageUrl,
    required this.fallbackEmoji,
  });

  bool get isHot => badges.contains('HOT');
  bool get isOrganic => badges.contains('ORGANIC');
}
