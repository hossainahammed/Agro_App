import '../../domain/entities/notification_payload_entity.dart';

class NotificationPayloadModel extends NotificationPayloadEntity {
  const NotificationPayloadModel({
    super.role,
    super.referenceId,
  });

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    return NotificationPayloadModel(
      role: json['role'] as String?,
      referenceId: json['reference_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'reference_id': referenceId,
    };
  }
}
