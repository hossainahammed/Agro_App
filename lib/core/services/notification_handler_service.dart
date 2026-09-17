import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_navigation_service.dart';

class NotificationHandlerService {
  static final NotificationHandlerService _instance =
      NotificationHandlerService._internal();
  factory NotificationHandlerService() => _instance;
  NotificationHandlerService._internal();

  final NotificationNavigationService _navigationService =
      NotificationNavigationService();

  /// Handle incoming messages in foreground or background/terminated states
  Future<void> handleNotification(RemoteMessage message, {required bool isTap}) async {
    log('Handling notification: messageId=${message.messageId}, isTap=$isTap');

    // 1. Parse payload details
    final data = message.data;
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';

    log('Notification Details: Title: "$title", Body: "$body", Data: $data');

    // 2. Save notification to local/remote DB (Future work)
    // TODO: Call API or repository to save notification locally

    // 3. Navigate if tapped
    if (isTap) {
      _navigationService.navigateToScreen(data);
    }
  }
}