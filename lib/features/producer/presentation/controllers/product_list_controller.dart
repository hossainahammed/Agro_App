import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/product_model.dart';

class ProductListController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxString selectedSortOption = 'Newest'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  // Filter options constant
  final List<String> filters = ['All', 'Active', 'Out of Stock'];

  @override
  void onInit() {
    super.onInit();
    _loadMockProducts();
  }

  void _loadMockProducts() {
    products.assignAll([
      ProductModel(
        id: '1',
        title: 'Fresh Roma Tomatoes',
        category: 'Vegetables',
        price: 4500.0,
        unit: 'crate',
        stock: 42,
        status: 'Active',
        imageUrl: 'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400',
        sold: 128,
        rating: 4.8,
        ratingCount: 36,
        description: 'Sun-ripened Roma tomatoes harvested from our pesticide-free greenhouse in Kaduna State. Firm, fleshy, and rich in natural sugars — ideal for cooking, stews, and paste. Picked at peak ripeness and packed within 24 hours of harvest to ensure freshness on delivery.',
        location: 'Kaduna State, Nigeria',
        listedDate: 'June 2, 2026',
      ),
      ProductModel(
        id: '2',
        title: 'Sweet Corn',
        category: 'Grains',
        price: 2200.0,
        unit: 'bag',
        stock: 15,
        status: 'Active',
        imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
        sold: 74,
        rating: 4.6,
        ratingCount: 22,
        description: 'Premium quality sweet corn, harvested fresh from the cob. Ideal for boiling, roasting, or mixing into salads and cooked dishes. Naturally sweet and loaded with fiber.',
        location: 'Oyo State, Nigeria',
        listedDate: 'May 28, 2026',
      ),
      ProductModel(
        id: '3',
        title: 'Organic Pepper',
        category: 'Spices',
        price: 6800.0,
        unit: 'kg',
        stock: 0,
        status: 'Out of Stock',
        imageUrl: 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400',
        sold: 210,
        rating: 4.9,
        ratingCount: 48,
        description: 'Fiery organic habanero peppers grown naturally without chemical fertilizers. Known for their distinct aroma and sharp heat, perfect for traditional spicy stews and hot sauces.',
        location: 'Kano State, Nigeria',
        listedDate: 'June 1, 2026',
      ),
      ProductModel(
        id: '4',
        title: 'Cassava Flour',
        category: 'Processed',
        price: 3100.0,
        unit: 'bag',
        stock: 88,
        status: 'Active',
        imageUrl: 'https://images.unsplash.com/photo-1574325131876-a7999373de5f?w=400',
        sold: 56,
        rating: 4.7,
        ratingCount: 15,
        description: 'Finely processed gluten-free cassava flour, perfect for baking and making traditional fufu. Rich in carbohydrates, well-sieved, and packaged under strict hygienic conditions.',
        location: 'Ogun State, Nigeria',
        listedDate: 'April 15, 2026',
      ),
      ProductModel(
        id: '5',
        title: 'Watermelon',
        category: 'Fruits',
        price: 1800.0,
        unit: 'piece',
        stock: 0,
        status: 'Out of Stock',
        imageUrl: 'https://images.unsplash.com/photo-1589615228446-015017e4e04f?w=400',
        sold: 142,
        rating: 4.5,
        ratingCount: 30,
        description: 'Sweet, juicy watermelons with high water content, ideal for refreshing summer drinks or direct consumption. Grown in sandy loam soil for maximum sweetness.',
        location: 'Jigawa State, Nigeria',
        listedDate: 'May 10, 2026',
      ),
      ProductModel(
        id: '6',
        title: 'Garden Eggs',
        category: 'Vegetables',
        price: 900.0,
        unit: 'basket',
        stock: 30,
        status: 'Active',
        imageUrl: 'https://images.unsplash.com/photo-1590378341256-e195bd41855e?w=400',
        sold: 95,
        rating: 4.4,
        ratingCount: 18,
        description: 'Fresh, bitter-sweet garden eggs (eggplants) rich in dietary fiber and essential minerals. Commonly enjoyed raw with peanut paste or cooked in traditional sauces.',
        location: 'Enugu State, Nigeria',
        listedDate: 'June 5, 2026',
      ),
    ]);
  }

  // Filtered and sorted list based on filter chip selection, search query, and sort options
  List<ProductModel> get filteredProducts {
    final list = products.where((product) {
      // 1. Filter by Status
      if (selectedFilter.value == 'Active' && !product.isActive) {
        return false;
      }
      if (selectedFilter.value == 'Out of Stock' && !product.isOutOfStock) {
        return false;
      }

      // 2. Filter by Search Query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final matchesTitle = product.title.toLowerCase().contains(query);
        final matchesCategory = product.category.toLowerCase().contains(query);
        return matchesTitle || matchesCategory;
      }

      return true;
    }).toList();

    // Apply Sorting
    switch (selectedSortOption.value) {
      case 'Price: Low–High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High–Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Qty: Low–High':
        list.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case 'Newest':
      default:
        list.sort((a, b) => _parseDate(b.listedDate).compareTo(_parseDate(a.listedDate)));
        break;
    }

    return list;
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('MMMM d, yyyy').parse(dateStr);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  void updateSortOption(String option) {
    selectedSortOption.value = option;
  }


  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void toggleProductStatus(String id) {
    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final product = products[index];
      final newStatus = product.isActive ? 'Out of Stock' : 'Active';
      final newStock = product.isActive ? 0 : 10; // Simple transition logic
      products[index] = ProductModel(
        id: product.id,
        title: product.title,
        category: product.category,
        price: product.price,
        unit: product.unit,
        stock: newStock,
        status: newStatus,
        imageUrl: product.imageUrl,
        sold: product.sold,
        rating: product.rating,
        ratingCount: product.ratingCount,
        description: product.description,
        location: product.location,
        listedDate: product.listedDate,
      );
    }
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
  }
}
