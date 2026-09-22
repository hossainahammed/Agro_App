import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'buyer_dashboard_screen.dart';
import 'browse/product_browse_screen.dart';
import 'cart/cart_screen.dart';
import 'orders/order_list_screen.dart';
import 'profile/buyer_profile_screen.dart';
import '../controllers/buyer_home_controller.dart';

class BuyerMainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class BuyerMainScreen extends StatelessWidget {
  final int? initialIndex;

  const BuyerMainScreen({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.isRegistered<BuyerMainController>()
        ? Get.find<BuyerMainController>()
        : Get.put(BuyerMainController());

    final homeController = Get.isRegistered<BuyerHomeController>()
        ? Get.find<BuyerHomeController>()
        : Get.put(BuyerHomeController());

    if (initialIndex != null) {
      navigationController.currentIndex.value = initialIndex!;
    }

    final List<Widget> screens = [
      const BuyerDashboardScreen(),
      const ProductBrowseScreen(),
      const CartScreen(),
      const OrderListScreen(),
      const BuyerProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE),
      body: Obx(() => screens[navigationController.currentIndex.value]),
      bottomNavigationBar:
          _buildBottomNavigationBar(context, navigationController, homeController),
    );
  }

  // ========================================================
  // BOTTOM NAVIGATION BAR (Matching Mockup with Active Pill)
  // ========================================================
  Widget _buildBottomNavigationBar(
    BuildContext context,
    BuyerMainController navController,
    BuyerHomeController homeController,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2EDE4).withValues(alpha: 0.8),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 4.h
            : 8.h,
      ),
      child: Obx(() {
        final currentIdx = navController.currentIndex.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: "Home",
              isSelected: currentIdx == 0,
              onTap: () => navController.changeIndex(0),
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.window_outlined,
              activeIcon: Icons.window_rounded,
              label: "Browse",
              isSelected: currentIdx == 1,
              onTap: () => navController.changeIndex(1),
            ),
            _buildCartNavItem(
              index: 2,
              icon: Icons.shopping_cart_outlined,
              activeIcon: Icons.shopping_cart_rounded,
              label: "Cart",
              isSelected: currentIdx == 2,
              cartCount: homeController.cartCount.value,
              onTap: () => navController.changeIndex(2),
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long_rounded,
              label: "Orders",
              isSelected: currentIdx == 3,
              onTap: () => navController.changeIndex(3),
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: "Profile",
              isSelected: currentIdx == 4,
              onTap: () => navController.changeIndex(4),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h)
            : EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F3ED) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22.sp,
              color: isSelected
                  ? const Color(0xFF236830)
                  : const Color(0xFF7A8C80),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF236830)
                    : const Color(0xFF7A8C80),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required int cartCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h)
            : EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F3ED) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22.sp,
                  color: isSelected
                      ? const Color(0xFF236830)
                      : const Color(0xFF7A8C80),
                ),
                if (cartCount > 0)
                  Positioned(
                    right: -7.w,
                    top: -5.h,
                    child: Container(
                      padding: EdgeInsets.all(3.h),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.h,
                        minHeight: 16.h,
                      ),
                      child: Center(
                        child: Text(
                          cartCount > 9 ? '9+' : '$cartCount',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF236830)
                    : const Color(0xFF7A8C80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
