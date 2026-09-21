import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class DeliveryTermsPrivacyScreen extends StatefulWidget {
  const DeliveryTermsPrivacyScreen({super.key});

  @override
  State<DeliveryTermsPrivacyScreen> createState() => _DeliveryTermsPrivacyScreenState();
}

class _DeliveryTermsPrivacyScreenState extends State<DeliveryTermsPrivacyScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Privacy',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // White terms box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE5EDE6), width: 1),
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
                        _buildContactSection(
                          '10. Contact',
                          'For questions about these terms or your data, contact: ',
                          'support@agroconnect.com',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Bottom Agreement Bar (Interactive, Default Unchecked, Left Aligned)
          InkWell(
            onTap: () {
              setState(() {
                _isAgreed = !_isAgreed;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: const BoxDecoration(
                color: Color(0xFFEDF7EE), // soft green tint
                border: Border(
                  top: BorderSide(color: Color(0xFFC6E8C7), width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: _isAgreed ? const Color(0xFF236830) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isAgreed ? const Color(0xFF236830) : const Color(0xFF9CA3AF),
                          width: 1.8,
                        ),
                      ),
                      child: _isAgreed
                          ? Icon(
                              Icons.check,
                              size: 13.sp,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'I agree to Privacy Policy.',
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: _isAgreed ? const Color(0xFF236830) : const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
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
      centerTitle: false,
      toolbarHeight: 70.h,
      leadingWidth: 54.w,
      titleSpacing: 8.w,
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

  Widget _buildTermSection(String title, String body) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              color: const Color(0xFF4B5563),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(String title, String prefix, String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 6.h),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              color: const Color(0xFF4B5563),
              height: 1.45,
            ),
            children: [
              TextSpan(text: prefix),
              TextSpan(
                text: email,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1E5B2B),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
