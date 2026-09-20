import '../../../../core/enums/notification_type_enum.dart';
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
    return list.where((item) => item.status.toString().contains('unread')).length;
  }

  @override
  Future<void> markAsRead(String id) async {
    await remoteDatasource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    await remoteDatasource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(String id) async {
    await remoteDatasource.deleteNotification(id);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await remoteDatasource.deleteAllNotifications();
    await localDatasource.clearCache();
  }

  @override
  Future<List<NotificationEntity>> getNotificationsByType(String category) async {
    final all = await getAllNotifications();
    
    switch (category.toLowerCase()) {
      case 'orders':
      case 'order':
        return all
            .where((n) =>
                n.type == NotificationType.orderPlaced ||
                n.type == NotificationType.orderCancelled)
            .toList();
      case 'payments':
      case 'payment':
        return all
            .where((n) =>
                n.type == NotificationType.earningCredited ||
                n.title.toLowerCase().contains('payment') ||
                n.title.toLowerCase().contains('payout') ||
                n.title.toLowerCase().contains('bonus'))
            .toList();
      case 'delivery':
        return all
            .where((n) =>
                n.type == NotificationType.orderShipped ||
                n.type == NotificationType.orderDelivered)
            .toList();
      default:
        return all;
    }
  }
}