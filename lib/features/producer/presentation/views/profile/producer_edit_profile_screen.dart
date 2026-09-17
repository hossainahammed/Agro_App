import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/producer_profile_controller.dart';

class ProducerEditProfileScreen extends StatelessWidget {
  const ProducerEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProducerProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Scrollable Form Fields
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Photo Edit Header
                  _buildPhotoEditSection(controller),
                  SizedBox(height: 24.h),

                  // 2. Personal Information Section
                  _buildSectionHeader('PERSONAL INFORMATION'),
                  SizedBox(height: 16.h),
                  
                  _buildLabel('Full Name *'),
                  _buildInputField(
                    controller: controller.nameController,
                    prefixIcon: Icons.person_outline_rounded,
                    hintText: 'Enter full name',
                    controllerToClear: controller.nameController,
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel('Phone Number *'),
                  _buildInputField(
                    controller: controller.phoneController,
                    prefixIcon: Icons.phone_outlined,
                    hintText: 'Enter phone number',
                    controllerToClear: controller.phoneController,
                    helperText: 'Used for order notifications and buyer contact.',
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel('Email Address *'),
                  _buildInputField(
                    controller: controller.emailController,
                    prefixIcon: Icons.email_outlined,
                    hintText: 'Enter email address',
                    controllerToClear: controller.emailController,
                  ),
                  SizedBox(height: 24.h),

                  // 3. Business Information Section
                  _buildSectionHeader('BUSINESS INFORMATION'),
                  SizedBox(height: 16.h),

                  _buildLabel('Business Name *'),
                  _buildInputField(
                    controller: controller.businessNameController,
                    prefixIcon: Icons.storefront_outlined,
                    hintText: 'Enter business name',
                    controllerToClear: controller.businessNameController,
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel('Address'),
                  _buildInputField(
                    controller: controller.addressController,
                    prefixIcon: Icons.location_on_outlined,
                    hintText: 'Enter business address',
                    controllerToClear: controller.addressController,
                    helperText: 'Your farm or business address.',
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel('State / Region *'),
                  _buildSelectorField(
                    value: controller.stateRegion.value,
                    prefixIcon: Icons.language_rounded,
                    onTap: () {
                      _showStateDropdown(context, controller);
                    },
                  ),
                  SizedBox(height: 24.h),

                  // 4. Account Section
                  _buildSectionHeader('ACCOUNT'),
                  SizedBox(height: 16.h),

                  _buildLabel('AgroConnect ID'),
                  _buildReadOnlyField(
                    value: controller.agroConnectId,
                    prefixIcon: Icons.person_outline_rounded,
                    helperText: 'Your unique producer ID. This cannot be changed.',
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel('Bio *'),
                  _buildSelectorField(
                    value: controller.stateRegion.value, // matches the design screenshot "Kaduna" showing in Bio
                    prefixIcon: Icons.language_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // 5. Pinned Save Changes Button
          _buildSaveButton(controller),
        ],
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
            'Edit Profile',
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

  Widget _buildPhotoEditSection(ProducerProfileController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          // Circular Avatar with green ring border
          Obx(() {
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
                  ),
                  child: CircleAvatar(
                    radius: 54.r,
                    backgroundImage: CachedNetworkImageProvider(controller.avatarUrl.value),
                    backgroundColor: Colors.grey.withAlpha(40),
                  ),
                ),
                // Floating Camera Edit Button
                Positioned(
                  bottom: 6.h,
                  right: 6.w,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D7A3A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 12.h),
          // Links text
          GestureDetector(
            onTap: () {},
            child: Text(
              'Change Photo',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D7A3A),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'JPG or PNG · Max 5 MB',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 4.h),
        const Divider(color: Color(0xFFE5ECE8), thickness: 1),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData prefixIcon,
    required String hintText,
    TextEditingController? controllerToClear,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8F6), // soft input background
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE0ECE8), width: 1),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 20.sp),
              suffixIcon: controllerToClear != null
                  ? IconButton(
                      icon: Icon(Icons.close_rounded, color: AppColors.textSecondary.withAlpha(150), size: 18.sp),
                      onPressed: () => controllerToClear.clear(),
                    )
                  : null,
              hintText: hintText,
              hintStyle: GoogleFonts.inter(color: AppColors.textSecondary.withAlpha(120), fontSize: 14.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            ),
          ),
        ),
        if (helperText != null) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              helperText,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String value,
    required IconData prefixIcon,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8F6), // soft read-only background
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE0ECE8), width: 1),
          ),
          child: Row(
            children: [
              Icon(prefixIcon, color: AppColors.textSecondary, size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (helperText != null) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              helperText,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectorField({
    required String value,
    required IconData prefixIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F8F6), // soft selector background
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE0ECE8), width: 1),
        ),
        child: Row(
          children: [
            Icon(prefixIcon, color: AppColors.textSecondary, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(ProducerProfileController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () => controller.saveProfile(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D7A3A), // brand-green save button
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
      ),
    );
  }

  void _showStateDropdown(BuildContext context, ProducerProfileController controller) {
    final List<String> states = ['Kaduna', 'Lagos', 'Kano', 'Abuja', 'Oyo', 'Enugu'];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select State / Region',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: states.length,
                itemBuilder: (context, index) {
                  final state = states[index];
                  return ListTile(
                    title: Text(
                      state,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        fontWeight: controller.stateRegion.value == state ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: controller.stateRegion.value == state
                        ? const Icon(Icons.check_rounded, color: Color(0xFF2D7A3A))
                        : null,
                    onTap: () {
                      controller.stateRegion.value = state;
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
