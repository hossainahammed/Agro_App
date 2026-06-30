import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/producer_wallet_controller.dart';
import '../../../data/models/payout_method_model.dart';
import 'widgets/add_payout_method_bottom_sheet.dart';

class PayoutMethodsScreen extends StatelessWidget {
  const PayoutMethodsScreen({super.key});

  // Helper to format account number or phone number for card display
  String _formatNumber(String number, String type) {
    final clean = number.replaceAll(' ', '');
    if (type == 'bank_account') {
      final last4 = clean.length >= 4 ? clean.substring(clean.length - 4) : clean;
      return '**** **** **** $last4';
    } else {
      // Mobile money phone number formatting (e.g. +234 803 *** *477)
      if (clean.startsWith('+234') && clean.length >= 13) {
        final part1 = clean.substring(0, 4); // +234
        final part2 = clean.substring(4, 7); // 803
        final last3 = clean.substring(clean.length - 3); // 477
        return '$part1 $part2 *** *$last3';
      } else if (clean.length >= 10) {
        // Fallback for standard 10 digit Nigerian numbers without country code
        final part1 = '+234';
        final part2 = clean.substring(1, 4); // e.g. 803
        final last3 = clean.substring(clean.length - 3); // e.g. 477
        return '$part1 $part2 *** *$last3';
      }
      // Fallback
      final last3 = clean.length >= 3 ? clean.substring(clean.length - 3) : clean;
      return '+234 803 *** *$last3';
    }
  }

  // Get nice gradient colors based on bank/provider name
  LinearGradient _getCardGradient(PayoutMethodModel method) {
    final name = method.providerName.toLowerCase();
    if (name.contains('gtbank') || name.contains('gtb')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFC04B02), Color(0xFFE2610A)], // deep orange
      );
    } else if (name.contains('mtn')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE5A100), Color(0xFFFFC400)], // gold/yellow
      );
    } else if (name.contains('access')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFC62828), Color(0xFFEF5350)], // red
      );
    } else if (name.contains('first bank')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F356B), Color(0xFF1E5296)], // navy/blue
      );
    } else if (name.contains('opay')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF008D46), Color(0xFF00C853)], // green
      );
    } else {
      // Default brand gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1B6A2F), Color(0xFF2E8A42)], // green
      );
    }
  }

  // Get avatar initials code based on provider name
  String _getInitials(String name) {
    if (name.toUpperCase().startsWith('MTN')) return 'MM';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  // Format date to string like "Mar 12, 2024"
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProducerWalletController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5), // soft greenish-grey background
      body: Column(
        children: [
          // 1. Dark Green Top Header
          _buildHeader(),

          // 2. Scrollable Body containing Methods
          Expanded(
            child: Obx(() {
              final defaultMethod = controller.defaultPayoutMethod;
              final methods = controller.payoutMethods;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Default Active Payout Method Summary Card (Top)
                    if (defaultMethod != null) ...[
                      _buildDefaultMethodSummaryCard(defaultMethod),
                      SizedBox(height: 20.h),
                    ],

                    // B. Methods Header Label
                    if (methods.isNotEmpty) ...[
                      Text(
                        'SAVED PAYOUT METHODS',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // C. Payout Cards List
                    if (methods.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: methods.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final method = methods[index];
                          return _buildPayoutCard(context, controller, method);
                        },
                      ),

                    SizedBox(height: 32.h),

                    // D. Add New Account Button
                    _buildAddButton(context),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      decoration: const BoxDecoration(
        color: Color(0xFF1B6A2F), // dark green banner
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
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
                        'WALLET',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB5D9BB),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Payout Methods',
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
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultMethodSummaryCard(PayoutMethodModel defaultMethod) {
    // Get last digits
    final String lastDigits = defaultMethod.accountNumber.length > 4
        ? defaultMethod.accountNumber.substring(defaultMethod.accountNumber.length - 4)
        : defaultMethod.accountNumber;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5ECE8), width: 1),
      ),
      child: Row(
        children: [
          // Green Circle avatar with device/phone or bank icon
          CircleAvatar(
            radius: 20.r,
            backgroundColor: const Color(0xFFEDF7EE),
            child: Icon(
              defaultMethod.type == 'bank_account'
                  ? Icons.account_balance_rounded
                  : Icons.smartphone_rounded,
              color: const Color(0xFF2D7A3A),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${defaultMethod.providerName} · *$lastDigits',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Withdrawals go here by default',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Default star badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1B6A2F),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 12.sp),
                SizedBox(width: 4.w),
                Text(
                  'Default',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10.sp,
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

  Widget _buildPayoutCard(BuildContext context, ProducerWalletController controller, PayoutMethodModel method) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getCardGradient(method),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upper Info Section
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar, Titles, Menu Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Initials Avatar
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.white24,
                      child: Text(
                        _getInitials(method.providerName),
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Titles
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.providerName,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                method.type == 'bank_account'
                                    ? Icons.account_balance_rounded
                                    : Icons.phone_android_rounded,
                                size: 11.sp,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                method.type == 'bank_account' ? 'Bank Account' : 'Mobile Money',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Three-dot Action Menu
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'default') {
                          controller.setDefaultPayoutMethod(method.id);
                        } else if (value == 'delete') {
                          _showDeleteConfirmation(context, controller, method);
                        }
                      },
                      itemBuilder: (context) => [
                        if (!method.isDefault)
                          PopupMenuItem(
                            value: 'default',
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber),
                                SizedBox(width: 8.w),
                                Text(
                                  'Set as default',
                                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline_rounded, color: Colors.red),
                              SizedBox(width: 8.w),
                              Text(
                                'Delete account',
                                style: GoogleFonts.inter(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Card Number display
                Text(
                  _formatNumber(method.accountNumber, method.type),
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: method.type == 'bank_account' ? 1.5 : 0.8,
                  ),
                ),
                SizedBox(height: 24.h),

                // Account Name & Date Added Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Account Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACCOUNT NAME',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white60,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          method.accountName,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Added Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ADDED',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white60,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          _formatDate(method.addedDate),
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(30),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Verified & Secured indicator
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14.sp,
                      color: Colors.white.withAlpha(204),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Verified & Secured',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.white.withAlpha(204),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Default toggle or status text
                GestureDetector(
                  onTap: () {
                    if (!method.isDefault) {
                      controller.setDefaultPayoutMethod(method.id);
                    }
                  },
                  child: Row(
                    children: [
                      if (method.isDefault) ...[
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Active payout',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Set as default',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.white.withAlpha(230),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 14.sp,
                          color: Colors.white.withAlpha(230),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 48.h),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_off_outlined,
            size: 48.sp,
            color: AppColors.textSecondary.withAlpha(102),
          ),
          SizedBox(height: 12.h),
          Text(
            'No Payout Methods Added Yet',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Add an account to receive your withdrawals.',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          const AddPayoutMethodBottomSheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D7A3A),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        minimumSize: Size(double.infinity, 52.h),
      ),
      child: Text(
        'Add New Account',
        style: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProducerWalletController controller, PayoutMethodModel method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Payout Method',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${method.providerName} account ending in ${_formatNumber(method.accountNumber, method.type).split(' ').last}?',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deletePayoutMethod(method.id);
              Get.back();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
