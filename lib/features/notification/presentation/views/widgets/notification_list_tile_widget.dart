import 'package:flutter/material.dart';
import 'package:project_structure/core/enums/notification_status_enum.dart';
import 'package:project_structure/core/enums/notification_type_enum.dart';
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

    // Resolve color styling based on notification type
    final iconConfig = _getIconConfigForType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24.0),
        child: const Icon(Icons.delete_outline, color: AppColors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFFF4F9F5) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread ? AppColors.primary.withValues(alpha: 0.15) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Unread indicator left bar
                if (isUnread)
                  Container(
                    width: 4,
                    color: AppColors.primary,
                  ),
                
                // Content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Leading circular icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: iconConfig['bgColor'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            iconConfig['icon'] as IconData,
                            color: iconConfig['iconColor'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Text details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Time row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (isUnread) ...[
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            style: TextStyle(
                                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(notification.createdAt),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              
                              // Body
                              _buildBody(context),
                              
                              // Action Button/Link
                              if (notification.actionLabel != null) ...[
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: onTap,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        notification.actionLabel!,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.chevron_right,
                                        size: 14,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (notification.type == NotificationType.reviewReceived) {
      // Split rating and comments if present in body
      final parts = notification.body.split('\n');
      if (parts.length > 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parts[0],
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.3),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(Icons.star, color: Color(0xFFF7A422), size: 14),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    parts[1].replaceAll('★★★★★ — ', ''),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    }

    return Text(
      notification.body,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        height: 1.4,
      ),
    );
  }

  Map<String, dynamic> _getIconConfigForType(NotificationType type) {
    switch (type) {
      case NotificationType.orderPlaced:
      case NotificationType.orderCancelled:
        return {
          'bgColor': const Color(0xFFFFF7ED),
          'iconColor': const Color(0xFFEA580C),
          'icon': Icons.shopping_cart_outlined,
        };
      case NotificationType.earningCredited:
        return {
          'bgColor': const Color(0xFFF0FDF4),
          'iconColor': const Color(0xFF16A34A),
          'icon': Icons.attach_money,
        };
      case NotificationType.orderShipped:
      case NotificationType.orderDelivered:
        return {
          'bgColor': const Color(0xFFFAF5FF),
          'iconColor': const Color(0xFF9333EA),
          'icon': Icons.local_shipping_outlined,
        };
      case NotificationType.reviewReceived:
        return {
          'bgColor': const Color(0xFFFFFBEB),
          'iconColor': const Color(0xFFD97706),
          'icon': Icons.star_outline,
        };
      default:
        return {
          'bgColor': const Color(0xFFEFF6FF),
          'iconColor': const Color(0xFF2563EB),
          'icon': Icons.verified_outlined,
        };
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      if (difference.inMinutes <= 1) return 'Just now';
      return '${difference.inMinutes}m ago';
    } else if (date.year == now.year && date.month == now.month && date.day == now.day) {
      // Format hour and minute
      final hourStr = date.hour > 12 ? '${date.hour - 12}' : '${date.hour}';
      final minStr = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '$hourStr:$minStr $period';
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      final hourStr = date.hour > 12 ? '${date.hour - 12}' : '${date.hour}';
      final minStr = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return 'Yesterday · $hourStr:$minStr $period';
    } else {
      // Month names
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final monthStr = months[date.month - 1];
      final hourStr = date.hour > 12 ? '${date.hour - 12}' : '${date.hour}';
      final minStr = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '$monthStr ${date.day} · $hourStr:$minStr $period';
    }
  }
}