import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/buyer_phone_verify_controller.dart';

class BuyerPhoneVerifyScreen extends StatelessWidget {
  final String? phoneNumber;
  final String? countryCode;

  const BuyerPhoneVerifyScreen({
    super.key,
    this.phoneNumber,
    this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    final String resolvedPhone = phoneNumber ??
        (Get.arguments?['phone'] as String? ?? '8000000000');
    final String resolvedCountryCode = countryCode ??
        (Get.arguments?['countryCode'] as String? ?? '+234');

    final controller = Get.put(
      BuyerPhoneVerifyController(
        rawPhoneNumber: resolvedPhone,
        countryCode: resolvedCountryCode,
      ),
    );

    final defaultPinTheme = PinTheme(
      width: 46.w,
      height: 52.h,
      textStyle: GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E2D24),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFD6E3D8),
          width: 1.2,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(
          color: const Color(0xFF236830),
          width: 1.6,
        ),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      textStyle: GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color(0xFF236830),
        border: Border.all(
          color: const Color(0xFF236830),
          width: 1.2,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF173E20),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildTopHeader(context),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 230.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF4EE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 36.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Verify Your Phone Number",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E2D24),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "We sent a 6-digit verification code to",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A8C80),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.maskedPhoneNumber,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E2D24),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Text(
                            "Change",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF236830),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: controller.otpController,
                        focusNode: controller.focusNode,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        separatorBuilder: (index) => SizedBox(width: 8.w),
                        onChanged: controller.onOtpChanged,
                        onCompleted: (pin) {
                          controller.verifyPhone();
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: const Color(0xFF7A8C80),
                          ),
                        ),
                        Obx(() {
                          if (controller.isResendClickable.value) {
                            return GestureDetector(
                              onTap: controller.resendCode,
                              child: Text(
                                "Resend Code",
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF236830),
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              "Resend in ${controller.countdownText}",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF236830),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.verifyPhone,
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
                          child: controller.isLoading.value
                              ? SizedBox(
                                  width: 22.h,
                                  height: 22.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Verify Phone Number",
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "By verifying, you agree to receive SMS messages from AgroConnect. Standard rates may apply.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7A8C80),
                          height: 1.45,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    GestureDetector(
                      onTap: controller.applyDemoCode,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E5B2C),
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
                            Container(
                              width: 8.h,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Tap to fill demo OTP (${BuyerPhoneVerifyController.demoOtp})",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4926), Color(0xFF133B1D)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40.w,
            top: -30.h,
            child: Container(
              width: 170.h,
              height: 170.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 40.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7.h,
                        height: 7.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        "Buyer Account",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Phone Verification",
                  style: GoogleFonts.inter(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "One last step to start buying fresh produce directly",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
