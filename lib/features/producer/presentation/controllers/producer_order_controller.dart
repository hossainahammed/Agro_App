import 'package:get/get.dart';
import '../../data/models/order_model.dart';

class ProducerOrderController extends GetxController {
  final RxString selectedTab = 'New'.obs;
  final RxString searchQuery = ''.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final List<String> tabs = ['New', 'In Progress', 'Completed', 'Cancelled'];

  @override
  void onInit() {
    super.onInit();
    _loadMockOrders();
  }

  void _loadMockOrders() {
    orders.assignAll([
      // New Orders
      OrderModel(
        id: '#AGC-2841',
        time: '9:14 AM',
        date: 'Jun 19, 2026',
        buyerName: 'Aisha Musa',
        buyerShop: 'Musa Fresh Supplies',
        buyerInitial: 'A',
        productTitle: 'Fresh Roma Tomatoes',
        quantity: 6,
        unit: 'crates',
        unitPrice: 4500.0,
        totalPrice: 27000.0,
        imageUrl: 'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400',
        status: 'New',
        showHeaderBadge: false,
        phone: '(+225) 812 340 9021',
        address: '14 Bello Road, Nassarawa GRA, Kano State',
        note: 'Please ensure crates are sealed properly.',
        deliveryFee: 1500.0,
      ),
      OrderModel(
        id: '#AGC-2839',
        time: '4:02 PM',
        date: 'Jun 18, 2026',
        buyerName: 'Chukwudi Eze',
        buyerShop: 'Eze Agro Market',
        buyerInitial: 'C',
        productTitle: 'Sweet Corn',
        quantity: 10,
        unit: 'bags',
        unitPrice: 2200.0,
        totalPrice: 22000.0,
        imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
        status: 'New',
        showHeaderBadge: false,
        phone: '(+225) 304 928 1029',
        address: '88 Gwarinpa Estate, Phase 3, Abuja',
        note: 'Deliver before sunset if possible.',
        deliveryFee: 2000.0,
      ),

      // In Progress Orders
      OrderModel(
        id: '#AGC-2830',
        time: '11:30 AM',
        date: 'Jun 17, 2026',
        buyerName: 'Fatima Bello',
        buyerShop: "Bello's Kitchen Store",
        buyerInitial: 'F',
        productTitle: 'Fresh Roma Tomatoes',
        quantity: 6,
        unit: 'crates',
        unitPrice: 4500.0,
        totalPrice: 27000.0,
        imageUrl: 'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400',
        status: 'In Progress',
        deliverBy: 'Jun 20, 2026',
        showHeaderBadge: false,
        phone: '(+225) 812 340 9021',
        address: '14 Bello Road, Nassarawa GRA, Kano State',
        note: 'Please ensure crates are sealed properly.',
        deliveryFee: 1500.0,
        driverName: 'Ibrahim Suleiman',
        driverPhone: '+234 812 340 9021',
        driverVehicle: 'Toyota Hilux',
        driverRating: 4.7,
        driverPlateNumber: 'KN 302 BCA',
        driverImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        items: [
          OrderItemModel(
            productTitle: 'Fresh Roma Tomatoes',
            quantity: 6,
            unit: 'crates',
            unitPrice: 4500.0,
            totalPrice: 27000.0,
            imageUrl: 'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400',
          ),
          OrderItemModel(
            productTitle: 'Organic Pepper',
            quantity: 2,
            unit: 'kgs',
            unitPrice: 6800.0,
            totalPrice: 13600.0,
            imageUrl: 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400',
          ),
        ],
      ),
      OrderModel(
        id: '#AGC-2821',
        time: '8:55 AM',
        date: 'Jun 16, 2026',
        buyerName: 'Emeka Okonkwo',
        buyerShop: 'Okonkwo Food Hub',
        buyerInitial: 'E',
        productTitle: 'Fresh Roma Tomatoes',
        quantity: 12,
        unit: 'crates',
        unitPrice: 4500.0,
        totalPrice: 54000.0,
        imageUrl: 'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400',
        status: 'In Progress',
        deliverBy: 'Jun 21, 2026',
        showHeaderBadge: true,
        phone: '(+225) 902 112 3344',
        address: '45 Bode Thomas Street, Surulere, Lagos',
        note: 'Keep tomatoes ventilated to avoid bruising.',
        deliveryFee: 3000.0,
        driverName: 'Chinedu Alao',
        driverPhone: '+234 901 234 5678',
        driverVehicle: 'Suzuki Carry',
        driverRating: 4.8,
        driverPlateNumber: 'LA 490 APP',
        driverImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      ),

      // Completed Orders
      OrderModel(
        id: '#AGC-2810',
        time: '10:22 AM',
        date: 'Jun 14, 2026',
        buyerName: 'Ngozi Adaeze',
        buyerShop: 'Adaeze Provisions',
        buyerInitial: 'N',
        productTitle: 'Cassava Flour',
        quantity: 20,
        unit: 'bags',
        unitPrice: 3100.0,
        totalPrice: 62000.0,
        imageUrl: 'https://images.unsplash.com/photo-1574325131876-a7999373de5f?w=400',
        status: 'Completed',
        deliverBy: 'Jun 16, 2026',
        showHeaderBadge: true,
        phone: '(+225) 803 445 6677',
        address: '12 Commercial Avenue, Sabo Yaba, Lagos',
        note: 'Make sure bags are stacked dry.',
        deliveryFee: 2500.0,
        driverName: 'Musa Bello',
        driverPhone: '+234 803 111 2222',
        driverVehicle: 'Ford Transit',
        driverRating: 4.9,
        driverPlateNumber: 'LA 820 GGE',
        driverImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      ),
      OrderModel(
        id: '#AGC-2798',
        time: '2:45 PM',
        date: 'Jun 12, 2026',
        buyerName: 'Yusuf Garba',
        buyerShop: 'Garba General Goods',
        buyerInitial: 'Y',
        productTitle: 'Garden Eggs',
        quantity: 8,
        unit: 'baskets',
        unitPrice: 900.0,
        totalPrice: 7200.0,
        imageUrl: 'https://images.unsplash.com/photo-1590378341256-e195bd41855e?w=400',
        status: 'Completed',
        deliverBy: 'Jun 13, 2026',
        showHeaderBadge: true,
        phone: '(+225) 815 909 2311',
        address: '55 Katsina Road, Fagge, Kano',
        note: 'Handle with care.',
        deliveryFee: 1000.0,
      ),

      // Cancelled Orders
      OrderModel(
        id: '#AGC-2780',
        time: '1:10 PM',
        date: 'Jun 11, 2026',
        buyerName: 'Chidinma Obi',
        buyerShop: 'Obi Fresh Markets',
        buyerInitial: 'C',
        productTitle: 'Sweet Corn',
        quantity: 5,
        unit: 'bags',
        unitPrice: 2200.0,
        totalPrice: 11000.0,
        imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
        status: 'Cancelled',
        showHeaderBadge: true,
        phone: '(+225) 706 887 9900',
        address: '90 Onitsha Main Market Road, Anambra State',
        note: null,
        deliveryFee: 1500.0,
      ),
    ]);
  }

  // Filtered orders based on selected tab and search query
  List<OrderModel> get filteredOrders {
    return orders.where((order) {
      // 1. Filter by status (tab)
      if (selectedTab.value == 'In Progress') {
        if (order.status != 'In Progress' && order.status != 'Ready for Pickup') {
          return false;
        }
      } else if (order.status != selectedTab.value) {
        return false;
      }

      // 2. Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final matchesId = order.id.toLowerCase().contains(query);
        final matchesBuyerName = order.buyerName.toLowerCase().contains(query);
        final matchesBuyerShop = order.buyerShop.toLowerCase().contains(query);
        final matchesProduct = order.productTitle.toLowerCase().contains(query);
        return matchesId || matchesBuyerName || matchesBuyerShop || matchesProduct;
      }

      return true;
    }).toList();
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Counts for each tab
  int getCountForTab(String tab) {
    if (tab == 'In Progress') {
      return orders.where((o) => o.status == 'In Progress' || o.status == 'Ready for Pickup').length;
    }
    return orders.where((o) => o.status == tab).length;
  }

  // Interactive actions for order details screen
  void acceptOrder(String orderId) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = orders[index];
      orders[index] = OrderModel(
        id: order.id,
        time: order.time,
        date: order.date,
        buyerName: order.buyerName,
        buyerShop: order.buyerShop,
        buyerInitial: order.buyerInitial,
        productTitle: order.productTitle,
        quantity: order.quantity,
        unit: order.unit,
        unitPrice: order.unitPrice,
        totalPrice: order.totalPrice,
        imageUrl: order.imageUrl,
        status: 'In Progress',
        deliverBy: 'Jun 20, 2026',
        showHeaderBadge: true,
        phone: order.phone,
        address: order.address,
        note: order.note,
        deliveryFee: order.deliveryFee,
        driverName: 'Ibrahim Suleiman',
        driverPhone: '+234 812 340 9021',
        driverVehicle: 'Toyota Hilux',
        driverRating: 4.7,
        driverPlateNumber: 'KN 302 BCA',
        driverImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        items: order.items,
      );
      orders.refresh();
    }
  }

  void markReadyForPickup(String orderId) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = orders[index];
      orders[index] = OrderModel(
        id: order.id,
        time: order.time,
        date: order.date,
        buyerName: order.buyerName,
        buyerShop: order.buyerShop,
        buyerInitial: order.buyerInitial,
        productTitle: order.productTitle,
        quantity: order.quantity,
        unit: order.unit,
        unitPrice: order.unitPrice,
        totalPrice: order.totalPrice,
        imageUrl: order.imageUrl,
        status: 'Ready for Pickup',
        deliverBy: order.deliverBy ?? 'Jun 20, 2026',
        showHeaderBadge: true,
        phone: order.phone,
        address: order.address,
        note: order.note,
        deliveryFee: order.deliveryFee,
        driverName: order.driverName ?? 'Ibrahim Suleiman',
        driverPhone: order.driverPhone ?? '+234 812 340 9021',
        driverVehicle: order.driverVehicle ?? 'Toyota Hilux',
        driverRating: order.driverRating ?? 4.7,
        driverPlateNumber: order.driverPlateNumber ?? 'KN 302 BCA',
        driverImageUrl: order.driverImageUrl ?? 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        items: order.items,
      );
      orders.refresh();
    }
  }
}
