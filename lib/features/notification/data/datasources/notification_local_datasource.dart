import 'dart:developer';
import '../models/notification_model.dart';

abstract class NotificationLocalDatasource {
  Future<List<NotificationModel>> getCachedNotifications();
  Future<void> cacheNotifications(List<NotificationModel> notifications);
  Future<void> clearCache();
}

class NotificationLocalDatasourceImpl implements NotificationLocalDatasource {
  // Future work: Inject Local DB dependencies like Hive or SharedPreferences

  @override
  Future<List<NotificationModel>> getCachedNotifications() async {
    log('LocalDatasource: Fetching cached notifications...');
    return [];
  }

  @override
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    log('LocalDatasource: Caching ${notifications.length} notifications...');
  }

  @override
  Future<void> clearCache() async {
    log('LocalDatasource: Clearing cache...');
  }
}