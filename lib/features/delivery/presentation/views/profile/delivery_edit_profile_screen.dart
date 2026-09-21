import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class DeliveryEditProfileScreen extends StatefulWidget {
  const DeliveryEditProfileScreen({super.key});

  @override
  State<DeliveryEditProfileScreen> createState() =>
      _DeliveryEditProfileScreenState();
}

class _DeliveryEditProfileScreenState extends State<DeliveryEditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _bioController;

  late final FocusNode _fullNameFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _bioFocusNode;

  String _selectedVehicleType = "FCT — Abuja";
  String _selectedCityState = "FCT — Abuja";

  final List<String> _vehicleTypeOptions = [
    "FCT — Abuja",
    "Van",
    "Pickup Truck",
    "Cargo Tricycle",
    "Motorcycle",
  ];

  final List<String> _cityStateOptions = [
    "FCT — Abuja",
    "Kano State",
    "Lagos State",
    "Kaduna State",
    "Oyo State",
    "Rivers State",
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: "Samuel Adeyemi");
    _phoneController = TextEditingController(text: "+234 803 221 4477");
    _emailController = TextEditingController(
      text: "samuel.adeyemi@agroconnect.ng",
    );
    _bioController = TextEditingController(text: "vdfgvfvgfdvdf fddf");

    _fullNameFocusNode = FocusNode()..addListener(() => setState(() {}));
    _phoneFocusNode = FocusNode()..addListener(() => setState(() {}));
    _emailFocusNode = FocusNode()..addListener(() => setState(() {}));
    _bioFocusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fullNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _bioFocusNode.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
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
                      "Edit Profile",
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
          // SCROLLABLE FORM BODY
          // ========================================================
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with Camera Badge & Change Photo Text
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 84.h,
                              height: 84.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFC8E6C9),
                                  width: 3.w,
                                ),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=250&auto=format&fit=crop',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: const Color(0xFF1B4926),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: const Color(0xFF1B4926),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 38,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            // Camera Badge
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () => AppSnackBar.info(
                                  "Select an image from gallery (Max 5 MB)",
                                  title: "Change Photo",
                                ),
                                child: Container(
                                  width: 26.h,
                                  height: 26.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF236830),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => AppSnackBar.info(
                            "Select an image from gallery (Max 5 MB)",
                            title: "Change Photo",
                          ),
                          child: Text(
                            "Change Photo",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF236830),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "JPG or PNG · Max 5 MB",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // ====================================================
                  // SECTION: PERSONAL INFORMATION
                  // ====================================================
                  _buildSectionHeader("PERSONAL INFORMATION"),
                  SizedBox(height: 14.h),

                  // Full Name
                  _buildLabel("Full Name"),
                  SizedBox(height: 6.h),
                  _buildInputField(
                    controller: _fullNameController,
                    focusNode: _fullNameFocusNode,
                    icon: Icons.person_outline_rounded,
                    hint: "Enter your full name",
                  ),
                  SizedBox(height: 14.h),

                  // Phone Number
                  _buildLabel("Phone Number"),
                  SizedBox(height: 6.h),
                  _buildInputField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    icon: Icons.phone_outlined,
                    hint: "Enter your phone number",
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Used for order notifications and buyer contact.",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Email Address
                  _buildLabel("Email Address"),
                  SizedBox(height: 6.h),
                  _buildInputField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    icon: Icons.mail_outline_rounded,
                    hint: "Enter your email address",
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 20.h),
                  const Divider(color: Color(0xFFE5EDE6), thickness: 1),
                  SizedBox(height: 16.h),

                  // ====================================================
                  // SECTION: VEHICLE INFORMATION
                  // ====================================================
                  _buildSectionHeader("VEHICLE INFORMATION"),
                  SizedBox(height: 14.h),

                  // Vehicle Type
                  _buildLabel("Vehicle Type"),
                  SizedBox(height: 6.h),
                  _buildDropdownField(
                    icon: Icons.local_shipping_outlined,
                    value: _selectedVehicleType,
                    items: _vehicleTypeOptions,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedVehicleType = val);
                      }
                    },
                  ),
                  SizedBox(height: 14.h),

                  // City / State
                  _buildLabel("City / State"),
                  SizedBox(height: 6.h),
                  _buildDropdownField(
                    icon: Icons.public_rounded,
                    value: _selectedCityState,
                    items: _cityStateOptions,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCityState = val);
                    },
                  ),

                  SizedBox(height: 20.h),
                  const Divider(color: Color(0xFFE5EDE6), thickness: 1),
                  SizedBox(height: 16.h),

                  // ====================================================
                  // SECTION: ACCOUNT
                  // ====================================================
                  _buildSectionHeader("ACCOUNT"),
                  SizedBox(height: 14.h),

                  // Bio
                  _buildLabel("Bio"),
                  SizedBox(height: 6.h),
                  _buildInputField(
                    controller: _bioController,
                    focusNode: _bioFocusNode,
                    icon: Icons.public_rounded,
                    hint: "Write something about yourself",
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
            padding: EdgeInsets.fromLTRB(
              20.w,
              12.h,
              20.w,
              MediaQuery.of(context).padding.bottom + 14.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: const Color(0xFFE5EDE6), width: 1),
              ),
            ),
            child: SizedBox(
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AppSnackBar.success("Profile updated successfully!");
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

  // ==========================================================
  // HELPER WIDGETS
  // ==========================================================
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: const Color(0xFF6B7280),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF374151),
        ),
        children: [
          TextSpan(
            text: " *",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isFocused = focusNode.hasFocus;

    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isFocused ? Colors.white : const Color(0xFFF7FBF8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isFocused
                ? const Color(0xFF236830)
                : const Color(0xFFE5EDE6),
            width: isFocused ? 1.5 : 1.0,
          ),
          boxShadow: isFocused
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
            Icon(
              icon,
              color: isFocused
                  ? const Color(0xFF236830)
                  : const Color(0xFF6B7280),
              size: 19.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: keyboardType,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (controller.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  controller.clear();
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Icon(
                    Icons.close_rounded,
                    color: isFocused
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF9CA3AF),
                    size: 16.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5EDE6)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF236830), size: 19.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(value) ? value : items.first,
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
                items: items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
