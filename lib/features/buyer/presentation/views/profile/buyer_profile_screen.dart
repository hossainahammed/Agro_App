import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/authentication/presentation/screens/login_screen.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2D24),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.h),
        child: Column(
          children: [
            // User Avatar & Name Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFD6E3D8)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54.h,
                    height: 54.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F3ED),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "NA",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ngozi Adaeze",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E2D24),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Buyer Account · Kano",
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            color: const Color(0xFF7A8C80),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Profile Options
            _buildProfileTile(Icons.location_on_outlined, "Delivery Addresses"),
            _buildProfileTile(Icons.favorite_outline_rounded, "Saved Items"),
            _buildProfileTile(Icons.payment_outlined, "Payment Methods"),
            _buildProfileTile(Icons.help_outline_rounded, "Help & Support"),
            _buildProfileTile(
              Icons.logout_rounded,
              "Log Out",
              isDestructive: true,
              onTap: () => Get.offAll(() => LoginScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    IconData icon,
    String title, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive
              ? const Color(0xFFEF4444)
              : const Color(0xFF236830),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDestructive
                ? const Color(0xFFEF4444)
                : const Color(0xFF1E2D24),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF7D8F83),
        ),
        onTap: onTap,
      ),
    );
  }
}
