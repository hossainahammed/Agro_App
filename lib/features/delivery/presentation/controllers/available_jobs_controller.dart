import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../views/jobs/active_job_screen.dart';
import '../views/jobs/job_detail_screen.dart';

class MissionModel {
  final String id;
  final String title;
  final String category;
  final bool isUrgent;
  final String weight;
  final String payout;
  final String etaMinutes;
  final String distanceTotal;
  final String imageUrl;

  // Pickup Details
  final String pickupName;
  final String pickupCity;
  final String pickupAddress;
  final String pickupSubtitle;
  final String pickupDistance;
  final String pickupContact;
  final String pickupRating;
  final String readyTime;

  // Drop-off Details
  final String dropoffName;
  final String dropoffCity;
  final String dropoffAddress;
  final String dropoffSubtitle;
  final String dropoffDistance;
  final String dropoffContact;
  final String dropoffRating;
  final String deliveryWindow;

  // Product Specification Details
  final String item;
  final String quantity;
  final String packaging;
  final String condition;
  final String careNote;

  const MissionModel({
    required this.id,
    required this.title,
    required this.category,
    this.isUrgent = false,
    required this.weight,
    required this.payout,
    required this.etaMinutes,
    required this.distanceTotal,
    required this.imageUrl,
    required this.pickupName,
    required this.pickupCity,
    required this.pickupAddress,
    required this.pickupSubtitle,
    required this.pickupDistance,
    required this.pickupContact,
    required this.pickupRating,
    required this.readyTime,
    required this.dropoffName,
    required this.dropoffCity,
    required this.dropoffAddress,
    required this.dropoffSubtitle,
    required this.dropoffDistance,
    required this.dropoffContact,
    required this.dropoffRating,
    required this.deliveryWindow,
    required this.item,
    required this.quantity,
    required this.packaging,
    required this.condition,
    required this.careNote,
  });
}

class AvailableJobsController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final RxList<String> categories = <String>[
    'All',
    'Vegetables',
    'Fruits',
    'Grains',
  ].obs;

  // Pre-populated 5 Mock Missions matching Figma mockup
  final RxList<MissionModel> allMissions = <MissionModel>[
    const MissionModel(
      id: 'AGC-5102',
      title: 'Maize (50 bags)',
      category: 'Grains',
      isUrgent: true,
      weight: '2.5 tonnes',
      payout: '₦3,200',
      etaMinutes: '35 min',
      distanceTotal: '8.7 km',
      imageUrl:
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=200&auto=format&fit=crop&q=80',
      pickupName: 'Alhaji Sule Farm',
      pickupCity: 'Ungogo, Kano',
      pickupAddress: 'Farm Gate, Ungogo LGA',
      pickupSubtitle:
          'Off Zaria Road, behind Ungogo Market, near the blue water tower',
      pickupDistance: '2.4 km',
      pickupContact: '+234 802 334 9911',
      pickupRating: '4.9',
      readyTime: 'Now',
      dropoffName: 'Kano Central Silo',
      dropoffCity: 'Fagge, Kano',
      dropoffAddress: 'Silo Complex, Fagge LGA',
      dropoffSubtitle:
          'Plot 12, Kano–Kaduna Expressway, opposite Fagge Mosque',
      dropoffDistance: '8.1 km',
      dropoffContact: '+234 803 111 2233',
      dropoffRating: '4.7',
      deliveryWindow: 'Before 3:00 PM today',
      item: 'Maize (Yellow Corn)',
      quantity: '50 bags',
      packaging: 'Woven polypropylene sacks',
      condition: 'Dry — no refrigeration needed',
      careNote:
          'Handle with care. Bags must remain upright to avoid spillage.',
    ),
    const MissionModel(
      id: 'AGC-5099',
      title: 'Tomatoes (30 crates)',
      category: 'Vegetables',
      isUrgent: false,
      weight: '480 kg',
      payout: '₦1,850',
      etaMinutes: '22 min',
      distanceTotal: '6.8 km',
      imageUrl:
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=200&auto=format&fit=crop&q=80',
      pickupName: 'Mama Ngozi Plots',
      pickupCity: 'Sabon Gari, Kano',
      pickupAddress: 'Sabon Gari Farm Gate, Kano',
      pickupSubtitle: 'Behind Sabon Gari market depot',
      pickupDistance: '1.1 km',
      pickupContact: '+234 805 443 1200',
      pickupRating: '4.8',
      readyTime: 'Now',
      dropoffName: 'Wuse Market Agent',
      dropoffCity: 'Wuse, Abuja',
      dropoffAddress: 'Wuse Modern Market, Stall 44',
      dropoffSubtitle: 'Gate 2 main delivery dock',
      dropoffDistance: '5.7 km',
      dropoffContact: '+234 803 998 4422',
      dropoffRating: '4.6',
      deliveryWindow: 'Before 4:30 PM today',
      item: 'Fresh Plum Tomatoes',
      quantity: '30 plastic crates',
      packaging: 'Ventilated stackable crates',
      condition: 'Fresh produce — keep shaded',
      careNote: 'Stack crates securely to avoid crushing soft produce.',
    ),
    const MissionModel(
      id: 'AGC-5097',
      title: 'Catfish (12 coolers)',
      category: 'Fish',
      isUrgent: false,
      weight: '310 kg',
      payout: '₦2,600',
      etaMinutes: '40 min',
      distanceTotal: '11.0 km',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=200&auto=format&fit=crop&q=80',
      pickupName: 'Rimi Fish Farm',
      pickupCity: 'Rimin Gado',
      pickupAddress: 'Rimin Gado Aquaculture Hub',
      pickupSubtitle: 'Pond sector 4, loading bay',
      pickupDistance: '6.8 km',
      pickupContact: '+234 806 771 9021',
      pickupRating: '4.9',
      readyTime: 'In 10 min',
      dropoffName: 'Gbenga Cold Store',
      dropoffCity: 'Bompai Rd.',
      dropoffAddress: 'Bompai Industrial Estate',
      dropoffSubtitle: 'Warehouse 8 cold chain dock',
      dropoffDistance: '4.2 km',
      dropoffContact: '+234 802 884 1100',
      dropoffRating: '4.9',
      deliveryWindow: 'Before 2:00 PM today',
      item: 'Live African Catfish',
      quantity: '12 aerated coolers',
      packaging: 'Water-filled thermal coolers',
      condition: 'Live transport — maintain oxygenation',
      careNote: 'Do not tilt coolers. Direct transit required.',
    ),
    const MissionModel(
      id: 'AGC-5094',
      title: 'Mangoes (25 crates)',
      category: 'Fruits',
      isUrgent: false,
      weight: '600 kg',
      payout: '₦2,100',
      etaMinutes: '30 min',
      distanceTotal: '10.8 km',
      imageUrl:
          'https://images.unsplash.com/photo-1553279768-865429fa0078?w=200&auto=format&fit=crop&q=80',
      pickupName: 'Danjuma Orchard',
      pickupCity: 'Tudun Wada',
      pickupAddress: 'Tudun Wada Mango Plantation',
      pickupSubtitle: 'North gate packing station',
      pickupDistance: '3.3 km',
      pickupContact: '+234 809 332 7781',
      pickupRating: '4.7',
      readyTime: 'Now',
      dropoffName: 'FreshMart Superstore',
      dropoffCity: 'GRA Phase 2',
      dropoffAddress: 'GRA Phase 2 Commercial Area',
      dropoffSubtitle: 'Rear loading dock B',
      dropoffDistance: '7.5 km',
      dropoffContact: '+234 803 550 9944',
      dropoffRating: '4.8',
      deliveryWindow: 'Before 5:00 PM today',
      item: 'Ripe Ogbomoso Mangoes',
      quantity: '25 crates',
      packaging: 'Cardboard vented cartons',
      condition: 'Ripe fruit — avoid high heat',
      careNote: 'Keep cargo bay ventilated during transit.',
    ),
    const MissionModel(
      id: 'AGC-5090',
      title: 'Fresh Milk (8 churns)',
      category: 'Dairy',
      isUrgent: true,
      weight: '960 litres',
      payout: '₦4,100',
      etaMinutes: '55 min',
      distanceTotal: '21.6 km',
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=200&auto=format&fit=crop&q=80',
      pickupName: 'Fulani Pastoral Co-op',
      pickupCity: 'Madobi',
      pickupAddress: 'Madobi Dairy Collection Center',
      pickupSubtitle: 'Main chilling center, Bay 1',
      pickupDistance: '12 km',
      pickupContact: '+234 802 119 4433',
      pickupRating: '4.9',
      readyTime: 'Ready now',
      dropoffName: 'Peak Dairy Factory',
      dropoffCity: 'Sharada Ind. Estate',
      dropoffAddress: 'Sharada Industrial Estate',
      dropoffSubtitle: 'Pasteurization plant intake silo',
      dropoffDistance: '9.6 km',
      dropoffContact: '+234 803 772 0011',
      dropoffRating: '5.0',
      deliveryWindow: 'Before 1:30 PM today (Urgent)',
      item: 'Raw Whole Cow Milk',
      quantity: '8 stainless churns',
      packaging: 'Sealed stainless steel churns',
      condition: 'Chilled at 4°C — temperature sensitive',
      careNote: 'Urgent priority shipment. Avoid delays.',
    ),
  ].obs;

  // Filtered missions by category & search
  List<MissionModel> get filteredMissions {
    return allMissions.where((m) {
      final matchesCategory = selectedCategory.value == 'All' ||
          m.category.toLowerCase() == selectedCategory.value.toLowerCase();
      final query = searchQuery.value.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          m.title.toLowerCase().contains(query) ||
          m.id.toLowerCase().contains(query) ||
          m.pickupAddress.toLowerCase().contains(query) ||
          m.dropoffAddress.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  final Rxn<MissionModel> activeMission = Rxn<MissionModel>();
  final RxInt countdownSeconds = 17.obs;
  Timer? _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    activeMission.value = allMissions.first;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void openMissionDetail(MissionModel mission) {
    activeMission.value = mission;
    Get.to(() => JobDetailScreen(mission: mission));
  }

  void acceptMission(MissionModel mission) {
    activeMission.value = mission;
    startCountdown(17);
    AppSnackBar.success('Mission ${mission.id} accepted! Navigation initialized.');
    Get.to(() => ActiveJobScreen(mission: mission));
  }

  void declineMission(MissionModel mission) {
    allMissions.removeWhere((m) => m.id == mission.id);
    AppSnackBar.info('Mission ${mission.id} declined.');
  }

  void startCountdown([int seconds = 17]) {
    _countdownTimer?.cancel();
    countdownSeconds.value = seconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 1) {
        countdownSeconds.value--;
      } else {
        countdownSeconds.value = 0;
        timer.cancel();
      }
    });
  }

  String get formattedCountdown {
    final s = countdownSeconds.value;
    final minutes = (s ~/ 60).toString().padLeft(2, '0');
    final seconds = (s % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void refreshMissions() {
    AppSnackBar.success('Available missions refreshed.');
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }
}
