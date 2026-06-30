import '../../../../core/enums/notification_status_enum.dart';
import '../../../../core/enums/notification_type_enum.dart';
import 'notification_payload_entity.dart';

class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationStatus status;
  final DateTime createdAt;
  final NotificationPayloadEntity? payload;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.status,
    required this.createdAt,
    this.payload,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    NotificationStatus? status,
    DateTime? createdAt,
    NotificationPayloadEntity? payload,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      payload: payload ?? this.payload,
    );
  }
}