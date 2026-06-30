import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/custom_back_button.dart';
import 'package:project_structure/core/common/widgets/custom_text_box.dart';
import 'package:project_structure/core/common/widgets/loader.dart';
import 'package:project_structure/features/authentication/presentation/screens/sing_up_screen.dart';
import 'package:project_structure/features/producer/presentation/views/producer_main_screen.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../controllers/login_controller.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

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
                          "Welcome back!",
                          style: GoogleFonts.inter(
                            color: AppColors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Log in to access your vault.",
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

            // Body
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    CustomTextBox(
                      controller: controller.emailController,
                      title: "Email",
                      isRequired: true,
                      subtitle: "Used for order updates and OTP verification",
                      hintText: "Enter your email",
                      validator: (value) => AppValidator.validateEmail(value),
                    ),
                    SizedBox(height: 24.h),

                    // Password
                    Obx(
                      () => CustomTextBox(
                        title: "Password",
                        isRequired: true,
                        hintText: "At least 8 characters",
                        controller: controller.passwordText,
                        obscureText: controller.isPasswordHidden.value,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                        suffixIcon: GestureDetector(
                          onTap: () => controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value,
                          child: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.to(() => ForgotPasswordScreen()),
                        child: CustomText(
                          text: 'Forgot password?',
                          color: AppColors.error,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Log In Button
                    Obx(
                      () => controller.isLoading.value
                          ? const Loader()
                          : CustomButton(
                              text: "Log in",
                              onTap: () {
                                // if (_formKey.currentState!.validate()) {
                                //   controller.signIn();
                                // }
                                Get.to(() => const ProducerMainScreen());
                              },
                            ),
                    ),
                    SizedBox(height: 32.h),

                    // Don't have account? Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Don’t have an account? ",
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: CustomText(
                            text: 'Sign Up',
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
