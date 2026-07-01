import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/producer/data/models/product_model.dart';
import 'package:project_structure/features/producer/presentation/controllers/product_list_controller.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductListController controller = Get.put(ProductListController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // 1. Forest Green Header block
          _buildHeader(controller),

          // 2. Filter Chips
          SizedBox(height: 16.h),
          _buildFilterChips(controller),
          SizedBox(height: 12.h),

          // 3. Products List
          Expanded(
            child: Obx(() {
              final filtered = controller.filteredProducts;

              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 48.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No products found",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Try searching for another term or changing your filter criteria.",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  return _buildProductCard(context, product, controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ProductListController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AgroConnect",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.white.withAlpha(200),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "My Products",
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  // Filter slider button (tune icon with sorting options)
                  Obx(() {
                    return PopupMenuButton<String>(
                      initialValue: controller.selectedSortOption.value,
                      onSelected: (String value) {
                        controller.updateSortOption(value);
                      },
                      offset: Offset(0, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      color: AppColors.white,
                      elevation: 4,
                      itemBuilder: (BuildContext context) {
                        final options = [
                          'Newest',
                          'Price: Low–High',
                          'Price: High–Low',
                          'Qty: Low–High',
                        ];
                        return options.map((option) {
                          final isSelected = controller.selectedSortOption.value == option;
                          return PopupMenuItem<String>(
                            value: option,
                            padding: EdgeInsets.zero,
                            child: Container(
                              width: 180.w,
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                              margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withAlpha(15) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    option,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 8.h,
                                      height: 8.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        width: 44.h,
                        height: 44.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.black.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: AppColors.white,
                          size: 22.sp,
                        ),
                      ),
                    );
                  }),
                ],
              ),

              SizedBox(height: 18.h),

              // Search bar
              Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  onChanged: controller.updateSearchQuery,
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.hintColor.withAlpha(180),
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.hintColor.withAlpha(180),
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(ProductListController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: controller.filters.map((filter) {
          return Obx(() {
            final isSelected = controller.selectedFilter.value == filter;
            return GestureDetector(
              onTap: () => controller.changeFilter(filter),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.containerSoft,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.containerBorder,
                    width: 1.w,
                  ),
                ),
                child: Text(
                  filter,
                  style: GoogleFonts.inter(
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel product,
    ProductListController controller,
  ) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.containerBorder),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 80.h,
                width: 80.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.containerSoft),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.containerSoft,
                  child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Middle: Details
            Expanded(
              child: SizedBox(
                height: 80.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          product.category,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "₦${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              TextSpan(
                                text: " /${product.unit}",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Text(
                              product.stock > 0 ? "${product.stock} units left" : "No stock",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              product.stock > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                              size: 14.sp,
                              color: product.stock > 0 ? AppColors.success : AppColors.error,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Right: Action Menu & Status Badge
            SizedBox(
              height: 80.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showProductActions(context, product, controller),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.all(4.h),
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textSecondary.withAlpha(200),
                        size: 20.sp,
                      ),
                    ),
                  ),
                  _buildStatusBadge(product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ProductModel product) {
    final bool isActive = product.isActive;
    final Color color = isActive ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withAlpha(40), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            product.status,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showProductActions(
    BuildContext context,
    ProductModel product,
    ProductListController controller,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 48.h,
                    width: 48.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        product.category,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildActionItem(
              icon: Icons.edit_outlined,
              title: "Edit Listing",
              onTap: () {
                Get.back();
                Get.snackbar("Info", "Edit product functionality coming soon");
              },
            ),
            _buildActionItem(
              icon: product.isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              title: product.isActive ? "Mark as Out of Stock" : "Mark as Active",
              onTap: () {
                controller.toggleProductStatus(product.id);
                Get.back();
              },
            ),
            const Divider(),
            _buildActionItem(
              icon: Icons.delete_outline_rounded,
              title: "Delete Listing",
              titleColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: () {
                controller.deleteProduct(product.id);
                Get.back();
                Get.snackbar(
                  "Success",
                  "${product.title} has been deleted",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error.withAlpha(20),
                  colorText: AppColors.error,
                );
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: titleColor ?? AppColors.textPrimary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
