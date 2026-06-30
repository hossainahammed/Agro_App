import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;
  final NotificationLocalDatasource localDatasource;

  NotificationRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    try {
      // Future work: implement network check and local caching flow
      final remoteData = await remoteDatasource.getAllNotifications();
      if (remoteData.isNotEmpty) {
        await localDatasource.cacheNotifications(remoteData);
      }
      return remoteData;
    } catch (_) {
      return await localDatasource.getCachedNotifications();
    }
  }

  @override
  Future<int> getUnreadCount() async {
    final list = await getAllNotifications();
    // Assuming status logic
    return list.where((item) => item.status.toString().contains('unread')).length;
  }

  @override
  Future<void> markAsRead(String id) async {
    await remoteDatasource.markAsRead(id);
    // Future work: update status in local cache
  }

  @override
  Future<void> markAllAsRead() async {
    await remoteDatasource.markAllAsRead();
    // Future work: update all statuses in local cache
  }

  @override
  Future<void> deleteNotification(String id) async {
    await remoteDatasource.deleteNotification(id);
    // Future work: remove from local cache
  }

  @override
  Future<void> deleteAllNotifications() async {
    await remoteDatasource.deleteAllNotifications();
    await localDatasource.clearCache();
  }

  @override
  Future<List<NotificationEntity>> getNotificationsByType(String role) async {
    final all = await getAllNotifications();
    return all.where((n) => n.payload?.role?.toUpperCase() == role.toUpperCase()).toList();
  }
}