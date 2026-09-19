import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/core/utils/constants/icon_path.dart';
import 'package:project_structure/routes/app_routes.dart';
import 'package:project_structure/features/notification/presentation/controllers/notification_controller.dart';
import 'package:project_structure/features/producer/data/models/product_model.dart';
import 'package:project_structure/features/producer/presentation/controllers/product_list_controller.dart';
import 'package:project_structure/features/producer/presentation/views/product/product_detail_screen.dart';
import '../../presentation/controllers/producer_dashboard_controller.dart';
import '../controllers/producer_main_controller.dart';
import 'widgets/sales_revenue_section.dart';

class ProducerDashboardScreen extends StatelessWidget {
  const ProducerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProducerDashboardController controller = Get.put(
      ProducerDashboardController(),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Forest Green Header block
            _buildHeader(controller),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Asymmetrical Statistics Grid
                  _buildStatsGrid(controller),

                  SizedBox(height: 24.h),

                  // 3. Sales Revenue Section
                  SalesRevenueSection(controller: controller),

                  SizedBox(height: 24.h),

                  // 4. Recent Listings Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Listings",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle See All navigation (switch to Tab 1 / Products tab)
                          final mainController =
                              Get.find<
                                ProducerMainController
                              >(); // Find ProducerMainController
                          mainController.changeIndex(1);
                        },
                        child: Row(
                          children: [
                            Text(
                              "See all",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.sp,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 4. Listings List
                  Obx(() {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recentListings.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final listing = controller.recentListings[index];
                        return _buildListingCard(listing);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ProducerDashboardController controller) {
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
              Row(
                children: [
                  // User Avatar
                  Obx(
                    () => CircleAvatar(
                      radius: 26.r,
                      backgroundImage: CachedNetworkImageProvider(
                        controller.avatarUrl.value,
                      ),
                      backgroundColor: AppColors.white.withAlpha(50),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Welcome Text & Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.white.withAlpha(200),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Obx(
                          () => Text(
                            controller.producerName.value,
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chat button
                  _buildHeaderIconButton(
                    iconPath: IconPath.chat,
                    onTap: () => Get.toNamed(AppRoute.chatList),
                    hasBadge: true,
                  ),
                  SizedBox(width: 12.w),

                  // Notification button
                  Obx(() {
                    final notificationCtrl = Get.find<NotificationController>();
                    return _buildHeaderIconButton(
                      iconPath: IconPath.notification,
                      onTap: () => Get.toNamed(AppRoute.notification),
                      hasBadge: notificationCtrl.unreadCount.value > 0,
                    );
                  }),
                ],
              ),

              SizedBox(height: 16.h),

              // Farm name pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.white.withAlpha(38)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.h,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors
                            .success, // Use success color for active state
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(
                      () => Text(
                        controller.farmName.value,
                        style: GoogleFonts.inter(
                          color: AppColors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required String iconPath,
    required VoidCallback onTap,
    required bool hasBadge,
  }) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 44.h,
            height: 44.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(
                40,
              ), // Darker overlay badge style background
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              iconPath,
              width: 32.h,
              height: 32.h,
              color: AppColors.white,
            ),
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Container(
              width: 8.h,
              height: 8.h,
              decoration: const BoxDecoration(
                color: Color(0xFFE57373), // Red notification indicator
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsGrid(ProducerDashboardController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Active Listings - tall card)
        Expanded(
          child: Container(
            height: 220.h,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top icon
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(38),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ),

                // Harvest picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://images.unsplash.com/photo-1606041008023-472dfb5e530f?w=400",
                    height: 80.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: AppColors.white.withAlpha(20)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                ),

                // Stats text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Active Listings",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withAlpha(200),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Obx(
                      () => Text(
                        "${controller.activeListings.value}",
                        style: GoogleFonts.inter(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 16.w),

        // Right Column (Pending Orders & Monthly Revenue)
        Expanded(
          child: Column(
            children: [
              // Pending Orders (Green Card)
              Container(
                height: 102.h,
                width: double.infinity,
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.h),
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(38),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.white,
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pending Orders",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withAlpha(200),
                          ),
                        ),
                        Obx(
                          () => Text(
                            "${controller.pendingOrders.value}",
                            style: GoogleFonts.inter(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Monthly Revenue (White Card)
              Container(
                height: 102.h,
                width: double.infinity,
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.containerBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.attach_money_rounded,
                        color: AppColors.primary,
                        size: 16.sp,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Monthly Revenue",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "₦${controller.monthlyRevenue.value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
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
        ),
      ],
    );
  }

  Widget _buildListingCard(DashboardListingModel listing) {
    Color statusColor = AppColors.primary;
    if (listing.status == 'Low Stock') {
      statusColor = AppColors.warning;
    } else if (listing.status == 'Out of Stock') {
      statusColor = AppColors.error;
    }

    return GestureDetector(
      onTap: () {
        final productController = Get.put(ProductListController());
        ProductModel? matchingProduct;
        for (var p in productController.products) {
          if (p.title.toLowerCase().contains(listing.title.toLowerCase()) ||
              listing.title.toLowerCase().contains(p.title.toLowerCase())) {
            matchingProduct = p;
            break;
          }
        }
        final product =
            matchingProduct ??
            ProductModel(
              id: 'mock_${listing.title}',
              title: listing.title,
              category: listing.category,
              price: listing.price,
              unit: listing.unit.replaceAll(
                RegExp(r'[/\s]+'),
                '',
              ), // e.g. "/ crate" -> "crate"
              stock: listing.stock,
              status: listing.status == 'Out of Stock'
                  ? 'Out of Stock'
                  : 'Active',
              imageUrl: listing.imageUrl,
              sold: listing.sold,
              rating: listing.rating,
              ratingCount: 24,
              description:
                  'Premium quality ${listing.title} harvested fresh from our farms. Firm, clean, and packed with care to ensure high quality on delivery.',
              location: 'Adeyemi Green Farms, Nigeria',
              listedDate: 'June 2, 2026',
            );
        Get.to(() => ProductDetailScreen(product: product));
      },
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.containerBorder),
        ),
        child: Row(
          children: [
            // Crop Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: listing.imageUrl,
                height: 72.h,
                width: 72.h,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.containerSoft),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              ),
            ),

            SizedBox(width: 12.w),

            // Middle content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    listing.category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Stock Dot and Status Text
                  Row(
                    children: [
                      Container(
                        width: 6.h,
                        height: 6.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        listing.status == 'Out of Stock'
                            ? 'Out of Stock'
                            : '${listing.status} (${listing.stock} left)',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right Price & Social Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₦${listing.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${listing.unit}",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 24.h),

                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 14.sp),
                    SizedBox(width: 2.w),
                    Text(
                      "${listing.rating}",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      " · ${listing.sold} sold",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
