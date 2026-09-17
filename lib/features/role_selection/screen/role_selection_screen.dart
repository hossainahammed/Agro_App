import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/core/utils/constants/image_path.dart';
import 'package:project_structure/features/authentication/presentation/screens/login_screen.dart';
import '../controller/role_selection_controller.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoleSelectionController controller = Get.put(RoleSelectionController());

    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F0), // Soft mint-green background from mockup
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // Top Back Button (Circular white container with drop shadow)
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 44.h,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              // Thin horizontal accent divider under top bar
              Divider(
                color: Colors.white.withValues(alpha: 0.9),
                thickness: 1.5,
                height: 1.5,
              ),

              SizedBox(height: 40.h),

              // Title and Subtitle
              Center(
                child: Column(
                  children: [
                    Text(
                      "Hey! Who are you?",
                      style: GoogleFonts.inter(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Choose your profile",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7E74),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 36.h),

              // Roles List
              Obx(() {
                final String currentRole = controller.selectedRole.value;

                return Column(
                  children: [
                    // 1. Producer Role Option
                    _buildRoleCard(
                      imagePath: ImagePath.producerRole,
                      title: 'Producer',
                      description: 'I sell my agricultural crops',
                      isSelected: currentRole == 'producer',
                      onTap: () => controller.selectRole('producer'),
                    ),
                    SizedBox(height: 16.h),

                    // 2. Buyer Role Option
                    _buildRoleCard(
                      imagePath: ImagePath.buyerRole,
                      title: 'Buyer',
                      description: 'Restaurant, hotel, supermarket...',
                      isSelected: currentRole == 'buyer',
                      onTap: () => controller.selectRole('buyer'),
                    ),
                    SizedBox(height: 16.h),

                    // 3. Delivery Person Role Option
                    _buildRoleCard(
                      imagePath: ImagePath.deliveryRole,
                      title: 'Delivery person',
                      description: 'I deliver orders',
                      isSelected: currentRole == 'delivery',
                      onTap: () => controller.selectRole('delivery'),
                    ),
                  ],
                );
              }),

              SizedBox(height: 36.h),

              // Continue Button (Pill shaped forest green button)
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: controller.handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF236830), // Forest green matching mockup
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Footer: Already have an account? Log in
              Center(
                child: GestureDetector(
                  onTap: () => Get.offAll(() => LoginScreen()),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: const Color(0xFF6B7E74),
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(text: "Already an account? "),
                        TextSpan(
                          text: "Log in",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF236830),
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String imagePath,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF236830) : Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF236830) : const Color(0xFFE4EDE6),
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF236830).withValues(alpha: 0.22),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Left Illustration Asset directly placed without background box
            Image.asset(
              imagePath,
              width: 48.h,
              height: 48.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 14.w),

            // Title & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.88)
                          : const Color(0xFF6B7E74),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Radio Button Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22.h,
              height: 22.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                border: isSelected
                    ? null
                    : Border.all(
                        color: const Color(0xFFDEE9E0),
                        width: 1.8.w,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
