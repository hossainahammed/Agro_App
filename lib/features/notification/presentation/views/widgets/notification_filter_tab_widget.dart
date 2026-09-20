import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class NotificationFilterTabWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const NotificationFilterTabWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filters = [
      {
        'label': 'All',
        'icon': null,
        'unselectedBg': const Color(0xFFF0F4F1),
        'iconColor': const Color(0xFF6B7280),
      },
      {
        'label': 'Orders',
        'icon': Icons.shopping_cart_outlined,
        'unselectedBg': const Color(0xFFFFF4EB),
        'iconColor': const Color(0xFFEA580C),
      },
      {
        'label': 'Payments',
        'icon': Icons.attach_money_rounded,
        'unselectedBg': const Color(0xFFEBF7ED),
        'iconColor': const Color(0xFF16A34A),
      },
      {
        'label': 'Delivery',
        'icon': Icons.local_shipping_outlined,
        'unselectedBg': const Color(0xFFF6F0FD),
        'iconColor': const Color(0xFF9333EA),
      },
    ];

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE5EDE6),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filters.map((filter) {
          final String label = filter['label'] as String;
          final IconData? icon = filter['icon'] as IconData?;
          final Color unselectedBg = filter['unselectedBg'] as Color;
          final Color iconColor = filter['iconColor'] as Color;
          final bool isSelected =
              label.toLowerCase() == selectedFilter.toLowerCase();

          return GestureDetector(
            onTap: () => onFilterSelected(label),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: icon != null ? 12.w : 15.w,
                vertical: 6.5.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF236830) : unselectedBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 14.5.sp,
                      color: isSelected ? Colors.white : iconColor,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF5A6E60),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
