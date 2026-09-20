import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/available_jobs_controller.dart';
import '../widgets/delivery_icons.dart';

class DeliveredMissionDetailScreen extends StatefulWidget {
  final MissionModel? mission;

  const DeliveredMissionDetailScreen({
    super.key,
    this.mission,
  });

  @override
  State<DeliveredMissionDetailScreen> createState() =>
      _DeliveredMissionDetailScreenState();
}

class _DeliveredMissionDetailScreenState
    extends State<DeliveredMissionDetailScreen> {
  late MissionModel job;
  int userRating = 5;

  @override
  void initState() {
    super.initState();
    final controller = Get.isRegistered<AvailableJobsController>()
        ? Get.find<AvailableJobsController>()
        : Get.put(AvailableJobsController());

    job = widget.mission ??
        controller.activeMission.value ??
        controller.allMissions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      body: Column(
        children: [
          // 1. Top Green App Bar
          _buildTopAppBar(context),

          // 2. Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Earnings Card
                  _buildTotalEarningsCard(),

                  SizedBox(height: 18.h),

                  // Delivery Timeline Card
                  _buildDeliveryTimelineCard(),

                  SizedBox(height: 18.h),

                  // Route Summary Card
                  _buildRouteSummaryCard(),

                  SizedBox(height: 18.h),

                  // Producer Card
                  _buildProducerCard(),

                  SizedBox(height: 18.h),

                  // Buyer Information Card
                  _buildBuyerInfoCard(),

                  SizedBox(height: 18.h),

                  // Product Details Card
                  _buildProductDetailsCard(),

                  SizedBox(height: 18.h),

                  // Rate This Mission Card
                  _buildRateThisMissionCard(),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP APP BAR: AGC-5102 + Completed Badge
  // ==========================================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF236830),
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 8.h,
        16.w,
        14.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button + Title & Timestamp
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36.h,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    job.id,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Fri 27 Jun · 9:03 AM — 9:41 AM",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFFD6E8DA),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Completed Pill Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  size: 15,
                ),
                SizedBox(width: 5.w),
                Text(
                  "Completed",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF236830),
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
  // 1. TOTAL EARNINGS CARD (With Fare Breakdown)
  // ==========================================================
  Widget _buildTotalEarningsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF236830),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF236830).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TOTAL EARNINGS",
                  style: GoogleFonts.inter(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: const Color(0xFFA7F3D0),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      job.payout,
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 13,
                            color: Color(0xFFD1FAE5),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            "+12% vs avg",
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD1FAE5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "Credited to your AgroConnect wallet",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFFD6E8DA),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.15),
          ),

          // 3-Column Fare Breakdown
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBreakdownColumn("₦1,500", "BASE FARE"),
                Container(
                  width: 1,
                  height: 26.h,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                _buildBreakdownColumn("₦1,050", "DISTANCE BONUS"),
                Container(
                  width: 1,
                  height: 26.h,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                _buildBreakdownColumn("₦650", "ON-TIME BONUS"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownColumn(String amount, String label) {
    return Column(
      children: [
        Text(
          amount,
          style: GoogleFonts.inter(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFD6E8DA),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 2. DELIVERY TIMELINE CARD (5 Checkpoints)
  // ==========================================================
  Widget _buildDeliveryTimelineCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DELIVERY TIMELINE",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Mission Accepted
              _buildTimelineRow(
                icon: Icons.check,
                iconColor: Colors.white,
                circleBgColor: const Color(0xFF236830),
                title: "Mission Accepted",
                subtitle: "${job.id} confirmed · Headed to pickup",
                time: "9:03 AM",
                showBottomLine: true,
              ),

              // 2. Arrived at Pickup
              _buildTimelineRow(
                icon: Icons.location_on_rounded,
                iconColor: Colors.white,
                circleBgColor: const Color(0xFF236830),
                title: "Arrived at Pickup",
                subtitle: "${job.pickupName} · ${job.pickupCity}",
                time: "9:11 AM",
                showBottomLine: true,
              ),

              // 3. Cargo Picked Up
              _buildTimelineRow(
                customWidget: const DeliveryBoxIcon(
                  size: 14,
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
                circleBgColor: const Color(0xFF236830),
                title: "Cargo Picked Up",
                subtitle: "${job.title} · ${job.weight} loaded",
                time: "9:19 AM",
                showBottomLine: true,
              ),

              // 4. En Route to Buyer (Blue indicator)
              _buildTimelineRow(
                customWidget: Container(
                  width: 8.h,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                circleBgColor: const Color(0xFF3B82F6),
                title: "En Route to Buyer",
                subtitle: "Heading to ${job.dropoffName} · 5.6 km",
                time: "9:19 AM",
                showBottomLine: true,
              ),

              // 5. Delivered
              _buildTimelineRow(
                icon: Icons.check,
                iconColor: Colors.white,
                circleBgColor: const Color(0xFF236830),
                title: "Delivered",
                isTitleGreen: true,
                subtitle: "${job.dropoffName} · ${job.dropoffCity} · On time",
                time: "9:41 AM",
                showBottomLine: false,
              ),

              SizedBox(height: 14.h),

              // Total Duration Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5ED),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled_rounded,
                          color: Color(0xFF236830),
                          size: 16,
                        ),
                        SizedBox(width: 8.w),
                        RichText(
                          text: TextSpan(
                            text: "Total Duration:  ",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: const Color(0xFF1E2D24),
                            ),
                            children: [
                              TextSpan(
                                text: "38 minutes",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF236830),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            size: 13,
                            color: Color(0xFF16A34A),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            "On time",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildTimelineRow({
    IconData? icon,
    Color? iconColor,
    Widget? customWidget,
    required Color circleBgColor,
    required String title,
    required String subtitle,
    required String time,
    required bool showBottomLine,
    bool isTitleGreen = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator Column
          Column(
            children: [
              Container(
                width: 24.h,
                height: 24.h,
                decoration: BoxDecoration(
                  color: circleBgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: customWidget ??
                    Icon(
                      icon,
                      size: 13,
                      color: iconColor,
                    ),
              ),
              if (showBottomLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE2E8F0),
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),

          // Content Column
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showBottomLine ? 16.h : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: isTitleGreen
                                ? const Color(0xFF236830)
                                : const Color(0xFF1E2D24),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF94A3B8),
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

  // ==========================================================
  // 3. ROUTE SUMMARY CARD (With Stylized Route Canvas)
  // ==========================================================
  Widget _buildRouteSummaryCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ROUTE SUMMARY",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Mini Route Map Canvas
              Container(
                height: 90.h,
                width: double.infinity,
                margin: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CustomPaint(
                    painter: _CompletedRouteMiniMapPainter(),
                  ),
                ),
              ),

              // Route Info Row
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 14.h),
                child: Row(
                  children: [
                    // Pickup Info
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.home_outlined,
                                size: 13,
                                color: Color(0xFF236830),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "PICKUP",
                                style: GoogleFonts.inter(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF236830),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            job.pickupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E2D24),
                            ),
                          ),
                          Text(
                            job.pickupCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Middle Distance & Time
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Color(0xFFE2E8F0)),
                          right: BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            job.distanceTotal,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E2D24),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "38 min",
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Drop-off Info
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "DROP-OFF",
                                style: GoogleFonts.inter(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Container(
                                width: 6.h,
                                height: 6.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF236830),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            job.dropoffName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E2D24),
                            ),
                          ),
                          Text(
                            job.dropoffCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
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

  // ==========================================================
  // 4. PRODUCER CARD
  // ==========================================================
  Widget _buildProducerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PRODUCER",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: const Color(0xFFEAF5ED),
                    child: Text(
                      "A",
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF236830),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Samuel Adeyemi",
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E2D24),
                          ),
                        ),
                        Text(
                          "Adeyemi Green Farms",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Color(0xFFF59E0B),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              "4.8",
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E2D24),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons: Call + Chat
                  _buildCircularActionButton(
                    icon: Icons.phone_rounded,
                    onTap: () => AppSnackBar.success("Calling Samuel Adeyemi..."),
                  ),
                  SizedBox(width: 8.w),
                  _buildCircularActionButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () => AppSnackBar.success("Opening chat with producer..."),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Container(
                    width: 24.h,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5ED),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF236830),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "14 Bello Road, Nassarawa GRA, Kano State",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFF1E2D24),
                        fontWeight: FontWeight.w500,
                      ),
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

  // ==========================================================
  // 5. BUYER INFORMATION CARD
  // ==========================================================
  Widget _buildBuyerInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BUYER INFORMATION",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: const Color(0xFFEAF5ED),
                    child: Text(
                      "A",
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF236830),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aisha Musa",
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E2D24),
                          ),
                        ),
                        Text(
                          "Musa Fresh Supplies",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF5ED),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "Wholesale Distributor",
                            style: GoogleFonts.inter(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF236830),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons: Call + Chat
                  _buildCircularActionButton(
                    icon: Icons.phone_rounded,
                    onTap: () => AppSnackBar.success("Calling Aisha Musa..."),
                  ),
                  SizedBox(width: 8.w),
                  _buildCircularActionButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () => AppSnackBar.success("Opening chat with buyer..."),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Container(
                    width: 24.h,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5ED),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: Color(0xFF236830),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "+234 812 340 9021",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF1E2D24),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 24.h,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5ED),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF236830),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "14 Bello Road, Nassarawa GRA, Kano State",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFF1E2D24),
                        fontWeight: FontWeight.w500,
                      ),
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

  // ==========================================================
  // 6. PRODUCT DETAILS CARD
  // ==========================================================
  Widget _buildProductDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DeliveryBoxIcon(
                size: 18,
                color: Color(0xFF236830),
                strokeWidth: 1.8,
              ),
              SizedBox(width: 8.w),
              Text(
                "Product Details",
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _buildDetailRow("Item", job.item),
          SizedBox(height: 10.h),
          _buildDetailRow("Quantity", job.quantity),
          SizedBox(height: 10.h),
          _buildDetailRow("Weight", job.weight),
          SizedBox(height: 10.h),
          _buildDetailRow("Packaging", job.packaging),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2D24),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 7. RATE THIS MISSION CARD (Interactive 5 Stars)
  // ==========================================================
  Widget _buildRateThisMissionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
      ),
      child: Column(
        children: [
          Text(
            "Rate this mission",
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2D24),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "How was your experience with this delivery?",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    userRating = starIndex;
                  });
                  AppSnackBar.success("Thanks for your rating of $userRating stars!");
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    Icons.star_rounded,
                    size: 34,
                    color: starIndex <= userRating
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 10.h),
          Text(
            "Excellent! — Thanks for rating!",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.h,
        height: 36.h,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF5ED),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 17,
          color: const Color(0xFF236830),
        ),
      ),
    );
  }
}

/// Custom painter for stylized route mini map
class _CompletedRouteMiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blockPaint = Paint()
      ..color = const Color(0xFFE2EDE4)
      ..style = PaintingStyle.fill;

    // Draw city blocks
    final rows = 3;
    final cols = 4;
    final gap = 6.0;
    final blockW = (size.width - (cols + 1) * gap) / cols;
    final blockH = (size.height - (rows + 1) * gap) / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            gap + c * (blockW + gap),
            gap + r * (blockH + gap),
            blockW,
            blockH,
          ),
          const Radius.circular(4),
        );
        canvas.drawRRect(rect, blockPaint);
      }
    }

    // Curved green dotted/dashed route line
    final routePaint = Paint()
      ..color = const Color(0xFF236830)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.50,
        size.width * 0.85,
        size.height * 0.38,
      );

    canvas.drawPath(path, routePaint);

    // Pickup Dot
    final pickupDotPaint = Paint()..color = const Color(0xFF236830);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.72),
      4.5,
      pickupDotPaint,
    );

    // Dropoff Square
    final dropoffRect = Rect.fromCenter(
      center: Offset(size.width * 0.85, size.height * 0.38),
      width: 8,
      height: 8,
    );
    canvas.drawRect(dropoffRect, pickupDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
