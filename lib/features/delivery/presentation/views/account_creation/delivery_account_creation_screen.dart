import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/authentication/presentation/screens/login_screen.dart';
import 'package:project_structure/features/producer/presentation/views/profile/producer_terms_privacy_screen.dart';
import '../../controllers/delivery_account_controller.dart';

class DeliveryAccountCreationScreen extends StatelessWidget {
  const DeliveryAccountCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryAccountController());

    return Scaffold(
      backgroundColor: const Color(0xFF173E20), // Dark forest green top
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========================================================
              // 1. TOP HEADER (Forest green curved backdrop)
              // ========================================================
              _buildTopHeader(context),

              // ========================================================
              // 2. FORM CARD CONTAINER
              // ========================================================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFEDF4EE,
                  ), // Signature soft sage-mint background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26.r),
                    topRight: Radius.circular(26.r),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECTION 1: PERSONAL INFORMATION ---
                    _buildSectionHeader("PERSONAL INFORMATION"),
                    SizedBox(height: 16.h),

                    // Full Name *
                    _buildFieldLabel("Full Name", isRequired: true),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: controller.fullNameController,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF1E2D24),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: _fieldDecoration(
                        hintText: "e.g. Ngozi Adaeze",
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: const Color(0xFF7D8F83),
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Phone Number *
                    _buildFieldLabel(
                      "Phone Number",
                      isRequired: true,
                      subtitle: "Used for order updates and OTP verification",
                    ),
                    SizedBox(height: 8.h),
                    _buildPhoneInput(context, controller),
                    SizedBox(height: 18.h),

                    // Email Address(optional)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Email Address",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E2D24),
                            ),
                          ),
                          TextSpan(
                            text: "(optional)",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7A8C80),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF1E2D24),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: _fieldDecoration(
                        hintText: "you@example.com",
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: const Color(0xFF7D8F83),
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Password *
                    _buildFieldLabel("Password", isRequired: true),
                    SizedBox(height: 8.h),
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF1E2D24),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _fieldDecoration(
                          hintText: "At least 8 characters",
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: const Color(0xFF7D8F83),
                            size: 20.sp,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: controller.togglePasswordVisibility,
                            child: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF7D8F83),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Confirm Password *
                    _buildFieldLabel("Confirm Password", isRequired: true),
                    SizedBox(height: 8.h),
                    Obx(
                      () => TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: controller.isConfirmPasswordHidden.value,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF1E2D24),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _fieldDecoration(
                          hintText: "Repeat your password",
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: const Color(0xFF7D8F83),
                            size: 20.sp,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: controller.toggleConfirmPasswordVisibility,
                            child: Icon(
                              controller.isConfirmPasswordHidden.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF7D8F83),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // --- SECTION 2: VEHICLE INFORMATION ---
                    _buildSectionHeader("VEHICLE INFORMATION"),
                    SizedBox(height: 16.h),

                    // Vehicle Type *
                    _buildFieldLabel("Vehicle Type", isRequired: true),
                    SizedBox(height: 8.h),
                    _buildVehicleTypeSelector(context, controller),
                    SizedBox(height: 18.h),

                    // City / State *
                    _buildFieldLabel("City / State", isRequired: true),
                    SizedBox(height: 8.h),
                    _buildCityStateSelector(context, controller),
                    SizedBox(height: 22.h),

                    // Terms & Conditions Checkbox
                    _buildTermsCheckbox(context, controller),
                    SizedBox(height: 24.h),

                    // Create Driver Account CTA Button
                    _buildCreateButton(controller),
                    SizedBox(height: 20.h),

                    // Footer: Already have an account? Log In
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.off(() => LoginScreen()),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: const Color(0xFF6B7E74),
                            ),
                            children: [
                              const TextSpan(text: "Already have an account? "),
                              TextSpan(
                                text: "Log In",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF236830),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================================
  // HEADER WIDGET
  // ========================================================
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4926), Color(0xFF133B1D)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circle in top right
          Positioned(
            right: -40.w,
            top: -30.h,
            child: Container(
              width: 170.h,
              height: 170.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Back Button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 40.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),

                // Driver Account Pill Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7.h,
                        height: 7.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        "Driver Account",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Title
                Text(
                  "Create Driver Account",
                  style: GoogleFonts.inter(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 6.h),

                // Subtitle
                Text(
                  "Join thousands of drivers earning with AgroConnect",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // SECTION HEADER
  // ========================================================
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF7E8D84),
        letterSpacing: 0.7,
      ),
    );
  }

  // ========================================================
  // FIELD LABEL WITH RED ASTERISK
  // ========================================================
  Widget _buildFieldLabel(
    String label, {
    bool isRequired = false,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E2D24),
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: "*",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(
                      0xFFE53935,
                    ), // Pure red asterisk from mockup
                  ),
                ),
            ],
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 3.h),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: const Color(0xFF7A8C80),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  // ========================================================
  // FIELD INPUT DECORATION (Standard Outer OutlineInputBorder)
  // ========================================================
  InputDecoration _fieldDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    BoxConstraints? prefixIconConstraints,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF2F7F3),
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontSize: 14.sp,
        color: const Color(0xFF7D8F83),
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconConstraints: prefixIconConstraints,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Color(0xFFD6E3D8), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Color(0xFFD6E3D8), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Color(0xFF236830), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  // ========================================================
  // PHONE INPUT ROW
  // Uses full TextField with outer enabledBorder & prefixIcon
  // Interactive Country Code Selector
  // ========================================================
  Widget _buildPhoneInput(
    BuildContext context,
    DeliveryAccountController controller,
  ) {
    return TextField(
      controller: controller.phoneController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        color: const Color(0xFF1E2D24),
        fontWeight: FontWeight.w500,
      ),
      decoration: _fieldDecoration(
        hintText: "800 000 0000",
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 12.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _showCountryCodeDialog(context, controller),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Text(
                        controller.selectedCountryFlag.value,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Obx(
                      () => Text(
                        controller.selectedCountryCode.value,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF384A3E),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF7D8F83),
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 1.w,
                height: 22.h,
                color: const Color(0xFFD6E3D8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountryCodeDialog(
    BuildContext context,
    DeliveryAccountController controller,
  ) {
    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 440.h,
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DFD8),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Select Country Code",
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: ListView.builder(
                itemCount: controller.countryCodes.length,
                itemBuilder: (context, index) {
                  final item = controller.countryCodes[index];
                  final isSelected =
                      controller.selectedCountryCode.value == item['code'] &&
                      controller.selectedCountryFlag.value == item['flag'];

                  return InkWell(
                    onTap: () {
                      controller.selectCountry(item);
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      margin: EdgeInsets.only(bottom: 6.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE8F3ED)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            item['flag'] ?? '',
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              item['name'] ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF236830)
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            item['code'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF236830)
                                  : const Color(0xFF7D8F83),
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.check_circle_rounded,
                              color: const Color(0xFF236830),
                              size: 18.sp,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
      isScrollControlled: true,
    );
  }

  // ========================================================
  // VEHICLE TYPE SELECTOR & DROPDOWN
  // ========================================================
  Widget _buildVehicleTypeSelector(
    BuildContext context,
    DeliveryAccountController controller,
  ) {
    return Obx(() {
      final selected = controller.selectedVehicleType.value;

      return GestureDetector(
        onTap: () => _showVehicleTypeDialog(context, controller),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7F3),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFD6E3D8), width: 1.0),
          ),
          child: Row(
            children: [
              Icon(
                _getVehicleIcon(selected),
                color: const Color(0xFF7D8F83),
                size: 20.sp,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  selected.isEmpty ? "Select Vehicle Type" : selected,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selected.isEmpty
                        ? const Color(0xFF7D8F83)
                        : const Color(0xFF1E2D24),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF7D8F83),
                size: 20.sp,
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData _getVehicleIcon(String type) {
    switch (type.toLowerCase()) {
      case 'motorbike':
        return Icons.two_wheeler_outlined;
      case 'tricycle':
        return Icons.electric_rickshaw_outlined;
      case 'van':
        return Icons.airport_shuttle_outlined;
      case 'truck':
        return Icons.local_shipping_outlined;
      default:
        return Icons.local_shipping_outlined;
    }
  }

  void _showVehicleTypeDialog(
    BuildContext context,
    DeliveryAccountController controller,
  ) {
    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DFD8),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Select Vehicle Type",
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            ...controller.vehicleTypes.map((type) {
              final isSelected = controller.selectedVehicleType.value == type;
              return InkWell(
                onTap: () {
                  controller.selectVehicleType(type);
                  Get.back();
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 13.h,
                  ),
                  margin: EdgeInsets.only(bottom: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFE8F3ED)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getVehicleIcon(type),
                        color: isSelected
                            ? const Color(0xFF236830)
                            : const Color(0xFF6B7E74),
                        size: 20.sp,
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          type,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF236830)
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF236830),
                          size: 20.sp,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      ),
      isScrollControlled: true,
    );
  }

  // ========================================================
  // CITY / STATE SELECTOR
  // ========================================================
  Widget _buildCityStateSelector(
    BuildContext context,
    DeliveryAccountController controller,
  ) {
    return Obx(() {
      final selected = controller.selectedCityState.value;

      return GestureDetector(
        onTap: () => _showCityStateDialog(context, controller),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7F3),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFD6E3D8), width: 1.0),
          ),
          child: Row(
            children: [
              Icon(
                Icons.language_outlined,
                color: const Color(0xFF7D8F83),
                size: 20.sp,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  selected.isEmpty ? "Select City / State" : selected,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: selected.isEmpty
                        ? const Color(0xFF7D8F83)
                        : const Color(0xFF1E2D24),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF7D8F83),
                size: 20.sp,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showCityStateDialog(
    BuildContext context,
    DeliveryAccountController controller,
  ) {
    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 420.h,
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DFD8),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Select City / State",
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: ListView.builder(
                itemCount: controller.citiesStates.length,
                itemBuilder: (context, index) {
                  final item = controller.citiesStates[index];
                  final isSelected = controller.selectedCityState.value == item;

                  return InkWell(
                    onTap: () {
                      controller.selectCityState(item);
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 13.h,
                      ),
                      margin: EdgeInsets.only(bottom: 6.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE8F3ED)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: isSelected
                                ? const Color(0xFF236830)
                                : const Color(0xFF6B7E74),
                            size: 20.sp,
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Text(
                              item,
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF236830)
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: const Color(0xFF236830),
                              size: 20.sp,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
      isScrollControlled: true,
    );
  }

  // ========================================================
  // TERMS & CONDITIONS CHECKBOX
  // ========================================================
  Widget _buildTermsCheckbox(
    BuildContext context,
    DeliveryAccountController controller,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => GestureDetector(
            onTap: controller.toggleTermsAgreement,
            child: Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 20.h,
              height: 20.h,
              decoration: BoxDecoration(
                color: controller.agreedToTerms.value
                    ? const Color(0xFF236830)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.agreedToTerms.value
                      ? const Color(0xFF236830)
                      : const Color(0xFF9EABA2),
                  width: 1.5,
                ),
              ),
              child: controller.agreedToTerms.value
                  ? Icon(Icons.check, color: Colors.white, size: 13.sp)
                  : null,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: "I agree to AgroConnect's "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () =>
                        Get.to(() => const ProducerTermsPrivacyScreen()),
                    child: Text(
                      "Terms & Conditions",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF236830),
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF236830),
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: " and "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () =>
                        Get.to(() => const ProducerTermsPrivacyScreen()),
                    child: Text(
                      "Privacy Policy",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF236830),
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF236830),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ========================================================
  // CTA BUTTON
  // ========================================================
  Widget _buildCreateButton(DeliveryAccountController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.handleCreateDriverAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF236830),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            disabledBackgroundColor: const Color(
              0xFF236830,
            ).withValues(alpha: 0.6),
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 22.h,
                  height: 22.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  "Create Driver Account",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
