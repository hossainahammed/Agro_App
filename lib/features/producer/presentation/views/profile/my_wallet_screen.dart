import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/routes/app_routes.dart';
import '../../controllers/producer_wallet_controller.dart';
import '../../../data/models/wallet_transaction_model.dart';
import 'widgets/withdraw_bottom_sheet.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProducerWalletController(), permanent: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      body: Column(
        children: [
          // 1. Banner Header (Balance & Actions)
          _buildHeader(controller),

          // 2. Clearance Cards (Pending & Total Withdrawn) and Bank Account Card
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  _buildClearanceRow(controller),
                  SizedBox(height: 16.h),
                  _buildBankAccountCard(controller),
                  SizedBox(height: 24.h),

                  // 3. Transactions Section (Tabs & Lists)
                  _buildTransactionsSection(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ProducerWalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B6A2F), Color(0xFF2E8A42)], // brand green gradient
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            // Header Top Row
            Row(
              children: [
                // Back Button (Circle style)
                CircleAvatar(
                  backgroundColor: Colors.white.withAlpha(38),
                  radius: 18.r,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(width: 12.w),
                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AGROCONNECT',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB5D9BB),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'My Wallet',
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // Top Info Pills Row
            Row(
              children: [
                // Wallet ID Pill (Copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: controller.walletId));
                    Get.snackbar(
                      'Copied',
                      'Wallet ID copied to clipboard.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 1),
                      margin: const EdgeInsets.all(16),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 13.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          controller.walletId,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.copy_rounded,
                          size: 12.sp,
                          color: Colors.white.withAlpha(160),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Secured Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 13.sp,
                        color: const Color(0xFFC6E8C7),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Secured',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFC6E8C7),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Available Balance Label + Eye Icon
            Row(
              children: [
                Text(
                  'Available Balance',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFB5D9BB),
                  ),
                ),
                SizedBox(width: 6.w),
                Obx(() {
                  return GestureDetector(
                    onTap: () => controller.toggleBalanceVisibility(),
                    child: Icon(
                      controller.isBalanceHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFFB5D9BB),
                      size: 16.sp,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 6.h),

            // Available Balance Text
            Obx(() {
              final String val = controller.isBalanceHidden.value
                  ? '••••••'
                  : '₦${_formatWithCommas(controller.availableBalance.value)}';
              return Text(
                val,
                style: GoogleFonts.inter(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }),
            SizedBox(height: 20.h),

            // Header Action Buttons (Withdraw and Refresh)
            Row(
              children: [
                // Withdraw Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.bottomSheet(
                        const WithdrawBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      minimumSize: Size(double.infinity, 48.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call_made_rounded,
                          size: 16.sp,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Withdraw',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Refresh Button
                GestureDetector(
                  onTap: () {
                    // Simulate refresh
                    Get.snackbar(
                      'Refreshed',
                      'Wallet balance and transactions updated.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: const Color(0xFF2D7A3A),
                      colorText: Colors.white,
                      duration: const Duration(seconds: 1),
                    );
                  },
                  child: Container(
                    width: 48.h,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(38),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20.sp,
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

  Widget _buildClearanceRow(ProducerWalletController controller) {
    return Obx(() {
      return Row(
        children: [
          // Pending Clearance Card
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.amber,
                        size: 20.sp,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Clearing',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '₦${_formatWithCommas(controller.pendingClearance.value)}',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Pending Clearance',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Arrives in 1–2 days',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: Colors.amber[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Total Withdrawn Card
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.call_made_rounded,
                        color: Colors.red,
                        size: 20.sp,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECEFF1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'All time',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '₦${_formatWithCommas(controller.totalWithdrawn.value)}',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Total Withdrawn',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Last: Jun 17, 2026',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBankAccountCard(ProducerWalletController controller) {
    return Obx(() {
      final defaultMethod = controller.defaultPayoutMethod;
      final bool hasMethod = defaultMethod != null;

      final String titleText = hasMethod 
          ? '${defaultMethod.providerName} · ${defaultMethod.type == 'bank_account' ? '****${defaultMethod.accountNumber.substring(defaultMethod.accountNumber.length - 4)}' : '*${defaultMethod.accountNumber.substring(defaultMethod.accountNumber.length - 3)}'}'
          : 'No Payout Method';

      final String subtitleText = hasMethod
          ? '${defaultMethod.type == 'bank_account' ? 'Bank Account' : 'Mobile Money'} · ${defaultMethod.accountName}'
          : 'Please add a payout method to withdraw';

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                color: Color(0xFFEDF7EE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasMethod && defaultMethod.type == 'mobile_money'
                    ? Icons.smartphone_rounded
                    : Icons.account_balance_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleText,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitleText,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoute.payoutMethods),
              child: Row(
                children: [
                  Text(
                    hasMethod ? 'Change' : 'Add',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D7A3A),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: const Color(0xFF2D7A3A),
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTransactionsSection(ProducerWalletController controller) {
    return Column(
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transactions',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Obx(() {
              return Text(
                '${controller.filteredTransactions.length} records',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
          ],
        ),
        SizedBox(height: 12.h),

        // Filter Tabs
        SizedBox(
          height: 34.h,
          child: Obx(() {
            final activeFilter = controller.selectedFilter.value;
            final List<String> filters = ['All', 'Credits', 'Withdrawals', 'Pending'];
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final bool isSelected = activeFilter == filter;

                return GestureDetector(
                  onTap: () => controller.setFilter(filter),
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2D7A3A) : const Color(0xFFE5ECE8),
                      borderRadius: BorderRadius.circular(17.r),
                    ),
                    child: Text(
                      filter,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        SizedBox(height: 18.h),

        // Grouped Transactions List
        Obx(() {
          final txs = controller.filteredTransactions;
          if (txs.isEmpty) {
            return _buildEmptyState();
          }

          // Get unique dateGroups present in filtered txs, preserving list order
          final List<String> dateGroups = [];
          for (var t in txs) {
            if (!dateGroups.contains(t.dateGroup)) {
              dateGroups.add(t.dateGroup);
            }
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: dateGroups.length,
            itemBuilder: (context, index) {
              final group = dateGroups[index];
              final groupTxs = txs.where((t) => t.dateGroup == group).toList();
              final double netSum = controller.getNetSumForDate(group);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group Header (Date & Net Sum)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          group,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        if (netSum != 0.0)
                          Text(
                            '${netSum > 0 ? '+' : ''}₦${_formatWithCommas(netSum)}',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: netSum > 0 ? const Color(0xFF2D7A3A) : Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFFE5ECE8), thickness: 1),

                  // Transaction List Tiles
                  ...groupTxs.map((t) => _buildTransactionTile(t)),
                  SizedBox(height: 12.h),
                ],
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildTransactionTile(WalletTransactionModel t) {
    Color amountColor = const Color(0xFF2D7A3A);
    Color badgeBgColor = const Color(0xFFEDF7EE);
    Color badgeTextColor = const Color(0xFF2D7A3A);
    String typeLabel = 'Credit';
    IconData leadingIcon = Icons.call_received_rounded;
    Color iconBgColor = const Color(0xFFEDF7EE);
    Color iconColor = const Color(0xFF2D7A3A);

    if (t.type == 'debit') {
      amountColor = Colors.red;
      badgeBgColor = const Color(0xFFFFEBEE);
      badgeTextColor = Colors.red;
      typeLabel = 'Debit';
      leadingIcon = Icons.call_made_rounded;
      iconBgColor = const Color(0xFFFFEBEE);
      iconColor = Colors.red;
    } else if (t.type == 'pending') {
      amountColor = Colors.amber[800]!;
      badgeBgColor = const Color(0xFFFFF8E1);
      badgeTextColor = Colors.amber[800]!;
      typeLabel = 'Pending';
      leadingIcon = Icons.access_time_rounded;
      iconBgColor = const Color(0xFFFFF8E1);
      iconColor = Colors.amber[800]!;
    }

    final String sign = t.type == 'debit' ? '-' : '+';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
      ),
      child: Row(
        children: [
          // Icon Leading
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              leadingIcon,
              color: iconColor,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Title & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  t.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  t.time,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),

          // Trailing Amount & Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign₦${_formatWithCommas(t.amount)}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  typeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 40.sp,
            color: AppColors.textSecondary.withAlpha(80),
          ),
          SizedBox(height: 12.h),
          Text(
            'No records found',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Format double amount with commas (e.g. 50,000)
  String _formatWithCommas(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
