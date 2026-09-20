import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/role_selection/screen/role_selection_screen.dart';
import '../../../../../routes/app_routes.dart';

class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF236830),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(26.r),
                  bottomRight: Radius.circular(26.r),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                20.w,
                MediaQuery.of(context).padding.top + 14.h,
                20.w,
                24.h,
              ),
              child: Column(
                children: [
                  Container(
                    width: 76.h,
                    height: 76.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.0),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=250&auto=format&fit=crop',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF1B4926),
                          child: const Icon(Icons.person, color: Colors.white, size: 36),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Emeka Okafor",
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: const Color(0xFF98D4A5), size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          "Verified Driver • AGC-DRV-0477",
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            color: const Color(0xFFD6E8DA),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Information Card
                  Text(
                    "Registered Vehicle",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildVehicleCard(),
                  SizedBox(height: 20.h),

                  // Verification Documents
                  Text(
                    "Document Status",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildDocStatusCard(),
                  SizedBox(height: 20.h),

                  // Settings / Actions
                  _buildActionTile(
                    icon: Icons.notifications_none_rounded,
                    title: "Delivery Notifications",
                    subtitle: "Sound, alerts, and priority dispatch",
                    onTap: () => Get.toNamed(AppRoute.notification),
                  ),
                  SizedBox(height: 10.h),
                  _buildActionTile(
                    icon: Icons.help_outline_rounded,
                    title: "Help & Dispatch Support",
                    subtitle: "Call emergency hub line or chat support",
                    onTap: () => AppSnackBar.info("Dispatch helpline: +234 800 247 6266"),
                  ),
                  SizedBox(height: 10.h),
                  _buildActionTile(
                    icon: Icons.swap_horiz_rounded,
                    title: "Switch Role",
                    subtitle: "Return to role selection (Producer / Buyer / Driver)",
                    onTap: () => Get.offAll(() => const RoleSelectionScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.h,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F3ED),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.two_wheeler_rounded, color: Color(0xFF236830), size: 24),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Motorcycle / Cargo Carrier",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Plate: KMC-492-XA • Max 100 kg load",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF7A8C80),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F3ED),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              "Active",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF236830),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocStatusCard() {
    final docs = [
      "National ID Card (NIN)",
      "Driver's License (FRSC)",
      "Vehicle Registration",
      "Insurance Certificate",
    ];

    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: docs.map((doc) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF236830), size: 18),
                    SizedBox(width: 10.w),
                    Text(
                      doc,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E2D24),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Verified",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF236830),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3ED),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: const Color(0xFF236830), size: 20),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF7A8C80),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF7A8C80)),
          ],
        ),
      ),
    );
  }
}
