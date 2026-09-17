import 'package:flutter/material.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';

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
    // List of filters with their corresponding config
    final List<Map<String, dynamic>> filters = [
      {
        'label': 'All',
        'icon': null,
        'unselectedBg': const Color(0xFFF0F4F1),
        'iconColor': AppColors.textSecondary,
      },
      {
        'label': 'Orders',
        'icon': Icons.shopping_cart_outlined,
        'unselectedBg': const Color(0xFFFFF7ED), // very light orange
        'iconColor': const Color(0xFFEA580C), // orange
      },
      {
        'label': 'Payments',
        'icon': Icons.attach_money,
        'unselectedBg': const Color(0xFFF0FDF4), // very light green
        'iconColor': const Color(0xFF16A34A), // success green
      },
      {
        'label': 'Delivery',
        'icon': Icons.local_shipping_outlined,
        'unselectedBg': const Color(0xFFFAF5FF), // very light purple
        'iconColor': const Color(0xFF9333EA), // purple
      },
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final String label = filter['label'];
          final IconData? icon = filter['icon'];
          final Color unselectedBg = filter['unselectedBg'];
          final Color iconColor = filter['iconColor'];
          final bool isSelected = label.toLowerCase() == selectedFilter.toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => onFilterSelected(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : unselectedBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected ? AppColors.white : iconColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
