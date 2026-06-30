import '../../../../core/enums/notification_status_enum.dart';
import '../../../../core/enums/notification_type_enum.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_payload_model.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.status,
    required super.createdAt,
    super.payload,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Parse Type
    final String typeStr = json['type'] as String? ?? 'system';
    final NotificationType type = NotificationType.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == typeStr.toLowerCase(),
      orElse: () => NotificationType.system,
    );

    // Parse Status
    final String statusStr = json['status'] as String? ?? 'unread';
    final NotificationStatus status = NotificationStatus.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == statusStr.toLowerCase(),
      orElse: () => NotificationStatus.unread,
    );

    return NotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: type,
      status: status,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      payload: json['payload'] != null
          ? NotificationPayloadModel.fromJson(json['payload'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'payload': payload != null ? (payload as NotificationPayloadModel).toJson() : null,
    };
  }
}
