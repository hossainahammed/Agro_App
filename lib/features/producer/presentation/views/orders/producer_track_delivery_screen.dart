import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/producer/data/models/order_model.dart';

/// Live Delivery Tracking Screen for Producers
class ProducerTrackDeliveryScreen extends StatefulWidget {
  final OrderModel order;

  const ProducerTrackDeliveryScreen({super.key, required this.order});

  @override
  State<ProducerTrackDeliveryScreen> createState() =>
      _ProducerTrackDeliveryScreenState();
}

class _ProducerTrackDeliveryScreenState
    extends State<ProducerTrackDeliveryScreen> {
  // Stepper state: 1 = 'On the Way', 2 = 'Delivered'
  late RxInt activeStep;
  // Bottom card details expansion toggle
  final RxBool isExpanded = false.obs;

  @override
  void initState() {
    super.initState();
    // Default to 'Delivered' if already completed, else 'On the Way'
    activeStep = (widget.order.status == 'Completed' ? 2 : 1).obs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 1. Stylized Live Map Background & Markers
            Positioned.fill(child: _buildMapBackground()),

            // 2. Top App Bar & Delivery Stepper Container
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopHeaderAndStepper(),
            ),

            // 3. Floating Bottom Delivery Sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomDeliverySheet(),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOP APP BAR & STEPPER
  // ==========================================

  Widget _buildTopHeaderAndStepper() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App Bar Row
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white.withAlpha(45),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // Title & Order ID
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Track Delivery",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Order ${widget.order.id}",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withAlpha(190),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // "Live" Pill Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.white.withAlpha(50),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: 45 * 3.14159 / 180,
                          child: Icon(
                            Icons.navigation_rounded,
                            color: AppColors.white,
                            size: 13.sp,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Live",
                          style: GoogleFonts.inter(
                            color: AppColors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        // Live pulsating green dot
                        Container(
                          width: 6.h,
                          height: 6.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stepper Box Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Obx(() => _buildStepper()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    final int step = activeStep.value;

    return Row(
      children: [
        // 1. Picked Up (Always completed)
        _buildStepItem(
          label: "Picked Up",
          icon: Icons.check_circle,
          isActive: true,
          isCompleted: true,
          onTap: () => activeStep.value = 1,
        ),

        // Line 1 -> 2
        Expanded(
          child: Container(
            height: 2.h,
            color: step >= 1 ? AppColors.primary : const Color(0xFFE2E8F0),
          ),
        ),

        // 2. On the Way
        _buildStepItem(
          label: "On the Way",
          icon: step >= 2 ? Icons.check_circle : Icons.radio_button_checked,
          isActive: step >= 1,
          isCompleted: step >= 2,
          onTap: () => activeStep.value = 1,
        ),

        // Line 2 -> 3
        Expanded(
          child: Container(
            height: 2.h,
            color: step >= 2 ? AppColors.primary : const Color(0xFFE2E8F0),
          ),
        ),

        // 3. Delivered
        _buildStepItem(
          label: "Delivered",
          icon: step >= 2 ? Icons.check_circle : Icons.radio_button_off,
          isActive: step >= 2,
          isCompleted: step >= 2,
          onTap: () => activeStep.value = 2,
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required String label,
    required IconData icon,
    required bool isActive,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    final Color iconColor = isActive
        ? AppColors.primary
        : const Color(0xFFCBD5E1);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22.sp, color: iconColor),
          SizedBox(height: 5.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.textPrimary : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STYLIZED MAP & MARKERS
  // ==========================================

  Widget _buildMapBackground() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        // Coordinates for route and pins:
        // Start Pin: Adeyemi Farm (bottom-left)
        final Offset startOffset = Offset(width * 0.12, height * 0.54);
        // Current Vehicle Location (mid-route)
        final Offset truckOffset = Offset(width * 0.44, height * 0.40);
        // Destination Pin: Musa Supplies (top-right)
        final Offset endOffset = Offset(width * 0.88, height * 0.25);

        return Stack(
          children: [
            // 1. Vector Map Canvas (Roads, City Blocks, Routes)
            Positioned.fill(
              child: CustomPaint(
                painter: _DeliveryMapVectorPainter(
                  start: startOffset,
                  truck: truckOffset,
                  end: endOffset,
                ),
              ),
            ),

            // 2. Start Marker: "Adeyemi Farm"
            Positioned(
              left: startOffset.dx - 16.w,
              top: startOffset.dy + 8.h,
              child: Row(
                children: [
                  Container(
                    width: 14.h,
                    height: 14.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D7A3A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 6.h,
                        height: 6.h,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withAlpha(20),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Adeyemi Farm",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Driver Vehicle Marker (Truck inside green ring)
            Positioned(
              left: truckOffset.dx - 18.w,
              top: truckOffset.dy - 18.h,
              child: Container(
                width: 36.h,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_shipping_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
              ),
            ),

            // 4. Destination Marker: "Musa Supplies"
            Positioned(
              right: width - endOffset.dx - 20.w,
              top: endOffset.dy - 34.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withAlpha(20),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.order.buyerShop.isNotEmpty
                          ? widget.order.buyerShop
                          : "Musa Supplies",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 30.h,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2.5.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withAlpha(20),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 17.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // FLOATING BOTTOM DELIVERY SHEET
  // ==========================================

  Widget _buildBottomDeliverySheet() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(25),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final bool isDelivered = activeStep.value == 2;
        final bool expanded = isExpanded.value;

        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull / Drag pill indicator
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // Status Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isDelivered) ...[
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Delivered!",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ] else ...[
                            Container(
                              width: 8.h,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "On the way",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isDelivered
                            ? "Order successfully delivered to buyer"
                            : "13 mins away · Kano State",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Success badge when delivered
                  if (isDelivered)
                    Container(
                      width: 38.h,
                      height: 38.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.primary,
                        size: 22.sp,
                      ),
                    ),
                ],
              ),

              SizedBox(height: 14.h),

              // Driver Information Card
              _buildDriverInformationCard(),

              // Collapsible Extra Order & Route Details
              if (expanded) ...[
                SizedBox(height: 14.h),
                _buildOrderSummaryCard(),
                SizedBox(height: 14.h),
                _buildRouteDetailsCard(),
              ],

              SizedBox(height: 10.h),

              // Expand / Collapse Details Toggle
              Center(
                child: GestureDetector(
                  onTap: () => isExpanded.toggle(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          size: 18.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          expanded ? "Less detail" : "Order details",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDriverInformationCard() {
    final order = widget.order;
    final String driverName = order.driverName ?? "Ibrahim Suleiman";
    final double rating = order.driverRating ?? 4.7;
    final String vehicle = order.driverVehicle ?? "Toyota Hilux";
    final String plate = order.driverPlateNumber ?? "KN 302 BCA";
    final String imageUrl =
        order.driverImageUrl ??
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2EFE7)),
      ),
      child: Row(
        children: [
          // Driver Avatar with Active Dot
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 44.h,
                  height: 44.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 44.h,
                    height: 44.h,
                    color: AppColors.primary.withAlpha(25),
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                ),
              ),
              Container(
                width: 10.h,
                height: 10.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 1.5.w),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),

          // Name, Rating & Vehicle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: const Color(0xFFF59E0B),
                      size: 13.sp,
                    ),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Text(
                        "$rating · $vehicle · $plate",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons: Call & Chat
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCircleActionButton(
                icon: Icons.phone_outlined,
                onTap: () {
                  Get.snackbar(
                    "Calling",
                    "Calling $driverName (${order.driverPhone ?? '+234 812 340 9021'})...",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primary.withAlpha(20),
                    colorText: AppColors.primary,
                  );
                },
              ),
              SizedBox(width: 8.w),
              _buildCircleActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () {
                  Get.snackbar(
                    "Chat",
                    "Opening chat with driver $driverName...",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primary.withAlpha(20),
                    colorText: AppColors.primary,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36.h,
        height: 36.h,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F3ED),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 16.sp),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    final order = widget.order;
    final total = order.totalPrice + order.deliveryFee;
    final formattedPrice = total
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    // Format item summary: "6x Fresh Roma Tomatoes · 2x Organic Pepper"
    final String itemsSummary = order.allItems
        .map((e) => "${e.quantity}x ${e.productTitle}")
        .join(" · ");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ORDER",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF8),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE2EFE7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 15.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
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
                            "Order ID copied",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.primary.withAlpha(20),
                            colorText: AppColors.primary,
                          );
                        },
                        child: Icon(
                          Icons.copy_rounded,
                          size: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "₦$formattedPrice",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                itemsSummary,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteDetailsCard() {
    final order = widget.order;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ROUTE",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF8),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE2EFE7)),
          ),
          child: Column(
            children: [
              // Origin stop
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 10.h,
                        height: 10.h,
                        margin: EdgeInsets.only(top: 3.h),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2D7A3A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2.w,
                        height: 24.h,
                        color: const Color(0xFF2D7A3A),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adeyemi Green Farms",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Kaduna State, Nigeria",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Destination stop
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                    size: 14.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.buyerShop.isNotEmpty
                              ? order.buyerShop
                              : "Musa Fresh Supplies",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          order.address,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom Vector Painter for Map, Roads, City Blocks, and Curves
class _DeliveryMapVectorPainter extends CustomPainter {
  final Offset start;
  final Offset truck;
  final Offset end;

  _DeliveryMapVectorPainter({
    required this.start,
    required this.truck,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Soft map background color
    final bgPaint = Paint()..color = const Color(0xFFE5EFE8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. City Blocks & Green zones (Rounded Rectangles grid)
    final blockPaint = Paint()
      ..color = const Color(0xFFD6E7DC)
      ..style = PaintingStyle.fill;

    const double cols = 4;
    const double rows = 6;
    final double blockW = (size.width - (cols + 1) * 16.0) / cols;
    final double blockH = (size.height - (rows + 1) * 16.0) / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double left = 16.0 + c * (blockW + 16.0);
        final double top = 16.0 + r * (blockH + 16.0);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left, top, blockW, blockH),
            const Radius.circular(8),
          ),
          blockPaint,
        );
      }
    }

    // 3. Main Roads (Lines with road styling)
    final roadPaint = Paint()
      ..color = const Color(0xFFF1F8F4)
      ..strokeWidth = 14.0
      ..style = PaintingStyle.stroke;

    for (int r = 0; r <= rows; r++) {
      final double y = 8.0 + r * (blockH + 16.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
    for (int c = 0; c <= cols; c++) {
      final double x = 8.0 + c * (blockW + 16.0);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }

    // 4. Completed Route Segment: Start -> Truck (Solid Green Line)
    final solidRoutePath = Path();
    solidRoutePath.moveTo(start.dx, start.dy);

    final cp1 = Offset(
      start.dx + (truck.dx - start.dx) * 0.45,
      start.dy + (truck.dy - start.dy) * 0.1,
    );
    final cp2 = Offset(start.dx + (truck.dx - start.dx) * 0.55, truck.dy);
    solidRoutePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, truck.dx, truck.dy);

    final solidRoutePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(solidRoutePath, solidRoutePaint);

    // 5. Remaining Route Segment: Truck -> End (Dashed Blue-Grey Line)
    final dashedRoutePath = Path();
    dashedRoutePath.moveTo(truck.dx, truck.dy);

    final cp3 = Offset(
      truck.dx + (end.dx - truck.dx) * 0.45,
      truck.dy + (end.dy - truck.dy) * 0.1,
    );
    final cp4 = Offset(truck.dx + (end.dx - truck.dx) * 0.55, end.dy);
    dashedRoutePath.cubicTo(cp3.dx, cp3.dy, cp4.dx, cp4.dy, end.dx, end.dy);

    final dashedRoutePaint = Paint()
      ..color = const Color(0xFF8B9EB2)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _drawDashedPath(canvas, dashedRoutePath, dashedRoutePaint, 8.0, 6.0);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          next > metric.length ? metric.length : next,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DeliveryMapVectorPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.truck != truck ||
        oldDelegate.end != end;
  }
}
