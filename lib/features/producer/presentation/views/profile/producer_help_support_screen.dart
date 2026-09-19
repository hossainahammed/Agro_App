import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class ProducerHelpSupportScreen extends StatefulWidget {
  const ProducerHelpSupportScreen({super.key});

  @override
  State<ProducerHelpSupportScreen> createState() => _ProducerHelpSupportScreenState();
}

class _ProducerHelpSupportScreenState extends State<ProducerHelpSupportScreen> {
  int _expandedIndex = 0; // First item expanded by default as in screenshot

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I list a product?',
      'answer': 'Go to "My Products" → tap the "+" button → add photos, set your price and available quantity → tap Save. Your product will be visible to buyers immediately.',
    },
    {
      'question': 'How do I get paid?',
      'answer': 'Your sales earnings go directly into your wallet. You can withdraw to your registered bank account at any time.',
    },
    {
      'question': 'What is the commission fee?',
      'answer': 'AgroConnect charges a commission fee (currently 7%) on each completed transaction.',
    },
    {
      'question': 'How do I get the verified/certified badge?',
      'answer': 'Producers can get a verified badge by uploading valid identification documents and land proof for verification under settings.',
    },
    {
      'question': 'My product isn\'t showing up. What should I do?',
      'answer': 'Ensure that your product listing has stock and status is set to Active. If it still doesn\'t show up, contact our support team.',
    },
    {
      'question': 'How do I track an order after a driver picks it up?',
      'answer': 'You can view active orders under the Orders tab and monitor real-time delivery status updates from the driver.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              children: [
                // FAQ Title Header
                Text(
                  'Frequently Asked Questions',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),

                // FAQ List items
                ...List.generate(_faqs.length, (index) {
                  final bool isExpanded = _expandedIndex == index;
                  final faq = _faqs[index];

                  return _buildFAQCard(index, faq['question']!, faq['answer']!, isExpanded);
                }),
              ],
            ),
          ),

          // Bottom Action Button
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            child: _buildContactSupportButton(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      toolbarHeight: 70.h,
      leadingWidth: 52.w,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.white.withAlpha(38),
            radius: 18.r,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PROFILE',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB5D9BB),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Help & Support',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(int index, String question, String answer, bool isExpanded) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isExpanded ? const Color(0xFFC6E8C7) : const Color(0xFFE5ECE8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Question row)
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    isExpanded ? Icons.close_rounded : Icons.add_rounded,
                    color: isExpanded ? const Color(0xFF2D7A3A) : AppColors.textSecondary,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),

          // Answer Section (Animated collapse/expand)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
              child: Text(
                answer,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupportButton() {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: const Color(0xFF2D7A3A),
        radius: 12.r,
        strokeWidth: 1.2,
      ),
      child: Container(
        width: double.infinity,
        height: 52.h,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Get.snackbar(
              'Support Ticket',
              'Connecting you with our support team...',
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFF2D7A3A),
              colorText: Colors.white,
            );
          },
          style: TextButton.styleFrom(
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Contact Support team',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D7A3A),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter to draw the dashed border for the Contact Support button
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1,
    this.radius = 12,
    this.dashWidth = 5,
    this.dashSpace = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    final dashPath = Path();
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
