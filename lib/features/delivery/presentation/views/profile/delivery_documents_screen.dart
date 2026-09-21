import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class DeliveryDocumentsScreen extends StatelessWidget {
  const DeliveryDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ========================================================
          // TOP GREEN APP BAR
          // ========================================================
          Container(
            width: double.infinity,
            color: const Color(0xFF236830),
            padding: EdgeInsets.fromLTRB(16.w, topPadding + 10.h, 20.w, 16.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38.h,
                    height: 38.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "PROFILE",
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      "My Documents",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ========================================================
          // SCROLLABLE BODY
          // ========================================================
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====================================================
                  // PROGRESS LINE (Multi-segment: 3 Verified, 1 Pending, 1 Expired)
                  // ====================================================
                  Container(
                    width: double.infinity,
                    height: 4.5.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: const Color(0xFFE5EDE6),
                    ),
                    child: Row(
                      children: [
                        // 3 Verified (60%)
                        Expanded(
                          flex: 3,
                          child: Container(color: const Color(0xFF16A34A)),
                        ),
                        SizedBox(width: 2.w),
                        // 1 Pending (20%)
                        Expanded(
                          flex: 1,
                          child: Container(color: const Color(0xFFF59E0B)),
                        ),
                        SizedBox(width: 2.w),
                        // 1 Expired (20%)
                        Expanded(
                          flex: 1,
                          child: Container(color: const Color(0xFFEF4444)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Document Summary Indicators
                  Row(
                    children: [
                      _buildStatusIndicator(
                        color: const Color(0xFF16A34A),
                        label: "3 Verified",
                      ),
                      SizedBox(width: 16.w),
                      _buildStatusIndicator(
                        color: const Color(0xFFF59E0B),
                        label: "1 Pending",
                      ),
                      SizedBox(width: 16.w),
                      _buildStatusIndicator(
                        color: const Color(0xFFEF4444),
                        label: "1 Expired",
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // Action Required Alert Banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFFECDD3), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: const Color(0xFFDC2626),
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "Action required: ",
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF991B1B),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "Police Clearance has expired. Re-upload to continue receiving missions.",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF991B1B),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ====================================================
                  // DOCUMENT CARD 1: National ID Card
                  // ====================================================
                  _buildDocumentCard(
                    icon: Icons.credit_card_outlined,
                    iconBgColor: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF236830),
                    title: "National ID Card",
                    tag: "NIN",
                    statusLabel: "Verified",
                    statusBgColor: const Color(0xFFE8F5E9),
                    statusTextColor: const Color(0xFF16A34A),
                    expiryText: "Exp. 31 Dec 2028",
                    fileName: "national_id_emeka.jpg",
                    uploadDate: "Uploaded 12 Jan 2024",
                    refreshBgColor: const Color(0xFFE8F5E9),
                    refreshIconColor: const Color(0xFF236830),
                  ),

                  SizedBox(height: 12.h),

                  // ====================================================
                  // DOCUMENT CARD 2: Driving License
                  // ====================================================
                  _buildDocumentCard(
                    icon: Icons.local_shipping_outlined,
                    iconBgColor: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF236830),
                    title: "Driving License",
                    statusLabel: "Verified",
                    statusBgColor: const Color(0xFFE8F5E9),
                    statusTextColor: const Color(0xFF16A34A),
                    expiryText: "Exp. 14 Mar 2026",
                    fileName: "driving_license.pdf",
                    uploadDate: "Uploaded 12 Jan 2024",
                    refreshBgColor: const Color(0xFFE8F5E9),
                    refreshIconColor: const Color(0xFF236830),
                  ),

                  SizedBox(height: 12.h),

                  // ====================================================
                  // DOCUMENT CARD 3: Vehicle Registration
                  // ====================================================
                  _buildDocumentCard(
                    icon: Icons.description_outlined,
                    iconBgColor: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF236830),
                    title: "Vehicle Registration",
                    tag: "Carte Grise",
                    statusLabel: "Verified",
                    statusBgColor: const Color(0xFFE8F5E9),
                    statusTextColor: const Color(0xFF16A34A),
                    expiryText: "Exp. 30 Jun 2025",
                    fileName: "carte_grise_kn402abc.jpg",
                    uploadDate: "Uploaded 15 Jun 2024",
                    topActionIcon: Icons.settings_outlined,
                    refreshBgColor: const Color(0xFFE8F5E9),
                    refreshIconColor: const Color(0xFF236830),
                  ),

                  SizedBox(height: 12.h),

                  // ====================================================
                  // DOCUMENT CARD 4: Insurance Certificate (Pending)
                  // ====================================================
                  _buildDocumentCard(
                    icon: Icons.shield_outlined,
                    iconBgColor: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFD97706),
                    title: "Insurance Certificate",
                    statusLabel: "Pending",
                    statusBgColor: const Color(0xFFFEF3C7),
                    statusTextColor: const Color(0xFFB45309),
                    fileName: "insurance_cert_2024.pdf",
                    uploadDate: "Uploaded 20 Jun 2024",
                    refreshBgColor: const Color(0xFFFEF3C7),
                    refreshIconColor: const Color(0xFFD97706),
                    bottomNote: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: const Color(0xFFD97706),
                          size: 13.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Under review by our team",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "~24-48 hrs",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ====================================================
                  // DOCUMENT CARD 5: Police Clearance (Expired)
                  // ====================================================
                  _buildDocumentCard(
                    icon: Icons.local_police_outlined,
                    iconBgColor: const Color(0xFFFEE2E2),
                    iconColor: const Color(0xFFDC2626),
                    title: "Police Clearance",
                    statusLabel: "Expired",
                    statusBgColor: const Color(0xFFFEE2E2),
                    statusTextColor: const Color(0xFFDC2626),
                    expiryText: "Exp. 10 Jun 2024",
                    fileName: "police_clearance_mar24.jpg",
                    uploadDate: "Uploaded 10 Mar 2024",
                    refreshBgColor: const Color(0xFFFEE2E2),
                    refreshIconColor: const Color(0xFFDC2626),
                    bottomNote: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: const Color(0xFFDC2626),
                          size: 13.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Expired — must be within 3 months",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => AppSnackBar.info(
                            "Select new Police Clearance document to upload",
                            title: "Re-upload",
                          ),
                          child: Text(
                            "Re-upload now",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFDC2626),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ====================================================
                  // BOTTOM SECURITY NOTE
                  // ====================================================
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Icon(
                            Icons.verified_user_outlined,
                            color: const Color(0xFF16A34A),
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "All documents are ",
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                color: const Color(0xFF166534),
                                height: 1.35,
                              ),
                              children: [
                                TextSpan(
                                  text: "encrypted",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF166534),
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      " and stored securely. Only AgroConnect compliance staff can view them.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HELPER WIDGETS
  // ==========================================================
  Widget _buildStatusIndicator({
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    String? tag,
    required String statusLabel,
    required Color statusBgColor,
    required Color statusTextColor,
    String? expiryText,
    required String fileName,
    required String uploadDate,
    required Color refreshBgColor,
    required Color refreshIconColor,
    IconData topActionIcon = Icons.visibility_outlined,
    Widget? bottomNote,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5EDE6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading Icon Box
              Container(
                width: 38.h,
                height: 38.h,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),

              // Title and Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Optional Tag (e.g. NIN, Carte Grise)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ),
                        if (tag != null) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.inter(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Status Pill & Expiry Text
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            statusLabel,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: statusTextColor,
                            ),
                          ),
                        ),
                        if (expiryText != null) ...[
                          SizedBox(width: 6.w),
                          Text(
                            expiryText,
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // File Name & Upload Date
                    Text(
                      "$fileName · $uploadDate",
                      style: GoogleFonts.inter(
                        fontSize: 10.5.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons: View and Refresh/Sync Indicator
              Column(
                children: [
                  GestureDetector(
                    onTap: () => AppSnackBar.info("Viewing $fileName", title: "Document Preview"),
                    child: Container(
                      width: 28.h,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5EDE6), width: 0.8),
                      ),
                      child: Icon(
                        topActionIcon,
                        color: const Color(0xFF6B7280),
                        size: 15.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => AppSnackBar.info("Upload new version for $title", title: "Update Document"),
                    child: Container(
                      width: 28.h,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: refreshBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: refreshIconColor,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (bottomNote != null) ...[
            SizedBox(height: 8.h),
            const Divider(height: 1, thickness: 0.8, color: Color(0xFFF0F4F1)),
            SizedBox(height: 8.h),
            bottomNote,
          ],
        ],
      ),
    );
  }
}
