import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/delivery_verification_controller.dart';

class DeliveryIdentityVerifyScreen extends StatelessWidget {
  const DeliveryIdentityVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryVerificationController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SafeArea(
        child: Column(
          children: [
            // ========================================================
            // TOP BAR & PROGRESS (Step 1 out of 2)
            // ========================================================
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button & Quick Demo Autofill button
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
                      // Demo quick-fill pill
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
                        "Step 1 out of 2",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E2D24),
                        ),
                      ),
                      Text(
                        "50%",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Progress Bar (50% filled)
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6E3D8),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Container(
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF236830),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ========================================================
            // SCROLLABLE DOCUMENT UPLOAD CONTENT
            // ========================================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      "Verify Your Identity",
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
                      "Upload clear photos of your documents. Make sure all details are visible and legible.",
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
                    // SECTION 1: National Identity Card (CNI) *
                    // ----------------------------------------------------
                    _buildSectionHeader(
                      title: "National Identity Card (CNI)",
                      isRequired: true,
                    ),
                    SizedBox(height: 10.h),

                    // Front side
                    Obx(
                      () => _buildUploadBox(
                        context: context,
                        label: "Tap to upload the front side",
                        filePath: controller.nationalIdFront.value,
                        fileName: controller.nationalIdFrontName.value,
                        onTap: () => controller.pickDocument(
                          context: context,
                          onSelected: (path, name) {
                            controller.nationalIdFront.value = path;
                            controller.nationalIdFrontName.value = name;
                          },
                        ),
                        onDelete: () {
                          controller.nationalIdFront.value = null;
                          controller.nationalIdFrontName.value = null;
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Back side
                    Obx(
                      () => _buildUploadBox(
                        context: context,
                        label: "Tap to upload the backside.",
                        filePath: controller.nationalIdBack.value,
                        fileName: controller.nationalIdBackName.value,
                        onTap: () => controller.pickDocument(
                          context: context,
                          onSelected: (path, name) {
                            controller.nationalIdBack.value = path;
                            controller.nationalIdBackName.value = name;
                          },
                        ),
                        onDelete: () {
                          controller.nationalIdBack.value = null;
                          controller.nationalIdBackName.value = null;
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ----------------------------------------------------
                    // SECTION 2: Driving License *
                    // ----------------------------------------------------
                    _buildSectionHeader(
                      title: "Driving License",
                      isRequired: true,
                    ),
                    SizedBox(height: 10.h),

                    // Front side
                    Obx(
                      () => _buildUploadBox(
                        context: context,
                        label: "Tap to upload the front side",
                        filePath: controller.licenseFront.value,
                        fileName: controller.licenseFrontName.value,
                        onTap: () => controller.pickDocument(
                          context: context,
                          onSelected: (path, name) {
                            controller.licenseFront.value = path;
                            controller.licenseFrontName.value = name;
                          },
                        ),
                        onDelete: () {
                          controller.licenseFront.value = null;
                          controller.licenseFrontName.value = null;
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Back side
                    Obx(
                      () => _buildUploadBox(
                        context: context,
                        label: "Tap to upload the backside.",
                        filePath: controller.licenseBack.value,
                        fileName: controller.licenseBackName.value,
                        onTap: () => controller.pickDocument(
                          context: context,
                          onSelected: (path, name) {
                            controller.licenseBack.value = path;
                            controller.licenseBackName.value = name;
                          },
                        ),
                        onDelete: () {
                          controller.licenseBack.value = null;
                          controller.licenseBackName.value = null;
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ----------------------------------------------------
                    // INFO CALLOUTS
                    // ----------------------------------------------------
                    // Green Card: Review within 24-48 hours & Data encrypted
                    _buildGreenInfoCard(),
                    SizedBox(height: 12.h),

                    // Amber Card: Tips for fast approval
                    _buildAmberTipCard(),
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
                  // Documents count row
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${controller.identityUploadedCount} of 2 documents uploaded",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7E74),
                          ),
                        ),
                        Text(
                          "${controller.identityRemainingCount} remaining",
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

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: controller.proceedToVehicleDocs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF236830),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      child: Text(
                        "Next — Vehicle Documents",
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
  // SECTION HEADER WITH REQUIRED BADGE
  // ========================================================
  Widget _buildSectionHeader({
    required String title,
    bool isRequired = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: " *",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE53935),
                  ),
                ),
            ],
          ),
        ),
        if (isRequired)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              "REQUIRED",
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE53935),
                letterSpacing: 0.4,
              ),
            ),
          ),
      ],
    );
  }

  // ========================================================
  // UPLOAD BOX (Empty vs Uploaded States)
  // ========================================================
  Widget _buildUploadBox({
    required BuildContext context,
    required String label,
    required String? filePath,
    required String? fileName,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    final isUploaded = filePath != null;

    if (!isUploaded) {
      // 1. UNUPLOADED EMPTY STATE
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7F3),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFD6E3D8),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.file_upload_outlined,
                color: const Color(0xFF7D8F83),
                size: 24.sp,
              ),
              SizedBox(height: 6.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E2D24),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "PDF, JPG, PNG — max 10MB",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7A8C80),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 2. UPLOADED STATE (Matching Screen 2 in user's mockup)
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F7F3),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF236830).withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Document Image Thumbnail with border
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 52.h,
                height: 52.h,
                color: const Color(0xFF236830).withValues(alpha: 0.12),
                child: Icon(
                  Icons.badge_outlined,
                  color: const Color(0xFF236830),
                  size: 26.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Metadata Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Uploaded chip
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: const Color(0xFF236830),
                        size: 13.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Uploaded",
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  Text(
                    label.contains("front") ? "National ID Card (Front)" : "National ID Card (Back)",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Text(
                    fileName ?? "document_file.jpg",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF7A8C80),
                    ),
                  ),
                ],
              ),
            ),

            // Action Icons on right (delete ✕ & re-upload)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 28.h,
                    height: 28.h,
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
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 28.h,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3ED),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.upload_rounded,
                      color: const Color(0xFF236830),
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // ========================================================
  // GREEN INFO CARD (Review within 24-48 hours)
  // ========================================================
  Widget _buildGreenInfoCard() {
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
                      "Your documents are reviewed by our team. You'll receive a notification once approved.",
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

  // ========================================================
  // AMBER TIP CARD (Tips for fast approval)
  // ========================================================
  Widget _buildAmberTipCard() {
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
                    text: "Tips for a fast approval: ",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                  const TextSpan(
                    text: "Ensure good lighting, no glare, and that all 4 corners of the document are visible.",
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
