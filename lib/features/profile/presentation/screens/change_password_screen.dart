import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/custom_back_button.dart';
import 'package:project_structure/core/common/widgets/custom_text_box.dart';
import 'package:project_structure/core/common/widgets/loader.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Solid Green Profile Header
            Container(
              height: 140.h,
              width: double.infinity,
              color: AppColors.primary,
              padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomBackButton(
                    color: AppColors.white.withAlpha(30),
                    iconColor: AppColors.white,
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PROFILE",
                        style: GoogleFonts.inter(
                          color: AppColors.white.withAlpha(178),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        "Change Password",
                        style: GoogleFonts.inter(
                          color: AppColors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                  children: [
                    // Card Container for fields
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // New Password
                          Obx(
                            () => CustomTextBox(
                              title: 'New Password',
                              controller: controller.newPasswordController,
                              hintText: 'Type new password',
                              obscureText: !controller.isNewPasswordVisible.value,
                              suffixIcon: GestureDetector(
                                onTap: controller.toggleNewPasswordVisibility,
                                child: Icon(
                                  controller.isNewPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              validator: AppValidator.validatePassword,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Confirm Password
                          Obx(
                            () => CustomTextBox(
                              title: 'Confirm Password',
                              controller: controller.confirmPasswordController,
                              hintText: 'Type confirm password',
                              obscureText: !controller.isConfirmPasswordVisible.value,
                              suffixIcon: GestureDetector(
                                onTap: controller.toggleConfirmPasswordVisibility,
                                child: Icon(
                                  controller.isConfirmPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please re-type password';
                                }
                                if (value != controller.newPasswordController.text.trim()) {
                                  return 'Passwords do not match.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Save Changes Button
                    Obx(
                      () => controller.isChangePasswordLoading.value
                          ? const Loader()
                          : CustomButton(
                              text: 'Save Changes',
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.changePassword();
                                }
                              },
                            ),
                    ),
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
