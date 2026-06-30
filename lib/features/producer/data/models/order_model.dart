class OrderItemModel {
  final String productTitle;
  final int quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final String imageUrl;

  OrderItemModel({
    required this.productTitle,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
    required this.imageUrl,
  });
}

class OrderModel {
  final String id;
  final String time;
  final String date;
  final String buyerName;
  final String buyerShop;
  final String buyerInitial;
  final String productTitle;
  final int quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final String imageUrl;
  String status; // 'New', 'In Progress', 'Completed', 'Cancelled', 'Ready for Pickup', etc.
  final String? deliverBy;
  final bool showHeaderBadge;

  // Additional fields for detail screen
  final String phone;
  final String address;
  final String? note;
  final double deliveryFee;
  
  // Driver Details
  final String? driverName;
  final String? driverPhone;
  final String? driverVehicle;
  final double? driverRating;
  final String? driverPlateNumber;
  final String? driverImageUrl;

  // Multi-item details
  final List<OrderItemModel>? items;

  OrderModel({
    required this.id,
    required this.time,
    required this.date,
    required this.buyerName,
    required this.buyerShop,
    required this.buyerInitial,
    required this.productTitle,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
    required this.imageUrl,
    required this.status,
    this.deliverBy,
    this.showHeaderBadge = false,
    this.phone = '(+225) 812 340 9021',
    this.address = '14 Bello Road, Nassarawa GRA, Kano State',
    this.note = 'Please ensure crates are sealed properly.',
    this.deliveryFee = 1500.0,
    this.driverName,
    this.driverPhone,
    this.driverVehicle,
    this.driverRating,
    this.driverPlateNumber,
    this.driverImageUrl,
    this.items,
  });

  // Helper to get all items (defaults to primary item if items is null)
  List<OrderItemModel> get allItems {
    if (items != null && items!.isNotEmpty) {
      return items!;
    }
    return [
      OrderItemModel(
        productTitle: productTitle,
        quantity: quantity,
        unit: unit,
        unitPrice: unitPrice,
        totalPrice: totalPrice,
        imageUrl: imageUrl,
      )
    ];
  }
}
