import 'package:flutter/material.dart';
import 'package:project_structure/core/enums/notification_status_enum.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/features/notification/domain/entities/notification_entity.dart';

class NotificationListTileWidget extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationListTileWidget({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = notification.status == NotificationStatus.unread;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: isUnread ? AppColors.containerSoft : AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUnread ? AppColors.primary.withValues(alpha: 0.2) : AppColors.containerBorder,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isUnread ? AppColors.primary.withValues(alpha: 0.1) : AppColors.containerBorder,
          child: Icon(
            _getIconForType(notification.type),
            color: isUnread ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.body,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatDate(notification.createdAt),
              style: TextStyle(
                color: AppColors.hintColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
          onPressed: onDelete,
        ),
      ),
    );
  }

  IconData _getIconForType(dynamic type) {
    // Return appropriate icon depending on type (Future work)
    return Icons.notifications_none;
  }

  String _formatDate(DateTime date) {
    // Simple format for stub (Future work can use intl Package)
    return '${date.day}/${date.month}/${date.year}';
  }
}