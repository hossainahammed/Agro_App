import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class ProducerTermsPrivacyScreen extends StatelessWidget {
  const ProducerTermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Privacy',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // White terms box
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermSection(
                          '1. Acceptance of Terms',
                          'By creating an account on AgroConnect, you agree to these Terms of Use and our Privacy Policy. If you do not agree, please do not use the platform.',
                        ),
                        _buildTermSection(
                          '2. Who Can Use AgroConnect',
                          'AgroConnect is open to producers, professional buyers, individual buyers, and delivery drivers who meet our registration and verification requirements.',
                        ),
                        _buildTermSection(
                          '3. Account & Verification',
                          '• Producers and drivers must provide valid identification and required documents (land proof, vehicle documents, etc.) for verification.\n• AgroConnect reserves the right to approve, suspend, or reject accounts that provide false or incomplete information.',
                        ),
                        _buildTermSection(
                          '4. Listings & Orders',
                          '• Producers are responsible for the accuracy of product information, pricing, and available stock.\n• Orders are confirmed once accepted by the producer and are subject to availability.\n• AgroConnect is not responsible for the quality of products beyond what is reasonably verifiable at the time of listing.',
                        ),
                        _buildTermSection(
                          '5. Payments & Commission',
                          '• AgroConnect charges a commission fee (currently 7%) on each completed transaction.\n• Payments are processed through approved payment partners (Mobile Money, card).\n• Earnings are credited to the producer\'s wallet after successful delivery confirmation.',
                        ),
                        _buildTermSection(
                          '6. Delivery',
                          '• Deliveries are carried out by independent drivers registered on the platform.\n• Optional transport insurance is available at checkout to cover loss or damage during delivery.',
                        ),
                        _buildTermSection(
                          '7. Cancellations & Disputes',
                          '• Orders may be cancelled before producer confirmation.\n• Disputes regarding quality, delivery, or payment can be raised through the in-app support and will be reviewed by our team.',
                        ),
                        _buildTermSection(
                          '8. Privacy & Data Use',
                          '• We collect personal information (name, phone number, location, payment details) necessary to operate the platform.\n• Your data is used only to facilitate orders, payments, deliveries, and platform improvements.\n• We do not sell your personal data to third parties.\n• Documents uploaded for verification (ID, certifications) are stored securely and used only for account validation purposes.',
                        ),
                        _buildTermSection(
                          '9. Changes to These Terms',
                          'AgroConnect may update these terms from time to time. Continued use of the app after changes means you accept the updated terms.',
                        ),
                        _buildTermSection(
                          '10. Contact',
                          'For questions about these terms or your data, contact: support@agroconnect.com',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Agreement Bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: const BoxDecoration(
              color: Color(0xFFEDF7EE), // soft green tint
              border: Border(
                top: BorderSide(color: Color(0xFFC6E8C7), width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: const Color(0xFF2D7A3A),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'I agree to Privacy Policy.',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D7A3A),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      toolbarHeight: 70.h,
      leadingWidth: 52.w,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.white.withAlpha(38),
            radius: 18.r,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PROFILE',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB5D9BB),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Terms & Privacy',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermSection(String title, String body, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
