import 'dart:developer';
import '../enums/notification_type_enum.dart';

class NotificationNavigationService {
  static final NotificationNavigationService _instance =
      NotificationNavigationService._internal();
  factory NotificationNavigationService() => _instance;
  NotificationNavigationService._internal();

  /// Parse the payload and navigate accordingly
  void navigateToScreen(Map<String, dynamic> data) {
    try {
      final String? typeString = data['type'];
      final String? role = data['role']; // e.g. PRODUCER, BUYER, DELIVERY
      final String? referenceId = data['reference_id']; // e.g. orderId, jobId

      if (typeString == null) {
        log('NotificationNavigationService: No type specified in payload data.');
        return;
      }

      // Convert string to enum (safely)
      NotificationType? type;
      try {
        type = NotificationType.values.firstWhere(
          (e) => e.toString().split('.').last.toUpperCase() == typeString.toUpperCase(),
        );
      } catch (_) {
        log('NotificationNavigationService: Unknown notification type "$typeString"');
      }

      if (type == null) return;

      log('Navigating based on: type=$type, role=$role, referenceId=$referenceId');

      switch (type) {
        // PRODUCER types
        case NotificationType.orderPlaced:
        case NotificationType.orderCancelled:
        case NotificationType.reviewReceived:
          // TODO: Navigate to Producer Order Details Screen
          // Get.toNamed('/producer/orders/$referenceId');
          log('Should navigate to Producer Order/Review Detail screen');
          break;

        case NotificationType.lowStock:
          // TODO: Navigate to Producer Product Details or Stock list
          log('Should navigate to Producer Stock screen');
          break;

        // BUYER types
        case NotificationType.orderConfirmed:
        case NotificationType.orderShipped:
        case NotificationType.orderDelivered:
          // TODO: Navigate to Buyer Order Details Screen
          // Get.toNamed('/buyer/orders/$referenceId');
          log('Should navigate to Buyer Order Detail screen');
          break;

        case NotificationType.promo:
          // TODO: Navigate to Promotions/Offers page
          log('Should navigate to Promotions screen');
          break;

        // DELIVERY types
        case NotificationType.newJob:
        case NotificationType.jobCancelled:
          // TODO: Navigate to Delivery Job Detail Screen
          // Get.toNamed('/delivery/jobs/$referenceId');
          log('Should navigate to Delivery Job screen');
          break;

        case NotificationType.earningCredited:
          // TODO: Navigate to Earnings screen
          log('Should navigate to Earnings screen');
          break;

        case NotificationType.ratingReceived:
          // TODO: Navigate to Reviews/Ratings screen
          log('Should navigate to Delivery Ratings screen');
          break;

        // General
        case NotificationType.system:
          // TODO: Navigate to generic notifications or App settings
          log('Should navigate to System settings or list');
          break;
      }
    } catch (e) {
      log('Error during notification navigation: $e');
    }
  }
}
