import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import '../controllers/notification_controller.dart';
import 'widgets/notification_empty_widget.dart';
import 'widgets/notification_filter_tab_widget.dart';
import 'widgets/notification_header_widget.dart';
import 'widgets/notification_list_tile_widget.dart';
import 'widgets/notification_shimmer_widget.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
            onPressed: () {
              Get.defaultDialog(
                title: 'Clear All',
                middleText: 'Are you sure you want to delete all notifications?',
                textConfirm: 'Yes',
                textCancel: 'No',
                confirmTextColor: AppColors.white,
                buttonColor: AppColors.primary,
                onConfirm: () {
                  controller.clearAllNotifications();
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Mark All Read
            Obx(
              () => NotificationHeaderWidget(
                unreadCount: controller.unreadCount.value,
                onMarkAllRead: controller.markAllNotificationsAsRead,
              ),
            ),
            // Filter Tabs
            Obx(
              () => NotificationFilterTabWidget(
                selectedFilter: controller.selectedFilter.value,
                onFilterSelected: controller.changeFilter,
              ),
            ),
            // Notification List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const NotificationShimmerWidget();
                }

                if (controller.notifications.isEmpty) {
                  return const NotificationEmptyWidget();
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchNotifications,
                  color: AppColors.primary,
                  child: ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return NotificationListTileWidget(
                        notification: notification,
                        onTap: () {
                          controller.markNotificationAsRead(notification.id);
                        },
                        onDelete: () {
                          controller.deleteSingleNotification(notification.id);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
