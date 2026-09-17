import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/custom_back_button.dart';
import 'package:project_structure/core/common/widgets/custom_button.dart';
import 'package:project_structure/core/common/widgets/custom_dropdown.dart';
import 'package:project_structure/core/common/widgets/custom_text.dart';
import 'package:project_structure/core/common/widgets/custom_text_box.dart';
import 'package:project_structure/core/common/widgets/custom_text_field.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/producer/presentation/controllers/product_add_controller.dart';

class ProductAddScreen extends StatelessWidget {
  const ProductAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductAddController controller = Get.put(ProductAddController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // 1. Forest Green Header
          _buildHeader(context),

          // 2. Scrollable Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Images Section Header
                  _buildImagesSectionHeader(controller),
                  SizedBox(height: 12.h),

                  // Horizontal Slots
                  _buildPhotoSlots(controller),
                  SizedBox(height: 16.h),

                  // Upload Product Photos Button
                  _buildUploadButton(controller),
                  SizedBox(height: 24.h),

                  // Form Fields
                  CustomTextBox(
                    title: "Product Name",
                    isRequired: true,
                    hintText: "e.g. Fresh Roma Tomatoes",
                    controller: controller.productNameController,
                  ),
                  SizedBox(height: 16.h),

                  // Category
                  _buildCategoryField(controller),
                  SizedBox(height: 16.h),

                  // Price and Unit
                  _buildPriceAndUnitFields(controller),
                  SizedBox(height: 16.h),

                  // Available Quantity
                  _buildQuantityField(controller),
                  SizedBox(height: 16.h),

                  // Description
                  CustomTextBox(
                    title: "Description(optional)",
                    hintText: "Describe your product — variety, freshness, how it was grown...",
                    controller: controller.descriptionController,
                    characterShow: true,
                    maxLength: 300,
                    maxLines: 4,
                  ),
                  SizedBox(height: 16.h),

                  // Certified switch card
                  _buildCertifiedCard(controller),
                  SizedBox(height: 32.h),

                  // Save Product Button & Message
                  _buildSaveSection(controller),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Row(
            children: [
              CustomBackButton(
                color: AppColors.white.withValues(alpha: 0.15),
                iconColor: AppColors.white,
                onTap: () => Get.back(),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PRODUCTS",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Add New Product",
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSectionHeader(ProductAddController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Product Images",
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: "Add up to 5 photos · First image is the cover",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        Obx(() {
          final count = controller.imagePaths.length;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100.h),
            ),
            child: CustomText(
              text: "$count/5",
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPhotoSlots(ProductAddController controller) {
    return Obx(() {
      final images = controller.imagePaths;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final hasImage = index < images.length;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: index == 0 || index == 4 ? 0 : 4.w),
              child: AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  onTap: () {
                    if (!hasImage) {
                      controller.pickImage();
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (hasImage)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.containerBorder),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.file(
                              File(images[index]),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        )
                      else
                        CustomPaint(
                          painter: DashedBorderPainter(
                            color: index == 0
                                ? AppColors.primary
                                : AppColors.containerBorder,
                            borderRadius: 16.r,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? AppColors.primary.withValues(alpha: 0.02)
                                  : AppColors.containerSoft,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              index == 0
                                  ? Icons.camera_alt_outlined
                                  : Icons.add_photo_alternate_outlined,
                              color: index == 0
                                  ? AppColors.primary
                                  : AppColors.hintColor,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      if (hasImage)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildUploadButton(ProductAddController controller) {
    return GestureDetector(
      onTap: controller.pickImage,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.primary.withValues(alpha: 0.5),
          borderRadius: 24.r,
        ),
        child: Container(
          height: 48.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(24.r),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: "Upload Product Photos",
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField(ProductAddController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Category",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: GoogleFonts.inter(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => CustomDropdownField(
              hintText: "Select a category",
              items: controller.categories,
              selectedValue: controller.selectedCategory.value,
              onChanged: (val) => controller.selectedCategory.value = val,
              fillColor: AppColors.containerSoft,
              borderRadius: 16,
              height: 52.h,
            )),
      ],
    );
  }

  Widget _buildPriceAndUnitFields(ProductAddController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price per Unit
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Price per Unit",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.inter(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: controller.priceController,
                hintText: "0.00",
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                radius: 16,
                containerColor: AppColors.containerSoft,
                borderColor: AppColors.containerBorder,
                prefixIconPath: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₦",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        // Unit Type
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Unit Type",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.inter(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() => CustomDropdownField(
                    hintText: "Select unit",
                    items: controller.units,
                    selectedValue: controller.selectedUnit.value,
                    onChanged: (val) => controller.selectedUnit.value = val,
                    fillColor: AppColors.containerSoft,
                    borderRadius: 16,
                    height: 52.h,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityField(ProductAddController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Available Quantity",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: GoogleFonts.inter(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: "How many units do you have?",
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: controller.quantityController,
          hintText: "e.g. 50",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          radius: 16,
          containerColor: AppColors.containerSoft,
          borderColor: AppColors.containerBorder,
        ),
      ],
    );
  }

  Widget _buildCertifiedCard(ProductAddController controller) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outlined,
              color: AppColors.success,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Mark as Certified Product",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "Certify this product meets AgroConnect quality & safety standards. Certified products get a badge and higher visibility.",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() => Switch(
                value: controller.isCertified.value,
                onChanged: (val) => controller.isCertified.value = val,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
              )),
        ],
      ),
    );
  }

  Widget _buildSaveSection(ProductAddController controller) {
    return Obx(() {
      final isValid = controller.isFormValid.value;
      return Column(
        children: [
          CustomButton(
            text: "Save Product",
            onTap: isValid ? controller.saveProduct : null,
            backgroundColor: isValid ? AppColors.primary : AppColors.containerSoft,
            textColor: isValid ? AppColors.white : AppColors.hintColor,
            borderRadius: BorderRadius.circular(16.r),
            height: 52.h,
          ),
          if (!isValid) ...[
            SizedBox(height: 12.h),
            Center(
              child: CustomText(
                text: "Fill in all required fields to continue",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      );
    });
  }
}

// Helper painter to draw dashed borders
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);

    final dashPath = _buildDashPath(path, dashLength, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashPath(Path source, double dashLength, double gap) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? dashLength : gap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
