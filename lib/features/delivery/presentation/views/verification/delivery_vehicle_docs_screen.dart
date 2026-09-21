import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/delivery_verification_controller.dart';

class DeliveryVehicleDocsScreen extends StatelessWidget {
  const DeliveryVehicleDocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DeliveryVerificationController>()
        ? Get.find<DeliveryVerificationController>()
        : Get.put(DeliveryVerificationController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SafeArea(
        child: Column(
          children: [
            // ========================================================
            // TOP BAR & PROGRESS (Step 2 out of 2 - 100%)
            // ========================================================
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40.h,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD6E3D8),
                              width: 1.0,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF1E2D24),
                            size: 20,
                          ),
                        ),
                      ),
                      // Quick Demo Autofill button
                      GestureDetector(
                        onTap: controller.prefillAllDemoDocuments,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF236830).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: const Color(0xFF236830).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: const Color(0xFF236830),
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Auto-Fill Demo",
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF236830),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Step indicator text row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Step 2 out of 2",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E2D24),
                        ),
                      ),
                      Text(
                        "100%",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Progress Bar (100% filled)
                  Container(
                    width: double.infinity,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF236830),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ],
              ),
            ),

            // ========================================================
            // SCROLLABLE VEHICLE DOCUMENTS CONTENT
            // ========================================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Step 1 complete badge banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF236830).withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: const Color(0xFF236830),
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              "Step 1 complete — ID & Driving License uploaded",
                              style: GoogleFonts.inter(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF236830),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Title
                    Text(
                      "Vehicle & Legal Documents",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Subtitle
                    Text(
                      "Upload your vehicle and compliance documents to complete verification.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A8C80),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 22.h),

                    // ----------------------------------------------------
                    // 1. Vehicle Registration Card (Carte Grise)
                    // ----------------------------------------------------
                    Obx(
                      () => _buildDocCard(
                        context: context,
                        icon: Icons.local_shipping_outlined,
                        title: "Vehicle Registration Card",
                        subtitle1: "Carte Grise",
                        subtitle2: "Must match the vehicle you registered",
                        filePath: controller.vehicleRegistration.value,
                        fileName: controller.vehicleRegistrationName.value,
                        onTap: () => controller.pickDocument(
                          context: context,
                          onSelected: (path, name) {
                            controller.vehicleRegistration.value = path;
                            controller.vehicleRegistrationName.value = name;
                          },
                        ),
                        onDelete: () {
                          controller.vehicleRegistration.value = null;
                          controller.vehicleRegistrationName.value = null;
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ----------------------------------------------------
                    // 2. Insurance Certificate
                    // ----------------------------------------------------
                    Obx(
                      () => _buildDocCard(
                        context: context,
                        icon: Icons.shield_outlined,
                        title: "Insurance Certificate",
                        subtitle1: "Valid policy — expiry date must be visible",
                        filePath: controller.insuranceCertificate.value,
                        fileName: controller.insuranceCertificateName.value,
                        onTap: () => controller.pickDocument(
                          context: context,
                          onSelected: (path, name) {
                            controller.insuranceCertificate.value = path;
                            controller.insuranceCertificateName.value = name;
                          },
                        ),
                        onDelete: () {
                          controller.insuranceCertificate.value = null;
                          controller.insuranceCertificateName.value = null;
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ----------------------------------------------------
                    // 3. Police Clearance Certificate
                    // ----------------------------------------------------
                    Obx(
                      () => _buildDocCard(
                        context: context,
                        icon: Icons.verified_user_outlined,
                        title: "Police Clearance Certificate",
                        subtitle1: "Must be issued within the last 3 months",
                        warningTag: "• Must be < 3 months old",
                        filePath: controller.policeClearance.value,
                        fileName: controller.policeClearanceName.value,
                        onTap: () => controller.pickDocument(
                          context: context,
                          onSelected: (path, name) {
                            controller.policeClearance.value = path;
                            controller.policeClearanceName.value = name;
                          },
                        ),
                        onDelete: () {
                          controller.policeClearance.value = null;
                          controller.policeClearanceName.value = null;
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Accepted formats footer
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: const Color(0xFF7A8C80),
                          size: 15.sp,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            "Accepted formats: JPG, PNG, PDF — max 5 MB per file",
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: const Color(0xFF7A8C80),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // Amber warning card: Police clearance 90 days validity
                    _buildPoliceClearanceWarning(),
                    SizedBox(height: 14.h),

                    // Green info card: Review within 24-48 hours
                    _buildGreenReviewCard(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // ========================================================
            // FIXED BOTTOM ACTION BAR
            // ========================================================
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF4EE),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Documents counter
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${controller.vehicleDocsUploadedCount} of 3 documents uploaded",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7E74),
                          ),
                        ),
                        Text(
                          "${controller.vehicleDocsRemainingCount} remaining",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7E74),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Submit for Review Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : controller.submitAllDocumentsForReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF236830),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          disabledBackgroundColor:
                              const Color(0xFF236830).withValues(alpha: 0.6),
                        ),
                        child: controller.isSubmitting.value
                            ? SizedBox(
                                width: 22.h,
                                height: 22.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_upload_outlined,
                                    size: 18.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Submit for Review",
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
    );
  }

  // ========================================================
  // DOCUMENT CARD (With Required tag, upload circle, or uploaded)
  // ========================================================
  Widget _buildDocCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle1,
    String? subtitle2,
    String? warningTag,
    required String? filePath,
    required String? fileName,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    final isUploaded = filePath != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7F3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUploaded
              ? const Color(0xFF236830).withValues(alpha: 0.4)
              : const Color(0xFFD6E3D8),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon in light mint circle
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: isUploaded
                  ? const Color(0xFF236830).withValues(alpha: 0.12)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFFD6E3D8),
                width: 1.0,
              ),
            ),
            child: Icon(
              icon,
              color: isUploaded ? const Color(0xFF236830) : const Color(0xFF6B7E74),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Central details column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
                SizedBox(height: 3.h),

                // Red REQUIRED tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "REQUIRED",
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE53935),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),

                // Subtitle 1
                Text(
                  subtitle1,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7E74),
                  ),
                ),

                if (subtitle2 != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle2,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF7A8C80),
                    ),
                  ),
                ],

                if (warningTag != null) ...[
                  SizedBox(height: 3.h),
                  Text(
                    warningTag,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                ],

                // Uploaded filename indicator
                if (isUploaded) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: const Color(0xFF236830),
                        size: 13.sp,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          fileName ?? "file_uploaded.pdf",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF236830),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Right Action Button (Upload vs Delete)
          if (!isUploaded)
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 36.h,
                height: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3ED),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF236830).withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  Icons.file_upload_outlined,
                  color: const Color(0xFF236830),
                  size: 18.sp,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 32.h,
                height: 32.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: const Color(0xFFE53935),
                  size: 16.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ========================================================
  // POLICE CLEARANCE WARNING
  // ========================================================
  Widget _buildPoliceClearanceWarning() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFFFE082),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFFE65100),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  color: const Color(0xFF795548),
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: "Police Clearance: ",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                  const TextSpan(
                    text: "The certificate date must be within 90 days of today. Expired clearances will be rejected.",
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
  // GREEN REVIEW CARD (Once all 5 documents are submitted)
  // ========================================================
  Widget _buildGreenReviewCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3ED),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFD6E3D8),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.access_time_rounded,
                color: const Color(0xFF236830),
                size: 18.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Review within 24–48 hours",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Once all 5 documents are submitted, our compliance team will begin the review process.",
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF6B7E74),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: const Color(0xFF236830),
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "Your data is encrypted and stored securely",
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF236830),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
