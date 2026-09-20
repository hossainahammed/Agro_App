import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/available_jobs_controller.dart';
import '../confirmation/delivery_confirmation_screen.dart';
import '../widgets/delivery_icons.dart';

enum DeliveryStage {
  toPickup,
  pickedUp,
  toDelivery,
  delivered,
}

class DeliveryNavigationScreen extends StatefulWidget {
  final MissionModel? mission;
  final DeliveryStage initialStage;

  const DeliveryNavigationScreen({
    super.key,
    this.mission,
    this.initialStage = DeliveryStage.toPickup,
  });

  @override
  State<DeliveryNavigationScreen> createState() => _DeliveryNavigationScreenState();
}

class _DeliveryNavigationScreenState extends State<DeliveryNavigationScreen> {
  late DeliveryStage currentStage;
  bool isDetailsExpanded = false;
  bool isVoiceMuted = false;

  late MissionModel activeMission;

  @override
  void initState() {
    super.initState();
    currentStage = widget.initialStage;
    final controller = Get.isRegistered<AvailableJobsController>()
        ? Get.find<AvailableJobsController>()
        : Get.put(AvailableJobsController());

    activeMission = widget.mission ??
        controller.activeMission.value ??
        controller.allMissions.first;
  }

  void _advanceStage() {
    setState(() {
      switch (currentStage) {
        case DeliveryStage.toPickup:
          currentStage = DeliveryStage.pickedUp;
          isDetailsExpanded = false;
          AppSnackBar.success("Arrived at Pickup: ${activeMission.pickupName}");
          break;
        case DeliveryStage.pickedUp:
          currentStage = DeliveryStage.toDelivery;
          AppSnackBar.success("Cargo marked as Picked Up. Heading to Delivery!");
          break;
        case DeliveryStage.toDelivery:
          currentStage = DeliveryStage.delivered;
          AppSnackBar.success("Arrived at Delivery: ${activeMission.dropoffName}");
          break;
        case DeliveryStage.delivered:
          Get.to(() => DeliveryConfirmationScreen(
            mission: activeMission,
          ));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE),
      body: Stack(
        children: [
          // 1. Interactive Stylized Live Map Canvas (Fills entire screen)
          Positioned.fill(
            child: CustomPaint(
              painter: _ActiveDeliveryLiveMapPainter(stage: currentStage),
            ),
          ),

          // 2. Top Header & Floating Stepper & Turn Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildTopAppBar(context),
                SizedBox(height: 10.h),
                _buildStepperCard(),
                SizedBox(height: 10.h),
                _buildTurnByTurnBanner(),
              ],
            ),
          ),

          // 3. Floating Map Controls (ETA pill & Re-center compass)
          Positioned(
            left: 0,
            right: 0,
            bottom: isDetailsExpanded ? 380.h : 220.h,
            child: _buildFloatingMapControls(),
          ),

          // 4. Slidable / Expandable Bottom Sheet (Figma Exact Matching)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP APP BAR: Track Delivery + Order ID + Live Badge
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back Button + Title & Subtitle
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
                    "Track Delivery",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Order #${activeMission.id}",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFFD6E8DA),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Live Pill Badge (Tilted navigation cursor + Live + glowing neon green dot)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NavigationArrowIcon(
                  size: 14,
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
                SizedBox(width: 6.w),
                Text(
                  "Live",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 6.5.h,
                  height: 6.5.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E676),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x9900E676),
                        blurRadius: 4,
                        spreadRadius: 0.5,
                      ),
                    ],
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
  // 4-STAGE PROGRESS STEPPER CARD (Exact Figma Mockup Match)
  // ==========================================================
  Widget _buildStepperCard() {
    final stages = [
      (stage: DeliveryStage.toPickup, label: "To Pickup"),
      (stage: DeliveryStage.pickedUp, label: "Picked Up"),
      (stage: DeliveryStage.toDelivery, label: "To Delivery"),
      (stage: DeliveryStage.delivered, label: "Delivered"),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.fromLTRB(10.w, 14.h, 10.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF236830).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final colWidth = totalWidth / 4;
          final badgeCenterY = 12.h; // Center of 24.h badge

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Connecting horizontal lines between stages (rendered behind badges)
              Positioned(
                top: badgeCenterY - 1.25, // Centered vertically with 2.5px line thickness
                left: 0,
                right: 0,
                child: SizedBox(
                  width: totalWidth,
                  height: 2.5,
                  child: Row(
                    children: [
                      SizedBox(width: colWidth * 0.5), // Offset to center of first badge
                      _buildConnectorSegment(
                        width: colWidth,
                        isCompleted: currentStage.index > 0,
                      ),
                      _buildConnectorSegment(
                        width: colWidth,
                        isCompleted: currentStage.index > 1,
                      ),
                      _buildConnectorSegment(
                        width: colWidth,
                        isCompleted: currentStage.index > 2,
                      ),
                      SizedBox(width: colWidth * 0.5), // Offset from center of last badge
                    ],
                  ),
                ),
              ),

              // 2. Interactive Steps (Badges + Text)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(4, (index) {
                  final isDone = currentStage.index > index;
                  final isActive = currentStage.index == index;

                  return SizedBox(
                    width: colWidth,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          currentStage = stages[index].stage;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Circular Badge
                          _buildStepBadge(isDone: isDone, isActive: isActive),
                          SizedBox(height: 7.h),
                          // Label
                          Text(
                            stages[index].label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: (isDone || isActive)
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: (isDone || isActive)
                                  ? const Color(0xFF236830)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildConnectorSegment({
    required double width,
    required bool isCompleted,
  }) {
    return SizedBox(
      width: width,
      child: Center(
        child: Container(
          width: math.max(0.0, width - 36.w),
          height: 2.5,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF236830) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildStepBadge({
    required bool isDone,
    required bool isActive,
  }) {
    if (isDone) {
      // Completed Badge: Solid green circle + inner thin white circular ring + centered checkmark
      return Container(
        width: 24.h,
        height: 24.h,
        decoration: const BoxDecoration(
          color: Color(0xFF236830),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 17.h,
          height: 17.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1.4,
            ),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 11,
          ),
        ),
      );
    } else if (isActive) {
      // Active Target Badge: Solid green circle + centered solid white circular dot
      return Container(
        width: 24.h,
        height: 24.h,
        decoration: const BoxDecoration(
          color: Color(0xFF236830),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 8.h,
          height: 8.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    } else {
      // Upcoming / Pending Badge: Light grey circular ring
      return Container(
        width: 24.h,
        height: 24.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFCBD5E1),
            width: 2.0,
          ),
          color: Colors.white,
        ),
      );
    }
  }

  // ==========================================================
  // FLOATING GPS TURN-BY-TURN BANNER
  // ==========================================================
  Widget _buildTurnByTurnBanner() {
    String turnText = "Turn right onto Zaria Road";
    String distanceEta = "3.1 km • 12 min away";

    switch (currentStage) {
      case DeliveryStage.toPickup:
        turnText = "Turn right onto Zaria Road";
        distanceEta = "3.1 km • 12 min away";
        break;
      case DeliveryStage.pickedUp:
        turnText = "Arrived at Alhaji Sule Farm";
        distanceEta = "Loading bay gate 2";
        break;
      case DeliveryStage.toDelivery:
        turnText = "Continue straight on Fagge Expressway";
        distanceEta = "5.4 km • 18 min away";
        break;
      case DeliveryStage.delivered:
        turnText = "Turn left into Kano Central Silo";
        distanceEta = "0.05 km • 2 min away";
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF184121),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Turn Arrow Icon in circle
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.turn_right_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          SizedBox(width: 12.w),

          // Instructions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  turnText,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  distanceEta,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFFD6E8DA),
                  ),
                ),
              ],
            ),
          ),

          // Voice Sound Button
          GestureDetector(
            onTap: () {
              setState(() {
                isVoiceMuted = !isVoiceMuted;
              });
              AppSnackBar.info(isVoiceMuted ? "Voice navigation muted" : "Voice navigation unmuted");
            },
            child: Container(
              width: 34.h,
              height: 34.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isVoiceMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FLOATING MAP CONTROLS (ETA Pill & Re-center compass)
  // ==========================================================
  Widget _buildFloatingMapControls() {
    final etaText = currentStage == DeliveryStage.delivered ? "2 min" : "12 min";
    final distText = currentStage == DeliveryStage.delivered ? "0.05 km" : "3.1 km";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40), // spacer for balance
          // ETA Pill at center
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Color(0xFF236830),
                ),
                SizedBox(width: 5.w),
                Text(
                  etaText,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 3.h,
                  height: 3.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF94A3B8),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  distText,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Re-center Compass Button
          GestureDetector(
            onTap: () {
              AppSnackBar.info("Map re-centered to your live GPS position");
            },
            child: Container(
              width: 42.h,
              height: 42.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const NavigationArrowIcon(
                size: 18,
                color: Color(0xFF236830),
                strokeWidth: 2.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SLIDABLE / EXPANDABLE BOTTOM SHEET (Matching Figma 5 States)
  // ==========================================================
  Widget _buildBottomSheet() {
    final isPickupStage = currentStage == DeliveryStage.toPickup ||
        currentStage == DeliveryStage.pickedUp;

    final contactName = isPickupStage ? activeMission.pickupName : activeMission.dropoffName;
    final contactRole = isPickupStage ? "Producer" : "Buyer";
    final contactAddress = isPickupStage ? activeMission.pickupAddress : activeMission.dropoffAddress;
    final contactPhone = isPickupStage ? activeMission.pickupContact : activeMission.dropoffContact;

    // Status label
    String statusTitle;
    String ctaButtonTitle;
    IconData ctaIcon;

    switch (currentStage) {
      case DeliveryStage.toPickup:
        statusTitle = "HEADING TO PICKUP";
        ctaButtonTitle = "Arrived at Pickup";
        ctaIcon = Icons.location_on_outlined;
        break;
      case DeliveryStage.pickedUp:
        statusTitle = "PICKED UP";
        ctaButtonTitle = "Mark as Picked Up";
        ctaIcon = Icons.inventory_2_outlined;
        break;
      case DeliveryStage.toDelivery:
        statusTitle = "HEADING TO DELIVERY";
        ctaButtonTitle = "Arrived at Delivery";
        ctaIcon = Icons.location_on_outlined;
        break;
      case DeliveryStage.delivered:
        statusTitle = "DELIVERED";
        ctaButtonTitle = "Confirm Delivery";
        ctaIcon = Icons.check_circle_outline_rounded;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          GestureDetector(
            onTap: () {
              setState(() {
                isDetailsExpanded = !isDetailsExpanded;
              });
            },
            child: Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Status Header: ● STATUS TITLE  AGC-5102
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7.h,
                    height: 7.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF236830),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    statusTitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: const Color(0xFF236830),
                    ),
                  ),
                ],
              ),
              Text(
                activeMission.id,
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Contact Profile Row
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20.r,
                backgroundColor: isPickupStage
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFDBEAFE),
                child: Text(
                  contactName.isNotEmpty ? contactName[0] : 'U',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isPickupStage
                        ? const Color(0xFF166534)
                        : const Color(0xFF1E40AF),
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Name + Role Badge + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            contactName,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E2D24),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: isPickupStage
                                ? const Color(0xFFE8F5EC)
                                : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            contactRole,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: isPickupStage
                                  ? const Color(0xFF236830)
                                  : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 11,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            contactAddress,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: const Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions: Call & WhatsApp
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      AppSnackBar.info("Calling $contactName at $contactPhone");
                    },
                    child: Container(
                      width: 34.h,
                      height: 34.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.phone_rounded,
                        color: Color(0xFF236830),
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      AppSnackBar.info("Opening chat with $contactName");
                    },
                    child: Container(
                      width: 34.h,
                      height: 34.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Color(0xFF236830),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Expanded Details Section (Shown when isDetailsExpanded is true)
          if (isDetailsExpanded) ...[
            SizedBox(height: 14.h),

            // Location card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF8),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFEAF1EB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Color(0xFF236830)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeMission.pickupAddress,
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E2D24),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          activeMission.pickupSubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            // Phone call box with Call button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF8),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFEAF1EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 16, color: Color(0xFF236830)),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contactPhone,
                            style: GoogleFonts.inter(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E2D24),
                            ),
                          ),
                          Text(
                            "Tap to call",
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      AppSnackBar.info("Calling $contactPhone");
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF236830),
                      side: const BorderSide(color: Color(0xFF236830)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    ),
                    child: Text(
                      "Call",
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            // Cargo details pill
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 15, color: Color(0xFFD97706)),
                  SizedBox(width: 8.w),
                  RichText(
                    text: TextSpan(
                      text: "Cargo: ",
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF92400E),
                      ),
                      children: [
                        TextSpan(
                          text: "${activeMission.title} • ${activeMission.weight}",
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 14.h),

          // Primary CTA Button: Arrived at Pickup / Mark as Picked Up / etc.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _advanceStage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF236830),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: Size(double.infinity, 50.h),
                padding: EdgeInsets.symmetric(vertical: 13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    ctaIcon,
                    color: Colors.white,
                    size: 17,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    ctaButtonTitle,
                    style: GoogleFonts.inter(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Expand / Collapse Order Details Toggle
          GestureDetector(
            onTap: () {
              setState(() {
                isDetailsExpanded = !isDetailsExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDetailsExpanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  size: 16,
                  color: const Color(0xFF64748B),
                ),
                SizedBox(width: 4.w),
                Text(
                  "Order details",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stylized Map Painter with City Blocks, Live Vehicle Pulse Beacon, and Route Path
class _ActiveDeliveryLiveMapPainter extends CustomPainter {
  final DeliveryStage stage;

  _ActiveDeliveryLiveMapPainter({required this.stage});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Fill base canvas with road asphalt color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFEFF5F1),
    );

    // 2. Draw city blocks
    final blockPaint = Paint()..color = const Color(0xFFDFEAE1);
    const int cols = 5;
    const int rows = 8;
    const double gap = 8.0;
    final double blockW = (size.width - (cols + 1) * gap) / cols;
    final double blockH = (size.height - (rows + 1) * gap) / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final left = gap + c * (blockW + gap);
        final top = gap + r * (blockH + gap);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left, top, blockW, blockH),
            const Radius.circular(5.0),
          ),
          blockPaint,
        );
      }
    }

    // 3. Traveled Route (Solid Green) vs Remaining Route (Dashed Blue)
    // Points along the route:
    // P_start: bottom-left
    // P_vehicle: center
    // P_end: top-right
    final pStart = Offset(size.width * 0.08, size.height * 0.58);
    final pVehicle = Offset(size.width * 0.48, size.height * 0.40);
    final pEnd = Offset(size.width * 0.88, size.height * 0.28);

    // Traveled path: Solid green
    final traveledPath = Path()
      ..moveTo(pStart.dx, pStart.dy)
      ..cubicTo(size.width * 0.20, size.height * 0.52, size.width * 0.35, size.height * 0.48, pVehicle.dx, pVehicle.dy);

    final greenLinePaint = Paint()
      ..color = const Color(0xFF236830)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(traveledPath, greenLinePaint);

    // Remaining path: Dashed light blue/grey
    final remainingPath = Path()
      ..moveTo(pVehicle.dx, pVehicle.dy)
      ..cubicTo(size.width * 0.62, size.height * 0.32, size.width * 0.75, size.height * 0.30, pEnd.dx, pEnd.dy);

    final dashedPaint = Paint()
      ..color = const Color(0xFF60A5FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    for (final metric in remainingPath.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = 6.0;
        final Path extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, dashedPaint);
        distance += 6.0 + 4.0;
      }
    }

    // 4. Vehicle Pulse Beacon (at pVehicle)
    // Outer translucent radar halo
    final haloPaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pVehicle, 22.0, haloPaint);

    // Mid white ring
    final midWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pVehicle, 12.0, midWhitePaint);

    // Center blue vehicle dot
    final centerBluePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pVehicle, 8.0, centerBluePaint);
  }

  @override
  bool shouldRepaint(covariant _ActiveDeliveryLiveMapPainter oldDelegate) {
    return oldDelegate.stage != stage;
  }
}
