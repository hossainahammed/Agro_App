import '../repositories/notification_repository.dart';

class MarkAsReadUsecase {
  final NotificationRepository repository;

  MarkAsReadUsecase(this.repository);

  Future<void> call(String id) async {
    await repository.markAsRead(id);
  }
}