import 'dart:developer';
import '../../../../core/enums/notification_status_enum.dart';
import '../../../../core/enums/notification_type_enum.dart';
import '../models/notification_model.dart';
import '../models/notification_payload_model.dart';

abstract class NotificationRemoteDatasource {
  Future<List<NotificationModel>> getAllNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  // Mock notifications list that reflects the screenshot design
  final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: '1',
      title: 'New Order Received',
      body: 'Aisha Musa placed an order for 6 crates of Fresh Roma Tomatoes. Review and accept to proceed.',
      type: NotificationType.orderPlaced,
      status: NotificationStatus.unread,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)), // Today 9:14 AM
      actionLabel: 'View Order',
      payload: const NotificationPayloadModel(role: 'PRODUCER', referenceId: 'AGC-2830'),
    ),
    NotificationModel(
      id: '2',
      title: 'Payment Confirmed',
      body: '₦27,100 has been credited to your AgroConnect wallet for order #AGC-2839.',
      type: NotificationType.earningCredited,
      status: NotificationStatus.unread,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)), // Today 8:50 AM
      actionLabel: 'View Wallet',
      payload: const NotificationPayloadModel(role: 'PRODUCER', referenceId: 'AGC-2839'),
    ),
    NotificationModel(
      id: '3',
      title: 'Order Picked Up',
      body: 'Ibrahim Suleiman picked up order #AGC-2830 (Organic Pepper × 3kg). Delivery is in progress.',
      type: NotificationType.orderShipped,
      status: NotificationStatus.unread,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)), // Today 8:22 AM
      actionLabel: 'Track',
      payload: const NotificationPayloadModel(role: 'PRODUCER', referenceId: 'AGC-2830'),
    ),
    NotificationModel(
      id: '4',
      title: 'New Review on Your Product',
      body: 'Chukwudi Eze rated Fresh Roma Tomatoes\n★★★★★ — "Excellent quality, very fresh!"',
      type: NotificationType.reviewReceived,
      status: NotificationStatus.read,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)), // Today 7:41 AM
      actionLabel: 'See Review',
      payload: const NotificationPayloadModel(role: 'PRODUCER', referenceId: 'prod-tomato'),
    ),
    NotificationModel(
      id: '5',
      title: 'Certification Approved',
      body: 'Your product "Cassava Flour" has been certified by the AgroConnect quality team. It now carries a verified badge.',
      type: NotificationType.system,
      status: NotificationStatus.read,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)), // Today 6:05 AM
      actionLabel: null,
      payload: const NotificationPayloadModel(role: 'PRODUCER', referenceId: 'cert-flour'),
    ),
    NotificationModel(
      id: '6',
      title: 'Order Cancelled',
      body: 'Chidinma Obi cancelled order #AGC-2780 for Sweet Corn. Reason: delivery delay.',
      type: NotificationType.orderCancelled,
      status: NotificationStatus.read,
      createdAt: DateTime.now().subtract(const Duration(days: 1)), // Yesterday 1:10 PM
      actionLabel: 'View Order',
      payload: const NotificationPayloadModel(role: 'PRODUCER', referenceId: 'AGC-2780'),
    ),
    NotificationModel(
      id: '7',
      title: 'Payout Processed',
      body: '₦62,400 has been sent to your bank account (GTB ****4412). Funds arrive in 1–2 business days.',
      type: NotificationType.earningCredited,
      status: NotificationStatus.read,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)), // Yesterday 10:30 AM
      actionLabel: 'View Details',
      payload: const NotificationPayloadModel(role: 'PRODUCER', referenceId: 'payout-12'),
    ),
    NotificationModel(
      id: '8',
      title: 'Referral Bonus Earned',
      body: 'You earned ₦1,500 for referring Yusuf Garba to AgroConnect. Bonus added to your wallet.',
      type: NotificationType.system,
      status: NotificationStatus.read,
      createdAt: DateTime.now().subtract(const Duration(days: 2)), // Jun 15
      actionLabel: 'View Wallet',
      payload: const NotificationPayloadModel(role: 'PRODUCER'),
    ),
  ];

  @override
  Future<List<NotificationModel>> getAllNotifications() async {
    log('RemoteDatasource: Fetching notifications...');
    return List.from(_mockNotifications);
  }

  @override
  Future<void> markAsRead(String id) async {
    log('RemoteDatasource: Marking notification $id as read');
    final index = _mockNotifications.indexWhere((element) => element.id == id);
    if (index != -1) {
      _mockNotifications[index] = _mockNotifications[index].copyWith(
        status: NotificationStatus.read,
      ) as NotificationModel;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    log('RemoteDatasource: Marking all notifications as read');
    for (int i = 0; i < _mockNotifications.length; i++) {
      _mockNotifications[i] = _mockNotifications[i].copyWith(
        status: NotificationStatus.read,
      ) as NotificationModel;
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    log('RemoteDatasource: Deleting notification $id');
    _mockNotifications.removeWhere((element) => element.id == id);
  }

  @override
  Future<void> deleteAllNotifications() async {
    log('RemoteDatasource: Deleting all notifications');
    _mockNotifications.clear();
  }
}