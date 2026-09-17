import 'package:get/get.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/delete_all_notifications_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_all_notifications_usecase.dart';
import '../../domain/usecases/get_notifications_by_type_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImpl(),
      fenix: true,
    );
    Get.lazyPut<NotificationLocalDatasource>(
      () => NotificationLocalDatasourceImpl(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(
        remoteDatasource: Get.find<NotificationRemoteDatasource>(),
        localDatasource: Get.find<NotificationLocalDatasource>(),
      ),
      fenix: true,
    );

    // Use cases
    Get.lazyPut(() => GetAllNotificationsUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => GetUnreadCountUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => MarkAsReadUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => MarkAllAsReadUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => DeleteNotificationUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => DeleteAllNotificationsUsecase(Get.find<NotificationRepository>()), fenix: true);
    Get.lazyPut(() => GetNotificationsByTypeUsecase(Get.find<NotificationRepository>()), fenix: true);

    // Controller
    Get.lazyPut(
      () => NotificationController(
        getAllNotificationsUsecase: Get.find<GetAllNotificationsUsecase>(),
        getUnreadCountUsecase: Get.find<GetUnreadCountUsecase>(),
        markAsReadUsecase: Get.find<MarkAsReadUsecase>(),
        markAllAsReadUsecase: Get.find<MarkAllAsReadUsecase>(),
        deleteNotificationUsecase: Get.find<DeleteNotificationUsecase>(),
        deleteAllNotificationsUsecase: Get.find<DeleteAllNotificationsUsecase>(),
        getNotificationsByTypeUsecase: Get.find<GetNotificationsByTypeUsecase>(),
      ),
    );
  }
}