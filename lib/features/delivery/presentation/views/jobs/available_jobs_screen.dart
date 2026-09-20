import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class AvailableJobsScreen extends StatelessWidget {
  const AvailableJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Forest Green Header
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
                20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Missions & Deliveries",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "3 available delivery requests near Kano, Nassarawa",
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      color: const Color(0xFFD6E8DA),
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
                  // Active Mission Card (if any)
                  Text(
                    "Active Mission",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildActiveMissionCard(),
                  SizedBox(height: 24.h),

                  // Available Requests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available Requests",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E2D24),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F3ED),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "3 Nearby",
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF236830),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Available Jobs List
                  _buildJobCard(
                    orderId: "AGC-4830",
                    farmerName: "Ibrahim Dahiru Farm",
                    pickup: "Dawanau Grain Market, Stall 14",
                    dropoff: "Bompai Industrial Area",
                    distance: "5.4 km",
                    price: "₦1,850",
                    packageWeight: "45 kg Maize Sacks",
                  ),
                  SizedBox(height: 12.h),
                  _buildJobCard(
                    orderId: "AGC-4831",
                    farmerName: "Fatima Aliyu Agro Store",
                    pickup: "Kano Central Market, Gate 3",
                    dropoff: "Nassarawa GRA, 12 Crescent Road",
                    distance: "3.2 km",
                    price: "₦1,400",
                    packageWeight: "20 kg Fresh Tomatoes",
                  ),
                  SizedBox(height: 12.h),
                  _buildJobCard(
                    orderId: "AGC-4832",
                    farmerName: "Saidu Garba Hub",
                    pickup: "Sabon Gari Agro Depot",
                    dropoff: "Tarauni Modern Market",
                    distance: "7.1 km",
                    price: "₦2,400",
                    packageWeight: "60 kg Rice Bags",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveMissionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFF236830).withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF236830).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3ED),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.h,
                      height: 6.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF236830),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "In Progress • AGC-4828",
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF236830),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "₦2,200",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "Farm Gate 4, Ungogo → Bompai Warehouse",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2D24),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Pickup: Contact Musa Bello (+234 802 334 9911)",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF7A8C80),
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton.icon(
              onPressed: () {
                AppSnackBar.success("Opening Live GPS Route for AGC-4828");
              },
              icon: Icon(Icons.navigation_rounded, size: 18.sp),
              label: Text(
                "Navigate Live Route",
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF236830),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required String orderId,
    required String farmerName,
    required String pickup,
    required String dropoff,
    required String distance,
    required String price,
    required String packageWeight,
  }) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: GoogleFonts.inter(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF236830),
                ),
              ),
              Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            farmerName,
            style: GoogleFonts.inter(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E2D24),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.radio_button_checked, size: 14, color: Color(0xFF236830)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  pickup,
                  style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF556B5C)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFFE53935)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  dropoff,
                  style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF556B5C)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$distance • $packageWeight",
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  color: const Color(0xFF7A8C80),
                  fontWeight: FontWeight.w500,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  AppSnackBar.success("Mission $orderId accepted successfully!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF236830),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  "Accept",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
