import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/routes/app_routes.dart';
import '../../controllers/producer_settings_controller.dart';

class ProducerSettingsScreen extends StatelessWidget {
  const ProducerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject settings controller (permanent so it persists when opening sub-screens)
    final controller = Get.put(ProducerSettingsController(), permanent: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Notifications Section
            _buildSectionHeader('NOTIFICATIONS'),
            SizedBox(height: 8.h),
            _buildNotificationsGroup(controller),
            SizedBox(height: 24.h),

            // 2. Account & Security Section
            _buildSectionHeader('ACCOUNT & SECURITY'),
            SizedBox(height: 8.h),
            _buildSecurityGroup(),
            SizedBox(height: 32.h),

            // 3. Branding & Version Footer
            _buildFooter(),
            SizedBox(height: 24.h),
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
            'Settings',
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildNotificationsGroup(ProducerSettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
      ),
      child: Column(
        children: [
          // Push Notifications Tile
          Obx(() => _buildSwitchTile(
                icon: Icons.notifications_outlined,
                iconColor: Colors.amber[700]!,
                iconBgColor: const Color(0xFFFFF8E1),
                title: 'Push Notifications',
                subtitle: 'Receive alerts on your device for orders and updates.',
                value: controller.isPushEnabled.value,
                onChanged: (val) => controller.togglePush(val),
              )),
          _buildDivider(),

          // Email Notifications Tile
          Obx(() => _buildSwitchTile(
                icon: Icons.email_outlined,
                iconColor: Colors.blue[600]!,
                iconBgColor: const Color(0xFFE3F2FD),
                title: 'Email Notifications',
                subtitle: 'Get order summaries and updates via email.',
                value: controller.isEmailEnabled.value,
                onChanged: (val) => controller.toggleEmail(val),
              )),
          _buildDivider(),

          // New Order Alerts Tile
          Obx(() => _buildSwitchTile(
                icon: Icons.notifications_paused_outlined,
                iconColor: Colors.green[600]!,
                iconBgColor: const Color(0xFFE8F5E9),
                title: 'New Order Alerts',
                subtitle: 'Sound and vibration when a new order arrives.',
                value: controller.isOrderAlertsEnabled.value,
                onChanged: (val) => controller.toggleOrderAlerts(val),
              )),
        ],
      ),
    );
  }

  Widget _buildSecurityGroup() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE), // soft red circular background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
          ),
          title: Text(
            'Change Password',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            'Update your account password.',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary.withAlpha(150),
            size: 20.sp,
          ),
          onTap: () {
            Get.toNamed(AppRoute.changePassword);
          },
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          // Circular Icon background
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20.sp,
            ),
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
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Switch toggle
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: const Color(0xFFECEFF1),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFF0F5F1),
      indent: 56.w,
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // AgroConnect Logo and Text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: Color(0xFF2D7A3A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.spa_rounded,
                color: Colors.white,
                size: 12,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              'AgroConnect',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D7A3A),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        // Version info
        Text(
          'Version 2.4.1 (Build 412) · Producer Edition',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: AppColors.textSecondary.withAlpha(150),
          ),
        ),
        SizedBox(height: 12.h),
        // Update Action text
        GestureDetector(
          onTap: () {
            Get.snackbar(
              'System Update',
              'You are running the latest version of AgroConnect.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF2D7A3A),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          },
          child: Text(
            'Check for Updates',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D7A3A),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
