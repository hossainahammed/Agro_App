import '../repositories/notification_repository.dart';

class DeleteNotificationUsecase {
  final NotificationRepository repository;

  DeleteNotificationUsecase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteNotification(id);
  }
}