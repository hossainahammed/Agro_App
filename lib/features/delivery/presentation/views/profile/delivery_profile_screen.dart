import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/chat/presentation/views/chat_list_screen.dart';
import 'package:project_structure/features/notification/presentation/views/notification_screen.dart';
import 'package:project_structure/features/role_selection/screen/role_selection_screen.dart';
import 'delivery_documents_screen.dart';
import 'delivery_edit_profile_screen.dart';
import 'delivery_help_support_screen.dart';
import 'delivery_settings_screen.dart';
import 'delivery_terms_privacy_screen.dart';
import 'delivery_vehicle_screen.dart';

class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ========================================================
            // TOP HEADER WITH CURVED GREEN BACKGROUND & ICONS
            // ========================================================
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Curved Forest Green Header
                Container(
                  width: double.infinity,
                  height: topPadding + 88.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF236830),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.r),
                      bottomRight: Radius.circular(32.r),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, topPadding + 8.h, 20.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chat button
                      GestureDetector(
                        onTap: () => Get.to(() => const ChatListScreen()),
                        child: Container(
                          width: 38.h,
                          height: 38.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.white,
                            size: 19.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Notification button
                      GestureDetector(
                        onTap: () => Get.to(() => const NotificationScreen()),
                        child: Container(
                          width: 38.h,
                          height: 38.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Avatar Centered Overlapping Header Bottom
                Positioned(
                  bottom: -44.h,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 86.h,
                        height: 86.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3.5.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=250&auto=format&fit=crop',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF1B4926),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF1B4926),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Camera Icon Badge
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 26.h,
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF236830),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.w),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 52.h),

            // ========================================================
            // DRIVER NAME, HANDLE, BADGES & RATING
            // ========================================================
            Text(
              "Emeka Okafor",
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "@emeka_driver · Kano, Nigeria",
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.h),

            // Badges Row: Verified Driver & Van
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Verified Driver Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF7EE),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFFBBE5C5),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: const Color(0xFF236830),
                        size: 13.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Verified Driver",
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Van Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFFBFDBFE),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: const Color(0xFF2563EB),
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Van",
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Star Rating Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 17.sp,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                RichText(
                  text: TextSpan(
                    text: "4.8 ",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                    children: [
                      TextSpan(
                        text: "· 142 trips",
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // ========================================================
            // DELIVERIES / THIS MONTH / ON-TIME STATS CARD
            // ========================================================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE5EDE6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildStatColumn("142", "DELIVERIES")),
                    Container(
                      width: 1,
                      height: 32.h,
                      color: const Color(0xFFE5EDE6),
                    ),
                    Expanded(child: _buildStatColumn("₦142k", "THIS MONTH")),
                    Container(
                      width: 1,
                      height: 32.h,
                      color: const Color(0xFFE5EDE6),
                    ),
                    Expanded(child: _buildStatColumn("96%", "ON-TIME")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ========================================================
            // MENU CARD GROUPS (Matching Attached Image Exactly)
            // ========================================================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // GROUP 1: Edit Profile, My Vehicle, Documents
                  _buildGroupCard(
                    children: [
                      // 1. Edit Profile
                      _buildTile(
                        iconBgColor: const Color(0xFFE8F5E9),
                        iconColor: const Color(0xFF2E7D32),
                        icon: Icons.edit_outlined,
                        title: "Edit Profile",
                        subtitle: "Update your personal details",
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        onTap: () =>
                            Get.to(() => const DeliveryEditProfileScreen()),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFF0F4F1),
                      ),

                      // 2. My Vehicle
                      _buildTile(
                        iconBgColor: const Color(0xFFE8F0FE),
                        iconColor: const Color(0xFF1E88E5),
                        icon: Icons.local_shipping_outlined,
                        title: "My Vehicle",
                        subtitle: "Van · KN-402-ABC",
                        onTap: () =>
                            Get.to(() => const DeliveryVehicleScreen()),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFF0F4F1),
                      ),

                      // 3. Documents
                      _buildTile(
                        iconBgColor: const Color(0xFFF3E8FF),
                        iconColor: const Color(0xFF9333EA),
                        icon: Icons.description_outlined,
                        title: "Documents",
                        subtitle: "All 5 verified",
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                        onTap: () =>
                            Get.to(() => const DeliveryDocumentsScreen()),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // GROUP 2: Settings, Help & Support, Terms & Privacy
                  _buildGroupCard(
                    children: [
                      // 4. Settings
                      _buildTile(
                        iconBgColor: const Color(0xFFF1F5F2),
                        iconColor: const Color(0xFF5A6E60),
                        icon: Icons.settings_outlined,
                        title: "Settings",
                        subtitle: "Language, privacy, notifcations",
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        onTap: () =>
                            Get.to(() => const DeliverySettingsScreen()),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFF0F4F1),
                      ),

                      // 5. Help & Support
                      _buildTile(
                        iconBgColor: const Color(0xFFE0F2FE),
                        iconColor: const Color(0xFF0284C7),
                        icon: Icons.help_outline_rounded,
                        title: "Help & Support",
                        subtitle: "Chat, FAQs, report an issue",
                        onTap: () =>
                            Get.to(() => const DeliveryHelpSupportScreen()),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFF0F4F1),
                      ),

                      // 6. Terms & Privacy
                      _buildTile(
                        iconBgColor: const Color(0xFFF5F5F4),
                        iconColor: const Color(0xFF57534E),
                        icon: Icons.article_outlined,
                        title: "Terms & Privacy",
                        subtitle: "Legal documents",
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                        onTap: () =>
                            Get.to(() => const DeliveryTermsPrivacyScreen()),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // GROUP 3: Log Out
                  _buildGroupCard(
                    children: [
                      _buildTile(
                        iconBgColor: const Color(0xFFFEE2E2),
                        iconColor: const Color(0xFFDC2626),
                        icon: Icons.logout_rounded,
                        title: "Log Out",
                        subtitle: "Sign out of your account",
                        titleColor: const Color(0xFFDC2626),
                        chevronColor: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // App Version Footer
            Text(
              "AgroConnect Driver · v2.4.1",
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HELPER WIDGETS
  // ==========================================================
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5EDE6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required Color iconBgColor,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Color? chevronColor,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          child: Row(
            children: [
              // Circular Icon Box
              Container(
                width: 42.h,
                height: 42.h,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 14.w),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: titleColor ?? const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron Arrow
              Icon(
                Icons.chevron_right_rounded,
                color: chevronColor ?? const Color(0xFF9CA3AF),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SafeArea(
        top: false,
        bottom: true,
        child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(35),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle Pill
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),

              // Red Logout Icon Badge
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xFFDC2626),
                  size: 26.sp,
                ),
              ),
              SizedBox(height: 14.h),

              // Title
              Text(
                "Log Out?",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              SizedBox(height: 8.h),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  "You'll need to sign back in to access your account and receive missions.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12.5.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Dual Buttons Row
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F4F6),
                          foregroundColor: const Color(0xFF374151),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF374151),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Get.offAll(() => const RoleSelectionScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Yes, Log Out",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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
}
