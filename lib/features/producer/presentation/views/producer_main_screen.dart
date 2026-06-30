import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/core/utils/constants/icon_path.dart';
import '../controllers/producer_main_controller.dart';
import 'producer_dashboard_screen.dart';

class ProducerMainScreen extends StatelessWidget {
  const ProducerMainScreen({super.key});

  static const List<Widget> _screens = [
    ProducerDashboardScreen(),
    PlaceholderScreen(title: "Products", icon: Icons.inventory_2_outlined),
    PlaceholderScreen(title: "Add Product", icon: Icons.add_circle_outline_rounded),
    PlaceholderScreen(title: "Orders", icon: Icons.shopping_bag_outlined),
    PlaceholderScreen(title: "Profile", icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final ProducerMainController controller = Get.put(ProducerMainController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() => _screens[controller.currentIndex.value]),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Flat White Bottom Navbar — fills all the way to screen edge
          Container(
            width: double.infinity,
            height: 72.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(25),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, IconPath.homeActive, IconPath.homeInactive, 'Home', controller),
                _buildNavItem(1, IconPath.productsActive, IconPath.productsInactive, 'Products', controller),

                // Space placeholder for the center floating button
                SizedBox(width: 68.w),

                _buildNavItem(3, IconPath.ordersActive, IconPath.ordersInactive, 'Orders', controller),
                _buildNavItem(4, IconPath.profileActive, IconPath.profileInactive, 'Profile', controller),
              ],
            ),
          ),

          // Floating Center Action Button — raised above the navbar
          Positioned(
            bottom: 28.h,
            child: Obx(() {
              final bool isSelected = controller.currentIndex.value == 2;

              return GestureDetector(
                onTap: () => controller.changeIndex(2),
                child: Container(
                  width: 62.h,
                  height: 62.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white,
                      width: 4.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(isSelected ? 90 : 50),
                        blurRadius: 14,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 30.sp,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String activeIcon,
    String inactiveIcon,
    String label,
    ProducerMainController controller,
  ) {
    return Obx(() {
      final bool isSelected = controller.currentIndex.value == index;

      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 64.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isSelected ? activeIcon : inactiveIcon,
                width: 22.h,
                height: 22.h,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// Beautiful Generic Placeholder Page
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 60.sp, color: AppColors.primary),
              ),
              SizedBox(height: 24.h),
              Text(
                "$title Screen",
                style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 8.h),
              Text(
                "This section is currently under construction and will be available in the next release.",
                style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
