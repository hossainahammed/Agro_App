import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/routes/app_routes.dart';
import '../controllers/delivery_dashboard_controller.dart';

class DeliveryDashboardScreen extends StatelessWidget {
  const DeliveryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryDashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // 1. TOP HEADER (Curved Forest Green)
            // ========================================================
            _buildTopHeader(context, controller),

            // ========================================================
            // 2. MAIN CONTENT (Hero Card, Summary, Recent Deliveries)
            // ========================================================
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Status Card (Online / Offline Toggle)
                  _buildHeroStatusCard(context, controller),
                  SizedBox(height: 22.h),

                  // Today's Summary Header & 2x3 Grid
                  _buildSummaryHeader(controller),
                  SizedBox(height: 12.h),
                  _buildSummaryGrid(controller),
                  SizedBox(height: 24.h),

                  // Recent Deliveries Header & List
                  _buildRecentDeliveriesHeader(controller),
                  SizedBox(height: 12.h),
                  _buildRecentDeliveriesList(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TOP HEADER COMPONENT
  // ==========================================================
  Widget _buildTopHeader(
    BuildContext context,
    DeliveryDashboardController controller,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF236830), // Signature forest green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        MediaQuery.of(context).padding.top + 8.h,
        20.w,
        18.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Driver Avatar & Name
          Row(
            children: [
              Container(
                width: 44.h,
                height: 44.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: Obx(
                    () => CachedNetworkImage(
                      imageUrl: controller.avatarUrl.value,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF1B4926),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF1B4926),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      controller.greeting.value,
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFD6E8DA),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Obx(
                    () => Text(
                      controller.driverName.value,
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Notification Bell
          GestureDetector(
            onTap: () => Get.toNamed(AppRoute.notification),
            child: Container(
              width: 42.h,
              height: 42.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HERO DRIVER STATUS CARD (Online / Offline)
  // ==========================================================
  Widget _buildHeroStatusCard(
    BuildContext context,
    DeliveryDashboardController controller,
  ) {
    return Obx(() {
      final isOnline = controller.isOnline.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: isOnline
              ? const LinearGradient(
                  colors: [
                    Color(0xFF1A5C26),
                    Color(0xFF2D7A3A),
                    Color(0xFF3D9E4A),
                  ], //1A5C26
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF2C3545), Color(0xFF1E2633)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow: [
            BoxShadow(
              color: isOnline
                  ? const Color(0xFF164A22).withValues(alpha: 0.35)
                  : const Color(0xFF1E2633).withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Status Text & optional Offline Icon)
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DRIVER STATUS",
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isOnline
                              ? const Color(0xFF98D4A5)
                              : const Color(0xFF8C9BAE),
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isOnline ? "You're Online" : "You're Offline",
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        isOnline
                            ? "You're visible to farmers & agents"
                            : "Go online to receive delivery requests",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isOnline
                              ? Colors.white.withValues(alpha: 0.85)
                              : const Color(0xFF9BA8B9),
                        ),
                      ),
                    ],
                  ),
                  if (!isOnline)
                    Container(
                      width: 36.h,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: const Icon(
                        Icons.eco_outlined,
                        color: Color(0xFF8C9BAE),
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),

            // Center Big Interactive Button with Concentric Rings
            Center(
              child: GestureDetector(
                onTap: controller.toggleOnlineStatus,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    // Outer Translucent Glow Ring (Figma FFFFFF 18% & 40%)
                    Container(
                      width: 108.h,
                      height: 108.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline
                            ? Colors.white.withValues(alpha: 0.18)
                            : Colors.white.withValues(alpha: 0.04),
                        border: Border.all(
                          color: isOnline
                              ? Colors.white.withValues(alpha: 0.40)
                              : const Color(0xFF4A5568).withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 78.h,
                        height: 78.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isOnline
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF4ADE80),
                                    Color(0xFF22C55E),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFEE5253),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: isOnline
                                  ? const Color(
                                      0xFF22C55E,
                                    ).withValues(alpha: 0.45)
                                  : const Color(
                                      0xFFEE5253,
                                    ).withValues(alpha: 0.45),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: isOnline
                            ? NavigationArrowIcon(
                                size: 30.sp,
                                color: Colors.white,
                                strokeWidth: 2.4,
                              )
                            : Icon(
                                Icons.radio_button_unchecked_rounded,
                                color: Colors.white,
                                size: 32.sp,
                              ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Tap prompt text
                    Text(
                      isOnline ? "Tap to go offline" : "Tap to go online",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isOnline
                            ? Colors.white.withValues(alpha: 0.85)
                            : const Color(0xFF9BA8B9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Bottom Location Status Pill
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isOnline
                    ? Colors.black.withValues(alpha: 0.16)
                    : Colors.black.withValues(alpha: 0.24),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24.r),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isOnline
                        ? Icons.location_on_outlined
                        : Icons.location_off_outlined,
                    color: isOnline
                        ? const Color(0xFF98D4A5)
                        : const Color(0xFF8C9BAE),
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      isOnline
                          ? controller.onlineLocation.value
                          : controller.offlineLocation.value,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isOnline
                            ? const Color(0xFFD6E8DA)
                            : const Color(0xFF8C9BAE),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================================
  // TODAY'S SUMMARY HEADER
  // ==========================================================
  Widget _buildSummaryHeader(DeliveryDashboardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Summary",
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2D24),
          ),
        ),
        GestureDetector(
          onTap: controller.viewAllSummary,
          child: Row(
            children: [
              Text(
                "View all",
                style: GoogleFonts.inter(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF236830),
                ),
              ),
              SizedBox(width: 3.w),
              Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF236830),
                size: 11.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TODAY'S SUMMARY 2x3 GRID
  // ==========================================================
  Widget _buildSummaryGrid(DeliveryDashboardController controller) {
    return Obx(() {
      final isOnline = controller.isOnline.value;

      return Column(
        children: [
          // Row 1: Deliveries, Earnings, Distance
          Row(
            children: [
              // Card 1: Deliveries
              Expanded(
                child: _buildMetricCard(
                  iconWidget: Container(
                    width: 30.h,
                    height: 30.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F3ED),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: DeliveryBoxIcon(
                      size: 18.sp,
                      color: const Color(0xFF236830),
                      strokeWidth: 1.8,
                    ),
                  ),
                  value: "${controller.todayDeliveries.value}",
                  label: "Deliveries",
                  sublabel: "Today",
                ),
              ),
              SizedBox(width: 10.w),

              // Card 2: Earnings (Solid green when Online, white when Offline)
              Expanded(
                child: _buildEarningsCard(
                  controller: controller,
                  isHighlighted: isOnline,
                ),
              ),
              SizedBox(width: 10.w),

              // Card 3: Distance
              Expanded(
                child: _buildMetricCard(
                  iconWidget: _buildIconBox(
                    Icons.trending_up_rounded,
                    const Color(0xFF236830),
                    const Color(0xFFE8F3ED),
                  ),
                  value: controller.distanceCovered.value,
                  label: "Distance",
                  sublabel: "Covered",
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Row 2: Rating, Total trips, On-time rate
          Row(
            children: [
              // Card 4: Rating
              Expanded(
                child: _buildMetricCard(
                  iconWidget: _buildIconBox(
                    Icons.star_rounded,
                    const Color(0xFFFFA000),
                    const Color(0xFFFFF8E1),
                  ),
                  value: "${controller.rating.value}",
                  label: "Rating",
                ),
              ),
              SizedBox(width: 10.w),

              // Card 5: Total trips
              Expanded(
                child: _buildMetricCard(
                  iconWidget: _buildIconBox(
                    Icons.bolt_rounded,
                    const Color(0xFF2979FF),
                    const Color(0xFFE3F2FD),
                  ),
                  value: "${controller.totalTrips.value}",
                  label: "Total trips",
                ),
              ),
              SizedBox(width: 10.w),

              // Card 6: On-time rate
              Expanded(
                child: _buildMetricCard(
                  iconWidget: _buildIconBox(
                    Icons.access_time_rounded,
                    const Color(0xFF236830),
                    const Color(0xFFE8F3ED),
                  ),
                  value: "${controller.onTimeRate.value}%",
                  label: "On-time rate",
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  // ==========================================================
  // HELPER METRIC CARD WIDGETS
  // ==========================================================
  Widget _buildIconBox(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: 30.h,
      height: 30.h,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: 16.sp),
    );
  }

  Widget _buildMetricCard({
    required Widget iconWidget,
    required String value,
    required String label,
    String? sublabel,
  }) {
    return Container(
      height: 118.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconWidget,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 17.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                  letterSpacing: -0.3,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7A8C80),
                  height: 1.15,
                ),
              ),
              if (sublabel != null)
                Text(
                  sublabel,
                  style: GoogleFonts.inter(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9EABA2),
                    height: 1.15,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard({
    required DeliveryDashboardController controller,
    required bool isHighlighted,
  }) {
    return Container(
      height: 118.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isHighlighted ? null : Colors.white,
        gradient: isHighlighted
            ? const LinearGradient(
                colors: [Color(0xFF2D7A3A), Color(0xFF3D9E4A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? const Color(0xFF22C55E).withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 28.h,
            height: 28.h,
            decoration: BoxDecoration(
              color: isHighlighted
                  ? Colors.white.withValues(alpha: 0.24)
                  : const Color(0xFFE8F3ED),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(
              "\$",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : const Color(0xFF236830),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.todayEarnings.value,
                style: GoogleFonts.inter(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.white : const Color(0xFF1E2D24),
                  letterSpacing: -0.3,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Earnings",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isHighlighted
                      ? Colors.white.withValues(alpha: 0.9)
                      : const Color(0xFF7A8C80),
                  height: 1.15,
                ),
              ),
              Text(
                "Today",
                style: GoogleFonts.inter(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w400,
                  color: isHighlighted
                      ? Colors.white.withValues(alpha: 0.75)
                      : const Color(0xFF9EABA2),
                  height: 1.15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // RECENT DELIVERIES HEADER
  // ==========================================================
  Widget _buildRecentDeliveriesHeader(DeliveryDashboardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Recent Deliveries",
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2D24),
          ),
        ),
        GestureDetector(
          onTap: controller.seeHistory,
          child: Row(
            children: [
              Text(
                "See history",
                style: GoogleFonts.inter(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF236830),
                ),
              ),
              SizedBox(width: 3.w),
              Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF236830),
                size: 11.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // RECENT DELIVERIES LIST (3 Cards matching mockup)
  // ==========================================================
  Widget _buildRecentDeliveriesList(DeliveryDashboardController controller) {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: controller.recentDeliveries.length,
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final item = controller.recentDeliveries[index];
          return GestureDetector(
            onTap: () => controller.openDeliveryDetails(item),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Green Package Icon Box
                  Container(
                    width: 44.h,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3ED),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: DeliveryBoxIcon(
                      size: 22.sp,
                      color: const Color(0xFF236830),
                      strokeWidth: 1.9,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Middle Column: Order ID + Time + Route
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.orderId,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF236830),
                              ),
                            ),
                            Text(
                              " • ${item.timeAgo}",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7A8C80),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.route,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E2D24),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Right Column: Price + Done Status Pill
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.price,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E2D24),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.h,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF236830),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item.status,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF236830),
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
        },
      ),
    );
  }
}

/// Outlined vector navigation arrow matching the Figma Lucide/Feather navigation cursor design
class NavigationArrowIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const NavigationArrowIcon({
    super.key,
    this.size = 28,
    this.color = Colors.white,
    this.strokeWidth = 2.4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavigationArrowPainter(
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _NavigationArrowPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _NavigationArrowPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final sx = size.width / 24.0;
    final sy = size.height / 24.0;

    // Standard Lucide polygon points: (3, 11) -> (22, 2) -> (13, 21) -> (11, 13) -> closed
    final path = Path()
      ..moveTo(3 * sx, 11 * sy)
      ..lineTo(22 * sx, 2 * sy)
      ..lineTo(13 * sx, 21 * sy)
      ..lineTo(11 * sx, 13 * sy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavigationArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

/// 3D Isometric Delivery Box Icon with packaging tape matching the Figma design
class DeliveryBoxIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const DeliveryBoxIcon({
    super.key,
    this.size = 20,
    this.color = const Color(0xFF236830),
    this.strokeWidth = 1.9,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DeliveryBoxPainter(color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _DeliveryBoxPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _DeliveryBoxPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final sx = size.width / 24.0;
    final sy = size.height / 24.0;

    // 1. Outer isometric contour of the box (hexagon)
    final outerBox = Path()
      ..moveTo(12 * sx, 3 * sy)
      ..lineTo(20.5 * sx, 7.5 * sy)
      ..lineTo(20.5 * sx, 16.5 * sy)
      ..lineTo(12 * sx, 21 * sy)
      ..lineTo(3.5 * sx, 16.5 * sy)
      ..lineTo(3.5 * sx, 7.5 * sy)
      ..close();
    canvas.drawPath(outerBox, paint);

    // 2. Y-seams dividing front-left, front-right, and top faces
    // Vertical center seam from (12, 12) down to (12, 21)
    canvas.drawLine(Offset(12 * sx, 12 * sy), Offset(12 * sx, 21 * sy), paint);

    // Left face top seam from (3.5, 7.5) to (12, 12)
    canvas.drawLine(
      Offset(3.5 * sx, 7.5 * sy),
      Offset(12 * sx, 12 * sy),
      paint,
    );

    // Right face top seam from (20.5, 7.5) to (12, 12)
    canvas.drawLine(
      Offset(20.5 * sx, 7.5 * sy),
      Offset(12 * sx, 12 * sy),
      paint,
    );

    // 3. Packaging tape stripes diagonally across top face
    // Tape line 1 (from back-left edge to front-right edge):
    canvas.drawLine(
      Offset(8.0 * sx, 5.1 * sy),
      Offset(16.5 * sx, 9.6 * sy),
      paint,
    );

    // Tape line 2 (parallel):
    canvas.drawLine(
      Offset(10.0 * sx, 4.1 * sy),
      Offset(18.5 * sx, 8.6 * sy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _DeliveryBoxPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
