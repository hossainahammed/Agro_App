import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/loader.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String? token;
  const ResetPasswordScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(
      ResetPasswordController(),
    );

    return Scaffold(
      backgroundColor: const Color(
        0xFFF7FAF7,
      ), // Soft greenish-light background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.h),
        child: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leadingWidth: 56.w,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Center(
              child: Container(
                width: 38.h,
                height: 38.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                ),
              ),
            ),
          ),
          titleSpacing: 10.w,
          title: Text(
            "Change Password",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Password Card Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE5ECE8),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // New Password Label
                    Text(
                      "New Password",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // New Password Input Field
                    Obx(
                      () => Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFE5ECE8),
                            width: 1.0,
                          ),
                        ),
                        child: TextField(
                          controller: controller.passwordTEController,
                          obscureText: controller.isPasswordVisible.value,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: "Type new password",
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                                size: 20,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                              splashRadius: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // Confirm Password Label
                    Text(
                      "Confirm Password",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Confirm Password Input Field
                    Obx(
                      () => Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFE5ECE8),
                            width: 1.0,
                          ),
                        ),
                        child: TextField(
                          controller: controller.confirmPasswordTEController,
                          obscureText: controller.isComPasswordVisible.value,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: "Type confirm password",
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isComPasswordVisible.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                                size: 20,
                              ),
                              onPressed: controller.toggleComPasswordVisibility,
                              splashRadius: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              // 2. Save Changes Button
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: Loader())
                    : Container(
                        width: double.infinity,
                        height: 54.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.28),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => controller.submitChanges(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            "Save Changes",
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
