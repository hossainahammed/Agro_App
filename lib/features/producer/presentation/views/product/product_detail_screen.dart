import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/producer/data/models/product_model.dart';
import 'package:project_structure/features/producer/presentation/controllers/product_list_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final PageController _pageController;
  int _currentImageIndex = 0;

  late final List<String> _images;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _images = [
      widget.product.imageUrl,
      'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=600',
      'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600',
      'https://images.unsplash.com/photo-1607305387299-a3d9611cd46f?w=600',
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentImageIndex < _images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentImageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductListController controller = Get.find<ProductListController>();

    // Calculate mock revenue dynamically
    final double revenueVal = widget.product.price * widget.product.sold;
    final String revenueStr = revenueVal >= 1000000
        ? "₦${(revenueVal / 1000000).toStringAsFixed(1)}m"
        : "₦${(revenueVal / 1000).toStringAsFixed(0)}k";

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Carousel Block
            _buildImageCarousel(),

            // 2. White Details Block (badges, title, price, location/date)
            Container(
              color: AppColors.white,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(15),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.product.category,
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _buildStatusBadge(widget.product),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Title
                  Text(
                    widget.product.title,
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Price & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "₦${widget.product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text: " /per ${widget.product.unit}",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Rating Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7EC),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.amber.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${widget.product.rating}",
                              style: GoogleFonts.inter(
                                color: const Color(0xFFC27D38),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " (${widget.product.ratingCount})",
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Location & Date Row
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        widget.product.location,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Listed ${widget.product.listedDate}",
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

            // 3. Light Green Content Block (metrics, about description, reviews)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metrics Card
                  _buildMetricsCard(revenueStr),
                  SizedBox(height: 24.h),

                  // About product
                  Text(
                    "About this Product",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Customer Reviews
                  _buildCustomerReviews(context, controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        // Page view carousel
        SizedBox(
          height: 320.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: _images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.containerSoft,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.containerSoft,
                  child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary, size: 40.sp),
                ),
              );
            },
          ),
        ),

        // Carousel Chevron Arrows
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Arrow
              GestureDetector(
                onTap: _previousPage,
                child: Container(
                  margin: EdgeInsets.only(left: 12.w),
                  width: 36.h,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(70),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.white,
                    size: 24.sp,
                  ),
                ),
              ),
              // Right Arrow
              GestureDetector(
                onTap: _nextPage,
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  width: 36.h,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(70),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bullet indicator dots (bottom center)
        Positioned(
          bottom: 16.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_images.length, (index) {
              final isCurrent = index == _currentImageIndex;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isCurrent ? 18.w : 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.white : AppColors.white.withAlpha(120),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),
        ),

        // Slide number Indicator (bottom right)
        Positioned(
          bottom: 12.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(100),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              "${_currentImageIndex + 1}/${_images.length}",
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Floating Appbar Buttons
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColors.black.withAlpha(70),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),

                  // Share & More actions
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.snackbar("Info", "Share functionality coming soon", snackPosition: SnackPosition.TOP),
                        child: Container(
                          width: 40.h,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.black.withAlpha(70),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.share_outlined,
                            color: AppColors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => _showTopOptions(context),
                        child: Container(
                          width: 40.h,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.black.withAlpha(70),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ProductModel product) {
    final bool isActive = product.isActive;
    final Color color = isActive ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withAlpha(40), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            product.status,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCard(String revenueStr) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Column 1: Stock
          Expanded(
            child: Column(
              children: [
                Text(
                  "In Stock",
                  style: GoogleFonts.inter(
                    color: AppColors.white.withAlpha(180),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${widget.product.stock}",
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${widget.product.unit}s",
                  style: GoogleFonts.inter(
                    color: AppColors.white.withAlpha(150),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1.w,
            height: 44.h,
            color: AppColors.white.withAlpha(40),
          ),

          // Column 2: Total Orders
          Expanded(
            child: Column(
              children: [
                Text(
                  "Total Orders",
                  style: GoogleFonts.inter(
                    color: AppColors.white.withAlpha(180),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${widget.product.sold}",
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "all time",
                  style: GoogleFonts.inter(
                    color: AppColors.white.withAlpha(150),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1.w,
            height: 44.h,
            color: AppColors.white.withAlpha(40),
          ),

          // Column 3: Revenue
          Expanded(
            child: Column(
              children: [
                Text(
                  "Revenue",
                  style: GoogleFonts.inter(
                    color: AppColors.white.withAlpha(180),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  revenueStr,
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: AppColors.white.withAlpha(180),
                      size: 11.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "+18%",
                      style: GoogleFonts.inter(
                        color: AppColors.white.withAlpha(180),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerReviews(BuildContext context, ProductListController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Customer Reviews",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Get.snackbar("Info", "All reviews page coming soon", snackPosition: SnackPosition.TOP),
              child: Row(
                children: [
                  Text(
                    "See all",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Ratings breakdown block
        Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor.withAlpha(60),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.containerBorder),
          ),
          child: Row(
            children: [
              // Left: average rating
              SizedBox(
                width: 100.w,
                child: Column(
                  children: [
                    Text(
                      "4.8",
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16.sp,
                        );
                      }),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "124 reviews",
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                width: 1.w,
                height: 60.h,
                color: AppColors.containerBorder,
              ),
              SizedBox(width: 16.w),

              // Right: rating bars
              Expanded(
                child: Column(
                  children: [
                    _buildRatingProgressBar(5, 0.78, "78%"),
                    SizedBox(height: 3.h),
                    _buildRatingProgressBar(4, 0.15, "15%"),
                    SizedBox(height: 3.h),
                    _buildRatingProgressBar(3, 0.05, "5%"),
                    SizedBox(height: 3.h),
                    _buildRatingProgressBar(2, 0.01, "1%"),
                    SizedBox(height: 3.h),
                    _buildRatingProgressBar(1, 0.01, "1%"),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Review 1
        _buildReviewCard(
          avatarName: "NA",
          avatarColor: const Color(0xFFAB47BC), // purple
          name: "Ngozi Adaeze",
          date: "Jun 15, 2026",
          rating: 5,
          content: "Absolutely fresh! Got delivered within 24 hours and the tomatoes were firm and ripe. Samuel's farm never disappoints.",
          helpfulCount: 14,
        ),
        SizedBox(height: 12.h),

        // Review 2
        _buildReviewCard(
          avatarName: "CE",
          avatarColor: const Color(0xFF29B6F6), // blue
          name: "Chukwudi Eze",
          date: "Jun 10, 2026",
          rating: 5,
          content: "Ordered 3 crates for my restaurant — quality is consistent. Will keep reordering every week.",
          helpfulCount: 10,
        ),
      ],
    );
  }

  Widget _buildRatingProgressBar(int stars, double progress, String label) {
    return Row(
      children: [
        Text(
          "$stars",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.star_rounded,
          color: Colors.amber,
          size: 11.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              color: Colors.amber,
              backgroundColor: AppColors.containerBorder,
              minHeight: 6.h,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 28.w,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String avatarName,
    required Color avatarColor,
    required String name,
    required String date,
    required int rating,
    required String content,
    required int helpfulCount,
  }) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.containerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 18.r,
                backgroundColor: avatarColor,
                child: Text(
                  avatarName,
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Name, Badge & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(12),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.primary.withAlpha(20)),
                          ),
                          child: Text(
                            "Verified",
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      date,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Star Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star_rounded,
                    color: index < rating ? Colors.amber : AppColors.containerBorder,
                    size: 14.sp,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Content
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),

          // Helpful button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.containerBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 12.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  "Helpful ($helpfulCount)",
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTopOptions(BuildContext context) {
    final ProductListController controller = Get.find<ProductListController>();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageUrl,
                    height: 48.h,
                    width: 48.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.product.category,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildActionItem(
              icon: Icons.edit_outlined,
              title: "Edit Listing",
              onTap: () {
                Get.back();
                Get.snackbar("Info", "Edit product functionality coming soon", snackPosition: SnackPosition.TOP);
              },
            ),
            _buildActionItem(
              icon: widget.product.isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              title: widget.product.isActive ? "Mark as Out of Stock" : "Mark as Active",
              onTap: () {
                controller.toggleProductStatus(widget.product.id);
                Get.back();
                // Pop detail screen so the list updates cleanly
                Get.back();
                Get.snackbar(
                  "Success",
                  "${widget.product.title} marked as ${widget.product.isActive ? 'Out of Stock' : 'Active'}",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColors.primary.withAlpha(20),
                  colorText: AppColors.primary,
                );
              },
            ),
            const Divider(),
            _buildActionItem(
              icon: Icons.delete_outline_rounded,
              title: "Delete Listing",
              titleColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: () {
                Get.back(); // close the action sheet first
                _confirmDeleteListing(context, controller);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: titleColor ?? AppColors.textPrimary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _confirmDeleteListing(BuildContext context, ProductListController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Slide indicator pill
            Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.containerBorder,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Trash can container
            Container(
              width: 60.h,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 18.h),

            // Header title
            Text(
              "Delete Product?",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),

            // Description sentence with bold product name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: "This will permanently remove "),
                    TextSpan(
                      text: widget.product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const TextSpan(text: " from your listings. This action cannot be undone."),
                  ],
                ),
              ),
            ),
            SizedBox(height: 28.h),

            // Row of buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.containerBorder),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.deleteProduct(widget.product.id);
                      Get.back(); // close sheet
                      Get.back(); // go back to list
                      Get.snackbar(
                        "Success",
                        "${widget.product.title} has been deleted",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.error.withAlpha(20),
                        colorText: AppColors.error,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Yes, Delete",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
