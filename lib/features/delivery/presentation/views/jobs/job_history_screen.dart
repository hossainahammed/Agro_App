import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/available_jobs_controller.dart';
import '../widgets/delivery_icons.dart';
import 'delivered_mission_detail_screen.dart';

enum HistoryFilter { all, completed, cancelled }

class HistoryItemModel {
  final String id;
  final String dayGroup; // TODAY, YEST., WED, TUE, MON
  final String dayLabel; // Today, Yesterday, Wed, Tue, Mon
  final String pickupName;
  final String pickupCity;
  final String dropoffName;
  final String dropoffCity;
  final String distance;
  final String? duration;
  final String payout;
  final bool isCompleted;
  final String item;
  final String weight;
  final String quantity;

  const HistoryItemModel({
    required this.id,
    required this.dayGroup,
    required this.dayLabel,
    required this.pickupName,
    required this.pickupCity,
    required this.dropoffName,
    required this.dropoffCity,
    required this.distance,
    this.duration,
    required this.payout,
    required this.isCompleted,
    this.item = 'Maize (Yellow Corn)',
    this.weight = '2.5 tonnes',
    this.quantity = '50 bags',
  });

  MissionModel toMissionModel() {
    return MissionModel(
      id: id,
      title: item,
      category: 'Grains',
      weight: weight,
      payout: payout == '—' ? '₦0' : payout,
      etaMinutes: duration ?? '30 min',
      distanceTotal: distance,
      imageUrl:
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=200&auto=format&fit=crop&q=80',
      pickupName: pickupName,
      pickupCity: pickupCity,
      pickupAddress: '$pickupName, Kano State',
      pickupSubtitle: 'Pickup gate bay 1',
      pickupDistance: distance,
      pickupContact: '+234 802 334 9911',
      pickupRating: '4.8',
      readyTime: 'Now',
      dropoffName: dropoffName,
      dropoffCity: dropoffCity,
      dropoffAddress: '$dropoffName, Kano State',
      dropoffSubtitle: 'Main unloading warehouse',
      dropoffDistance: distance,
      dropoffContact: '+234 812 340 9021',
      dropoffRating: '4.9',
      deliveryWindow: 'Delivered',
      item: item,
      quantity: quantity,
      packaging: 'Woven polypropylene sacks',
      condition: 'Dry — verified',
      careNote: 'Handled with care.',
    );
  }
}

class JobHistoryScreen extends StatefulWidget {
  const JobHistoryScreen({super.key});

  @override
  State<JobHistoryScreen> createState() => _JobHistoryScreenState();
}

class _JobHistoryScreenState extends State<JobHistoryScreen> {
  HistoryFilter activeFilter = HistoryFilter.all;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  String searchQuery = '';

  // 10 Mock missions exactly matching the Figma mockup
  final List<HistoryItemModel> allHistoryItems = const [
    // TODAY
    HistoryItemModel(
      id: 'AGC-5102',
      dayGroup: 'TODAY',
      dayLabel: 'Today',
      pickupName: 'Alhaji Sule Farm',
      pickupCity: 'Ungogo LGA',
      dropoffName: 'Kano Central Silo',
      dropoffCity: 'Fagge LGA',
      distance: '8.7 km',
      duration: '38 min',
      payout: '₦3,200',
      isCompleted: true,
      item: 'Maize (50 bags)',
      weight: '2.5 tonnes',
    ),
    HistoryItemModel(
      id: 'AGC-5099',
      dayGroup: 'TODAY',
      dayLabel: 'Today',
      pickupName: 'Mama Ngozi Plots',
      pickupCity: 'Bichi LGA',
      dropoffName: 'Wuse Market Agent',
      dropoffCity: 'Nassarawa',
      distance: '5.7 km',
      duration: '22 min',
      payout: '₦1,850',
      isCompleted: true,
      item: 'Tomatoes (30 crates)',
      weight: '750 kg',
    ),

    // YEST.
    HistoryItemModel(
      id: 'AGC-5091',
      dayGroup: 'YEST.',
      dayLabel: 'Yesterday',
      pickupName: 'Rimi Fish Farm',
      pickupCity: 'Rimi LGA',
      dropoffName: 'Gbenga Cold Store',
      dropoffCity: 'Tarauni LGA',
      distance: '4.2 km',
      duration: null,
      payout: '—',
      isCompleted: false, // Cancelled
      item: 'Catfish (20 tanks)',
      weight: '400 kg',
    ),
    HistoryItemModel(
      id: 'AGC-5087',
      dayGroup: 'YEST.',
      dayLabel: 'Yesterday',
      pickupName: 'Danjuma Orchard',
      pickupCity: 'Kura LGA',
      dropoffName: 'FreshMart Superstore',
      dropoffCity: 'Kano Municipal',
      distance: '7.5 km',
      duration: '30 min',
      payout: '₦2,100',
      isCompleted: true,
      item: 'Oranges (40 sacks)',
      weight: '1.2 tonnes',
    ),
    HistoryItemModel(
      id: 'AGC-5080',
      dayGroup: 'YEST.',
      dayLabel: 'Yesterday',
      pickupName: 'Fulani Pastoral Co.',
      pickupCity: 'Dawakin Kudu',
      dropoffName: 'Peak Dairy Factory',
      dropoffCity: 'Bompai Industrial',
      distance: '9.6 km',
      duration: '55 min',
      payout: '₦4,100',
      isCompleted: true,
      item: 'Fresh Milk (50 cans)',
      weight: '1.8 tonnes',
    ),

    // WED
    HistoryItemModel(
      id: 'AGC-5071',
      dayGroup: 'WED',
      dayLabel: 'Wed',
      pickupName: 'Bello Maize Farm',
      pickupCity: 'Danbatta LGA',
      dropoffName: 'Dawanau Market',
      dropoffCity: 'Dawakin Tofa',
      distance: '6.1 km',
      duration: '28 min',
      payout: '₦2,400',
      isCompleted: true,
      item: 'Maize (Yellow Corn)',
      weight: '1.5 tonnes',
    ),
    HistoryItemModel(
      id: 'AGC-5068',
      dayGroup: 'WED',
      dayLabel: 'Wed',
      pickupName: 'Hafsah Poultry',
      pickupCity: 'Gwarzo LGA',
      dropoffName: 'Kano Cold Chain Hub',
      dropoffCity: 'Gwale LGA',
      distance: '3.4 km',
      duration: null,
      payout: '—',
      isCompleted: false, // Cancelled
      item: 'Broiler Chickens (100 birds)',
      weight: '300 kg',
    ),

    // TUE
    HistoryItemModel(
      id: 'AGC-5060',
      dayGroup: 'TUE',
      dayLabel: 'Tue',
      pickupName: 'Audu Veggie Plot',
      pickupCity: 'Kumbotso LGA',
      dropoffName: 'Sabo Market Depot',
      dropoffCity: 'Kano Municipal',
      distance: '5 km',
      duration: '25 min',
      payout: '₦1,600',
      isCompleted: true,
      item: 'Bell Peppers (25 sacks)',
      weight: '500 kg',
    ),
    HistoryItemModel(
      id: 'AGC-5055',
      dayGroup: 'TUE',
      dayLabel: 'Tue',
      pickupName: 'Zaria Road Farm',
      pickupCity: 'Zaria Road Corridor',
      dropoffName: 'BUA Foods Factory',
      dropoffCity: 'Bompai Industrial',
      distance: '12.3 km',
      duration: '62 min',
      payout: '₦5,200',
      isCompleted: true,
      item: 'Sorghum (80 bags)',
      weight: '4.0 tonnes',
    ),

    // MON
    HistoryItemModel(
      id: 'AGC-5044',
      dayGroup: 'MON',
      dayLabel: 'Mon',
      pickupName: 'Kura Farm Coop',
      pickupCity: 'Kura LGA',
      dropoffName: 'Yankaba Market',
      dropoffCity: 'Nassarawa LGA',
      distance: '8.9 km',
      duration: '42 min',
      payout: '₦2,950',
      isCompleted: true,
      item: 'Onions (45 bags)',
      weight: '2.0 tonnes',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isSearchFocused = _searchFocusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<HistoryItemModel> get filteredItems {
    return allHistoryItems.where((item) {
      // 1. Filter by tab
      if (activeFilter == HistoryFilter.completed && !item.isCompleted) {
        return false;
      }
      if (activeFilter == HistoryFilter.cancelled && item.isCompleted) {
        return false;
      }

      // 2. Filter by search
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchId = item.id.toLowerCase().contains(q);
        final matchPickup = item.pickupName.toLowerCase().contains(q);
        final matchDropoff = item.dropoffName.toLowerCase().contains(q);
        final matchItem = item.item.toLowerCase().contains(q);
        return matchId || matchPickup || matchDropoff || matchItem;
      }

      return true;
    }).toList();
  }

  // Groups items by dayGroup maintaining original date order
  Map<String, List<HistoryItemModel>> get groupedItems {
    final Map<String, List<HistoryItemModel>> map = {};
    for (var item in filteredItems) {
      map.putIfAbsent(item.dayGroup, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final groups = groupedItems;

    return Scaffold(
      backgroundColor: const Color(0xFFEDF3EE),
      body: Column(
        children: [
          // 1. Forest Green App Bar
          _buildTopAppBar(context),

          // 2. White Background Container enclosing Stats Banner & Filter Chips
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Stats Banner Card
                _buildSummaryStatsBanner(),

                SizedBox(height: 14.h),

                // Filter Chips (All 10, Completed 8, Cancelled 2)
                _buildFilterChips(),
              ],
            ),
          ),

          // 3. Scrollable Body Content (Search bar + History items on pale sage background)
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  _buildSearchBar(),

                  SizedBox(height: 16.h),

                  // Grouped List of Items
                  if (groups.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          "No delivery records found.",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    )
                  else
                    ...groups.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateGroupHeader(entry.key),
                          SizedBox(height: 8.h),
                          ...entry.value.map((item) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildHistoryCard(item),
                            );
                          }),
                          SizedBox(height: 8.h),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP APP BAR: Delivery History + This week Subtitle
  // ==========================================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF236830),
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 8.h,
        16.w,
        14.h,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delivery History",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "This week · Jun 23–27",
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  color: const Color(0xFFD6E8DA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SUMMARY STATS BANNER CARD (8 TRIPS | ₦23,400 | 71.4km | 2 CANCELLED)
  // ==========================================================
  Widget _buildSummaryStatsBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF236830),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF236830).withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn("8", "TRIPS"),
          _buildDivider(),
          _buildStatColumn("₦23,400", "EARNINGS"),
          _buildDivider(),
          _buildStatColumn("71.4km", "DISTANCE"),
          _buildDivider(),
          _buildStatColumn("2", "CANCELLED"),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String val, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          val,
          style: GoogleFonts.inter(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: const Color(0xFFD6E8DA),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24.h,
      color: Colors.white.withValues(alpha: 0.18),
    );
  }

  // ==========================================================
  // FILTER CHIPS: All (10) · Completed (8) · Cancelled (8)
  // ==========================================================
  Widget _buildFilterChips() {
    return Row(
      children: [
        _buildFilterChipItem(
          filter: HistoryFilter.all,
          label: "All",
          count: "10",
        ),
        SizedBox(width: 10.w),
        _buildFilterChipItem(
          filter: HistoryFilter.completed,
          label: "Completed",
          count: "8",
        ),
        SizedBox(width: 10.w),
        _buildFilterChipItem(
          filter: HistoryFilter.cancelled,
          label: "Cancelled",
          count: "8",
        ),
      ],
    );
  }

  Widget _buildFilterChipItem({
    required HistoryFilter filter,
    required String label,
    required String count,
  }) {
    final isSelected = activeFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF236830) : const Color(0xFFEAF4EC),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF2E4534),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.22)
                    : const Color(0xFFDDE8DF),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                count,
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF5D7063),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SEARCH BAR: Focus and enabled borders applied to whole container
  // ==========================================================
  Widget _buildSearchBar() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _searchFocusNode.requestFocus();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 46.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
            color: _isSearchFocused
                ? const Color(0xFF236830)
                : const Color(0xFFE2E8F0),
            width: _isSearchFocused ? 1.5 : 1.0,
          ),
          boxShadow: _isSearchFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF236830).withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 19,
              color: _isSearchFocused
                  ? const Color(0xFF236830)
                  : const Color(0xFF64748B),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                textAlignVertical: TextAlignVertical.center,
                cursorColor: const Color(0xFF236830),
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: const Color(0xFF1E2D24),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Search by ID, location, product...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: const Color(0xFF718096),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() {
                    searchQuery = '';
                  });
                },
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DATE GROUP HEADER (TODAY, YEST., WED, TUE, MON)
  // ==========================================================
  Widget _buildDateGroupHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HISTORY ITEM CARD (Matching Figma Mockup)
  // ==========================================================
  Widget _buildHistoryCard(HistoryItemModel item) {
    final isDone = item.isCompleted;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => DeliveredMissionDetailScreen(
            mission: item.toMissionModel(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Box Icon with status dot underneath
            Column(
              children: [
                Container(
                  width: 38.h,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFFEAF5ED)
                        : const Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: DeliveryBoxIcon(
                    size: 19,
                    color: isDone
                        ? const Color(0xFF236830)
                        : const Color(0xFFEF4444),
                    strokeWidth: 1.8,
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  width: 5.h,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            SizedBox(width: 12.w),

            // Middle Column: ID · Day | Route Details | Distance & Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID · Day
                  Row(
                    children: [
                      Text(
                        item.id,
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF236830),
                        ),
                      ),
                      Text(
                        " · ${item.dayLabel}",
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Route: Pickup (hollow circle)
                  Row(
                    children: [
                      Container(
                        width: 7.h,
                        height: 7.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF236830),
                            width: 1.5,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          item.pickupName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E2D24),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Route: Dropoff (solid grey dot)
                  Row(
                    children: [
                      Container(
                        width: 7.h,
                        height: 7.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          item.dropoffName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Distance & Duration
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        item.distance,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      if (item.duration != null) ...[
                        SizedBox(width: 8.w),
                        const Icon(
                          Icons.trending_up_rounded,
                          size: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          item.duration!,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Right Column: Price | Status Pill | Chevron >
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.payout,
                  style: GoogleFonts.inter(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.bold,
                    color: isDone
                        ? const Color(0xFF236830)
                        : const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 2.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFFEAF5ED)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isDone ? "Done" : "Cancelled",
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: isDone
                          ? const Color(0xFF236830)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
