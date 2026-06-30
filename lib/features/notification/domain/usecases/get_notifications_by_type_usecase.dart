import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsByTypeUsecase {
  final NotificationRepository repository;

  GetNotificationsByTypeUsecase(this.repository);

  Future<List<NotificationEntity>> call(String role) async {
    return await repository.getNotificationsByType(role);
  }
}