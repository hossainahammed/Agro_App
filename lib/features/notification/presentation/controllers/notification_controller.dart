import 'package:get/get.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/delete_all_notifications_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_all_notifications_usecase.dart';
import '../../domain/usecases/get_notifications_by_type_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';

class NotificationController extends GetxController {
  final GetAllNotificationsUsecase getAllNotificationsUsecase;
  final GetUnreadCountUsecase getUnreadCountUsecase;
  final MarkAsReadUsecase markAsReadUsecase;
  final MarkAllAsReadUsecase markAllAsReadUsecase;
  final DeleteNotificationUsecase deleteNotificationUsecase;
  final DeleteAllNotificationsUsecase deleteAllNotificationsUsecase;
  final GetNotificationsByTypeUsecase getNotificationsByTypeUsecase;

  NotificationController({
    required this.getAllNotificationsUsecase,
    required this.getUnreadCountUsecase,
    required this.markAsReadUsecase,
    required this.markAllAsReadUsecase,
    required this.deleteNotificationUsecase,
    required this.deleteAllNotificationsUsecase,
    required this.getNotificationsByTypeUsecase,
  });

  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt unreadCount = 0.obs;
  final RxString selectedFilter = 'All'.obs; // All, Orders, Delivery, Promo

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final List<NotificationEntity> fetchedList;
      if (selectedFilter.value == 'All') {
        fetchedList = await getAllNotificationsUsecase();
      } else {
        fetchedList = await getNotificationsByTypeUsecase(selectedFilter.value);
      }
      notifications.assignAll(fetchedList);
      await fetchUnreadCount();
    } catch (_) {
      // Handle error (Future work)
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      unreadCount.value = await getUnreadCountUsecase();
    } catch (_) {}
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      await markAsReadUsecase(id);
      final index = notifications.indexWhere((element) => element.id == id);
      if (index != -1) {
        // Mock UI state update for local performance
        // notifications[index] = notifications[index].copyWith(status: NotificationStatus.read);
      }
      await fetchUnreadCount();
      await fetchNotifications();
    } catch (_) {}
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      isLoading.value = true;
      await markAllAsReadUsecase();
      await fetchUnreadCount();
      await fetchNotifications();
    } catch (_) {} finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSingleNotification(String id) async {
    try {
      await deleteNotificationUsecase(id);
      await fetchUnreadCount();
      await fetchNotifications();
    } catch (_) {}
  }

  Future<void> clearAllNotifications() async {
    try {
      isLoading.value = true;
      await deleteAllNotificationsUsecase();
      notifications.clear();
      unreadCount.value = 0;
    } catch (_) {} finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    fetchNotifications();
  }
}
