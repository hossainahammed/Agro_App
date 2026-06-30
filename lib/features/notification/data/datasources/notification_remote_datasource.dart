import 'dart:developer';
import '../models/notification_model.dart';

abstract class NotificationRemoteDatasource {
  Future<List<NotificationModel>> getAllNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  // final NetworkCaller _networkCaller = NetworkCaller(); // Future work: Inject/use NetworkCaller

  @override
  Future<List<NotificationModel>> getAllNotifications() async {
    log('RemoteDatasource: Fetching notifications...');
    // Future implementation: call remote server
    // final response = await _networkCaller.getRequest(AppUrls.notifications);
    return [];
  }

  @override
  Future<void> markAsRead(String id) async {
    log('RemoteDatasource: Marking notification $id as read');
    // Future implementation: call remote server
  }

  @override
  Future<void> markAllAsRead() async {
    log('RemoteDatasource: Marking all notifications as read');
    // Future implementation: call remote server
  }

  @override
  Future<void> deleteNotification(String id) async {
    log('RemoteDatasource: Deleting notification $id');
    // Future implementation: call remote server
  }

  @override
  Future<void> deleteAllNotifications() async {
    log('RemoteDatasource: Deleting all notifications');
    // Future implementation: call remote server
  }
}