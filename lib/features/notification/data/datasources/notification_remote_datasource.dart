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
  static List<NotificationModel> _generateMockNotifications() {
    final now = DateTime.now();
    return [
      // 1. TODAY (9:14 AM) - Orders (Unread)
      NotificationModel(
        id: '1',
        title: 'New Order Received',
        body:
            'Aisha Musa placed an order for 6 crates of Fresh Roma Tomatoes. Review and accept to proceed.',
        type: NotificationType.orderPlaced,
        status: NotificationStatus.unread,
        createdAt: DateTime(now.year, now.month, now.day, 9, 14),
        actionLabel: 'View Order',
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'AGC-2830'),
      ),
      // 2. TODAY (8:50 AM) - Payments (Unread)
      NotificationModel(
        id: '2',
        title: 'Payment Confirmed',
        body:
            '₦27,100 has been credited to your AgroConnect wallet for order #AGC-2839.',
        type: NotificationType.earningCredited,
        status: NotificationStatus.unread,
        createdAt: DateTime(now.year, now.month, now.day, 8, 50),
        actionLabel: 'View Wallet',
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'AGC-2839'),
      ),
      // 3. TODAY (8:22 AM) - Delivery (Unread)
      NotificationModel(
        id: '3',
        title: 'Order Picked Up',
        body:
            'Ibrahim Suleiman picked up order #AGC-2830 (Organic Pepper × 3kg). Delivery is in progress.',
        type: NotificationType.orderShipped,
        status: NotificationStatus.unread,
        createdAt: DateTime(now.year, now.month, now.day, 8, 22),
        actionLabel: 'Track',
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'AGC-2830'),
      ),
      // 4. TODAY (7:41 AM) - Reviews (Read)
      NotificationModel(
        id: '4',
        title: 'New Review on Your Product',
        body:
            'Chukwudi Eze rated Fresh Roma Tomatoes ★★★★★ - "Excellent quality, very fresh!"',
        type: NotificationType.reviewReceived,
        status: NotificationStatus.read,
        createdAt: DateTime(now.year, now.month, now.day, 7, 41),
        actionLabel: 'See Review',
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'prod-tomato'),
      ),
      // 5. TODAY (6:09 AM) - System / Certification (Read)
      NotificationModel(
        id: '5',
        title: 'Certification Approved',
        body:
            'Your product "Cassava Flour" has been certified by the AgroConnect quality team. It now carries a verified badge.',
        type: NotificationType.system,
        status: NotificationStatus.read,
        createdAt: DateTime(now.year, now.month, now.day, 6, 9),
        actionLabel: null,
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'cert-flour'),
      ),
      // 6. EARLIER - Yesterday 1:10 PM - Orders (Read)
      NotificationModel(
        id: '6',
        title: 'Order Cancelled',
        body:
            'Chidinma Obi cancelled order #AGC-2780 for Sweet Corn. Reason: delivery delay.',
        type: NotificationType.orderCancelled,
        status: NotificationStatus.read,
        createdAt: DateTime(now.year, now.month, now.day - 1, 13, 10),
        actionLabel: 'View Order',
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'AGC-2780'),
      ),
      // 7. EARLIER - Yesterday 10:30 AM - Payments (Read)
      NotificationModel(
        id: '7',
        title: 'Payout Processed',
        body:
            '₦62,400 has been sent to your bank account (GTB ****4412). Funds arrive in 1–2 business days.',
        type: NotificationType.earningCredited,
        status: NotificationStatus.read,
        createdAt: DateTime(now.year, now.month, now.day - 1, 10, 30),
        actionLabel: 'View Details',
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'payout-12'),
      ),
      // 8. EARLIER - Jun 17 · 3:48 PM - Delivery (Read)
      NotificationModel(
        id: '8',
        title: 'Order Delivered',
        body:
            'Order #AGC-2810 (Cassava Flour × 20 bags) was successfully delivered to Ngozi Adaeze in Port Harcourt.',
        type: NotificationType.orderDelivered,
        status: NotificationStatus.read,
        createdAt: DateTime(now.year, 6, 17, 15, 48),
        actionLabel: null,
        payload: const NotificationPayloadModel(role: 'DRIVER', referenceId: 'AGC-2810'),
      ),
      // 9. EARLIER - Jun 15 · 11:20 AM - Payments (Read)
      NotificationModel(
        id: '9',
        title: 'Referral Bonus Earned',
        body:
            'You earned ₦1,500 for referring Yusuf Garba to AgroConnect. Bonus added to your wallet.',
        type: NotificationType.earningCredited,
        status: NotificationStatus.read,
        createdAt: DateTime(now.year, 6, 15, 11, 20),
        actionLabel: 'View Wallet',
        payload: const NotificationPayloadModel(role: 'DRIVER'),
      ),
    ];
  }

  late final List<NotificationModel> _mockNotifications = _generateMockNotifications();

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