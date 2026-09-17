import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/producer_settings_controller.dart';

class ProducerChangePasswordScreen extends StatelessWidget {
  const ProducerChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the active settings controller
    final controller = Get.find<ProducerSettingsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            // 1. Password Form Card Container
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
                  // Old Password Field
                  _buildPasswordField(
                    label: 'Old Password',
                    hintText: 'Type old password',
                    textController: controller.oldPasswordController,
                  ),
                  SizedBox(height: 18.h),

                  // New Password Field
                  _buildPasswordField(
                    label: 'New Password',
                    hintText: 'Type new password',
                    textController: controller.newPasswordController,
                  ),
                  SizedBox(height: 18.h),

                  // Confirm Password Field
                  _buildPasswordField(
                    label: 'Confirm Password',
                    hintText: 'Type confirm password',
                    textController: controller.confirmPasswordController,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // 2. Save Changes Action Button
            ElevatedButton(
              onPressed: () => controller.changePassword(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7A3A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text(
                'Save Changes',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
            'Change Password',
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

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController textController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        // Text Input Field
        Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBF9), // extremely soft greenish-white bg
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5ECE8), width: 1.0),
          ),
          child: TextField(
            controller: textController,
            obscureText: true,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                color: AppColors.textSecondary.withAlpha(120),
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
