import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../../data/models/order_model.dart';
import '../../controllers/producer_order_controller.dart';

class ProducerOrderDetailScreen extends StatelessWidget {
  final String orderId;

  const ProducerOrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ProducerOrderController controller = Get.find<ProducerOrderController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        final order = controller.orders.firstWhereOrNull((o) => o.id == orderId);
        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Order Not Found")),
            body: const Center(child: Text("The requested order details could not be found.")),
          );
        }

        return Column(
          children: [
            // 1. Forest Green Header with Back Button and Status Pill
            _buildHeader(context, order),

            // 2. Scrollable Details content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                child: Column(
                  children: [
                    // Conditional Timeline Card (Only for non-New statuses)
                    if (order.status != 'New') ...[
                      _buildTimelineCard(order),
                      SizedBox(height: 16.h),
                    ],

                    // Buyer Information Card
                    _buildBuyerInfoCard(context, order),
                    SizedBox(height: 16.h),

                    // Products card(s)
                    if (order.allItems.length > 1) ...[
                      // Multi-item details card (Screenshots 3 and 4)
                      _buildMultiItemCard(order),
                    ] else ...[
                      // Single item card (Screenshots 1 and 2)
                      _buildSingleProductCard(order),
                      SizedBox(height: 16.h),
                      _buildSummaryCard(order),
                    ],
                    SizedBox(height: 16.h),

                    // Assigned Driver Card (If driver information exists and status is In Progress, Ready for Pickup or Completed)
                    if (order.driverName != null && order.status != 'Cancelled') ...[
                      _buildDriverCard(order),
                      SizedBox(height: 16.h),
                    ],

                    // Details Card
                    _buildDetailsCard(order),
                    SizedBox(height: 16.h),

                    // Note from Buyer (If note is present)
                    if (order.note != null && order.note!.isNotEmpty) ...[
                      _buildBuyerNoteCard(order),
                      SizedBox(height: 16.h),
                    ],

                    // Bottom info notification box (Waiting for driver...)
                    if (order.status == 'Ready for Pickup') ...[
                      _buildWaitingForDriverBox(),
                    ],
                  ],
                ),
              ),
            ),

            // 3. Dynamic Bottom Action buttons (New: Accept/Decline, In Progress: Ready for Pickup)
            _buildBottomActionBar(context, order, controller),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, OrderModel order) {
    // Determine status pill icon and text
    IconData pillIcon;
    String pillText;

    switch (order.status) {
      case 'New':
        pillIcon = Icons.access_time_rounded;
        pillText = 'New Order';
        break;
      case 'In Progress':
        pillIcon = Icons.local_shipping_outlined;
        pillText = 'In Progress';
        break;
      case 'Ready for Pickup':
        pillIcon = Icons.archive_outlined;
        pillText = 'Ready for Pickup';
        break;
      case 'Completed':
        pillIcon = Icons.check_circle_outline_rounded;
        pillText = 'Delivered';
        break;
      case 'Cancelled':
        pillIcon = Icons.cancel_outlined;
        pillText = 'Cancelled';
        break;
      default:
        pillIcon = Icons.info_outline;
        pillText = order.status;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button + Title Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withAlpha(38),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ORDER DETAIL",
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: AppColors.white.withAlpha(180),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        order.id,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Status Pill
              Container(
                margin: EdgeInsets.only(left: 42.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(45),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pillIcon,
                      color: AppColors.white,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      pillText,
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTimelineCard(OrderModel order) {
    // True if status is past or equal to the stage
    final bool isPlacedChecked = true;
    final bool isConfirmedChecked = order.status != 'New';
    final bool isReadyChecked = order.status == 'Ready for Pickup' || order.status == 'Completed';
    final bool isPickedChecked = order.status == 'Completed'; // Under completed we mock picked up & delivered checked
    final bool isDeliveredChecked = order.status == 'Completed';

    // Badge flags
    final bool showConfirmedBadge = order.status == 'In Progress';
    final bool showReadyBadge = order.status == 'Ready for Pickup';
    final bool showPickedBadge = false; // We can keep it simple or set badge if needed

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ORDER PROGRESS",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 20.h),

          // Timeline vertical rows
          _buildTimelineNode(
            title: "Order Placed",
            time: order.time,
            isChecked: isPlacedChecked,
            isNextChecked: isConfirmedChecked,
            isLast: false,
          ),
          _buildTimelineNode(
            title: "Confirmed",
            time: "9:22 AM", // Mock confirm time
            isChecked: isConfirmedChecked,
            isNextChecked: isReadyChecked,
            showNowBadge: showConfirmedBadge,
            isLast: false,
          ),
          _buildTimelineNode(
            title: "Ready for Pickup",
            time: "11:05 AM", // Mock ready time
            isChecked: isReadyChecked,
            isNextChecked: isPickedChecked,
            showNowBadge: showReadyBadge,
            isLast: false,
          ),
          _buildTimelineNode(
            title: "Picked Up",
            time: "",
            isChecked: isPickedChecked,
            isNextChecked: isDeliveredChecked,
            showNowBadge: showPickedBadge,
            isLast: false,
          ),
          _buildTimelineNode(
            title: "Delivered",
            time: "",
            isChecked: isDeliveredChecked,
            isNextChecked: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required String title,
    required String time,
    required bool isChecked,
    required bool isNextChecked,
    bool showNowBadge = false,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Timeline Indicator
          Column(
            children: [
              Container(
                width: 22.h,
                height: 22.h,
                decoration: BoxDecoration(
                  color: isChecked ? AppColors.success.withAlpha(20) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChecked ? AppColors.success : AppColors.borderColor,
                    width: 2.w,
                  ),
                ),
                child: isChecked
                    ? Icon(
                        Icons.check_circle,
                        size: 18.sp,
                        color: AppColors.success,
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: isNextChecked ? AppColors.success : AppColors.borderColor,
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),

          // Right Timeline Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: isChecked ? FontWeight.bold : FontWeight.w500,
                          color: isChecked ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                      if (showNowBadge) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "Now",
                            style: GoogleFonts.inter(
                              color: AppColors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (time.isNotEmpty)
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
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

  Widget _buildBuyerInfoCard(BuildContext context, OrderModel order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BUYER INFORMATION",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),

          // Avatar + Info + Contact Buttons Row
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
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2EFED),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Wholesale Distributor",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF206C5F),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Call & Chat buttons
              Row(
                children: [
                  _buildCircleIconButton(
                    icon: Icons.phone_outlined,
                    onTap: () {},
                  ),
                  SizedBox(width: 8.w),
                  _buildCircleIconButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(color: AppColors.containerBorder),
          SizedBox(height: 12.h),

          // Detail Rows
          _buildInfoRow(
            icon: Icons.phone_outlined,
            text: order.phone,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            text: order.address,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: const BoxDecoration(
          color: Color(0xFFE5EFEA),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6.h),
          decoration: const BoxDecoration(
            color: Color(0xFFEEF6F2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 16.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleProductCard(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PRODUCT",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: order.imageUrl,
                  height: 56.h,
                  width: 56.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productTitle,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Vegetables", // Mock category
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2EFE7),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "${order.quantity} ${order.unit}",
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "×  ₦${order.unitPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(OrderModel order) {
    final String formattedSubtotal = order.totalPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    final String formattedDelivery = order.deliveryFee.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    final String formattedTotal = (order.totalPrice + order.deliveryFee).toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SUMMARY",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow("Subtotal", "₦$formattedSubtotal"),
          SizedBox(height: 12.h),
          _buildSummaryRow("Delivery fee", "₦$formattedDelivery"),
          SizedBox(height: 12.h),
          const Divider(color: AppColors.containerBorder),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "₦$formattedTotal",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMultiItemCard(OrderModel order) {
    double subtotal = 0;
    for (var item in order.allItems) {
      subtotal += item.totalPrice;
    }

    final String formattedSubtotal = subtotal.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    final String formattedDelivery = order.deliveryFee.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    final String formattedTotal = (subtotal + order.deliveryFee).toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ORDERED PRODUCTS",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),

          // Product List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.allItems.length,
            separatorBuilder: (context, index) => Column(
              children: [
                SizedBox(height: 12.h),
                const Divider(color: AppColors.containerBorder),
                SizedBox(height: 12.h),
              ],
            ),
            itemBuilder: (context, index) {
              final item = order.allItems[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
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
                          item.productTitle,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "${item.quantity} ${item.unit}  ×  ₦${item.unitPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                  Text(
                    "₦${item.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 16.h),
          const Divider(color: AppColors.containerBorder),
          SizedBox(height: 16.h),

          // Totals block inside the card
          _buildSummaryRow("Subtotal", "₦$formattedSubtotal"),
          SizedBox(height: 12.h),
          _buildSummaryRow("Delivery fee", "₦$formattedDelivery"),
          SizedBox(height: 12.h),
          const Divider(color: AppColors.containerBorder),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "₦$formattedTotal",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ASSIGNED DRIVER",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),

          // Driver details row
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: order.driverImageUrl ?? 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                      height: 44.h,
                      width: 44.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 12.h,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2.w),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.driverName!,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 14.sp),
                        SizedBox(width: 2.w),
                        Text(
                          "${order.driverRating}  •  ${order.driverVehicle}",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildCircleIconButton(
                    icon: Icons.phone_outlined,
                    onTap: () {},
                  ),
                  SizedBox(width: 8.w),
                  _buildCircleIconButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Plate Number Box
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8F7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.credit_card_outlined,
                      color: AppColors.textSecondary,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Plate number",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  order.driverPlateNumber ?? "KN 302 BCA",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Track Delivery Button
          GestureDetector(
            onTap: () {
              Get.snackbar("Track", "Opening live tracking map...");
            },
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 45 * 3.14159 / 180,
                          child: Icon(
                            Icons.navigation_rounded,
                            color: AppColors.white,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Track Delivery",
                          style: GoogleFonts.inter(
                            color: AppColors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DETAILS",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),
          // Order ID details line
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    order.id,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: order.id));
                      Get.snackbar(
                        "Copied",
                        "Order ID copied to clipboard",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primary.withAlpha(20),
                        colorText: AppColors.primary,
                      );
                    },
                    child: Icon(
                      Icons.copy_rounded,
                      color: AppColors.textSecondary,
                      size: 15.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Placed details line
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Placed",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${order.date} · ${order.time}",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          // Expected Delivery details line (If In Progress, Completed, etc.)
          if (order.deliverBy != null && order.status != 'Cancelled') ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expected delivery",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  order.deliverBy!,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBuyerNoteCard(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFECF5EC), // Pale green note box
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note from buyer",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            order.note!,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingForDriverBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6F3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor.withAlpha(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_rounded,
            color: AppColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Waiting for driver to pick up the order. You will be notified once it's collected.",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFF335544),
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    OrderModel order,
    ProducerOrderController controller,
  ) {
    if (order.status == 'New') {
      return Container(
        color: AppColors.white,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        child: Row(
          children: [
            // Decline Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    "Declined",
                    "Order ${order.id} has been declined.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.error.withAlpha(20),
                    colorText: AppColors.error,
                  );
                },
                child: Container(
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.error.withAlpha(80)),
                  ),
                  child: Text(
                    "Decline",
                    style: GoogleFonts.inter(
                      color: AppColors.error,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Accept Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.acceptOrder(order.id);
                  Get.snackbar(
                    "Success",
                    "Order ${order.id} has been accepted!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.success.withAlpha(20),
                    colorText: AppColors.success,
                  );
                },
                child: Container(
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "Accept Order",
                    style: GoogleFonts.inter(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (order.status == 'In Progress') {
      return Container(
        color: AppColors.white,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        child: GestureDetector(
          onTap: () {
            controller.markReadyForPickup(order.id);
            Get.snackbar(
              "Success",
              "Order ${order.id} marked as Ready for Pickup!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.success.withAlpha(20),
              colorText: AppColors.success,
            );
          },
          child: Container(
            height: 48.h,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              "Mark as Ready for Pickup",
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    // Otherwise, return empty spacing (or no action buttons needed at the bottom)
    return const SizedBox.shrink();
  }
}
