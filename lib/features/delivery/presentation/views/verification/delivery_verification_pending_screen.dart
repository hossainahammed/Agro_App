import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/role_selection/screen/role_selection_screen.dart';
import '../../controllers/delivery_verification_controller.dart';

class DeliveryVerificationPendingScreen extends StatelessWidget {
  const DeliveryVerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DeliveryVerificationController>()
        ? Get.find<DeliveryVerificationController>()
        : Get.put(DeliveryVerificationController());

    return Scaffold(
      backgroundColor: const Color(0xFF173E20), // Dark forest green top
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // ========================================================
              // 1. TOP HEADER (With Glowing Clock Badge)
              // ========================================================
              _buildTopHeader(context),

              // ========================================================
              // 2. BODY CARD CONTAINER (Soft Mint-Sage)
              // ========================================================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF4EE), // Signature soft sage-mint
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 36.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      "Documents Are Under Review",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle
                    Text(
                      "We'll notify you once your account is approved — usually within 24–48 hours.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A8C80),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Submission timestamp pill
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F3ED),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFF236830).withValues(alpha: 0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: const Color(0xFF236830),
                              size: 14.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Submitted today at ${controller.submissionTime.value.isNotEmpty ? controller.submissionTime.value : '9:41 AM'}",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF236830),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ====================================================
                    // REVIEW PROGRESS CARD (Vertical Timeline)
                    // ====================================================
                    _buildReviewProgressCard(),
                    SizedBox(height: 20.h),

                    // ====================================================
                    // SUBMITTED DOCUMENTS CARD
                    // ====================================================
                    _buildSubmittedDocsCard(),
                    SizedBox(height: 24.h),

                    // Dashboard unlocks footer note
                    Text(
                      "Dashboard unlocks after your account is approved",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7A8C80),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Go to Dashboard Button
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          AppSnackBar.info(
                            "Your driver account is currently undergoing verification.",
                          );
                          // Seamless transition back to login or role selection
                          Get.offAll(() => const RoleSelectionScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8F3ED),
                          foregroundColor: const Color(0xFF236830),
                          elevation: 0,
                          side: const BorderSide(
                            color: Color(0xFFD6E3D8),
                            width: 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                        ),
                        child: Text(
                          "Go to Dashboard",
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF236830),
                          ),
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

  // ========================================================
  // TOP HEADER WIDGET (Clock badge & rings)
  // ========================================================
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B4926),
            Color(0xFF133B1D),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative Soft Circles
          Positioned(
            left: -30.w,
            top: 20.h,
            child: Container(
              width: 140.h,
              height: 140.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: -30.w,
            top: -20.h,
            child: Container(
              width: 170.h,
              height: 170.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Circular Back Button (Top Left)
          Positioned(
            left: 20.w,
            top: 14.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40.h,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // Central Glowing Clock Badge
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 14.h),
                Container(
                  width: 86.h,
                  height: 86.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 64.h,
                          height: 64.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF2E8A49),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.access_time_rounded,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                        // Amber status indicator dot
                        Positioned(
                          right: -2.w,
                          top: 2.h,
                          child: Container(
                            width: 14.h,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB300),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
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
        ],
      ),
    );
  }

  // ========================================================
  // REVIEW PROGRESS CARD (4-Step Timeline)
  // ========================================================
  Widget _buildReviewProgressCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFD6E3D8),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Text(
            "REVIEW PROGRESS",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF7A8C80),
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: 16.h),

          // 1. Documents received (Completed)
          _buildTimelineItem(
            title: "Documents received",
            state: _TimelineState.completed,
            showLine: true,
          ),

          // 2. Identity check (Completed)
          _buildTimelineItem(
            title: "Identity check",
            state: _TimelineState.completed,
            showLine: true,
          ),

          // 3. Background verification (In progress)
          _buildTimelineItem(
            title: "Background verification",
            state: _TimelineState.inProgress,
            badgeText: "In progress",
            showLine: true,
          ),

          // 4. Final approval (Pending)
          _buildTimelineItem(
            title: "Final approval",
            state: _TimelineState.pending,
            showLine: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required _TimelineState state,
    String? badgeText,
    required bool showLine,
  }) {
    Widget iconWidget;

    switch (state) {
      case _TimelineState.completed:
        iconWidget = Container(
          width: 20.h,
          height: 20.h,
          decoration: const BoxDecoration(
            color: Color(0xFF236830),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 13),
        );
        break;
      case _TimelineState.inProgress:
        iconWidget = Container(
          width: 20.h,
          height: 20.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFA000), width: 2.0),
          ),
          child: Center(
            child: Container(
              width: 8.h,
              height: 8.h,
              decoration: const BoxDecoration(
                color: Color(0xFFFFA000),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
        break;
      case _TimelineState.pending:
        iconWidget = Container(
          width: 20.h,
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD6DFD8), width: 1.5),
          ),
        );
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon + connecting vertical line
          Column(
            children: [
              iconWidget,
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2.w,
                    margin: EdgeInsets.symmetric(vertical: 3.h),
                    color: state == _TimelineState.completed
                        ? const Color(0xFF236830)
                        : const Color(0xFFE0E0E0),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),

          // Title & optional Badge
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLine ? 16.h : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: state == _TimelineState.inProgress
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: state == _TimelineState.pending
                          ? const Color(0xFF9EABA2)
                          : const Color(0xFF1E2D24),
                    ),
                  ),
                  if (badgeText != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        badgeText,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE65100),
                        ),
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

  // ========================================================
  // SUBMITTED DOCUMENTS CARD (With Pending Badges)
  // ========================================================
  Widget _buildSubmittedDocsCard() {
    final List<Map<String, dynamic>> submittedDocs = [
      {'name': 'National ID Card (CNI)', 'icon': Icons.badge_outlined},
      {'name': 'Driving License', 'icon': Icons.assignment_ind_outlined},
      {'name': 'Vehicle Registration (Carte Grise)', 'icon': Icons.local_shipping_outlined},
      {'name': 'Insurance Certificate', 'icon': Icons.shield_outlined},
      {'name': 'Police Clearance Certificate', 'icon': Icons.verified_user_outlined},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFD6E3D8),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Text(
            "SUBMITTED DOCUMENTS",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF7A8C80),
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: 12.h),

          // List of submitted documents
          ...submittedDocs.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            final isLast = index == submittedDocs.length - 1;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      // Document Icon
                      Icon(
                        doc['icon'] as IconData,
                        color: const Color(0xFF236830),
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),

                      // Document Name
                      Expanded(
                        child: Text(
                          doc['name'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E2D24),
                          ),
                        ),
                      ),

                      // Pending Chip
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFFFD54F),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5.h,
                              height: 5.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFA000),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Pending",
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE65100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: const Color(0xFFF0F4F1),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

enum _TimelineState {
  completed,
  inProgress,
  pending,
}
