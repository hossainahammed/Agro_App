import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/custom_back_button.dart';
import 'package:project_structure/core/common/widgets/custom_button.dart';
import 'package:project_structure/core/common/widgets/custom_text.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/core/utils/constants/icon_path.dart';
import 'package:project_structure/features/authentication/presentation/screens/login_screen.dart';
import '../controller/role_selection_controller.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoleSelectionController controller = Get.put(RoleSelectionController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              
              // Back Button
              const CustomBackButton(),
              
              SizedBox(height: 40.h),

              // Title and Subtitle
              Center(
                child: Column(
                  children: [
                    Text(
                      "Hey! Who are you?",
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Choose your profile",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Roles List
              Expanded(
                child: Obx(() {
                  final String currentRole = controller.selectedRole.value;

                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Producer Role Option
                      _buildRoleCard(
                        roleKey: 'producer',
                        iconPath: IconPath.producer,
                        title: 'Producer',
                        description: 'I sell my agricultural crops',
                        isSelected: currentRole == 'producer',
                        onTap: () => controller.selectRole('producer'),
                      ),
                      SizedBox(height: 16.h),

                      // Buyer Role Option
                      _buildRoleCard(
                        roleKey: 'buyer',
                        iconPath: IconPath.buyer,
                        title: 'Buyer',
                        description: 'Restaurant, hotel, supermarket...',
                        isSelected: currentRole == 'buyer',
                        onTap: () => controller.selectRole('buyer'),
                      ),
                      SizedBox(height: 16.h),

                      // Delivery Person Role Option
                      _buildRoleCard(
                        roleKey: 'delivery',
                        iconPath: IconPath.deliveryPerson,
                        title: 'Delivery person',
                        description: 'I deliver orders',
                        isSelected: currentRole == 'delivery',
                        onTap: () => controller.selectRole('delivery'),
                      ),
                    ],
                  );
                }),
              ),

              // Continue Button
              CustomButton(
                text: 'Continue',
                onTap: controller.handleContinue,
                backgroundColor: AppColors.primary,
              ),

              SizedBox(height: 24.h),

              // Footer (Already have an account? Log in)
              Center(
                child: GestureDetector(
                  onTap: () => Get.offAll(() => LoginScreen()),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(text: "Already an account? "),
                        TextSpan(
                          text: "Log in",
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String roleKey,
    required String iconPath,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.containerSoft,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.containerBorder,
            width: 1.5.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(51),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Left Icon in background circle/container
            Container(
              width: 48.h,
              height: 48.h,
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withAlpha(38)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 16.w),

            // Title & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: description,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: isSelected
                        ? AppColors.white.withAlpha(217)
                        : AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            // Radio Button indicator
            Container(
              width: 24.h,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.white : AppColors.borderColor,
                  width: 2.w,
                ),
                color: isSelected ? AppColors.white : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.h,
                        height: 10.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
