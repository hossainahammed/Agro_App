import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/custom_back_button.dart';
import 'package:project_structure/core/common/widgets/custom_button.dart';
import 'package:project_structure/core/common/widgets/custom_text_box.dart';
import 'package:project_structure/core/common/widgets/custom_text.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/authentication/presentation/screens/login_screen.dart';
import '../../controllers/producer_account_controller.dart';

class ProducerAccountCreationScreen extends StatelessWidget {
  const ProducerAccountCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProducerAccountController controller = Get.put(ProducerAccountController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          final int step = controller.currentStep.value;
          
          // Calculate dynamic percentage label
          String percentage = "33%";
          if (step == 2) {
            percentage = "66%";
          } else if (step == 3) {
            percentage = "100%";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              
              // Custom Header: Back button, Step text, and progress bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(
                      onTap: () => controller.previousStep(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Step $step out of 3",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          percentage,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // Segmented Progress Bar (3 steps)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: List.generate(3, (index) {
                    final isCompletedOrActive = index < step;
                    return Expanded(
                      child: Container(
                        height: 6.h,
                        margin: EdgeInsets.only(right: index == 2 ? 0 : 8.w),
                        decoration: BoxDecoration(
                          color: isCompletedOrActive
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 24.h),

              // Step Title & Description Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildStepHeader(step, controller),
              ),

              SizedBox(height: 24.h),

              // Dynamic Body View
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildStepBody(step, controller),
                ),
              ),

              SizedBox(height: 16.h),

              // Step Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildStepActions(step, controller),
              ),

              SizedBox(height: 16.h),

              // Footer Login Link
              Center(
                child: GestureDetector(
                  onTap: () => Get.offAll(() => LoginScreen()),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
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
          );
        }),
      ),
    );
  }

  Widget _buildStepHeader(int step, ProducerAccountController controller) {
    String title = "";
    String subtitle = "";

    switch (step) {
      case 1:
        title = "Your Information";
        subtitle = "Personal contact information";
        break;
      case 2:
        title = "Your activity";
        subtitle = "Information about your activity";
        break;
      case 3:
        final farmName = controller.farmNameController.text.trim();
        title = "Your ${farmName.isNotEmpty ? farmName : 'Farm/Holding'}";
        subtitle = "Information about your ${farmName.isNotEmpty ? farmName : 'Farm/Holding'}";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomText(
            text: title,
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 6.h),
        Center(
          child: CustomText(
            text: subtitle,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildStepBody(int step, ProducerAccountController controller) {
    switch (step) {
      case 1:
        return _buildStep1(controller);
      case 2:
        return _buildStep2(controller);
      case 3:
        return _buildStep3(controller);
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Your Information
  Widget _buildStep1(ProducerAccountController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextBox(
          title: "Phone Number",
          isRequired: true,
          hintText: "Enter your phone number",
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),
        
        // Editable Dropdown for City
        CustomTextBox(
          title: "City",
          isRequired: true,
          hintText: "Select or type your city",
          controller: controller.cityController,
          suffixIcon: PopupMenuButton<String>(
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            onSelected: (val) {
              controller.cityController.text = val;
            },
            itemBuilder: (context) {
              return const ["Abidjan", "Bouaké", "Daloa", "Yamoussoukro", "San-Pédro", "Korhogo"].map((city) {
                return PopupMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList();
            },
          ),
        ),
        SizedBox(height: 16.h),

        // Editable Dropdown for Region
        CustomTextBox(
          title: "Region",
          isRequired: true,
          hintText: "Select or type your region",
          controller: controller.regionController,
          suffixIcon: PopupMenuButton<String>(
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            onSelected: (val) {
              controller.regionController.text = val;
            },
            itemBuilder: (context) {
              return const ["Lagunes", "Gôh-Djiboua", "Bas-Sassandra", "Sassandra-Marahoué", "Savanes", "Poro"].map((region) {
                return PopupMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList();
            },
          ),
        ),
        SizedBox(height: 16.h),

        CustomTextBox(
          title: "Full address",
          isRequired: true,
          hintText: "Type your full address",
          controller: controller.addressController,
        ),
      ],
    );
  }

  // Step 2: Your activity (Dynamically switches Private vs Company fields)
  Widget _buildStep2(ProducerAccountController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Type Toggle Option
        _buildAccountTypeToggle(controller),
        SizedBox(height: 16.h),
        
        Obx(() {
          final isCompany = controller.accountType.value == 'Company';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextBox(
                title: "Name of the farm / holding",
                isRequired: true,
                hintText: "Konan & Fils Farm",
                controller: controller.farmNameController,
              ),
              
              if (isCompany) ...[
                SizedBox(height: 16.h),
                CustomTextBox(
                  title: "Company Name",
                  isRequired: true,
                  hintText: "Agro Konan SARL",
                  controller: controller.companyNameController,
                ),
                SizedBox(height: 16.h),
                CustomTextBox(
                  title: "RCCM No.",
                  isRequired: true,
                  hintText: "CI-ABJ-2024",
                  controller: controller.rccmController,
                ),
                SizedBox(height: 16.h),
                CustomTextBox(
                  title: "SIREN number (auto-entrepreneur)",
                  isRequired: true,
                  hintText: "123456789",
                  controller: controller.sirenController,
                ),
              ],

              SizedBox(height: 16.h),
              CustomTextBox(
                title: "Agricultural area (hectares)",
                isRequired: !isCompany, // Required for private, optional for company in step 3 mock, but let's make it standard
                hintText: "5",
                controller: controller.agriculturalAreaController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              CustomTextBox(
                title: "Location of the farm",
                isRequired: true,
                hintText: "Village, commune, Sub-prefecture...",
                controller: controller.farmLocationController,
              ),
            ],
          );
        }),
      ],
    );
  }

  // Step 3: Your Documents
  Widget _buildStep3(ProducerAccountController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CNI Upload Zone
        _buildUploadZone(
          label: "National Identity Card (CNI)",
          isRequired: true,
          fileName: controller.cniFileName.value,
          onTap: () => controller.pickDocument('cni'),
          onRemove: () => controller.removeDocument('cni'),
        ),
        SizedBox(height: 16.h),

        // Land Proof Upload Zone
        _buildUploadZone(
          label: "Land proof (land certificate, rural lease or development certificate)",
          isRequired: true,
          fileName: controller.landProofFileName.value,
          onTap: () => controller.pickDocument('land'),
          onRemove: () => controller.removeDocument('land'),
        ),
        SizedBox(height: 16.h),

        // Optional Farm Photo Upload Zone
        _buildUploadZone(
          label: "Photo of the farm / field (optional)",
          isRequired: false,
          fileName: controller.farmPhotoFileName.value,
          onTap: () => controller.pickDocument('photo'),
          onRemove: () => controller.removeDocument('photo'),
        ),
        SizedBox(height: 24.h),

        // Read-only summaries of farm data (to match mockup)
        CustomTextBox(
          title: "Agricultural area (hectares)",
          hintText: "Area",
          controller: controller.agriculturalAreaController,
          readOnly: true,
        ),
        SizedBox(height: 16.h),
        CustomTextBox(
          title: "Location of the farm",
          isRequired: true,
          hintText: "Location",
          controller: controller.farmLocationController,
          readOnly: true,
        ),
        SizedBox(height: 20.h),

        // Confidentiality Notice
        Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: AppColors.containerSoft,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: "Confidentiality: ",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const TextSpan(
                  text: "Your documents are stored securely and used only for the verification of your identity by the AgroConnect team.",
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildAccountTypeToggle(ProducerAccountController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Account Type",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildAccountTypeButton(
                label: "Private",
                icon: Icons.person_outline,
                isActive: controller.accountType.value == 'Private',
                onTap: () => controller.setAccountType('Private'),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildAccountTypeButton(
                label: "Company",
                icon: Icons.business_outlined,
                isActive: controller.accountType.value == 'Company',
                onTap: () => controller.setAccountType('Company'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountTypeButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withAlpha(13) : AppColors.containerSoft,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.containerBorder,
            width: 1.5.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadZone({
    required String label,
    required String fileName,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(text: label),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: fileName.isEmpty ? onTap : null,
          child: CustomPaint(
            painter: DashedBorderPainter(
              color: fileName.isEmpty ? AppColors.borderColor : AppColors.primary,
              borderRadius: 12.r,
              strokeWidth: 1.5.w,
              dashWidth: 6.w,
              dashGap: 4.w,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: fileName.isEmpty ? AppColors.containerSoft : AppColors.primary.withAlpha(13),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: fileName.isEmpty
                  ? Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 32.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Tap to upload',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'PDF, JPG, PNG — max 10MB',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          color: AppColors.primary,
                          size: 28.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            fileName,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.error),
                          onPressed: onRemove,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepActions(int step, ProducerAccountController controller) {
    if (step == 1) {
      return CustomButton(
        text: 'Continue',
        onTap: () => controller.nextStep(),
        backgroundColor: AppColors.primary,
      );
    }

    final isLastStep = (step == 3);

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Back',
            onTap: () => controller.previousStep(),
            isOutline: true,
            borderColor: AppColors.primary,
            textColor: AppColors.primary,
            backgroundColor: AppColors.backgroundColor, // Matches page background perfectly
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CustomButton(
            text: isLastStep ? 'Create my account' : 'Continue',
            onTap: () => controller.nextStep(),
            backgroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// Custom Dashed Border Painter
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = Path();

    double distance = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final double len = dashWidth;
        if (distance + len > metric.length) {
          dashedPath.addPath(
            metric.extractPath(distance, metric.length),
            Offset.zero,
          );
        } else {
          dashedPath.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len + dashGap;
      }
      distance = 0.0;
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.borderRadius != borderRadius;
  }
}
