import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/available_jobs_controller.dart';
import '../widgets/delivery_icons.dart';

class ActiveJobScreen extends StatelessWidget {
  final MissionModel? mission;

  const ActiveJobScreen({
    super.key,
    this.mission,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AvailableJobsController>()
        ? Get.find<AvailableJobsController>()
        : Get.put(AvailableJobsController());

    final activeMission = mission ??
        controller.activeMission.value ??
        controller.allMissions.first;

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint background
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Top Deep Green Header with Ambient Circles & Concentric Glow Badge
            _buildHeader(context),

            // 2. Body Details (Matching user's attached screenshot)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
              child: Column(
                children: [
                  // Title: Mission Accepted!
                  Text(
                    "Mission Accepted!",
                    style: GoogleFonts.inter(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                      letterSpacing: -0.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  // Subtitle: Head to Alhaji Sule Farm for pickup. Navigation has started.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      "Head to ${activeMission.pickupName} for pickup. Navigation has started.",
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        color: const Color(0xFF64748B),
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 26.h),

                  // Mission Summary Card (4 rows without divider lines)
                  _buildSummaryCard(activeMission),

                  SizedBox(height: 24.h),

                  // Resend code in 00:17 (Centered text without clock icon)
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Resend code in ",
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          controller.formattedCountdown,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // Start Navigation CTA Button (Navigation Arrow on LEFT)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        AppSnackBar.success(
                          "Opening turn-by-turn navigation to ${activeMission.pickupName}",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF236830),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: Size(double.infinity, 52.h),
                        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const NavigationArrowIcon(
                            size: 17,
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Start Navigation",
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TOP FOREST GREEN HEADER (Matching Mockup Concentric Badge)
  // ==========================================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270.h,
      decoration: const BoxDecoration(
        color: Color(0xFF184121),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient Circle Top Right
          Positioned(
            top: -20.h,
            right: -30.w,
            child: Container(
              width: 170.h,
              height: 170.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF285C33).withValues(alpha: 0.35),
              ),
            ),
          ),

          // Ambient Circle Bottom Left
          Positioned(
            bottom: -25.h,
            left: -35.w,
            child: Container(
              width: 150.h,
              height: 150.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF23552D).withValues(alpha: 0.35),
              ),
            ),
          ),

          // Top Back Navigation Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 38.h,
                height: 38.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
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
          ),

          // Central Glowing Concentric Badge System
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              width: 116.h,
              height: 116.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF236830).withValues(alpha: 0.28),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 86.h,
                height: 86.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2B7B3E).withValues(alpha: 0.65),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 58.h,
                  height: 58.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2E8540),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 32.h,
                    height: 32.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MISSION SUMMARY CARD (Matching Screenshot with green payout)
  // ==========================================================
  Widget _buildSummaryCard(MissionModel mission) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE2EDE4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            label: "Mission ID",
            value: mission.id,
          ),
          SizedBox(height: 14.h),
          _buildSummaryRow(
            label: "Payout",
            value: mission.payout,
            isPayoutGreen: true,
          ),
          SizedBox(height: 14.h),
          _buildSummaryRow(
            label: "ETA to pickup",
            value: "~8 min",
          ),
          SizedBox(height: 14.h),
          _buildSummaryRow(
            label: "Delivery deadline",
            value: "Before 3:00 PM",
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isPayoutGreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.5.sp,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isPayoutGreen ? 14.5.sp : 13.5.sp,
            fontWeight: FontWeight.bold,
            color: isPayoutGreen
                ? const Color(0xFF236830)
                : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
