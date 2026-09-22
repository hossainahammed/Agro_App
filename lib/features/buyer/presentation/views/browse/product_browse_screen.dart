import 'package:flutter/material.dart';
import '../buyer_dashboard_screen.dart';

class ProductBrowseScreen extends StatelessWidget {
  const ProductBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuses the full BuyerDashboardScreen with focus on browsing
    return const BuyerDashboardScreen();
  }
}
