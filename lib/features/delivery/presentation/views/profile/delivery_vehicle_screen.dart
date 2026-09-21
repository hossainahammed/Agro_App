import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class DeliveryVehicleScreen extends StatefulWidget {
  const DeliveryVehicleScreen({super.key});

  @override
  State<DeliveryVehicleScreen> createState() => _DeliveryVehicleScreenState();
}

class _DeliveryVehicleScreenState extends State<DeliveryVehicleScreen> {
  String _selectedVehicleType = "Van";
  String _selectedBrand = "Toyota";
  late final TextEditingController _modelController;
  late final TextEditingController _plateController;
  String _selectedYear = "2019";
  late final TextEditingController _colourController;

  late final FocusNode _modelFocusNode;
  late final FocusNode _plateFocusNode;
  late final FocusNode _colourFocusNode;

  final List<String> _vehicleTypes = ["Van", "Pickup Truck", "Cargo Tricycle", "Motorcycle"];
  final List<String> _brands = ["Toyota", "Nissan", "Ford", "Mercedes-Benz", "Hyundai", "Bajaj"];
  final List<String> _years = ["2024", "2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016"];

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: "Hiace");
    _plateController = TextEditingController(text: "KN - 402 - ABC");
    _colourController = TextEditingController(text: "White");

    _modelFocusNode = FocusNode()..addListener(() => setState(() {}));
    _plateFocusNode = FocusNode()..addListener(() => setState(() {}));
    _colourFocusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _modelFocusNode.dispose();
    _plateFocusNode.dispose();
    _colourFocusNode.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _colourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ========================================================
          // TOP GREEN APP BAR
          // ========================================================
          Container(
            width: double.infinity,
            color: const Color(0xFF236830),
            padding: EdgeInsets.fromLTRB(16.w, topPadding + 10.h, 20.w, 16.h),
            child: Row(
              children: [
                // Circular Translucent Back Button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38.h,
                    height: 38.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Title and Subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "PROFILE",
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      "My Vehicle",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ========================================================
          // SCROLLABLE BODY
          // ========================================================
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Photo Label
                  Text(
                    "Vehicle Photo",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Vehicle Photo Upload Card
                  GestureDetector(
                    onTap: () => AppSnackBar.info(
                      "Select a clear photo of your vehicle",
                      title: "Add Vehicle Photo",
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFE5EDE6), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Truck Icon with Camera Badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 54.h,
                                height: 54.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF4EE),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Icon(
                                  Icons.local_shipping_outlined,
                                  color: const Color(0xFF4B5563),
                                  size: 28.sp,
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: Container(
                                  width: 20.h,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF236830),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5.w),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 10.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Add Vehicle Photo",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            "Show a clear side view of your vehicle",
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // ====================================================
                  // VEHICLE VERIFIED BANNER
                  // ====================================================
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.h,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.verified_user_outlined,
                            color: const Color(0xFF16A34A),
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vehicle Verified",
                                style: GoogleFonts.inter(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF166534),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Approved by AgroConnect · Last checked Jun 2024",
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // ====================================================
                  // VEHICLE TYPE DROPDOWN
                  // ====================================================
                  Text(
                    "Vehicle Type",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE5EDE6)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: const Color(0xFF2563EB),
                          size: 19.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedVehicleType,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF6B7280),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF111827),
                              ),
                              items: _vehicleTypes
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedVehicleType = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // ====================================================
                  // BRAND & MODEL ROW
                  // ====================================================
                  Row(
                    children: [
                      // Brand
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Brand",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: const Color(0xFFE5EDE6)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedBrand,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF6B7280),
                                  ),
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF111827),
                                  ),
                                  items: _brands
                                      .map((b) => DropdownMenuItem(
                                            value: b,
                                            child: Text(b),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedBrand = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Model
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Model",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            GestureDetector(
                              onTap: () => _modelFocusNode.requestFocus(),
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: _modelFocusNode.hasFocus ? Colors.white : const Color(0xFFF7FBF8),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: _modelFocusNode.hasFocus ? const Color(0xFF236830) : const Color(0xFFE5EDE6),
                                    width: _modelFocusNode.hasFocus ? 1.5 : 1.0,
                                  ),
                                  boxShadow: _modelFocusNode.hasFocus
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF236830).withValues(alpha: 0.08),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: TextField(
                                  controller: _modelController,
                                  focusNode: _modelFocusNode,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF111827),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // ====================================================
                  // PLATE NUMBER
                  // ====================================================
                  Text(
                    "Plate Number",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () => _plateFocusNode.requestFocus(),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: _plateFocusNode.hasFocus ? Colors.white : const Color(0xFFF7FBF8),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: _plateFocusNode.hasFocus ? const Color(0xFF236830) : const Color(0xFFE5EDE6),
                          width: _plateFocusNode.hasFocus ? 1.5 : 1.0,
                        ),
                        boxShadow: _plateFocusNode.hasFocus
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF236830).withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _plateController,
                              focusNode: _plateFocusNode,
                              style: GoogleFonts.inter(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: const Color(0xFF111827),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          // NG Pill Badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              "NG",
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Must match your vehicle registration document",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // ====================================================
                  // YEAR & COLOUR ROW
                  // ====================================================
                  Row(
                    children: [
                      // Year
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Year",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: const Color(0xFFE5EDE6)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedYear,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF6B7280),
                                  ),
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF111827),
                                  ),
                                  items: _years
                                      .map((y) => DropdownMenuItem(
                                            value: y,
                                            child: Text(y),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedYear = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Colour
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Colour",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF374151),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            GestureDetector(
                              onTap: () => _colourFocusNode.requestFocus(),
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: _colourFocusNode.hasFocus ? Colors.white : const Color(0xFFF7FBF8),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: _colourFocusNode.hasFocus ? const Color(0xFF236830) : const Color(0xFFE5EDE6),
                                    width: _colourFocusNode.hasFocus ? 1.5 : 1.0,
                                  ),
                                  boxShadow: _colourFocusNode.hasFocus
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF236830).withValues(alpha: 0.08),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: TextField(
                                  controller: _colourController,
                                  focusNode: _colourFocusNode,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF111827),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  // ====================================================
                  // RE-VERIFICATION WARNING CARD
                  // ====================================================
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFFDE68A), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Icon(
                            Icons.error_outline_rounded,
                            color: const Color(0xFFD97706),
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "Vehicle changes require ",
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                color: const Color(0xFF92400E),
                                height: 1.35,
                              ),
                              children: [
                                TextSpan(
                                  text: "re-verification.",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF92400E),
                                  ),
                                ),
                                const TextSpan(
                                  text: " Your account will be reviewed within 24 hours.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // ========================================================
          // PINNED BOTTOM SAVE CHANGES BUTTON
          // ========================================================
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, MediaQuery.of(context).padding.bottom + 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: const Color(0xFFE5EDE6), width: 1)),
            ),
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AppSnackBar.success("Vehicle details submitted for review!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF236830),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
