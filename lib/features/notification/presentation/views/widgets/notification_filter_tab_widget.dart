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
    final filters = ['All', 'Order', 'Delivery', 'Promo'];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.containerSoft,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (_) => onFilterSelected(filter),
            ),
          );
        },
      ),
    );
  }
}
