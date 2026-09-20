import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/enums/notification_status_enum.dart';
import 'package:project_structure/core/enums/notification_type_enum.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
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
    final iconConfig = _getIconConfigForType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.5.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(14.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isUnread ? const Color(0xFFD6E8DA) : const Color(0xFFE5EDE6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Green Indicator Bar on the far left for Unread
                if (isUnread)
                  Container(
                    width: 3.8.w,
                    color: const Color(0xFF236830),
                  ),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Icon Rounded Container
                        Container(
                          width: 40.h,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: iconConfig['bgColor'] as Color,
                            borderRadius: BorderRadius.circular(11.r),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            iconConfig['icon'] as IconData,
                            color: iconConfig['iconColor'] as Color,
                            size: 19.sp,
                          ),
                        ),
                        SizedBox(width: 11.w),

                        // Details Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Time Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Green Dot for unread + Title
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (isUnread) ...[
                                          Container(
                                            width: 5.5.h,
                                            height: 5.5.h,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF236830),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                        ],
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            style: GoogleFonts.inter(
                                              fontSize: 13.5.sp,
                                              fontWeight: isUnread
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                              color: const Color(0xFF1E2D24),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),

                                  // Time string
                                  Text(
                                    _formatDate(notification.createdAt),
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF7A8C80),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),

                              // Body text
                              _buildBody(context),

                              // Action Link (e.g. View Order >)
                              if (notification.actionLabel != null &&
                                  notification.actionLabel!.isNotEmpty) ...[
                                SizedBox(height: 7.h),
                                GestureDetector(
                                  onTap: onTap,
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        notification.actionLabel!,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF236830),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        size: 15,
                                        color: Color(0xFF236830),
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
      final parts = notification.body.split('\n');
      if (parts.length > 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parts[0],
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFF5A6E60),
                height: 1.35,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFA000),
                      size: 13,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    parts[1].replaceAll('★★★★★ — ', '').replaceAll('★★★★★ - ', ''),
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF5A6E60),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        color: const Color(0xFF5A6E60),
        height: 1.35,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final isYesterday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    final timeStr = "$hour:$minute $period";

    if (isToday) {
      return timeStr;
    } else if (isYesterday) {
      return "Yesterday · $timeStr";
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return "${months[date.month - 1]} ${date.day} · $timeStr";
    }
  }

  Map<String, dynamic> _getIconConfigForType(NotificationType type) {
    switch (type) {
      case NotificationType.orderPlaced:
      case NotificationType.orderCancelled:
        return {
          'bgColor': const Color(0xFFFFF4EB),
          'iconColor': const Color(0xFFEA580C),
          'icon': Icons.shopping_cart_outlined,
        };
      case NotificationType.earningCredited:
        return {
          'bgColor': const Color(0xFFEBF7ED),
          'iconColor': const Color(0xFF16A34A),
          'icon': Icons.attach_money_rounded,
        };
      case NotificationType.orderShipped:
      case NotificationType.orderDelivered:
        return {
          'bgColor': const Color(0xFFF6F0FD),
          'iconColor': const Color(0xFF9333EA),
          'icon': Icons.local_shipping_outlined,
        };
      case NotificationType.reviewReceived:
        return {
          'bgColor': const Color(0xFFFFFBEB),
          'iconColor': const Color(0xFFD97706),
          'icon': Icons.star_outline_rounded,
        };
      case NotificationType.lowStock:
        return {
          'bgColor': const Color(0xFFFFFBEB),
          'iconColor': const Color(0xFFD97706),
          'icon': Icons.warning_amber_rounded,
        };
      case NotificationType.system:
      default:
        return {
          'bgColor': const Color(0xFFEFF6FF),
          'iconColor': const Color(0xFF2563EB),
          'icon': Icons.verified_outlined,
        };
    }
  }
}