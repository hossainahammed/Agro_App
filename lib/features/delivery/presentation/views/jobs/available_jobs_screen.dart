import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/core/utils/constants/image_path.dart';
import '../../controllers/available_jobs_controller.dart';
import '../widgets/delivery_icons.dart';

class AvailableJobsScreen extends StatefulWidget {
  const AvailableJobsScreen({super.key});

  @override
  State<AvailableJobsScreen> createState() => _AvailableJobsScreenState();
}

class _AvailableJobsScreenState extends State<AvailableJobsScreen> {
  late final TextEditingController _searchController;
  late final AvailableJobsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<AvailableJobsController>()
        ? Get.find<AvailableJobsController>()
        : Get.put(AvailableJobsController());
    _searchController =
        TextEditingController(text: _controller.searchQuery.value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: const Color(
        0xFFEDF4EE,
      ), // Signature soft sage-mint background
      body: Column(
        children: [
          // Top Forest Green Header
          _buildHeader(context, _controller),

          // Scrollable Content
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF236830),
              backgroundColor: Colors.white,
              onRefresh: () async {
                controller.refreshMissions();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Category Filter Pills with Individual Asset Images
                    _buildCategoryPills(controller),
                    SizedBox(height: 12.h),

                    // Refresh Prompt Line
                    _buildRefreshPromptLine(controller),
                    SizedBox(height: 12.h),

                    // Missions List
                    Obx(() {
                      final missions = controller.filteredMissions;
                      if (missions.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: missions.length,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, index) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final mission = missions[index];
                          return _buildMissionCard(
                            context,
                            controller,
                            mission,
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP FOREST GREEN HEADER (Matching Mockup 1)
  // ==========================================================
  Widget _buildHeader(
    BuildContext context,
    AvailableJobsController controller,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF236830),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16441F).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 10.h,
        16.w,
        18.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Title + Missions count + Map button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      "${controller.allMissions.length} missions near you",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFD6E8DA),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Available Missions",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              // Map Outline Icon Button (Circle matching mockup)
              GestureDetector(
                onTap: () {
                  AppSnackBar.info("Opening Mission Live Map View");
                },
                child: Container(
                  width: 38.h,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Search Bar (Translucent dark green matching mockup)
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _controller.onSearchChanged,
              style: GoogleFonts.inter(fontSize: 13.5.sp, color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: const Color(0xFFB4D8BC),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFFD6E8DA),
                  size: 19,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 11.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HORIZONTAL CATEGORY PILLS WITH INDIVIDUAL ASSET IMAGES
  // ==========================================================
  Widget _buildCategoryPills(AvailableJobsController controller) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: controller.categories.map((category) {
            final isSelected = controller.selectedCategory.value == category;
            final imageAsset = _getCategoryImage(category);

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectCategory(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF236830) : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF236830)
                          : const Color(0xFFE2EDE4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: const Color(
                            0xFF236830,
                          ).withValues(alpha: 0.22),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Individual category image from asset -> image folder
                      Image.asset(
                        imageAsset,
                        width: 17.h,
                        height: 17.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return ImagePath.vegetablesCategory;
      case 'fruits':
        return ImagePath.fruitsCategory;
      case 'grains':
        return ImagePath.grainsCategory;
      case 'all':
      default:
        return ImagePath.allCategory;
    }
  }

  // ==========================================================
  // REFRESH PROMPT LINE
  // ==========================================================
  Widget _buildRefreshPromptLine(AvailableJobsController controller) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.sync_rounded, size: 14, color: Color(0xFF7A8C80)),
          SizedBox(width: 4.w),
          Text(
            "Pull down to refresh",
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              color: const Color(0xFF7A8C80),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: controller.refreshMissions,
            child: Text(
              "Refresh now",
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF236830),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MISSION CARD (Figma Exact Matching Layout with Dummy Network Image)
  // ==========================================================
  Widget _buildMissionCard(
    BuildContext context,
    AvailableJobsController controller,
    MissionModel mission,
  ) {
    final avatarColors = _getAvatarColorForMission(mission.title);

    return GestureDetector(
      onTap: () => controller.openMissionDetail(mission),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFE5EDE6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Circular Dummy Network Image + Title + URGENT + Payout + ETA
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Dummy Network Image container with tint border
                Container(
                  width: 44.h,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: avatarColors['bg'],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: avatarColors['border']!,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      mission.imageUrl,
                      width: 44.h,
                      height: 44.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: DeliveryBoxIcon(
                          size: 20,
                          color: avatarColors['icon']!,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 16.h,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                avatarColors['icon']!,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Title + Weight / Urgent
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              mission.title,
                              style: GoogleFonts.inter(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E2D24),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (mission.isUrgent) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: const Color(0xFFFFCDD2),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.bolt_rounded,
                                    size: 11,
                                    color: Color(0xFFE53935),
                                  ),
                                  Text(
                                    "URGENT",
                                    style: GoogleFonts.inter(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFE53935),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "${mission.id} • ${mission.weight}",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Payout & ETA
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      mission.payout,
                      style: GoogleFonts.inter(
                        fontSize: 16.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF236830),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: Color(0xFF7A8C80),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          mission.etaMinutes.replaceAll('~', ''),
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF7A8C80),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Route Timeline Section matching Mockup
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF8),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFEAF1EB), width: 1.0),
              ),
              child: Column(
                children: [
                  // Pickup Location Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hollow green circle
                      Container(
                        margin: EdgeInsets.only(top: 2.h),
                        width: 12.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF236830),
                            width: 2.0,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mission.pickupName,
                              style: GoogleFonts.inter(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E2D24),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 11,
                                  color: Color(0xFF64748B),
                                ),
                                SizedBox(width: 3.w),
                                Flexible(
                                  child: Text(
                                    mission.pickupCity,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Distance badge in green
                      Text(
                        mission.pickupDistance,
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ],
                  ),

                  // Connecting vertical dotted connector
                  Padding(
                    padding: EdgeInsets.only(left: 5.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 1.5,
                        height: 14.h,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),

                  // Drop-off Location Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Concentric / solid target circle
                      Container(
                        margin: EdgeInsets.only(top: 2.h),
                        width: 12.h,
                        height: 12.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF236830),
                        ),
                        child: Center(
                          child: Container(
                            width: 4.h,
                            height: 4.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mission.dropoffName,
                              style: GoogleFonts.inter(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E2D24),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 11,
                                  color: Color(0xFF64748B),
                                ),
                                SizedBox(width: 3.w),
                                Flexible(
                                  child: Text(
                                    mission.dropoffCity,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Distance badge in grey
                      Text(
                        mission.dropoffDistance,
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Bottom Action Buttons: Decline & Accept Mission
            Row(
              children: [
                // Decline button
                Expanded(
                  flex: 3,
                  child: OutlinedButton(
                    onPressed: () => controller.declineMission(mission),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8FAFC),
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Decline",
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Accept Mission button
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: () => controller.acceptMission(mission),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF236830),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const NavigationArrowIcon(
                          size: 15,
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Accept Mission",
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Color> _getAvatarColorForMission(String title) {
    final t = title.toLowerCase();
    if (t.contains('maize')) {
      return {
        'bg': const Color(0xFFFFF7ED),
        'border': const Color(0xFFFED7AA),
        'icon': const Color(0xFFD97706),
      };
    } else if (t.contains('tomato')) {
      return {
        'bg': const Color(0xFFF0FDF4),
        'border': const Color(0xFFBBF7D0),
        'icon': const Color(0xFF16A34A),
      };
    } else if (t.contains('fish')) {
      return {
        'bg': const Color(0xFFEFF6FF),
        'border': const Color(0xFFBFDBFE),
        'icon': const Color(0xFF2563EB),
      };
    } else if (t.contains('mango')) {
      return {
        'bg': const Color(0xFFFAF5FF),
        'border': const Color(0xFFE9D5FF),
        'icon': const Color(0xFF9333EA),
      };
    } else {
      return {
        'bg': const Color(0xFFFFF7ED),
        'border': const Color(0xFFFFEDD5),
        'icon': const Color(0xFFEA580C),
      };
    }
  }

  // ==========================================================
  // EMPTY STATE WIDGET
  // ==========================================================
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48.sp,
            color: const Color(0xFF94A3B8),
          ),
          SizedBox(height: 12.h),
          Text(
            "No missions found",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2D24),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Try clearing your search or choosing another category.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              color: const Color(0xFF7A8C80),
            ),
          ),
        ],
      ),
    );
  }
}
