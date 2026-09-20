import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/enums/notification_status_enum.dart';
import 'package:project_structure/core/enums/notification_type_enum.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../../delivery/presentation/views/delivery_main_screen.dart';
import '../../../producer/presentation/views/orders/producer_delivered_order_screen.dart';
import '../controllers/notification_controller.dart';
import 'widgets/notification_empty_widget.dart';
import 'widgets/notification_filter_tab_widget.dart';
import 'widgets/notification_list_tile_widget.dart';
import 'widgets/notification_shimmer_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7), // Soft clean background
      body: Column(
        children: [
          // 1. Top Forest Green Header with Curved Bottom
          _buildTopAppBar(context),

          // 2. Filter Tabs Bar (All, Orders, Payments, Delivery)
          Obx(
            () => NotificationFilterTabWidget(
              selectedFilter: controller.selectedFilter.value,
              onFilterSelected: controller.changeFilter,
            ),
          ),

          // 3. Notification List Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const NotificationShimmerWidget();
              }

              if (controller.notifications.isEmpty) {
                return const NotificationEmptyWidget();
              }

              final today = DateTime.now();
              final todayNotifications = controller.notifications.where((n) {
                return n.createdAt.year == today.year &&
                    n.createdAt.month == today.month &&
                    n.createdAt.day == today.day;
              }).toList();

              final earlierNotifications = controller.notifications.where((n) {
                return !(n.createdAt.year == today.year &&
                    n.createdAt.month == today.month &&
                    n.createdAt.day == today.day);
              }).toList();

              final todayUnreadCount = todayNotifications
                  .where((n) => n.status == NotificationStatus.unread)
                  .length;

              return RefreshIndicator(
                onRefresh: controller.fetchNotifications,
                color: const Color(0xFF236830),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
                  children: [
                    // TODAY Section
                    if (todayNotifications.isNotEmpty) ...[
                      _buildSectionHeader('TODAY', todayUnreadCount),
                      ...todayNotifications.map((notification) {
                        return NotificationListTileWidget(
                          notification: notification,
                          onTap: () => _handleNotificationTap(notification, controller),
                          onDelete: () =>
                              controller.deleteSingleNotification(notification.id),
                        );
                      }),
                    ],

                    // EARLIER Section
                    if (earlierNotifications.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      _buildSectionHeader('EARLIER', 0),
                      ...earlierNotifications.map((notification) {
                        return NotificationListTileWidget(
                          notification: notification,
                          onTap: () => _handleNotificationTap(notification, controller),
                          onDelete: () =>
                              controller.deleteSingleNotification(notification.id),
                        );
                      }),
                    ],

                    // "You're all caught up" Footer Indicator
                    _buildCaughtUpWidget(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 1. TOP APP BAR WITH CURVED BOTTOM
  // ====================================================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 8.h,
        16.w,
        16.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF236830), // Solid forest green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Translucent Back Navigation Button
          GestureDetector(
            onTap: () => Get.back(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 14.w),

          // Title & Subtitle Stack
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AGROCONNECT',
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB5D9BB),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 1.5.h),
              Text(
                'Notifications',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 2. SECTION HEADER
  // ====================================================================
  Widget _buildSectionHeader(String title, int unreadCount) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 6.h),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2D24),
              letterSpacing: 0.8,
            ),
          ),
          if (unreadCount > 0) ...[
            SizedBox(width: 6.w),
            Container(
              width: 18.h,
              height: 18.h,
              decoration: const BoxDecoration(
                color: Color(0xFF236830),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$unreadCount',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ====================================================================
  // 3. CAUGHT UP FOOTER
  // ====================================================================
  Widget _buildCaughtUpWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: const Color(0xFF7A8C80),
            size: 16.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            "You're all caught up",
            style: GoogleFonts.inter(
              color: const Color(0xFF7A8C80),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 4. ACTION TAP DISPATCHER
  // ====================================================================
  void _handleNotificationTap(
      dynamic notification, NotificationController controller) {
    controller.markNotificationAsRead(notification.id);

    if (notification.actionLabel == 'View Wallet') {
      Get.offAll(() => const DeliveryMainScreen(initialIndex: 2));
      return;
    }

    if (notification.type == NotificationType.orderDelivered ||
        notification.payload?.referenceId == 'AGC-2830' ||
        notification.payload?.referenceId == 'AGC-2810') {
      Get.to(() => ProducerDeliveredOrderDetailScreen(
            orderId: notification.payload?.referenceId != null
                ? "#${notification.payload!.referenceId}"
                : "#AGC-2830",
          ));
      return;
    }

    if (notification.actionLabel == 'See Review') {
      AppSnackBar.info("Product review: 'Excellent quality, very fresh!'");
      return;
    }

    if (notification.actionLabel == 'View Details') {
      AppSnackBar.info("Payout #WDR-20240627-8821: ₦62,400 sent to GTB ****4412");
      return;
    }

    if (notification.actionLabel == 'Track') {
      AppSnackBar.info("Tracking active mission #AGC-2830");
      return;
    }
  }
}
