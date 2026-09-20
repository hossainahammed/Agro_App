import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/available_jobs_controller.dart';
import '../widgets/delivery_icons.dart';

class JobDetailScreen extends StatelessWidget {
  final MissionModel mission;

  const JobDetailScreen({
    super.key,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AvailableJobsController>()
        ? Get.find<AvailableJobsController>()
        : Get.put(AvailableJobsController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Stylized City Block Map Route Preview
                  _buildMapRoutePreview(context),
                  SizedBox(height: 16.h),

                  // 2. YOUR PAYOUT Banner
                  _buildPayoutBanner(),
                  SizedBox(height: 16.h),

                  // 3. Product Details Card (with green weight text and caution callout)
                  _buildProductDetailsCard(),
                  SizedBox(height: 16.h),

                  // 4. Pickup Location Card (Producer)
                  _buildPickupLocationCard(),
                  SizedBox(height: 16.h),

                  // 5. Delivery Location Card (Buyer)
                  _buildDeliveryLocationCard(),
                  SizedBox(height: 16.h),

                  // 6. Driver Requirements Card
                  _buildRequirementsCard(),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),

          // 7. Sticky Bottom Action Bar
          _buildBottomActionBar(controller),
        ],
      ),
    );
  }

  // ==========================================================
  // APP BAR
  // ==========================================================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF236830),
      elevation: 0,
      leading: IconButton(
        icon: Container(
          width: 34.h,
          height: 34.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mission Details",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "${mission.id} • POSTED 4 MIN AGO",
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFD6E8DA),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 1. STYLIZED MAP ROUTE PREVIEW (City Grid + Markers + Bar)
  // ==========================================================
  Widget _buildMapRoutePreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210.h,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5F1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD3E2D6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // City Blocks Custom Painter
            Positioned.fill(
              child: CustomPaint(
                painter: StylizedMapRoutePainter(),
              ),
            ),

            // Pickup Marker: Green pill (● Pickup)
            Positioned(
              left: 20.w,
              bottom: 64.h,
              child: _buildMapMarkerPill(
                title: "Pickup",
                bgColor: const Color(0xFF236830),
                textColor: Colors.white,
                leadingDotColor: const Color(0xFF4ADE80),
              ),
            ),

            // You Marker: Blue pill with cursor arrow (⌖ You)
            Positioned(
              left: 138.w,
              top: 55.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.navigation_rounded, size: 11, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      "You",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Drop-off Marker: Dark slate pill (● Drop-off)
            Positioned(
              right: 22.w,
              top: 24.h,
              child: _buildMapMarkerPill(
                title: "Drop-off",
                bgColor: const Color(0xFF111827),
                textColor: Colors.white,
                leadingDotColor: Colors.white,
              ),
            ),

            // Bottom Route Info Bar Overlay
            Positioned(
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF236830)),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              "Ungogo",
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E2D24),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "${mission.distanceTotal}  ~${mission.etaMinutes}",
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            width: 6.h,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF111827),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              "Fagge",
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E2D24),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () {
                        AppSnackBar.success("Launching GPS Map Route for ${mission.id}");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF4EE),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFF236830), width: 1.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Navigate",
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF236830),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 13,
                              color: Color(0xFF236830),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarkerPill({
    required String title,
    required Color bgColor,
    required Color textColor,
    required Color leadingDotColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              color: leadingDotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 2. YOUR PAYOUT BANNER (Matching Mockup 2 Exactly)
  // ==========================================================
  Widget _buildPayoutBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF236830),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16441F).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Label + Amount + Confirmation note
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "YOUR PAYOUT",
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF86EFAC),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                mission.payout,
                style: GoogleFonts.inter(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Credited on delivery confirmation",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: const Color(0xFFA7F3D0),
                ),
              ),
            ],
          ),

          // Right: Stacked Pill Badges
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5326),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF2E7D32), width: 1.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      mission.etaMinutes.replaceAll('~', ''),
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5326),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF2E7D32), width: 1.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      mission.distanceTotal,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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

  // ==========================================================
  // 3. PRODUCT DETAILS CARD (Specs with green weight & Caution Callout)
  // ==========================================================
  Widget _buildProductDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1.2),
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
        children: [
          Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                size: 20,
                color: Color(0xFF236830),
              ),
              SizedBox(width: 6.w),
              Text(
                "Product Details",
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // 5 Spec Rows
          _buildSpecRow("Item", mission.item),
          _buildDivider(),
          _buildSpecRow("Quantity", mission.quantity),
          _buildDivider(),
          _buildSpecRow(
            "Total Weight",
            mission.weight,
            isGreenValue: true,
          ),
          _buildDivider(),
          _buildSpecRow("Packaging", mission.packaging),
          _buildDivider(),
          _buildSpecRow("Condition", mission.condition),

          SizedBox(height: 14.h),

          // Caution Alert Callout Box
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Color(0xFFD97706),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    mission.careNote,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF92400E),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, {bool isGreenValue = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                fontWeight: isGreenValue ? FontWeight.bold : FontWeight.w600,
                color: isGreenValue
                    ? const Color(0xFF236830)
                    : const Color(0xFF1E2D24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F5F9),
    );
  }

  // ==========================================================
  // 4. PICKUP LOCATION CARD (PRODUCER)
  // ==========================================================
  Widget _buildPickupLocationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1.2),
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
        children: [
          // Header: ○ Pickup Location + PRODUCER badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.h,
                    height: 12.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF236830),
                        width: 2.0,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Pickup Location",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "PRODUCER",
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Profile row: Avatar A + Name + Rating + Phone button
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFFDCFCE7),
                child: Text(
                  mission.pickupName.isNotEmpty ? mission.pickupName[0] : 'P',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF166534),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.pickupName,
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                        SizedBox(width: 3.w),
                        Text(
                          "${mission.pickupRating} • Verified Producer",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  AppSnackBar.info("Calling Producer at ${mission.pickupContact}...");
                },
                icon: Container(
                  width: 34.h,
                  height: 34.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.phone_rounded,
                    color: Color(0xFF166534),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Address with Location Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 2.h),
                width: 24.h,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.pickupAddress,
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      mission.pickupSubtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () {
                        AppSnackBar.success("Opening pickup coordinates in Maps");
                      },
                      child: Text(
                        "Open in Maps >",
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Ready for pickup bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF64748B)),
                SizedBox(width: 6.w),
                Text(
                  "Ready for pickup: ",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Text(
                  mission.readyTime,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 5. DELIVERY LOCATION CARD (BUYER)
  // ==========================================================
  Widget _buildDeliveryLocationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1.2),
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
        children: [
          // Header: ⦿ Delivery Location + BUYER badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.h,
                    height: 12.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF236830),
                    ),
                    child: Center(
                      child: Container(
                        width: 4.h,
                        height: 4.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Delivery Location",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "BUYER",
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Profile row: Avatar K + Name + Rating + Phone button
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFFDBEAFE),
                child: Text(
                  mission.dropoffName.isNotEmpty ? mission.dropoffName[0] : 'B',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E40AF),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.dropoffName,
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                        SizedBox(width: 3.w),
                        Text(
                          "${mission.dropoffRating} • Verified Buyer",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  AppSnackBar.info("Calling Buyer at ${mission.dropoffContact}...");
                },
                icon: Container(
                  width: 34.h,
                  height: 34.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDBEAFE),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.phone_rounded,
                    color: Color(0xFF1E40AF),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Address with Location Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 2.h),
                width: 24.h,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.dropoffAddress,
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      mission.dropoffSubtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () {
                        AppSnackBar.success("Opening drop-off coordinates in Maps");
                      },
                      child: Text(
                        "Open in Maps >",
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Delivery window bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF64748B)),
                SizedBox(width: 6.w),
                Text(
                  "Delivery window: ",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Flexible(
                  child: Text(
                    mission.deliveryWindow,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
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
  }

  // ==========================================================
  // 6. DRIVER REQUIREMENTS CARD
  // ==========================================================
  Widget _buildRequirementsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1.2),
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
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: Color(0xFF236830),
              ),
              SizedBox(width: 8.w),
              Text(
                "Driver Requirements",
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          _buildRequirementItem(
            "Van or Truck (your vehicle qualifies)",
            isCheck: true,
          ),
          SizedBox(height: 8.h),
          _buildRequirementItem(
            "Active driver account",
            isCheck: true,
          ),
          SizedBox(height: 8.h),
          _buildRequirementItem(
            "Loading assistance may be required",
            isCheck: false,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, {required bool isCheck}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          child: Icon(
            isCheck ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
            size: 15,
            color: isCheck ? const Color(0xFF16A34A) : const Color(0xFFD97706),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: isCheck ? const Color(0xFF334155) : const Color(0xFFD97706),
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 7. STICKY BOTTOM ACTION BAR (Decline & Accept Mission)
  // ==========================================================
  Widget _buildBottomActionBar(AvailableJobsController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2EDE4).withValues(alpha: 0.8),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
      child: Row(
        children: [
          // Decline Button
          Expanded(
            flex: 3,
            child: OutlinedButton(
              onPressed: () {
                controller.declineMission(mission);
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF8FAFC),
                foregroundColor: const Color(0xFF64748B),
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.close_rounded, size: 16, color: Color(0xFF64748B)),
                  SizedBox(width: 4.w),
                  Text(
                    "Decline",
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Accept Mission Button
          Expanded(
            flex: 5,
            child: ElevatedButton(
              onPressed: () {
                controller.acceptMission(mission);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF236830),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const NavigationArrowIcon(
                    size: 16,
                    color: Colors.white,
                    strokeWidth: 2.2,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Accept Mission",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
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
}
