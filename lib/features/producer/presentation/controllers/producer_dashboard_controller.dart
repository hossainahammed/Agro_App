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

class RevenueChartData {
  final List<String> xLabels;
  final List<double> values;
  final double maxY;
  final double minY;
  final List<String> yLabels;
  final int highlightedIndex;
  final int boldXIndex;

  const RevenueChartData({
    required this.xLabels,
    required this.values,
    this.maxY = 20.0,
    this.minY = 0.0,
    this.yLabels = const ['\$20k', '\$16k', '\$12k', '\$8k', '\$4k', '\$0'],
    this.highlightedIndex = 4,
    this.boldXIndex = 3,
  });
}

class ProducerDashboardController extends GetxController {
  // Statistics
  final RxInt activeListings = 24.obs;
  final RxInt pendingOrders = 8.obs;
  final RxDouble monthlyRevenue = 482500.0.obs;

  // Sales Revenue Chart
  final RxString selectedRevenuePeriod = 'Week'.obs;

  final Map<String, RevenueChartData> revenueData = {
    'Week': const RevenueChartData(
      xLabels: ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'],
      values: [7.8, 5.2, 11.6, 10.4, 16.8, 11.2],
      highlightedIndex: 4, // Oct: marker circle & vertical guide line
      boldXIndex: 3,       // Sep: bold text as shown in design
    ),
    'Month': const RevenueChartData(
      xLabels: ['Jan', 'Mar', 'May', 'Jul', 'Sep', 'Nov'],
      values: [6.2, 9.5, 8.4, 13.8, 17.5, 12.8],
      highlightedIndex: 4,
      boldXIndex: 4,
    ),
    'Year': const RevenueChartData(
      xLabels: ['2021', '2022', '2023', '2024', '2025', '2026'],
      values: [5.5, 8.2, 11.0, 14.5, 17.8, 15.2],
      highlightedIndex: 4,
      boldXIndex: 4,
    ),
  };

  RevenueChartData get currentRevenueData =>
      revenueData[selectedRevenuePeriod.value] ?? revenueData['Week']!;

  void changeRevenuePeriod(String period) {
    selectedRevenuePeriod.value = period;
  }

  // Profile data
  final RxString producerName = "Samuel Adeyemi".obs;
  final RxString farmName = "Adeyemi Green Farms".obs;
  final RxString avatarUrl =
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150".obs;

  // Recent listings
  final RxList<DashboardListingModel> recentListings =
      <DashboardListingModel>[].obs;

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
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiAQU8SzvnIS_EDSfaRhkfPdb7OBNwXnTBWdKll0-vXw&s=10",
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
        imageUrl:
            "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400",
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
        imageUrl:
            "https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400",
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
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPX6pKhfqxyszAWwtkyyOF7IqZLe84096JoWwtgHGAkQ&s=10",
      ),
    ]);
  }
}
