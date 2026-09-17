import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetAllNotificationsUsecase {
  final NotificationRepository repository;

  GetAllNotificationsUsecase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return await repository.getAllNotifications();
  }
}