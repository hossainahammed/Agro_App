import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/universal_image.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';

void showSignupConfirmationDialog({
  required String image,
  required String title,
  required String subTitle,
  required String butonText,
  required VoidCallback onTap,
}) {
  Get.dialog(
    AlertDialog(
      content: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 90.h,
              width: 90.h,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90.h,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 64.h,
                      height: 64.h,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 38.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Gap(20.h),
            CustomText(
              textAlign: TextAlign.center,
              text: title,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 18.sp,
            ),
            CustomText(
              textAlign: TextAlign.center,
              text: subTitle,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
            Gap(32.h),
            CustomButton(
              text: butonText,
              onTap: () {
                onTap();
              },
            ),
          ],
        ),
      ),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.white,
    ),
  );
}
