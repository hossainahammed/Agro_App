import 'package:get/get.dart';
import '../../features/notification/data/datasources/notification_local_datasource.dart';
import '../../features/notification/data/datasources/notification_remote_datasource.dart';
import '../../features/notification/data/repositories/notification_repository_impl.dart';
import '../../features/notification/domain/repositories/notification_repository.dart';
import '../../features/notification/domain/usecases/delete_all_notifications_usecase.dart';
import '../../features/notification/domain/usecases/delete_notification_usecase.dart';
import '../../features/notification/domain/usecases/get_all_notifications_usecase.dart';
import '../../features/notification/domain/usecases/get_notifications_by_type_usecase.dart';
import '../../features/notification/domain/usecases/get_unread_count_usecase.dart';
import '../../features/notification/domain/usecases/mark_all_as_read_usecase.dart';
import '../../features/notification/domain/usecases/mark_as_read_usecase.dart';
import '../../features/notification/presentation/controllers/notification_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // 1. Notification Data Sources
    Get.lazyPut<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImpl(),
      fenix: true,
    );
    Get.lazyPut<NotificationLocalDatasource>(
      () => NotificationLocalDatasourceImpl(),
      fenix: true,
    );

    // 2. Notification Repository
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(
        remoteDatasource: Get.find<NotificationRemoteDatasource>(),
        localDatasource: Get.find<NotificationLocalDatasource>(),
      ),
      fenix: true,
    );

    // 3. Notification Use Cases
    Get.lazyPut(() => GetAllNotificationsUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => GetUnreadCountUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => MarkAsReadUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => MarkAllAsReadUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => DeleteNotificationUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => DeleteAllNotificationsUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => GetNotificationsByTypeUsecase(Get.find<NotificationRepository>()), fenix: true);

    // 4. Global Notification Controller
    Get.put(
      NotificationController(
        getAllNotificationsUsecase: Get.find<GetAllNotificationsUsecase>(),
        getUnreadCountUsecase: Get.find<GetUnreadCountUsecase>(),
        markAsReadUsecase: Get.find<MarkAsReadUsecase>(),
        markAllAsReadUsecase: Get.find<MarkAllAsReadUsecase>(),
        deleteNotificationUsecase: Get.find<DeleteNotificationUsecase>(),
        deleteAllNotificationsUsecase: Get.find<DeleteAllNotificationsUsecase>(),
        getNotificationsByTypeUsecase: Get.find<GetNotificationsByTypeUsecase>(),
      ),
      permanent: true,
    );
  }
}