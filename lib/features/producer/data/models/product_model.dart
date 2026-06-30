class ProductModel {
  final String id;
  final String title;
  final String category;
  final double price;
  final String unit;
  final int stock;
  final String status; // 'Active' or 'Out of Stock'
  final String imageUrl;
  final int sold;
  final double rating;
  final int ratingCount;
  final String description;
  final String location;
  final String listedDate;

  ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.unit,
    required this.stock,
    required this.status,
    required this.imageUrl,
    required this.sold,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.location,
    required this.listedDate,
  });

  bool get isActive => status.toLowerCase() == 'active';
  bool get isOutOfStock => status.toLowerCase() == 'out of stock';
}
