import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/notification/presentation/views/notification_screen.dart';
import 'orders/order_list_screen.dart';
import '../controllers/buyer_home_controller.dart';
import '../../data/models/buyer_product_model.dart';

class BuyerDashboardScreen extends StatelessWidget {
  const BuyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BuyerHomeController>()
        ? Get.find<BuyerHomeController>()
        : Get.put(BuyerHomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature pale mint-sage
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // ========================================================
            // MAIN VIEW
            // ========================================================
            Column(
              children: [
                // Top Green Header (Location, Scanner, Notifications, Search)
                _buildTopHeader(context, controller),

                // Scrollable Body
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    behavior: HitTestBehavior.translucent,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        // --- Category Chips Carousel (from Image 2) ---
                        _buildCategoryCarousel(controller),

                        // --- Section Header: All Products & Filter ---
                        _buildSectionHeader(context, controller),

                        // --- 2-Column Product Grid ---
                        _buildProductGrid(context, controller),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

            // ========================================================
            // SAVED ADDRESSES DROPDOWN OVERLAY (Matching Attached Mockup)
            // ========================================================
            Obx(() {
              if (!controller.isAddressDropdownOpen.value) {
                return const SizedBox.shrink();
              }

              return Positioned.fill(
                child: GestureDetector(
                  onTap: controller.closeAddressDropdown,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.15),
                    child: Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 52.h,
                          left: 18.w,
                          right: 18.w,
                          child: GestureDetector(
                            onTap: () {}, // Prevent tap from closing
                            child: _buildSavedAddressesCard(context, controller),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ========================================================
  // TOP GREEN HEADER WIDGET
  // ========================================================
  Widget _buildTopHeader(BuildContext context, BuyerHomeController controller) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E5B2C),
            Color(0xFF164821),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        18.w,
        MediaQuery.of(context).padding.top + 10.h,
        18.w,
        16.h,
      ),
      child: Column(
        children: [
          // Row 1: Delivery Location & Right Action Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Delivery Location Button
              GestureDetector(
                onTap: controller.toggleAddressDropdown,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Container(
                      width: 32.h,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Deliver to",
                          style: GoogleFonts.inter(
                            fontSize: 10.5.sp,
                            color: Colors.white.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                controller.selectedAddress.value,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Obx(
                              () => Icon(
                                controller.isAddressDropdownOpen.value
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right Actions: Order Notes & Eco / Tree badge (matching attached mockup)
              Row(
                children: [
                  // Order Notes / Scan Document Icon Button
                  Container(
                    width: 36.h,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.assignment_outlined,
                        color: Colors.white,
                        size: 19.sp,
                      ),
                      onPressed: () {
                        Get.to(() => const OrderListScreen());
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Eco / Tree Circular Badge
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const NotificationScreen());
                    },
                    child: Container(
                      width: 36.h,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Icon(
                        Icons.park_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Row 2: Search Bar with Whole-Container Focus & Tuning Filter Button
          Obx(() {
            final isFocused = controller.isSearchFocused.value;

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(controller.searchFocusNode);
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF236830)
                        : Colors.transparent,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isFocused
                          ? const Color(0xFF236830).withValues(alpha: 0.25)
                          : Colors.black.withValues(alpha: 0.08),
                      blurRadius: isFocused ? 14 : 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: isFocused
                          ? const Color(0xFF236830)
                          : const Color(0xFF7D8F83),
                      size: 21.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        focusNode: controller.searchFocusNode,
                        onChanged: controller.onSearchChanged,
                        style: GoogleFonts.inter(
                          fontSize: 13.5.sp,
                          color: const Color(0xFF1E2D24),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search fresh produce, farms...",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: const Color(0xFF8A9B8F),
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (controller.searchQuery.value.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          controller.searchController.clear();
                          controller.onSearchChanged('');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Icon(
                            Icons.close_rounded,
                            color: const Color(0xFF7D8F83),
                            size: 18.sp,
                          ),
                        ),
                      ),
                    // Filter tuning button (opens saved addresses / search filter popup)
                    GestureDetector(
                      onTap: controller.toggleAddressDropdown,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2EFE4),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: const Color(0xFF236830),
                          size: 17.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ========================================================
  // SAVED ADDRESSES POPUP CARD (Exact Mockup Replica)
  // ========================================================
  Widget _buildSavedAddressesCard(
    BuildContext context,
    BuyerHomeController controller,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFD6E3D8), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: SAVED ADDRESSES
          Text(
            "SAVED ADDRESSES",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF7A8C80),
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: 10.h),

          // Addresses List
          Obx(() {
            return Column(
              children: controller.savedAddresses.map((addr) {
                final isSelected = controller.selectedAddress.value == addr;

                return InkWell(
                  onTap: () => controller.selectAddress(addr),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 9.h,
                    ),
                    margin: EdgeInsets.only(bottom: 4.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEAF4EC)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: isSelected
                              ? const Color(0xFF236830)
                              : const Color(0xFF7D8F83),
                          size: 18.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            addr,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF236830)
                                  : const Color(0xFF1E2D24),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.my_location_rounded,
                            color: const Color(0xFF236830),
                            size: 18.sp,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),

          const Divider(color: Color(0xFFE2EDE4), height: 16),

          // + Add New Address
          InkWell(
            onTap: () {
              controller.closeAddressDropdown();
              _showAddNewAddressDialog(context, controller);
            },
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: const Color(0xFF236830),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Add New Address",
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF236830),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to Add New Address
  void _showAddNewAddressDialog(
    BuildContext context,
    BuyerHomeController controller,
  ) {
    final textController = TextEditingController();

    Get.defaultDialog(
      title: "Add New Address",
      titleStyle: GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 17.sp,
        color: const Color(0xFF1E2D24),
      ),
      contentPadding: EdgeInsets.all(16.h),
      content: TextField(
        controller: textController,
        style: GoogleFonts.inter(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: "Enter street address, city...",
          hintStyle: GoogleFonts.inter(fontSize: 13.sp),
          prefixIcon: const Icon(Icons.location_on_outlined),
          filled: true,
          fillColor: const Color(0xFFF2F7F3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFFD6E3D8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFFD6E3D8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFF236830), width: 1.5),
          ),
        ),
      ),
      textConfirm: "Save Address",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF236830),
      onConfirm: () {
        if (textController.text.trim().isNotEmpty) {
          controller.addNewAddress(textController.text.trim());
          Get.back();
        }
      },
    );
  }

  // ========================================================
  // CATEGORY CAROUSEL (Matching Image 2 banner)
  // ========================================================
  Widget _buildCategoryCarousel(BuyerHomeController controller) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 14.h, bottom: 6.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        itemCount: BuyerHomeController.categories.length,
        itemBuilder: (context, index) {
          final cat = BuyerHomeController.categories[index];
          final name = cat['name']!;
          final emoji = cat['emoji']!;

          return Obx(() {
            final isSelected = controller.selectedCategory.value == name;

            return GestureDetector(
              onTap: () => controller.selectCategory(name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF236830) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF236830)
                        : const Color(0xFFD6E3D8),
                    width: 1.0,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: const Color(0xFF236830).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (name == 'All') ...[
                      Icon(
                        Icons.eco_rounded,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF236830),
                        size: 15.sp,
                      ),
                      SizedBox(width: 5.w),
                    ] else if (emoji.isNotEmpty) ...[
                      Text(
                        emoji,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(width: 6.w),
                    ],
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF384A3E),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // ========================================================
  // SECTION HEADER: "All Products" & "Filter" Button
  // ========================================================
  Widget _buildSectionHeader(
    BuildContext context,
    BuyerHomeController controller,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Products",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Obx(
                () => Text(
                  "${controller.filteredProducts.length} items available",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF7A8C80),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),

          // Filter Button Pill
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context, controller),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color(0xFFD6E3D8),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: const Color(0xFF236830),
                    size: 15.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Filter",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF236830),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // 2-COLUMN PRODUCT GRID
  // ========================================================
  Widget _buildProductGrid(
    BuildContext context,
    BuyerHomeController controller,
  ) {
    return Obx(() {
      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48.sp,
                color: const Color(0xFF9EABA2),
              ),
              SizedBox(height: 12.h),
              Text(
                "No produce found",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Try searching for another produce name or reset your category filters.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: const Color(0xFF7A8C80),
                ),
              ),
              SizedBox(height: 14.h),
              ElevatedButton(
                onPressed: controller.resetFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF236830),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: const Text("Reset Filters"),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 14.h,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product, controller);
          },
        ),
      );
    });
  }

  // ========================================================
  // SINGLE PRODUCT CARD (Exact Mockup Replica with /crate, /kg, /bag, etc.)
  // ========================================================
  Widget _buildProductCard(
    BuyerProductModel product,
    BuyerHomeController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with Badges & Heart Icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                child: Container(
                  height: 124.h,
                  width: double.infinity,
                  color: const Color(0xFFF4F8F5),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Text(
                        product.fallbackEmoji,
                        style: TextStyle(fontSize: 42.sp),
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Text(
                        product.fallbackEmoji,
                        style: TextStyle(fontSize: 42.sp),
                      ),
                    ),
                  ),
                ),
              ),

              // Badges in top-left
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.isHot)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        margin: EdgeInsets.only(bottom: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "🔥 HOT",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (product.isOrganic)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "🌱 ORGANIC",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Favorite Heart Button in top-right
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Obx(() {
                  final isFav =
                      controller.favoriteProductIds.contains(product.id);

                  return GestureDetector(
                    onTap: () => controller.toggleFavorite(product.id),
                    child: Container(
                      width: 28.h,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFav
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF7D8F83),
                        size: 16.sp,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          // Content Details Area
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Title
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
                SizedBox(height: 3.h),

                // Farm Name with Verified Icon
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.farmName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: const Color(0xFF7A8C80),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    if (product.isFarmVerified) ...[
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.check_circle_rounded,
                        color: const Color(0xFF236830),
                        size: 12.sp,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 5.h),

                // Rating: ★ 4.8 (124)
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 15.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      product.rating.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "(${product.ratingCount})",
                      style: GoogleFonts.inter(
                        fontSize: 10.5.sp,
                        color: const Color(0xFF7A8C80),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Price & Add Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "₦${product.price.toStringAsFixed(0)}",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF236830),
                            ),
                          ),
                          TextSpan(
                            text: " /${product.unit}",
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: const Color(0xFF7A8C80),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add Button (Circular soft mint with green +)
                    GestureDetector(
                      onTap: () => controller.addToCart(product),
                      child: Container(
                        width: 30.h,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2EFE4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: const Color(0xFF236830),
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // FILTER MODAL BOTTOM SHEET
  // ========================================================
  void _showFilterBottomSheet(
    BuildContext context,
    BuyerHomeController controller,
  ) {
    final tempSort = controller.selectedSort.value.obs;
    final tempOrganic = controller.onlyOrganic.value.obs;
    final tempHot = controller.onlyHot.value.obs;

    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6DFD8),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter & Sort Produce",
                    style: GoogleFonts.inter(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    child: Text(
                      "Reset",
                      style: GoogleFonts.inter(
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Sort Options
              Text(
                "Sort by",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  'Popular',
                  'Rating',
                  'Price: Low to High',
                  'Price: High to Low',
                ].map((sortOption) {
                  return Obx(() {
                    final isSel = tempSort.value == sortOption;
                    return GestureDetector(
                      onTap: () => tempSort.value = sortOption,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSel
                              ? const Color(0xFF236830)
                              : const Color(0xFFF2F7F3),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isSel
                                ? const Color(0xFF236830)
                                : const Color(0xFFD6E3D8),
                          ),
                        ),
                        child: Text(
                          sortOption,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight:
                                isSel ? FontWeight.bold : FontWeight.w500,
                            color: isSel
                                ? Colors.white
                                : const Color(0xFF384A3E),
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              SizedBox(height: 16.h),

              // Tag Badges Filters
              Text(
                "Special Badges",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Obx(
                    () => FilterChip(
                      label: const Text("🌱 Only Organic"),
                      selected: tempOrganic.value,
                      onSelected: (val) => tempOrganic.value = val,
                      selectedColor:
                          const Color(0xFF10B981).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFF236830),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => FilterChip(
                      label: const Text("🔥 Hot Deals"),
                      selected: tempHot.value,
                      onSelected: (val) => tempHot.value = val,
                      selectedColor:
                          const Color(0xFFEF4444).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),

              // Apply CTA
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilterOptions(
                      sort: tempSort.value,
                      organic: tempOrganic.value,
                      hot: tempHot.value,
                    );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF236830),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    "Apply Filters",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
