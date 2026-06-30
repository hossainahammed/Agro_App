import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../../data/models/order_model.dart';
import '../../controllers/producer_order_controller.dart';
import 'producer_order_detail_screen.dart';

class ProducerOrderListScreen extends StatelessWidget {
  const ProducerOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProducerOrderController controller = Get.put(ProducerOrderController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // 1. Forest Green Header
          _buildHeader(controller),

          // 2. Custom Tabs Row
          _buildTabBar(controller),

          // 3. Orders List
          Expanded(
            child: Obx(() {
              final filtered = controller.filteredOrders;

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
                            Icons.shopping_bag_outlined,
                            size: 48.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No orders found",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Try searching for another order number, buyer, or product.",
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
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final order = filtered[index];
                  return _buildOrderCard(order);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ProducerOrderController controller) {
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
              // Small App Subtext
              Text(
                "AGROCONNECT",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppColors.white.withAlpha(180),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              // Main Screen Title
              Text(
                "My Orders",
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 18.h),

              // Search Input Box
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
                    hintText: "Search orders, buyers...",
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.white.withAlpha(150),
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.white.withAlpha(180),
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

  Widget _buildTabBar(ProducerOrderController controller) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: Obx(() {
        final activeTab = controller.selectedTab.value;
        return Row(
          children: controller.tabs.map((tab) {
            final bool isActive = activeTab == tab;
            final int count = controller.getCountForTab(tab);

            // Tab-specific colors for active state
            Color activeColor;
            switch (tab) {
              case 'New':
                activeColor = AppColors.warning; // Yellow
                break;
              case 'In Progress':
                activeColor = AppColors.info; // Blue
                break;
              case 'Completed':
                activeColor = AppColors.success; // Green
                break;
              case 'Cancelled':
                activeColor = AppColors.error; // Red
                break;
              default:
                activeColor = AppColors.primary;
            }

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(tab),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 14.h),
                    // Tab Label
                    Text(
                      tab,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),
                    // Badge Count
                    Container(
                      height: 20.h,
                      width: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : const Color(0xFFF0F4F2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: isActive ? AppColors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Bottom underline indicator
                    Container(
                      height: 3.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.r),
                          topRight: Radius.circular(2.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    // Determine card accent and badge colors based on order status
    Color statusColor;
    IconData badgeIcon;
    String badgeText;

    switch (order.status) {
      case 'New':
        statusColor = AppColors.warning;
        badgeIcon = Icons.star_border_rounded;
        badgeText = 'New';
        break;
      case 'In Progress':
        statusColor = AppColors.info;
        badgeIcon = Icons.local_shipping_outlined;
        badgeText = 'In Progress';
        break;
      case 'Completed':
        statusColor = AppColors.success;
        badgeIcon = Icons.check_circle_outline_rounded;
        badgeText = 'Delivered';
        break;
      case 'Cancelled':
        statusColor = AppColors.error;
        badgeIcon = Icons.cancel_outlined;
        badgeText = 'Cancelled';
        break;
      default:
        statusColor = AppColors.primary;
        badgeIcon = Icons.info_outline;
        badgeText = '';
    }

    final String formattedTotal = order.totalPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    final String formattedUnitPrice = order.unitPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return GestureDetector(
      onTap: () => Get.to(() => ProducerOrderDetailScreen(orderId: order.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: statusColor, width: 4.h),
            left: const BorderSide(color: AppColors.containerBorder),
            right: const BorderSide(color: AppColors.containerBorder),
            bottom: const BorderSide(color: AppColors.containerBorder),
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Meta Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Order ID & Time
                  Row(
                    children: [
                      Text(
                        order.id,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          "•",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        order.time,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Header Badge (Or date for New status)
                  Row(
                    children: [
                      if (order.status == 'New') ...[
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          order.date,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ] else if (order.showHeaderBadge) ...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(15),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: statusColor.withAlpha(40), width: 1.w),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                badgeIcon,
                                size: 13.sp,
                                color: statusColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                badgeText,
                                style: GoogleFonts.inter(
                                  color: statusColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary.withAlpha(180),
                        size: 18.sp,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // 2. Buyer Block Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: const Color(0xFFE2EFE7),
                    child: Text(
                      order.buyerInitial,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.buyerName,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          order.buyerShop,
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
              SizedBox(height: 12.h),

              // 3. Nested Product details box
              Container(
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAF8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    // Product Image (Circular)
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: order.imageUrl,
                        height: 48.h,
                        width: 48.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: const Color(0xFFECECEC)),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFFECECEC),
                          child: Icon(Icons.image_outlined, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productTitle,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "${order.quantity} ${order.unit} × ₦$formattedUnitPrice",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Total Price block
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₦$formattedTotal",
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "total",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. Footer info row (Only for non-New statuses)
              if (order.status != 'New') ...[
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          order.date,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // Deliver-by Date
                    if (order.deliverBy != null && order.status != 'Cancelled')
                      Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Deliver by ${order.deliverBy}",
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
            ],
          ),
        ),
      ),
    ),
  );
}
}

