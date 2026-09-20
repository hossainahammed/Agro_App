import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/available_jobs_controller.dart';
import '../jobs/available_jobs_screen.dart';
import '../jobs/job_history_screen.dart';

class DeliveryCompleteScreen extends StatelessWidget {
  final MissionModel? mission;
  final int durationMinutes;

  const DeliveryCompleteScreen({
    super.key,
    this.mission,
    this.durationMinutes = 38,
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
      backgroundColor: const Color(0xFFF4F7F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Forest Green Ambient Curved Header with Celebration Badge
            _buildHeader(context),

            // 2. Body Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  // Headline & Subtitle
                  Text(
                    "Delivery Complete!",
                    style: GoogleFonts.inter(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Mission ${activeMission.id} successfully delivered to ${activeMission.dropoffName}.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      color: const Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // Earnings Added Green Card
                  _buildEarningsCard(activeMission),

                  SizedBox(height: 18.h),

                  // Delivery Summary Specs Card
                  _buildSummaryCard(activeMission),

                  SizedBox(height: 26.h),

                  // Outlined "Back to Missions" Button
                  _buildBackToMissionsButton(controller),

                  SizedBox(height: 16.h),

                  // "Delivery History" Text Link
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const JobHistoryScreen());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                      child: Text(
                        "Delivery History",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF236830),
                        ),
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
  // TOP CURVED AMBIENT HEADER WITH CELEBRATION BADGE
  // ==========================================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230.h,
      decoration: const BoxDecoration(
        color: Color(0xFF184121),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient Overlapping Circle (Top-Right)
          Positioned(
            top: -30.h,
            right: -20.w,
            child: Container(
              width: 170.h,
              height: 170.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF285C33).withValues(alpha: 0.35),
              ),
            ),
          ),

          // Ambient Overlapping Circle (Bottom-Left)
          Positioned(
            bottom: -30.h,
            left: -20.w,
            child: Container(
              width: 150.h,
              height: 150.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF23552D).withValues(alpha: 0.35),
              ),
            ),
          ),

          // Top-Left Back Navigation Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            child: GestureDetector(
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
          ),

          // Center Celebration Circular Badge
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 24.h),
              width: 82.h,
              height: 82.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                width: 52.h,
                height: 52.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF236830),
                    width: 3.2,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF236830),
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EARNINGS ADDED GREEN CARD
  // ==========================================================
  Widget _buildEarningsCard(MissionModel mission) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
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
          Text(
            "EARNINGS ADDED",
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: const Color(0xFFA7F3D0),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            mission.payout,
            style: GoogleFonts.inter(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Credited to your AgroConnect wallet",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFFD1FAE5),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DELIVERY SUMMARY SPECS CARD (4-row details)
  // ==========================================================
  Widget _buildSummaryCard(MissionModel mission) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            label: "Distance",
            value: mission.distanceTotal,
          ),
          SizedBox(height: 14.h),
          _buildSummaryRow(
            label: "Duration",
            value: "$durationMinutes minutes",
          ),
          SizedBox(height: 14.h),
          _buildSummaryRow(
            label: "Cargo",
            value: "${mission.title.split('(').first.trim()} · ${mission.weight}",
          ),
          SizedBox(height: 14.h),
          _buildSummaryRow(
            label: "Delivered to",
            value: mission.dropoffName,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // BACK TO MISSIONS OUTLINED BUTTON
  // ==========================================================
  Widget _buildBackToMissionsButton(AvailableJobsController controller) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: () {
          // Clear active mission and return to Available Jobs
          controller.activeMission.value = null;
          Get.offAll(() => const AvailableJobsScreen());
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFF236830),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(
          "Back to Missions",
          style: GoogleFonts.inter(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF236830),
          ),
        ),
      ),
    );
  }
}
