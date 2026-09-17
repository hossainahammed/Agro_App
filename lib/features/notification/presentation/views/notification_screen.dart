import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/notification_status_enum.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../controllers/notification_controller.dart';
import 'widgets/notification_empty_widget.dart';
import 'widgets/notification_filter_tab_widget.dart';
import 'widgets/notification_list_tile_widget.dart';
import 'widgets/notification_shimmer_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final RxBool showHighlightCard = true.obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7), // soft light background
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            radius: 18,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AGROCONNECT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB5D9BB), // light matching green
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Tabs
            Obx(
              () => NotificationFilterTabWidget(
                selectedFilter: controller.selectedFilter.value,
                onFilterSelected: controller.changeFilter,
              ),
            ),
            
            // Notification List Area
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const NotificationShimmerWidget();
                }

                if (controller.notifications.isEmpty) {
                  return const NotificationEmptyWidget();
                }

                // Filter notifications locally
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
                  color: AppColors.primary,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      // Highlight Delivery Card at top (Dismissible)
                      Obx(() {
                        if (showHighlightCard.value && controller.selectedFilter.value == 'All') {
                          return _buildHighlightCard();
                        }
                        return const SizedBox.shrink();
                      }),

                      // TODAY section
                      if (todayNotifications.isNotEmpty) ...[
                        _buildSectionHeader('TODAY', todayUnreadCount),
                        ...todayNotifications.map((notification) {
                          return NotificationListTileWidget(
                            notification: notification,
                            onTap: () {
                              controller.markNotificationAsRead(notification.id);
                            },
                            onDelete: () {
                              controller.deleteSingleNotification(notification.id);
                            },
                          );
                        }),
                      ],

                      // EARLIER section
                      if (earlierNotifications.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildSectionHeader('EARLIER', 0),
                        ...earlierNotifications.map((notification) {
                          return NotificationListTileWidget(
                            notification: notification,
                            onTap: () {
                              controller.markNotificationAsRead(notification.id);
                            },
                            onDelete: () {
                              controller.deleteSingleNotification(notification.id);
                            },
                          );
                        }),
                      ],

                      // Caught up indicator
                      _buildCaughtUpWidget(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.8,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(
              color: Color(0xFFE5E7EB),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF7EE), // soft green
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC6E8C7),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Top indicator line
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon leading
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined, // box icon
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'AGROCONNECT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                'Just now',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Order Delivered!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Your order #AGC-2830 has arrived',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          // Handle View Order
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View order',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Close button
                GestureDetector(
                  onTap: () => showHighlightCard.value = false,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaughtUpWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.primary.withValues(alpha: 0.5),
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            "You're all caught up",
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
