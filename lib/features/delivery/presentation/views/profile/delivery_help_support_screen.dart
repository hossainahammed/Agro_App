import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/chat/presentation/views/chat_list_screen.dart';

class DeliveryHelpSupportScreen extends StatefulWidget {
  const DeliveryHelpSupportScreen({super.key});

  @override
  State<DeliveryHelpSupportScreen> createState() => _DeliveryHelpSupportScreenState();
}

class _DeliveryHelpSupportScreenState extends State<DeliveryHelpSupportScreen> {
  // By default, the first question is expanded matching the mockup screenshot
  int? _expandedIndex = 0;

  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I list a product?",
      "answer":
          'Go to "My Products" -> tap the "+" button -> add photos, set your price and available quantity -> tap Save. Your product will be visible to buyers immediately.',
    },
    {
      "question": "How do I get paid?",
      "answer":
          "Earnings are credited to your driver wallet immediately after a customer confirms receipt of delivery. You can withdraw your earnings anytime via the Earnings & Payout tab.",
    },
    {
      "question": "What is the commission fee?",
      "answer":
          "AgroConnect charges a transparent 5% platform commission on completed trips to cover insurance, dispatch matching, and emergency roadside assistance.",
    },
    {
      "question": "How do I get the verified/certified badge?",
      "answer":
          "Upload your National ID, Driving License, Vehicle Registration, and valid Police Clearance under the Documents section. Our team reviews submissions within 24 to 48 hours.",
    },
    {
      "question": "My product isn't showing up. What should I do?",
      "answer":
          "Check that your vehicle is approved and your document status is in good standing. If an expired document is flagged, re-upload it to reactivate automatic mission dispatch.",
    },
    {
      "question": "How do I track an order after a driver picks it up?",
      "answer":
          "Active missions display turn-by-turn in-app GPS navigation. Both the producer and buyer receive automated location updates throughout the journey.",
    },
  ];

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
                      "Help & Support",
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
                  Text(
                    "Frequently Asked Questions",
                    style: GoogleFonts.inter(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // FAQ List
                  ...List.generate(_faqs.length, (index) {
                    final item = _faqs[index];
                    final isExpanded = _expandedIndex == index;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFE5EDE6), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : index;
                              });
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item["question"]!,
                                          style: GoogleFonts.inter(
                                            fontSize: 13.5.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF111827),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        isExpanded ? Icons.close_rounded : Icons.add_rounded,
                                        color: const Color(0xFF6B7280),
                                        size: 18.sp,
                                      ),
                                    ],
                                  ),
                                  if (isExpanded) ...[
                                    SizedBox(height: 8.h),
                                    Text(
                                      item["answer"]!,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF6B7280),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 16.h),

                  // Contact Support Team Button (Outlined with brand green)
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () => _showContactSupportSheet(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF236830), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        "Contact Support team",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF236830),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, MediaQuery.of(context).padding.bottom + 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "How can we help you?",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Our dedicated dispatch and driver support team is available 24/7.",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 16.h),

            // Emergency Dispatch Helpline
            _buildContactOption(
              icon: Icons.phone_in_talk_outlined,
              title: "Call Emergency Dispatch Hub",
              subtitle: "+234 800 247 6266 (Toll-Free)",
              onTap: () {
                Navigator.pop(context);
                AppSnackBar.success("Connecting to dispatch helpline...");
              },
            ),
            SizedBox(height: 8.h),

            // Live In-App Chat Support
            _buildContactOption(
              icon: Icons.chat_outlined,
              title: "Live In-App Chat",
              subtitle: "Average response time: under 2 mins",
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ChatListScreen());
              },
            ),
            SizedBox(height: 8.h),

            // Email Support
            _buildContactOption(
              icon: Icons.mail_outline_rounded,
              title: "Email Support Desk",
              subtitle: "driver-support@agroconnect.ng",
              onTap: () {
                Navigator.pop(context);
                AppSnackBar.info("Email copied: driver-support@agroconnect.ng");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5EDE6)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 38.h,
          height: 38.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: const Color(0xFF236830), size: 19.sp),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11.5.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}
