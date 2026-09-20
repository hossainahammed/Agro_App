import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/earnings_controller.dart';
import '../widgets/delivery_icons.dart';
import 'withdraw_earnings_screen.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EarningsController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // 1. TOP FOREST GREEN APP BAR / HEADER
            // ==========================================================
            _buildTopHeader(context, controller),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================================
                  // 2. MAIN WALLET GRADIENT CARD (AVAILABLE BALANCE)
                  // ==========================================================
                  _buildAvailableBalanceCard(context, controller),
                  SizedBox(height: 14.h),

                  // ==========================================================
                  // 3. 3 QUICK METRIC CARDS ROW
                  // ==========================================================
                  _buildQuickMetricsRow(controller),
                  SizedBox(height: 14.h),

                  // ==========================================================
                  // 4. WEEKLY EARNINGS BAR CHART CARD
                  // ==========================================================
                  _buildWeeklyEarningsChartCard(controller),
                  SizedBox(height: 20.h),

                  // ==========================================================
                  // 5. RECENT TRANSACTIONS HEADER & LIST
                  // ==========================================================
                  _buildRecentTransactionsSection(context, controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================================
  // 1. TOP FOREST GREEN HEADER
  // ====================================================================
  Widget _buildTopHeader(BuildContext context, EarningsController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF236830), // Solid rich forest green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        MediaQuery.of(context).padding.top + 10.h,
        20.w,
        20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AgroConnect Driver Pay",
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFD6E8DA),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "My Wallet",
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),

          // Translucent circular icon button on right (Folded map / statement icon)
          GestureDetector(
            onTap: controller.openStatementSheet,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.map_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 2. MAIN WALLET GRADIENT CARD (AVAILABLE BALANCE)
  // ====================================================================
  Widget _buildAvailableBalanceCard(
    BuildContext context,
    EarningsController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF184E23), // Deep forest green
            Color(0xFF226732),
            Color(0xFF2C7D3E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5227).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: AVAILABLE BALANCE + Eye toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "AVAILABLE BALANCE",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFA3DEB0),
                  letterSpacing: 0.8,
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleBalanceVisibility,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isBalanceHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          // Primary Currency Amount
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  "₦ ",
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  controller.isBalanceHidden.value
                      ? "••••••"
                      : controller.availableBalance.value,
                  style: GoogleFonts.inter(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Last updated timestamp
          Obx(
            () => Text(
              "Last updated: ${controller.lastUpdated.value}",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: const Color(0xFFD6E8DA),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // [ ⭡ Withdraw ] Full-width pill action button
          GestureDetector(
            onTap: () {
              final currentBalance =
                  double.tryParse(
                    controller.availableBalance.value.replaceAll(',', ''),
                  ) ??
                  23450.0;
              Get.to(
                () => WithdrawEarningsScreen(initialBalance: currentBalance),
                transition: Transition.rightToLeft,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 11.5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.30),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.north_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    "Withdraw",
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Bottom 3-Column Stats: TODAY, THIS WEEK, THIS MONTH
          Obx(
            () => Row(
              children: [
                // 1. TODAY
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.isBalanceHidden.value
                            ? "••••"
                            : controller.todayEarnings.value,
                        style: GoogleFonts.inter(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "TODAY",
                        style: GoogleFonts.inter(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFA3DEB0),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Divider
                Container(
                  height: 22.h,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.18),
                ),

                // 2. THIS WEEK
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isBalanceHidden.value
                              ? "••••"
                              : controller.thisWeekEarnings.value,
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "THIS WEEK",
                          style: GoogleFonts.inter(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFA3DEB0),
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Vertical Divider
                Container(
                  height: 22.h,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.18),
                ),

                // 3. THIS MONTH
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isBalanceHidden.value
                              ? "••••"
                              : controller.thisMonthEarnings.value,
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "THIS MONTH",
                          style: GoogleFonts.inter(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFA3DEB0),
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 3. 3 QUICK METRIC CARDS ROW
  // ====================================================================
  Widget _buildQuickMetricsRow(EarningsController controller) {
    return Row(
      children: [
        // 1. Deliveries All time
        Expanded(
          child: _buildMetricCard(
            badgeColor: const Color(0xFFE8F5E9),
            icon: const DeliveryBoxIcon(
              color: Color(0xFF236830),
              size: 16,
              strokeWidth: 1.8,
            ),
            value: "${controller.allTimeDeliveries.value}",
            title: "Deliveries",
            subtitle: "All time",
          ),
        ),
        SizedBox(width: 10.w),

        // 2. Avg/Trip This month
        Expanded(
          child: _buildMetricCard(
            badgeColor: const Color(0xFFE8F0FE),
            icon: const Icon(
              Icons.trending_up_rounded,
              color: Color(0xFF1E88E5),
              size: 15,
            ),
            value: controller.avgTripEarnings.value,
            title: "Avg/Trip",
            subtitle: "This month",
          ),
        ),
        SizedBox(width: 10.w),

        // 3. Pending In review
        Expanded(
          child: _buildMetricCard(
            badgeColor: const Color(0xFFFFF8E1),
            icon: const Icon(
              Icons.monetization_on_outlined,
              color: Color(0xFFFFA000),
              size: 15,
            ),
            value: controller.pendingEarnings.value,
            title: "Pending",
            subtitle: "In review",
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required Color badgeColor,
    required Widget icon,
    required String value,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Badge
          Container(
            width: 28.h,
            height: 28.h,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          SizedBox(height: 8.h),

          // Primary Value
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2D24),
            ),
          ),
          SizedBox(height: 1.h),

          // Label
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),

          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              color: const Color(0xFF8C9B92),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 4. WEEKLY EARNINGS BAR CHART CARD
  // ====================================================================
  Widget _buildWeeklyEarningsChartCard(EarningsController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Weekly Earnings + Pill date badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekly Earnings",
                style: GoogleFonts.inter(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2D24),
                ),
              ),

              // Date range pill badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: Color(0xFF236830),
                      size: 13,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      controller.weeklyDateRange.value,
                      style: GoogleFonts.inter(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF236830),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Total ₦68,100
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Total  ",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF7A8C80),
                  ),
                ),
                TextSpan(
                  text: controller.weeklyChartTotal.value,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),

          // Bar Chart with Left Y-Axis Labels
          SizedBox(
            height: 142.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left Y-Axis labels (N17k, N11k, N6k, N0k)
                Padding(
                  padding: EdgeInsets.only(bottom: 22.h),
                  child: SizedBox(
                    height: 110.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "N17k",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            color: const Color(0xFF9EABA2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "N11k",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            color: const Color(0xFF9EABA2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "N6k",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            color: const Color(0xFF9EABA2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "N0k",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            color: const Color(0xFF9EABA2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 14.w),

                // 7 Vertical Bars (Mon - Sun)
                Expanded(
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        controller.weeklyChartBars.length,
                        (index) {
                          final bar = controller.weeklyChartBars[index];
                          final isSelected =
                              controller.selectedDayIndex.value == index;

                          return GestureDetector(
                            onTap: () => controller.selectDay(index),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // The Vertical Bar
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  height: 110.h * bar.heightRatio,
                                  width: 17.w,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(
                                            0xFF236830,
                                          ) // Active dark forest green
                                        : const Color(
                                            0xFFCBE3D1,
                                          ), // Soft light sage mint
                                    borderRadius: BorderRadius.circular(6.r),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF236830,
                                              ).withValues(alpha: 0.25),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                                SizedBox(height: 8.h),

                                // Day Label underneath bar
                                Text(
                                  bar.day,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF1E2D24)
                                        : const Color(0xFF7A8C80),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 5. RECENT TRANSACTIONS SECTION
  // ====================================================================
  Widget _buildRecentTransactionsSection(
    BuildContext context,
    EarningsController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Transactions",
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E2D24),
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: controller.toggleShowAll,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.showAllTransactions.value
                          ? "See all"
                          : "See all",
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF236830),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Color(0xFF236830),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // List of Transaction Cards
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: controller.transactions.length,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final item = controller.transactions[index];
              return _buildTransactionCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(TransactionItem item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Icon Container:
          // Soft green with downward arrow for Credit / Payout
          // Soft pink/red with upward arrow for Debit / Withdrawal
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              color: item.isCredit
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              item.isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: item.isCredit
                  ? const Color(0xFF236830)
                  : const Color(0xFFE53935),
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Middle Column: Title, Subtitle, Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: const Color(0xFF7A8C80),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  item.date,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: const Color(0xFF9EABA2),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Right Column: Amount (+₦ / −₦) and Transaction Code
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: item.isCredit
                      ? const Color(0xFF236830) // Green for credit
                      : const Color(0xFFE53935), // Red for withdrawal
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                item.id,
                style: GoogleFonts.inter(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9EABA2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
