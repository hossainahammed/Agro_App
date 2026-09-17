import 'package:flutter/material.dart';
import 'package:project_structure/core/common/widgets/container_shimmer.dart';

class NotificationShimmerWidget extends StatelessWidget {
  const NotificationShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Circular avatar shimmer
              ContainerShimmer(
                height: 48,
                width: 48,
                borderRadius: 24,
              ),
              SizedBox(width: 16),
              // Content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerShimmer(
                      height: 14,
                      width: 150,
                      borderRadius: 4,
                    ),
                    SizedBox(height: 8),
                    ContainerShimmer(
                      height: 12,
                      width: double.infinity,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
