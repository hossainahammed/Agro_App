import 'package:get/get.dart';

class DashboardListingModel {
  final String title;
  final double price;
  final String unit;
  final String category;
  final int stock;
  final String status; // 'In Stock', 'Low Stock', 'Out of Stock'
  final double rating;
  final int sold;
  final String imageUrl;

  DashboardListingModel({
    required this.title,
    required this.price,
    required this.unit,
    required this.category,
    required this.stock,
    required this.status,
    required this.rating,
    required this.sold,
    required this.imageUrl,
  });
}

class ProducerDashboardController extends GetxController {
  // Statistics
  final RxInt activeListings = 24.obs;
  final RxInt pendingOrders = 8.obs;
  final RxDouble monthlyRevenue = 482500.0.obs;

  // Profile data
  final RxString producerName = "Samuel Adeyemi".obs;
  final RxString farmName = "Adeyemi Green Farms".obs;
  final RxString avatarUrl = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150".obs;

  // Recent listings
  final RxList<DashboardListingModel> recentListings = <DashboardListingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    recentListings.assignAll([
      DashboardListingModel(
        title: "Fresh Tomatoes",
        price: 4500.0,
        unit: "/ crate",
        category: "Vegetables",
        stock: 42,
        status: "In Stock",
        rating: 4.8,
        sold: 128,
        imageUrl: "https://images.unsplash.com/photo-1595855759920-86582396756a?w=400",
      ),
      DashboardListingModel(
        title: "Sweet Corn",
        price: 2200.0,
        unit: "/ bag",
        category: "Grains",
        stock: 15,
        status: "Low Stock",
        rating: 4.6,
        sold: 74,
        imageUrl: "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400",
      ),
      DashboardListingModel(
        title: "Organic Pepper",
        price: 6800.0,
        unit: "/ kg",
        category: "Spices",
        stock: 0,
        status: "Out of Stock",
        rating: 4.9,
        sold: 210,
        imageUrl: "https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400",
      ),
      DashboardListingModel(
        title: "Cassava Flour",
        price: 3100.0,
        unit: "/ bag",
        category: "Processed",
        stock: 88,
        status: "In Stock",
        rating: 4.7,
        sold: 56,
        imageUrl: "https://images.unsplash.com/photo-1574325131876-a7999373de5f?w=400",
      ),
    ]);
  }
}
