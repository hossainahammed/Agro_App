import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/available_jobs_controller.dart';
import '../widgets/delivery_icons.dart';
import 'delivery_complete_screen.dart';

class DeliveryConfirmationScreen extends StatefulWidget {
  final MissionModel? mission;

  const DeliveryConfirmationScreen({
    super.key,
    this.mission,
  });

  @override
  State<DeliveryConfirmationScreen> createState() =>
      _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState
    extends State<DeliveryConfirmationScreen> {
  late MissionModel activeMission;

  bool isRecipientConfirmed = false;
  bool isPhotoUploaded = false;
  String? capturedPhotoPath;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = Get.isRegistered<AvailableJobsController>()
        ? Get.find<AvailableJobsController>()
        : Get.put(AvailableJobsController());

    activeMission = widget.mission ??
        controller.activeMission.value ??
        controller.allMissions.first;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleSimulateTakePhoto() {
    setState(() {
      isPhotoUploaded = true;
      capturedPhotoPath =
          "https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=500&auto=format&fit=crop&q=80";
    });
    AppSnackBar.success("Proof of delivery photo captured!");
  }

  void _handleCompleteDelivery() {
    Get.to(
      () => DeliveryCompleteScreen(
        mission: activeMission,
        durationMinutes: 38,
      ),
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      body: Column(
        children: [
          _buildTopAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Subtitle
                  Text(
                    "Confirm Delivery",
                    style: GoogleFonts.inter(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "You're almost done. Verify the drop-off details before completing this mission.",
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      color: const Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Mission Summary Banner Card
                  _buildMissionSummaryBanner(),

                  SizedBox(height: 18.h),

                  // 1. Proof of Delivery Section
                  _buildProofOfDeliveryCard(),

                  SizedBox(height: 18.h),

                  // 2. Recipient Confirmation Section
                  _buildRecipientConfirmationCard(),

                  SizedBox(height: 18.h),

                  // 3. Delivery Notes Section
                  _buildDeliveryNotesCard(),

                  SizedBox(height: 18.h),

                  // 4. GPS & Time Verification Badges
                  _buildGpsAndTimeCards(),

                  SizedBox(height: 24.h),

                  // 5. Verification Status Dots
                  _buildStatusDotsRow(),

                  SizedBox(height: 12.h),

                  // 6. Complete Delivery Button
                  _buildCompleteDeliveryButton(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP APP BAR: AGROCONNECT + Confirm Delivery
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
                "AGROCONNECT",
                style: GoogleFonts.inter(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: const Color(0xFFD6E8DA),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Confirm Delivery",
                style: GoogleFonts.inter(
                  fontSize: 17.5.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MISSION SUMMARY BANNER CARD (Green container)
  // ==========================================================
  Widget _buildMissionSummaryBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF236830),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF236830).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const DeliveryBoxIcon(
              size: 20,
              color: Colors.white,
              strokeWidth: 1.8,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${activeMission.title} · ${activeMission.weight}",
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${activeMission.id} · ${activeMission.dropoffName}",
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: const Color(0xFFD6E8DA),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activeMission.payout,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Payout",
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
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
  // 1. PROOF OF DELIVERY CARD (Take Photo / Upload)
  // ==========================================================
  Widget _buildProofOfDeliveryCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 16,
                  color: Color(0xFF1E2D24),
                ),
                SizedBox(width: 6.w),
                Text(
                  "Proof of Delivery",
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
              ],
            ),
            Text(
              "Optional",
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
          ),
          child: isPhotoUploaded && capturedPhotoPath != null
              ? Column(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            capturedPhotoPath!,
                            height: 140.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPhotoUploaded = false;
                              capturedPhotoPath = null;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.h),
                            padding: EdgeInsets.all(4.h),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF16A34A),
                          size: 16,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Photo attached successfully",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 34,
                      color: Color(0xFF94A3B8),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: _handleSimulateTakePhoto,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 9.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5ED),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
                              color: Color(0xFF236830),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Take Photo",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF236830),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: _handleSimulateTakePhoto,
                      child: Text(
                        "Or tap to upload from gallery",
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        SizedBox(height: 6.h),
        Text(
          "A clear photo helps resolve disputes. Show cargo at the drop-off location.",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: const Color(0xFF64748B),
            height: 1.3,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 2. RECIPIENT CONFIRMATION CARD (Interactive toggle)
  // ==========================================================
  Widget _buildRecipientConfirmationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 16,
                  color: Color(0xFF1E2D24),
                ),
                SizedBox(width: 6.w),
                Text(
                  "Recipient Confirmation",
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
              ],
            ),
            Text(
              "Optional",
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            setState(() {
              isRecipientConfirmed = !isRecipientConfirmed;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isRecipientConfirmed
                    ? const Color(0xFF236830)
                    : const Color(0xFFE2E8F0),
                width: isRecipientConfirmed ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 22.h,
                  height: 22.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecipientConfirmed
                        ? const Color(0xFF236830)
                        : Colors.white,
                    border: Border.all(
                      color: isRecipientConfirmed
                          ? const Color(0xFF236830)
                          : const Color(0xFFCBD5E1),
                      width: 1.8,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isRecipientConfirmed
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recipient confirmed receipt",
                        style: GoogleFonts.inter(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E2D24),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "${activeMission.dropoffName} staff acknowledged delivery",
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 3. DELIVERY NOTES CARD (Multi-line text area)
  // ==========================================================
  Widget _buildDeliveryNotesCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  size: 18,
                  color: Color(0xFF1E2D24),
                ),
                SizedBox(width: 6.w),
                Text(
                  "Delivery Notes",
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
              ],
            ),
            Text(
              "Optional",
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: TextField(
            controller: _notesController,
            maxLines: 3,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              color: const Color(0xFF1E2D24),
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText:
                  "e.g. Left with security guard at gate, bags counted and verified...",
              hintStyle: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFF94A3B8),
                height: 1.4,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 4. GPS & TIME VERIFICATION BADGES (2 Equal side-by-side cards)
  // ==========================================================
  Widget _buildGpsAndTimeCards() {
    final locationName = activeMission.dropoffCity.contains(',')
        ? activeMission.dropoffCity.split(',').first
        : activeMission.dropoffCity;

    return Row(
      children: [
        // GPS Card
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 32.h,
                  height: 32.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF5ED),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF16A34A),
                    size: 17,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locationName.isNotEmpty ? locationName : "Fagge LGA",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E2D24),
                        ),
                      ),
                      Text(
                        "GPS confirmed",
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Time Card
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 32.h,
                  height: 32.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF5ED),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.access_time_filled_rounded,
                    color: Color(0xFF16A34A),
                    size: 17,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "9:41 AM",
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E2D24),
                        ),
                      ),
                      Text(
                        "On-time ✓",
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 5. STATUS DOTS ROW: Photo · Recipient · GPS & Time
  // ==========================================================
  Widget _buildStatusDotsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Photo Status
        _buildDotItem(
          isDone: isPhotoUploaded,
          label: "Photo",
        ),
        _buildMiddleDot(),

        // Recipient Status
        _buildDotItem(
          isDone: isRecipientConfirmed,
          label: "Recipient",
        ),
        _buildMiddleDot(),

        // GPS & Time Status (Always verified by location & system clock)
        _buildDotItem(
          isDone: true,
          label: "GPS & Time",
        ),
      ],
    );
  }

  Widget _buildDotItem({required bool isDone, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDone)
          Container(
            width: 14.h,
            height: 14.h,
            decoration: const BoxDecoration(
              color: Color(0xFF236830),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 9.5,
            ),
          )
        else
          Container(
            width: 14.h,
            height: 14.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                width: 1.5,
              ),
              color: Colors.white,
            ),
          ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
            color: isDone ? const Color(0xFF236830) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildMiddleDot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        "·",
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  // ==========================================================
  // 6. COMPLETE DELIVERY BUTTON
  // ==========================================================
  Widget _buildCompleteDeliveryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: _handleCompleteDelivery,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF236830),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFF236830).withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              "Complete Delivery",
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
