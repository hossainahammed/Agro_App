import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/custom_back_button.dart';
import 'package:project_structure/core/common/widgets/custom_text_box.dart';
import 'package:project_structure/core/common/widgets/loader.dart';
import 'package:project_structure/features/authentication/presentation/screens/verify_code_screen.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../../../core/utils/constants/enums.dart';
import '../../controllers/sing_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  // Decorative Circle Top Right
                  Positioned(
                    top: -40.h,
                    right: -40.w,
                    child: Container(
                      width: 200.h,
                      height: 200.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withAlpha(10),
                      ),
                    ),
                  ),
                  // Decorative Circle Bottom Left
                  Positioned(
                    bottom: -30.h,
                    left: -60.w,
                    child: Container(
                      width: 160.h,
                      height: 160.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withAlpha(10),
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
                  // Content: Pill, Title, Subtitle
                  Positioned(
                    left: 20.w,
                    bottom: 24.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Producer Account Pill
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.white.withAlpha(38)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8.h,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF5CD87A),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Producer Account",
                                style: GoogleFonts.inter(
                                  color: AppColors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Create Account",
                          style: GoogleFonts.inter(
                            color: AppColors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Join us today to start your journey.",
                          style: GoogleFonts.inter(
                            color: AppColors.white.withAlpha(178),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name Input
                    CustomTextBox(
                      controller: controller.firstNameTEController,
                      title: "First Name",
                      isRequired: true,
                      hintText: "Enter your first name",
                    ),
                    SizedBox(height: 20.h),

                    // Last Name Input
                    CustomTextBox(
                      controller: controller.lastNameTEController,
                      title: "Last Name",
                      isRequired: true,
                      hintText: "Enter your last name",
                    ),
                    SizedBox(height: 20.h),

                    // Email Address Input
                    CustomTextBox(
                      controller: controller.emailTEController,
                      title: "Email Address",
                      isRequired: true,
                      hintText: "your@email.com",
                      validator: (value) => AppValidator.validateEmail(value),
                    ),
                    SizedBox(height: 20.h),

                    // Password Input
                    Obx(
                      () => CustomTextBox(
                        title: "Password",
                        isRequired: true,
                        hintText: "Create Password",
                        controller: controller.passwordTEController,
                        obscureText: controller.isPasswordVisible.value,
                        suffixIcon: GestureDetector(
                          onTap: controller.togglePasswordVisibility,
                          child: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Confirm Password Input
                    Obx(
                      () => CustomTextBox(
                        title: "Confirm Password",
                        isRequired: true,
                        hintText: "Confirm Password",
                        controller: controller.confirmPasswordTEController,
                        obscureText: controller.isConfirmPasswordVisible.value,
                        suffixIcon: GestureDetector(
                          onTap: controller.toggleComPasswordVisibility,
                          child: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Continue Button
                    Obx(
                      () => controller.isLoading.value
                          ? const Loader()
                          : CustomButton(
                              text: 'Continue',
                              onTap: () {
                                // if (_formKey.currentState!.validate()) {
                                //   controller.signUp(
                                //     email: controller.emailTEController.text.trim(),
                                //     verifyType: VerifyType.signup.name,
                                //   );
                                // }
                                Get.to(() => VerifyCodeScreen(
                                      email: controller.emailTEController.text.trim().isNotEmpty
                                          ? controller.emailTEController.text.trim()
                                          : "example@mailto.plus",
                                      verifyType: VerifyType.signup.name,
                                    ));
                              },
                            ),
                    ),
                    SizedBox(height: 32.h),

                    // Already have an account? Log in
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Already have an account? ",
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: CustomText(
                            text: 'Log in',
                            color: AppColors.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
