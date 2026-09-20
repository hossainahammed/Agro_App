import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';

class DeliveryOrderItem {
  final String orderId;
  final String timeAgo;
  final String route;
  final String price;
  final String status;

  const DeliveryOrderItem({
    required this.orderId,
    required this.timeAgo,
    required this.route,
    required this.price,
    this.status = 'Done',
  });
}

class DeliveryDashboardController extends GetxController {
  // Driver Status
  final RxBool isOnline = true.obs;

  // Driver Profile Info
  final RxString driverName = 'Emeka Okafor'.obs;
  final RxString greeting = 'Good morning 👋'.obs;
  final RxString avatarUrl =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=250&auto=format&fit=crop'
          .obs;

  // Summary Metrics
  final RxInt todayDeliveries = 7.obs;
  final RxString todayEarnings = '₦8,450'.obs;
  final RxString distanceCovered = '34km'.obs;
  final RxDouble rating = 4.8.obs;
  final RxInt totalTrips = 142.obs;
  final RxInt onTimeRate = 96.obs;

  // Location details
  final RxString onlineLocation = 'Kano, Nassarawa LGA — GPS active'.obs;
  final RxString offlineLocation = 'Location paused while offline'.obs;

  // Recent Deliveries List
  final RxList<DeliveryOrderItem> recentDeliveries = <DeliveryOrderItem>[
    const DeliveryOrderItem(
      orderId: 'AGC-4821',
      timeAgo: '2h ago',
      route: 'Kano Central Market → Bompai Road',
      price: '₦1,200',
      status: 'Done',
    ),
    const DeliveryOrderItem(
      orderId: 'AGC-4819',
      timeAgo: '4h ago',
      route: 'Sabon Gari Farm → Nassarawa GRA',
      price: '₦950',
      status: 'Done',
    ),
    const DeliveryOrderItem(
      orderId: 'AGC-4815',
      timeAgo: '6h ago',
      route: 'Dawanau Market → Farm Gate, Ung...',
      price: '₦2,100',
      status: 'Done',
    ),
  ].obs;

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
    if (isOnline.value) {
      AppSnackBar.success(
        'You are now Online. Visible to farmers and receiving delivery orders.',
      );
    } else {
      AppSnackBar.info(
        'You are now Offline. GPS location and incoming requests paused.',
      );
    }
  }

  void viewAllSummary() {
    AppSnackBar.info('Summary overview feature');
  }

  void seeHistory() {
    AppSnackBar.info('Navigating to full delivery history');
  }

  void openDeliveryDetails(DeliveryOrderItem order) {
    AppSnackBar.info('Order details for ${order.orderId}');
  }
}
