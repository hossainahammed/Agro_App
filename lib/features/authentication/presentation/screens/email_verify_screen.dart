import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/custom_back_button.dart';
import 'package:project_structure/core/common/widgets/loader.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/core/utils/constants/enums.dart';
import 'package:project_structure/core/common/widgets/custom_button.dart';
import 'package:project_structure/core/common/widgets/custom_text.dart';
import 'package:project_structure/features/role_selection/screen/role_selection_screen.dart';
import '../../controllers/verify_controller.dart';
import 'reset_password_screen.dart';

class EmailVerifyScreen extends StatelessWidget {
  final String? email;
  final String? verifyType;

  EmailVerifyScreen({
    super.key,
    this.email,
    this.verifyType,
  });

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    final String resolvedEmail = email ?? (Get.arguments?['email'] as String? ?? 'example@mail.com');
    final String resolvedVerifyType = verifyType ?? (Get.arguments?['verifyType'] as String? ?? VerifyType.forget.name);

    // Ensure controller knows the email
    controller.email = resolvedEmail;

    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.containerSoft,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder, width: 1.w),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      textStyle: defaultPinTheme.textStyle?.copyWith(color: AppColors.white),
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary, width: 2.w),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dark Green Gradient Header
            Container(
              height: 260.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.verseGradient,
              ),
              child: Stack(
                children: [
                  // Decorative Ring 3 (Outer)
                  Center(
                    child: Container(
                      width: 140.h,
                      height: 140.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withAlpha(8),
                      ),
                    ),
                  ),
                  // Decorative Ring 2 (Middle)
                  Center(
                    child: Container(
                      width: 110.h,
                      height: 110.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withAlpha(15),
                      ),
                    ),
                  ),
                  // Central Circle Badge with Handset Icon
                  Center(
                    child: Container(
                      width: 76.h,
                      height: 76.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2E8A49),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.phone_outlined,
                        color: AppColors.white,
                        size: 32.sp,
                      ),
                    ),
                  ),
                  // Back Button (Top Left)
                  Positioned(
                    top: 50.h,
                    left: 20.w,
                    child: CustomBackButton(
                      color: AppColors.white.withAlpha(30),
                      iconColor: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Verify Your Email",
                    style: GoogleFonts.inter(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "We sent a 6-digit verification code to",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        resolvedEmail,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          "Change",
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // 6 Digit Pin Inputs
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: controller.otpTEController,
                      focusNode: controller.focusNode,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      onChanged: controller.updateOtpValue,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Countdown Timer & Resend Button
                  Obx(() {
                    if (controller.isResendClickable.value) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Didn't receive code? ",
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                          GestureDetector(
                            onTap: () => controller.resendOtp(email: resolvedEmail),
                            child: controller.isResentPasswordLoading.value
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : CustomText(
                                    text: "Resend",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                          ),
                        ],
                      );
                    } else {
                      return RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                          ),
                          children: [
                            const TextSpan(text: "Resend code in "),
                            TextSpan(
                              text: controller.countdownText,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                  SizedBox(height: 40.h),

                  // Verify Button with Loading
                  Obx(
                    () => controller.isLoading.value
                        ? const Loader()
                        : CustomButton(
                            text: 'Verify Email',
                            onTap: () {
                              // For development/mock testing flow, we do direct transition.
                              // If you want backend API verification, uncomment this:
                              /*
                              controller.verifyOtp(
                                otp: controller.otpTEController.text.trim(),
                                email: resolvedEmail,
                                verifyType: resolvedVerifyType,
                              );
                              */
                              
                            if (resolvedVerifyType == VerifyType.signup.name) {
                              Future.delayed(const Duration(milliseconds: 800), () {
                                Get.offAll(() => const RoleSelectionScreen());
                              });
                            } else if (resolvedVerifyType == VerifyType.forget.name) {
                                Get.off(() => ResetPasswordScreen(token: "testing token"));
                              }
                            },
                          ),
                  ),
                  SizedBox(height: 32.h),

                  // Footer Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "By verifying, you agree to receive email from AgroConnect.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.4,
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
}
