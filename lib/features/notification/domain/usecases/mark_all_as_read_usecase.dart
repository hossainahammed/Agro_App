import '../repositories/notification_repository.dart';

class MarkAllAsReadUsecase {
  final NotificationRepository repository;

  MarkAllAsReadUsecase(this.repository);

  Future<void> call() async {
    await repository.markAllAsRead();
  }
}