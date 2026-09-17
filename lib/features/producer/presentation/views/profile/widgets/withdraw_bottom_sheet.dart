import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/routes/app_routes.dart';
import '../../../controllers/producer_wallet_controller.dart';

class WithdrawBottomSheet extends StatefulWidget {
  const WithdrawBottomSheet({super.key});

  @override
  State<WithdrawBottomSheet> createState() => _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends State<WithdrawBottomSheet> {
  final controller = Get.find<ProducerWalletController>();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.resetWithdrawalFlow();
    textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final String cleanText = textController.text.replaceAll(',', '').trim();
    if (cleanText.isEmpty) {
      controller.setWithdrawAmount(0.0);
    } else {
      final double? parsed = double.tryParse(cleanText);
      if (parsed != null) {
        controller.setWithdrawAmount(parsed);
      }
    }
  }

  // Format amount with commas (e.g. 50,000)
  String _formatWithCommas(double amount) {
    if (amount == 0) return '0';
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void _setAmountFromPill(double amount) {
    textController.text = _formatWithCommas(amount);
    // Move cursor to end
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
    controller.setWithdrawAmount(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Obx(() {
        final step = controller.withdrawalStep.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slide indicator pill at very top
            SizedBox(height: 8.h),
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5ECE8),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),

            if (step == 1)
              _buildEnterAmountStep(context)
            else
              _buildConfirmStep(context),
          ],
        );
      }),
    );
  }

  Widget _buildEnterAmountStep(BuildContext context) {
    final double amount = controller.withdrawAmount.value;
    final bool isValid = amount >= 500 && amount <= controller.availableBalance.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Withdraw Funds',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: CircleAvatar(
                  radius: 14.r,
                  backgroundColor: const Color(0xFFF4F8F6),
                  child: Icon(Icons.close_rounded, size: 16.sp, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Bank Selector
          Obx(() {
            final defaultMethod = controller.defaultPayoutMethod;
            final bool hasMethod = defaultMethod != null;

            final String titleText = hasMethod 
                ? '${defaultMethod.providerName} · ${defaultMethod.type == 'bank_account' ? '****${defaultMethod.accountNumber.substring(defaultMethod.accountNumber.length - 4)}' : '*${defaultMethod.accountNumber.substring(defaultMethod.accountNumber.length - 3)}'}'
                : 'No Payout Method';

            final String subtitleText = hasMethod
                ? '${defaultMethod.accountName} · ${defaultMethod.providerName}'
                : 'Please add a payment method to withdraw';

            return GestureDetector(
              onTap: () {
                Get.back(); // close bottom sheet
                Get.toNamed(AppRoute.payoutMethods); // navigate to Payout Methods screen
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7EE), // soft green bg
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFC6E8C7), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D7A3A),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        hasMethod && defaultMethod.type == 'mobile_money'
                            ? Icons.smartphone_rounded
                            : Icons.account_balance_rounded,
                        color: Colors.white,
                        size: 16.sp,
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
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 20.h),

          // Label
          Text(
            'Enter Amount (Min ₦500)',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),

          // Input field container
          Container(
            height: 64.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8F6),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: amount > 0
                    ? (isValid ? const Color(0xFF2D7A3A) : Colors.red)
                    : const Color(0xFFE0ECE8),
                width: amount > 0 ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Text(
                  '₦ ',
                  style: GoogleFonts.inter(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: amount > 0 ? AppColors.textPrimary : AppColors.textSecondary.withAlpha(120),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.textSecondary.withAlpha(120),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                if (textController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      textController.clear();
                      controller.setWithdrawAmount(0.0);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  ),
              ],
            ),
          ),

          // Validation Warnings & Withdraw All link
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Show validation warning
              if (amount > 0 && amount < 500)
                Text(
                  'Minimum withdrawal is ₦500',
                  style: GoogleFonts.inter(color: Colors.red, fontSize: 11.sp, fontWeight: FontWeight.w500),
                )
              else if (amount > controller.availableBalance.value)
                Text(
                  'Insufficient available balance',
                  style: GoogleFonts.inter(color: Colors.red, fontSize: 11.sp, fontWeight: FontWeight.w500),
                )
              else
                const SizedBox.shrink(),

              // Withdraw all button
              GestureDetector(
                onTap: () => _setAmountFromPill(controller.availableBalance.value),
                child: Text(
                  'Withdraw all',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF2D7A3A),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // Speed Pill buttons row
          Row(
            children: [
              _buildSpeedPill(5000, '₦5k'),
              SizedBox(width: 8.w),
              _buildSpeedPill(10000, '₦10k'),
              SizedBox(width: 8.w),
              _buildSpeedPill(25000, '₦25k'),
              SizedBox(width: 8.w),
              _buildSpeedPill(50000, '₦50k'),
            ],
          ),
          SizedBox(height: 24.h),

          // Pinned Continue Button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.zero,
              child: ElevatedButton(
                onPressed: isValid ? () => controller.goToConfirmStep() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D7A3A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFF4F8F6),
                  disabledForegroundColor: AppColors.textSecondary.withAlpha(100),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    side: BorderSide(
                      color: isValid ? Colors.transparent : const Color(0xFFE0ECE8),
                    ),
                  ),
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.call_made_rounded,
                      size: 16.sp,
                      color: isValid ? Colors.white : AppColors.textSecondary.withAlpha(100),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(BuildContext context) {
    final double amount = controller.withdrawAmount.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Headers
          Text(
            'Confirm Withdrawal',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Review the details before proceeding.',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),

          // Detail list table grid
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8F6),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE0ECE8), width: 1),
            ),
            child: Column(
              children: [
                _buildConfirmRow('Amount', '₦${_formatWithCommas(amount)}', isBold: true),
                _buildConfirmDivider(),
                Obx(() {
                  final defMethod = controller.defaultPayoutMethod;
                  String methodText = 'No Account';
                  if (defMethod != null) {
                    final String suffix = defMethod.accountNumber.length > 4 
                        ? defMethod.accountNumber.substring(defMethod.accountNumber.length - 4) 
                        : defMethod.accountNumber;
                    methodText = '${defMethod.providerName} · ****$suffix';
                  }
                  return _buildConfirmRow('Account', methodText);
                }),
                _buildConfirmDivider(),
                _buildConfirmRow('Fee', '₦0.00 (free)'),
                _buildConfirmDivider(),
                _buildConfirmRow('Arrives', '1–2 business days'),
              ],
            ),
          ),
          SizedBox(height: 28.h),

          // Bottom Buttons Side-by-Side
          SafeArea(
            child: Row(
              children: [
                // Back Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.goToEnterAmountStep(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFB7CBC5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                      foregroundColor: AppColors.textPrimary,
                    ),
                    child: Text(
                      'Back',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Confirm Withdrawal Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.executeWithdrawal(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D7A3A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSpeedPill(double amt, String label) {
    final bool isSelected = controller.withdrawAmount.value == amt;

    return Expanded(
      child: GestureDetector(
        onTap: () => _setAmountFromPill(amt),
        child: Container(
          height: 38.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F3EA) : const Color(0xFFF4F8F6),
            borderRadius: BorderRadius.circular(19.r),
            border: Border.all(
              color: isSelected ? const Color(0xFF2D7A3A) : const Color(0xFFE0ECE8),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? const Color(0xFF2D7A3A) : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE0ECE8),
    );
  }
}
