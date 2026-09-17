import '../repositories/notification_repository.dart';

class DeleteAllNotificationsUsecase {
  final NotificationRepository repository;

  DeleteAllNotificationsUsecase(this.repository);

  Future<void> call() async {
    await repository.deleteAllNotifications();
  }
}