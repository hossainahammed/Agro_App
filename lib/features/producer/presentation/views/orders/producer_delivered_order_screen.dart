import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

/// Delivered Order Details & Receipt Screen (Order #AGC-2830)
class ProducerDeliveredOrderDetailScreen extends StatefulWidget {
  final String orderId;

  const ProducerDeliveredOrderDetailScreen({
    super.key,
    this.orderId = "#AGC-2830",
  });

  @override
  State<ProducerDeliveredOrderDetailScreen> createState() =>
      _ProducerDeliveredOrderDetailScreenState();
}

class _ProducerDeliveredOrderDetailScreenState
    extends State<ProducerDeliveredOrderDetailScreen> {
  final RxBool isRated = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF5EE), // Soft mint background
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. "Delivered on time 🎉" Card
            _buildDeliveredOnTimeBanner(),
            SizedBox(height: 14.h),

            // 2. Producer Information Card
            _buildProducerCard(),
            SizedBox(height: 14.h),

            // 3. Items Purchased Card (Yellow Corn, Tomatoes, Mangoes)
            _buildItemsCard(),
            SizedBox(height: 14.h),

            // 4. Price Summary Card & Payment Banner
            _buildPriceSummaryCard(),
            SizedBox(height: 14.h),

            // 5. Order Timeline Card (5 verified milestones)
            _buildTimelineCard(),
            SizedBox(height: 14.h),

            // 6. Assigned Driver Card
            _buildDriverCard(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // ========================================================
  // 1. APP BAR
  // ========================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      toolbarHeight: 72.h,
      leadingWidth: 56.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Center(
          child: GestureDetector(
            onTap: () => Get.back(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "AGROCONNECT",
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB5D9BB),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Order ${widget.orderId}",
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // 2. DELIVERED ON TIME BANNER
  // ========================================================
  Widget _buildDeliveredOnTimeBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E6B32), // Dark forest green
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left check circle badge
          Container(
            width: 36.h,
            height: 36.h,
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(35),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delivered on time 🎉",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "39 min from order to your door",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.white.withAlpha(210),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Receipt download button
          GestureDetector(
            onTap: () {
              Get.snackbar(
                "Receipt",
                "Downloading official receipt for ${widget.orderId}...",
                snackPosition: SnackPosition.TOP,
                backgroundColor: AppColors.primary.withAlpha(20),
                colorText: AppColors.primary,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(45),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.white.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_download_outlined,
                    color: AppColors.white,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Receipt",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // 3. PRODUCER CARD
  // ========================================================
  Widget _buildProducerCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PRODUCER",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 14.h),

          // Profile row
          Row(
            children: [
              // Avatar with letter 'A'
              Container(
                width: 44.h,
                height: 44.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "A",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Name, Farm & Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Samuel Adeyemi",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Adeyemi Green Farms",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFF59E0B),
                          size: 13.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "4.8",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Call & Chat buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCircleAction(
                    icon: Icons.phone_outlined,
                    onTap: () {
                      Get.snackbar(
                        "Call",
                        "Calling Samuel Adeyemi (+234 803 112 3456)...",
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                  ),
                  SizedBox(width: 8.w),
                  _buildCircleAction(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      Get.snackbar(
                        "Chat",
                        "Opening chat with Samuel Adeyemi...",
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Address row
          Row(
            children: [
              Container(
                width: 30.h,
                height: 30.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "14 Bello Road, Nassarawa GRA, Kano State",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========================================================
  // 4. ITEMS (3) CARD
  // ========================================================
  Widget _buildItemsCard() {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Yellow Corn (Maize)',
        'category': 'Grains',
        'details': '20 bags × ₦4,500/bag',
        'price': '₦90,000',
        'imageUrl':
            'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
      },
      {
        'title': 'Fresh Tomatoes',
        'category': 'Vegetables',
        'details': '10 crates × ₦2,200/crate',
        'price': '₦22,000',
        'imageUrl':
            'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400',
      },
      {
        'title': 'Ripe Mangoes',
        'category': 'Fruits',
        'details': '5 crates × ₦3,800/crate',
        'price': '₦19,000',
        'imageUrl':
            'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400',
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ITEMS (3)",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                "3 products",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Items list
          ...items.asMap().entries.map((entry) {
            final int index = entry.key;
            final item = entry.value;

            return Column(
              children: [
                if (index > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(height: 1.h, color: const Color(0xFFF1F5F2)),
                  ),
                Row(
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: 48.h,
                        height: 48.h,
                        color: const Color(0xFFF1F8F3),
                        child: CachedNetworkImage(
                          imageUrl: (item['imageUrl'] as String?) ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFE8F5E9),
                            child: Center(
                              child: SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFFE8F5E9),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.eco_rounded,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  item['category'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  item['details'] as String,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Text(
                      item['price'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ========================================================
  // 5. PRICE SUMMARY CARD
  // ========================================================
  Widget _buildPriceSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PRICE SUMMARY",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 14.h),

          _buildPriceRow("Subtotal (3 items)", "₦131,000"),
          SizedBox(height: 10.h),
          _buildPriceRow("Delivery fee", "₦3,200"),
          SizedBox(height: 10.h),
          _buildPriceRow("Service fee", "₦800"),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1.h, color: const Color(0xFFF1F5F2)),
          ),

          // Total Paid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Paid",
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "₦135,000",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // MTN Mobile Money Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF6ED),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Paid via MTN Mobile Money",
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ========================================================
  // 6. ORDER TIMELINE CARD
  // ========================================================
  Widget _buildTimelineCard() {
    final List<Map<String, String>> timelineNodes = [
      {
        'title': 'Order Placed',
        'subtitle': 'Payment confirmed',
        'time': 'Fri 27 Jun 8:02 AM',
      },
      {
        'title': 'Confirmed by Farm',
        'subtitle': 'Alhaji Sule Farm accepted',
        'time': 'Fri 27 Jun 8:17 AM',
      },
      {
        'title': 'Ready for Pickup',
        'subtitle': 'Cargo loaded and sealed',
        'time': 'Fri 27 Jun 8:45 AM',
      },
      {
        'title': 'Picked Up',
        'subtitle': 'Emeka O. collected the order',
        'time': 'Fri 27 Jun 9:03 AM',
      },
      {
        'title': 'Delivered',
        'subtitle': 'Signed off by Fatima A.',
        'time': 'Fri 27 Jun 9:41 AM',
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ORDER TIMELINE",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 16.h),

          ...timelineNodes.asMap().entries.map((entry) {
            final int index = entry.key;
            final node = entry.value;
            final bool isLast = index == timelineNodes.length - 1;
            final bool isDeliveredNode = node['title'] == 'Delivered';

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left indicator
                  Column(
                    children: [
                      Container(
                        width: 22.h,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 18.sp,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2.w,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 12.w),

                  // Node content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                node['title']!,
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDeliveredNode
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                node['subtitle']!,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            node['time']!,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 14.h),

          // Order complete banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF6ED),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFCBE5D1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "🎉 Order complete - Thank you!",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // 7. ASSIGNED DRIVER CARD
  // ========================================================
  Widget _buildDriverCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ASSIGNED DRIVER",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 14.h),

          Row(
            children: [
              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150",
                      width: 44.h,
                      height: 44.h,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 44.h,
                        height: 44.h,
                        color: AppColors.primary.withAlpha(20),
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),
                    ),
                  ),
                  Container(
                    width: 10.h,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1.5.w),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ibrahim Suleiman",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFF59E0B),
                          size: 13.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "4.7 · Toyota Hilux",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Call & Chat
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCircleAction(
                    icon: Icons.phone_outlined,
                    onTap: () {
                      Get.snackbar(
                        "Call",
                        "Calling Ibrahim Suleiman (+234 812 340 9021)...",
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                  ),
                  SizedBox(width: 8.w),
                  _buildCircleAction(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      Get.snackbar(
                        "Chat",
                        "Opening chat with Ibrahim Suleiman...",
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38.h,
        height: 38.h,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F3ED),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 18.sp),
      ),
    );
  }

  // ========================================================
  // 8. BOTTOM ACTION BAR
  // ========================================================
  Widget _buildBottomActionBar() {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Row(
        children: [
          // Rate Your Order Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                isRated.value = true;
                Get.snackbar(
                  "Thank You",
                  "Review submitted for Order ${widget.orderId}!",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColors.success.withAlpha(25),
                  colorText: AppColors.success,
                );
              },
              child: Container(
                height: 48.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_outline_rounded,
                      color: AppColors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "Rate Your Order",
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Added! Button
          GestureDetector(
            onTap: () {
              Get.snackbar(
                "Order Added",
                "Order ${widget.orderId} saved to your records.",
                snackPosition: SnackPosition.TOP,
              );
            },
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF6ED),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Added!",
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
