import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../../data/models/buyer_product_model.dart';

class BuyerHomeController extends GetxController {
  // Address selection matching attached image
  final RxString selectedAddress = 'Plot 5, Abuja'.obs;
  final RxBool isAddressDropdownOpen = false.obs;

  final RxList<String> savedAddresses = <String>[
    '14 Bello Road, Kano',
    '12 Marina St, Lagos',
    'Plot 5, Abuja',
  ].obs;

  // Search
  final searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxString searchQuery = ''.obs;
  final RxBool isSearchFocused = false.obs;

  // Categories exactly as attached by user
  static const List<Map<String, String>> categories = [
    {'name': 'All', 'emoji': '', 'icon': 'all'},
    {'name': 'Vegetables', 'emoji': '🥦', 'icon': 'veg'},
    {'name': 'Fruits', 'emoji': '🍊', 'icon': 'fruit'},
    {'name': 'Grains', 'emoji': '🌾', 'icon': 'grain'},
    {'name': 'Dairy', 'emoji': '🥛', 'icon': 'dairy'},
    {'name': 'Spices', 'emoji': '🌶', 'icon': 'spice'},
    {'name': 'Tubers', 'emoji': '🍠', 'icon': 'tuber'},
    {'name': 'Poultry', 'emoji': '🍗', 'icon': 'poultry'},
    {'name': 'Processed', 'emoji': '🍲', 'icon': 'processed'},
  ];

  final RxString selectedCategory = 'All'.obs;

  // Favorites & Cart
  final RxSet<String> favoriteProductIds = <String>{}.obs;
  final RxInt cartCount = 0.obs;
  final RxList<BuyerProductModel> cartItems = <BuyerProductModel>[].obs;

  // Filter & Sort States
  final RxString selectedSort = 'Popular'.obs;
  final RxBool onlyOrganic = false.obs;
  final RxBool onlyHot = false.obs;

  // Master product list exactly matching the attached image
  final List<BuyerProductModel> allProducts = const [
    BuyerProductModel(
      id: 'prod_1',
      title: 'Fresh Roma Tomatoes',
      farmName: 'Adeyemi Farms',
      isFarmVerified: true,
      price: 4500,
      unit: 'crate',
      rating: 4.8,
      ratingCount: 124,
      category: 'Vegetables',
      imageUrl:
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500',
      fallbackEmoji: '🍅',
    ),
    BuyerProductModel(
      id: 'prod_2',
      title: 'Organic Pepper',
      farmName: 'Bello Spice Farm',
      isFarmVerified: true,
      price: 6800,
      unit: 'kg',
      rating: 4.9,
      ratingCount: 89,
      category: 'Spices',
      imageUrl:
          'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=500',
      fallbackEmoji: '🌶',
    ),
    BuyerProductModel(
      id: 'prod_3',
      title: 'Sweet Corn',
      farmName: 'Eze Agro',
      isFarmVerified: false,
      price: 2200,
      unit: 'bag',
      rating: 4.6,
      ratingCount: 57,
      category: 'Grains',
      badges: ['HOT'],
      imageUrl:
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=500',
      fallbackEmoji: '🌽',
    ),
    BuyerProductModel(
      id: 'prod_4',
      title: 'Garden Eggs',
      farmName: 'Garba Greens',
      isFarmVerified: false,
      price: 900,
      unit: 'basket',
      rating: 4.5,
      ratingCount: 33,
      category: 'Vegetables',
      badges: ['ORGANIC'],
      imageUrl:
          'https://images.unsplash.com/photo-1528825871115-3581a5387919?w=500',
      fallbackEmoji: '🍆',
    ),
    BuyerProductModel(
      id: 'prod_5',
      title: 'Fresh Watermelon',
      farmName: 'Sunshine Fruits',
      isFarmVerified: true,
      price: 1800,
      unit: 'piece',
      rating: 4.7,
      ratingCount: 62,
      category: 'Fruits',
      badges: ['HOT'],
      imageUrl:
          'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=500',
      fallbackEmoji: '🍉',
    ),
    BuyerProductModel(
      id: 'prod_6',
      title: 'Cassava Flour',
      farmName: 'Abacos Mills',
      isFarmVerified: true,
      price: 3100,
      unit: 'bag',
      rating: 4.7,
      ratingCount: 64,
      category: 'Tubers',
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
      fallbackEmoji: '🌾',
    ),
    BuyerProductModel(
      id: 'prod_7',
      title: 'Ripe Plantain',
      farmName: 'Delta Harvest',
      isFarmVerified: false,
      price: 1200,
      unit: 'bunch',
      rating: 4.4,
      ratingCount: 78,
      category: 'Fruits',
      badges: ['ORGANIC'],
      imageUrl:
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500',
      fallbackEmoji: '🍌',
    ),
    BuyerProductModel(
      id: 'prod_8',
      title: 'Fresh Ginger',
      farmName: 'Plateau Roots',
      isFarmVerified: true,
      price: 3500,
      unit: 'kg',
      rating: 4.8,
      ratingCount: 91,
      category: 'Spices',
      badges: ['HOT', 'ORGANIC'],
      imageUrl:
          'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
      fallbackEmoji: '🫚',
    ),
  ];

  final RxList<BuyerProductModel> filteredProducts = <BuyerProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredProducts.assignAll(allProducts);
    searchFocusNode.addListener(() {
      isSearchFocused.value = searchFocusNode.hasFocus;
    });
  }

  void toggleAddressDropdown() {
    isAddressDropdownOpen.value = !isAddressDropdownOpen.value;
  }

  void closeAddressDropdown() {
    isAddressDropdownOpen.value = false;
  }

  void selectAddress(String address) {
    selectedAddress.value = address;
    isAddressDropdownOpen.value = false;
    AppSnackBar.success('Delivery location set to $address');
  }

  void addNewAddress(String newAddr) {
    if (newAddr.trim().isNotEmpty) {
      savedAddresses.add(newAddr.trim());
      selectedAddress.value = newAddr.trim();
      isAddressDropdownOpen.value = false;
      AppSnackBar.success('New address added and selected!');
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void toggleFavorite(String productId) {
    if (favoriteProductIds.contains(productId)) {
      favoriteProductIds.remove(productId);
    } else {
      favoriteProductIds.add(productId);
    }
  }

  void addToCart(BuyerProductModel product) {
    cartItems.add(product);
    cartCount.value = cartItems.length;
    AppSnackBar.success('Added ${product.title} to cart!');
  }

  void _applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();
    final cat = selectedCategory.value;

    filteredProducts.assignAll(
      allProducts.where((product) {
        // Category filter
        if (cat != 'All') {
          if (product.category.toLowerCase() != cat.toLowerCase()) {
            return false;
          }
        }

        // Search query filter
        if (query.isNotEmpty) {
          final matchesTitle = product.title.toLowerCase().contains(query);
          final matchesFarm = product.farmName.toLowerCase().contains(query);
          final matchesCat = product.category.toLowerCase().contains(query);
          if (!matchesTitle && !matchesFarm && !matchesCat) {
            return false;
          }
        }

        // Tag filters
        if (onlyOrganic.value && !product.isOrganic) {
          return false;
        }

        if (onlyHot.value && !product.isHot) {
          return false;
        }

        return true;
      }).toList(),
    );

    // Apply sorting
    if (selectedSort.value == 'Price: Low to High') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort.value == 'Price: High to Low') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (selectedSort.value == 'Rating') {
      filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }
  }

  void applyFilterOptions({
    required String sort,
    required bool organic,
    required bool hot,
  }) {
    selectedSort.value = sort;
    onlyOrganic.value = organic;
    onlyHot.value = hot;
    _applyFilters();
  }

  void resetFilters() {
    selectedSort.value = 'Popular';
    onlyOrganic.value = false;
    onlyHot.value = false;
    selectedCategory.value = 'All';
    searchController.clear();
    searchQuery.value = '';
    _applyFilters();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
