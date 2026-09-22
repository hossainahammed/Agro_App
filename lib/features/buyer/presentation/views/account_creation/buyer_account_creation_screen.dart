import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/authentication/presentation/screens/login_screen.dart';
import 'package:project_structure/features/producer/presentation/views/profile/producer_terms_privacy_screen.dart';
import '../../controllers/buyer_account_controller.dart';

class BuyerAccountCreationScreen extends StatelessWidget {
  const BuyerAccountCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuyerAccountController());

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
                  color: const Color(0xFFEDF4EE), // Signature soft sage-mint
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

                    // --- SECTION 2: DELIVERY INFORMATION ---
                    _buildSectionHeader("DELIVERY INFORMATION"),
                    SizedBox(height: 16.h),

                    // Delivery Address *
                    _buildFieldLabel(
                      "Delivery Address",
                      isRequired: true,
                      subtitle: "Where should orders be delivered?",
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: controller.deliveryAddressController,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF1E2D24),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: _fieldDecoration(
                        hintText: "Street, area, landmark...",
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: const Color(0xFF7D8F83),
                          size: 20.sp,
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(8.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2EFE4),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.my_location_rounded,
                                color: const Color(0xFF236830),
                                size: 18.sp,
                              ),
                              onPressed: controller.useCurrentLocation,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // "Use my current location" Action link
                    GestureDetector(
                      onTap: controller.useCurrentLocation,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.near_me_outlined,
                            size: 15.sp,
                            color: const Color(0xFF236830),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Use my current location",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF236830),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // City / State *
                    _buildFieldLabel("City / State", isRequired: true),
                    SizedBox(height: 8.h),
                    _buildCityStateSelector(context, controller),
                    SizedBox(height: 22.h),

                    // --- SECTION 3: BUSINESS DETAILS (EXPANDABLE CARD) ---
                    _buildBusinessDetailsCard(context, controller),
                    SizedBox(height: 22.h),

                    // Terms & Conditions Checkbox
                    _buildTermsCheckbox(context, controller),
                    SizedBox(height: 24.h),

                    // Create Buyer Account CTA Button
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

                // Buyer Account Pill Badge
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
                        "Buyer Account",
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
                  "Create Account",
                  style: GoogleFonts.inter(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 6.h),

                // Subtitle
                Text(
                  "Buy fresh produce directly from local farmers",
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
                    color: const Color(0xFFE53935),
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
  // FIELD INPUT DECORATION
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
  // ========================================================
  Widget _buildPhoneInput(
    BuildContext context,
    BuyerAccountController controller,
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
    BuyerAccountController controller,
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
  // CITY / STATE SELECTOR & SEARCHABLE BOTTOM SHEET
  // ========================================================
  Widget _buildCityStateSelector(
    BuildContext context,
    BuyerAccountController controller,
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
    BuyerAccountController controller,
  ) {
    controller.stateSearchController.clear();
    controller.filterStates('');

    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 520.h,
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
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),

              // Search Input Field
              TextField(
                controller: controller.stateSearchController,
                onChanged: controller.filterStates,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFF1E2D24),
                ),
                decoration: InputDecoration(
                  hintText: "Search state...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF7D8F83),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: const Color(0xFF7D8F83),
                    size: 20.sp,
                  ),
                  suffixIcon: Obx(() {
                    if (controller.stateSearchController.text.isNotEmpty) {
                      return GestureDetector(
                        onTap: () {
                          controller.stateSearchController.clear();
                          controller.filterStates('');
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: const Color(0xFF7D8F83),
                          size: 18.sp,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  filled: true,
                  fillColor: const Color(0xFFF2F7F3),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFD6E3D8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFD6E3D8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFF236830),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // Filtered States List
              Expanded(
                child: Obx(() {
                  if (controller.filteredStates.isEmpty) {
                    return Center(
                      child: Text(
                        "No states found",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF7D8F83),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredStates.length,
                    itemBuilder: (context, index) {
                      final item = controller.filteredStates[index];
                      final isSelected =
                          controller.selectedCityState.value == item;

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
                            vertical: 12.h,
                          ),
                          margin: EdgeInsets.only(bottom: 5.h),
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
                                size: 19.sp,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Text(
                                  item,
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
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: const Color(0xFF236830),
                                  size: 19.sp,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ========================================================
  // BUSINESS DETAILS CARD (EXPANDABLE ACCORDION)
  // ========================================================
  Widget _buildBusinessDetailsCard(
    BuildContext context,
    BuyerAccountController controller,
  ) {
    return Obx(() {
      final isExpanded = controller.isBusinessDetailsExpanded.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFD6E3D8), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Clickable)
            InkWell(
              onTap: controller.toggleBusinessDetails,
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF4EF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.business_outlined,
                        color: const Color(0xFF4A6852),
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Business Details",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E2D24),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Optional · for invoices & accounting",
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7A8C80),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF7D8F83),
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expandable Content
            if (isExpanded) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const Divider(color: Color(0xFFEDF4EE), height: 1),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Name (Optional)
                    Text(
                      "Business Name (optional)",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: controller.businessNameController,
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        color: const Color(0xFF1E2D24),
                      ),
                      decoration: _fieldDecoration(
                        hintText: "e.g. Acme Supermarket or Fresh Bites",
                        prefixIcon: Icon(
                          Icons.store_outlined,
                          color: const Color(0xFF7D8F83),
                          size: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Business Type (Optional)
                    Text(
                      "Business Type",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _buildBusinessTypeSelector(context, controller),
                    SizedBox(height: 14.h),

                    // Tax ID / CAC Reg. (Optional)
                    Text(
                      "Tax ID / CAC Reg. (optional)",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: controller.taxIdController,
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        color: const Color(0xFF1E2D24),
                      ),
                      decoration: _fieldDecoration(
                        hintText: "e.g. RC-1234567 or TIN number",
                        prefixIcon: Icon(
                          Icons.badge_outlined,
                          color: const Color(0xFF7D8F83),
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ========================================================
  // BUSINESS TYPE SELECTOR & SEARCHABLE BOTTOM SHEET
  // ========================================================
  Widget _buildBusinessTypeSelector(
    BuildContext context,
    BuyerAccountController controller,
  ) {
    return Obx(() {
      final selected = controller.selectedBusinessType.value;

      return GestureDetector(
        onTap: () => _showBusinessTypeDialog(context, controller),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7F3),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFD6E3D8), width: 1.0),
          ),
          child: Row(
            children: [
              Icon(
                Icons.category_outlined,
                color: const Color(0xFF7D8F83),
                size: 19.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  selected.isEmpty ? "Select Business Type" : selected,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
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

  void _showBusinessTypeDialog(
    BuildContext context,
    BuyerAccountController controller,
  ) {
    controller.businessTypeSearchController.clear();
    controller.filterBusinessTypes('');

    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 480.h,
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
                "Select Business Type",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),

              // Search input: Search type... as specified
              TextField(
                controller: controller.businessTypeSearchController,
                onChanged: controller.filterBusinessTypes,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFF1E2D24),
                ),
                decoration: InputDecoration(
                  hintText: "Search type...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF7D8F83),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: const Color(0xFF7D8F83),
                    size: 20.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF2F7F3),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFD6E3D8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFD6E3D8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFF236830),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              Expanded(
                child: Obx(() {
                  if (controller.filteredBusinessTypes.isEmpty) {
                    return Center(
                      child: Text(
                        "No business types found",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF7D8F83),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredBusinessTypes.length,
                    itemBuilder: (context, index) {
                      final type = controller.filteredBusinessTypes[index];
                      final isSelected =
                          controller.selectedBusinessType.value == type;

                      return InkWell(
                        onTap: () {
                          controller.selectBusinessType(type);
                          Get.back();
                        },
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          margin: EdgeInsets.only(bottom: 5.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8F3ED)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.storefront_outlined,
                                color: isSelected
                                    ? const Color(0xFF236830)
                                    : const Color(0xFF6B7E74),
                                size: 19.sp,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Text(
                                  type,
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
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: const Color(0xFF236830),
                                  size: 19.sp,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
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
    BuyerAccountController controller,
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
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF236830),
                        decoration: TextDecoration.underline,
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
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF236830),
                        decoration: TextDecoration.underline,
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
  Widget _buildCreateButton(BuyerAccountController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.handleCreateBuyerAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF236830),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
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
                  "Create Buyer Account",
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
