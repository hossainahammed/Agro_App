import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/routes/app_routes.dart';
import '../../controllers/producer_profile_controller.dart';
import 'producer_edit_profile_screen.dart';

class ProducerProfileScreen extends StatelessWidget {
  const ProducerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject or find profile controller
    final controller = Get.put(ProducerProfileController(), permanent: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Sloping Gradient Header (Avatar & Top Shortcuts)
            _buildHeader(controller),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  // 2. Identity Details (Name, Pills, Bio, Rating)
                  _buildIdentity(controller),
                  SizedBox(height: 24.h),

                  // 3. Stats Grid (Products, Orders, Revenue)
                  _buildStatsGrid(controller),
                  SizedBox(height: 24.h),

                  // 4. Account Settings Section
                  _buildSectionHeader('ACCOUNT'),
                  SizedBox(height: 8.h),
                  _buildAccountGroup(controller),
                  SizedBox(height: 20.h),

                  // 5. Support Section
                  _buildSectionHeader('SUPPORT'),
                  SizedBox(height: 8.h),
                  _buildSupportGroup(),
                  SizedBox(height: 20.h),

                  // 6. Log Out Button
                  _buildLogoutButton(),
                  SizedBox(height: 24.h),

                  // 7. Branding & Version Footer
                  _buildFooter(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ProducerProfileController controller) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Green Gradient Banner Background
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B6A2F), Color(0xFF2E8A42)], // brand green gradient
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, right: 16.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Chat Shortcut
                    _buildHeaderIconButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: () => Get.toNamed(AppRoute.chatList),
                    ),
                    SizedBox(width: 12.w),
                    // Notification Shortcut
                    _buildHeaderIconButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: () => Get.toNamed(AppRoute.notification),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Floating Profile Avatar Ring
        Positioned(
          bottom: -48.h,
          child: Obx(() {
            return Stack(
              children: [
                // Outer ring
                Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2.h),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 46.r,
                      backgroundImage: CachedNetworkImageProvider(controller.avatarUrl.value),
                      backgroundColor: Colors.grey.withAlpha(40),
                    ),
                  ),
                ),
                // Camera Badge Overlay
                Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E8A42),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeaderIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.h,
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(38), // circular translucent background
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildIdentity(ProducerProfileController controller) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(height: 56.h), // offset for floating avatar
          
          // Full Name
          Text(
            controller.name.value,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Business Name
          Text(
            controller.businessName.value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),

          // Verified & Location Pills Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Verified Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D7A3A),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 13.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'AgroConnect Verified',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Location Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFC6E8C7), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13.sp,
                      color: const Color(0xFF2D7A3A),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${controller.stateRegion.value} State, Nigeria',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF2D7A3A),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    color: index < 5 ? Colors.amber : Colors.grey.withAlpha(50),
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '${controller.rating}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '(${controller.reviewCount} reviews)',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Bio Paragraph
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              controller.bio.value,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),

          // Contact details & member since
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                controller.phone.value,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  '|',
                  style: GoogleFonts.inter(color: Colors.grey.withAlpha(80)),
                ),
              ),
              Icon(
                Icons.verified_outlined,
                size: 14.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                controller.sinceDate,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatsGrid(ProducerProfileController controller) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.inventory_2_outlined,
          value: '${controller.productsCount}',
          label: 'Products',
        ),
        SizedBox(width: 12.w),
        _buildStatCard(
          icon: Icons.assignment_outlined,
          value: '${controller.ordersCount}',
          label: 'Orders',
        ),
        SizedBox(width: 12.w),
        _buildStatCard(
          icon: Icons.trending_up_rounded,
          value: controller.revenue,
          label: 'Revenue',
        ),
      ],
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: Color(0xFFEDF7EE), // soft green circular bg for stats icons
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 18.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
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
      ),
    );
  }

  Widget _buildAccountGroup(ProducerProfileController controller) {
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
        child: Column(
          children: [
            _buildSettingsItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle: 'Update photo, name, bio',
              onTap: () {
                controller.loadFormValues();
                Get.to(() => const ProducerEditProfileScreen());
              },
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'My Wallet',
              subtitle: 'Sales, Revenue & Withdraw History',
              onTap: () => Get.toNamed(AppRoute.myWallet),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.credit_card_outlined,
              title: 'Bank & Payment Details',
              subtitle: 'Add or update bank account',
              onTap: () => Get.toNamed(AppRoute.payoutMethods),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'App preferences & privacy',
              onTap: () => Get.toNamed(AppRoute.settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportGroup() {
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
        child: Column(
          children: [
            _buildSettingsItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'FAQs, contact us',
              onTap: () => Get.toNamed(AppRoute.helpSupport),
            ),
            _buildDivider(),
            _buildSettingsItem(
              icon: Icons.description_outlined,
              title: 'Terms & Privacy',
              subtitle: 'Legal & privacy policy',
              onTap: () => Get.toNamed(AppRoute.termsPrivacy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
          leading: Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE), // soft red circle background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
              size: 20,
            ),
          ),
          title: Text(
            'Log Out',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: const BoxDecoration(
            color: Color(0xFFEDF7EE), // soft green circle background for settings icons
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
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
        onTap: onTap,
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
                Icons.spa_rounded, // flower/leaf icon matching AgroConnect branding
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
        Text(
          'Version 2.4.1 · Producer Edition',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: AppColors.textSecondary.withAlpha(150),
          ),
        ),
      ],
    );
  }
}
