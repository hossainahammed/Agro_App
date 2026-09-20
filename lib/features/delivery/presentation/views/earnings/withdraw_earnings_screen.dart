import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'withdrawal_requested_screen.dart';

class PayoutAccount {
  final String id;
  final String title;
  final String subtitle;
  final String owner;
  final bool isDefault;
  final bool isMobileMoney;
  final String eta;

  const PayoutAccount({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.owner,
    this.isDefault = false,
    this.isMobileMoney = true,
    this.eta = '5–30 min',
  });
}

class WithdrawEarningsScreen extends StatefulWidget {
  final double initialBalance;

  const WithdrawEarningsScreen({
    super.key,
    this.initialBalance = 23450.0,
  });

  @override
  State<WithdrawEarningsScreen> createState() => _WithdrawEarningsScreenState();
}

class _WithdrawEarningsScreenState extends State<WithdrawEarningsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  late double _balance;
  int _selectedAccountIndex = 0;
  double _enteredAmount = 0.0;

  final List<PayoutAccount> _accounts = const [
    PayoutAccount(
      id: 'momo_1',
      title: 'MTN Mobile Money',
      subtitle: '+234 803 ••• ••98',
      owner: 'Emeka Okafor · Default',
      isDefault: true,
      isMobileMoney: true,
      eta: '5–30 min',
    ),
    PayoutAccount(
      id: 'bank_1',
      title: 'Zenith Bank',
      subtitle: '•••••••4821 · Savings',
      owner: 'Emeka Okafor',
      isDefault: false,
      isMobileMoney: false,
      eta: '1–2 business days',
    ),
  ];

  final List<int> _quickPresets = const [2000, 5000, 10000, 15000];

  @override
  void initState() {
    super.initState();
    _balance = widget.initialBalance;
    _amountFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onAmountChanged(String val) {
    final clean = val.replaceAll(',', '').replaceAll('₦', '').trim();
    final parsed = double.tryParse(clean) ?? 0.0;
    setState(() {
      _enteredAmount = parsed;
    });
  }

  void _selectPreset(int amount) {
    setState(() {
      _enteredAmount = amount.toDouble();
      _amountController.text = _formatAmount(_enteredAmount);
    });
  }

  void _setMaxAmount() {
    setState(() {
      _enteredAmount = _balance;
      _amountController.text = _formatAmount(_enteredAmount);
    });
  }

  String _formatAmount(double amount) {
    if (amount == 0) return '0';
    final parts = amount.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(parts[i]);
    }
    return buffer.toString();
  }

  double get _fee {
    if (_enteredAmount <= 0) return 0;
    // 1% fee capped at 200
    final fee = _enteredAmount * 0.01;
    return fee > 200 ? 200 : (fee < 20 ? 20 : fee);
  }

  double get _netAmount {
    if (_enteredAmount <= 0) return 0;
    return _enteredAmount - _fee;
  }

  double get _balancePercentage {
    if (_balance <= 0) return 0;
    return (_enteredAmount / _balance).clamp(0.0, 1.0);
  }

  bool get _isValidAmount {
    return _enteredAmount >= 500 && _enteredAmount <= _balance;
  }

  void _confirmWithdrawal() {
    if (!_isValidAmount) {
      if (_enteredAmount < 500) {
        AppSnackBar.error('Minimum withdrawal amount is ₦500.');
      } else {
        AppSnackBar.error('Entered amount exceeds your available balance.');
      }
      return;
    }

    final selectedAccount = _accounts[_selectedAccountIndex];

    // Navigate to Withdrawal Requested screen (Confirmation review step)
    Get.to(
      () => WithdrawalRequestedScreen(
        requestedAmount: _enteredAmount,
        fee: _fee,
        netAmount: _netAmount,
        account: selectedAccount,
      ),
      transition: Transition.fadeIn,
    );
  }

  void _showAddAccountDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildAddAccountModal(ctx),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedAccount = _accounts[_selectedAccountIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: Column(
        children: [
          // 1. Top Forest Green App Bar
          _buildTopAppBar(context),

          // 2. Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Balance Card
                  _buildAvailableBalanceCard(),
                  SizedBox(height: 18.h),

                  // Enter Amount to Withdraw Section
                  _buildAmountInputSection(),
                  SizedBox(height: 20.h),

                  // Withdraw To Account Selector Section
                  _buildWithdrawToSection(),
                  SizedBox(height: 18.h),

                  // Withdrawal Rules Card
                  _buildWithdrawalRulesCard(),
                  SizedBox(height: 14.h),

                  // Security Assurance Card
                  _buildSecurityNoticeCard(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // 3. Bottom Action Bar with Sending Subtext & Confirm Button
          _buildBottomConfirmationBar(selectedAccount),
        ],
      ),
    );
  }

  // ====================================================================
  // 1. TOP FOREST GREEN APP BAR
  // ====================================================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF236830), // Solid forest green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 8.h,
        16.w,
        18.h,
      ),
      child: Row(
        children: [
          // Circular Translucent Back Button
          GestureDetector(
            onTap: () => Get.back(),
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
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 14.w),

          // Title & Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Withdraw Earnings",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 1.5.h),
              Text(
                "AgroConnect Driver Pay",
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  color: const Color(0xFFD6E8DA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 2. AVAILABLE BALANCE CARD
  // ====================================================================
  Widget _buildAvailableBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF184E23),
            Color(0xFF226732),
            Color(0xFF2C7D3E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5227).withValues(alpha: 0.30),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: AVAILABLE BALANCE + Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AVAILABLE BALANCE",
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFA3DEB0),
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "₦${_formatAmount(_balance)}",
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),

          // Right: Verified Pill + Timestamp
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Verified",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Updated just now",
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  color: const Color(0xFFD6E8DA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 3. ENTER AMOUNT TO WITHDRAW SECTION
  // ====================================================================
  Widget _buildAmountInputSection() {
    final hasAmount = _enteredAmount > 0;
    final isFocused = _amountFocusNode.hasFocus;
    final isHighlighted = isFocused || hasAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Amount to Withdraw",
          style: GoogleFonts.inter(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2D24),
          ),
        ),
        SizedBox(height: 8.h),

        // Main Outer Container (Focus & Enable border applied to the whole outer container)
        GestureDetector(
          onTap: () => _amountFocusNode.requestFocus(),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isHighlighted
                    ? const Color(0xFF236830) // Active / focused green border
                    : const Color(0xFFE2EDE4), // Default enabled soft border
                width: isHighlighted ? 1.8 : 1.2,
              ),
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: const Color(0xFF236830).withValues(alpha: 0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
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
                // Currency Prefix Symbol
                Text(
                  "₦ ",
                  style: GoogleFonts.inter(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isHighlighted
                        ? const Color(0xFF236830)
                        : const Color(0xFF9EABA2),
                  ),
                ),

                // Text Field without individual borders (handled by outer container)
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: _onAmountChanged,
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                    decoration: InputDecoration(
                      hintText: "0",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFCBD5E1),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                    ),
                  ),
                ),

              // MAX Action Pill Button
              GestureDetector(
                onTap: _setMaxAmount,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    "MAX",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF236830),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

        // Percentage Indicator under input (Screen 2 state)
        if (hasAmount) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(
                "${(_balancePercentage * 100).toStringAsFixed(0)}% of your balance",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: const Color(0xFF7A8C80),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.r),
                  child: LinearProgressIndicator(
                    value: _balancePercentage,
                    minHeight: 4.h,
                    backgroundColor: const Color(0xFFE2EDE4),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF236830),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 12.h),

        // Quick Preset Chips (₦2,000, ₦5,000, ₦10,000, ₦15,000)
        Row(
          children: _quickPresets.map((amount) {
            final isSelected = _enteredAmount == amount.toDouble();
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                child: GestureDetector(
                  onTap: () => _selectPreset(amount),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8F5E9)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(11.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF236830)
                            : const Color(0xFFE2EDE4),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "₦${_formatAmount(amount.toDouble())}",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF236830)
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ====================================================================
  // 4. WITHDRAW TO ACCOUNT SELECTOR SECTION
  // ====================================================================
  Widget _buildWithdrawToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Withdraw To",
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E2D24),
              ),
            ),
            GestureDetector(
              onTap: _showAddAccountDialog,
              behavior: HitTestBehavior.opaque,
              child: Text(
                "+ Add account",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF236830),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Accounts List
        ...List.generate(_accounts.length, (index) {
          final acc = _accounts[index];
          final isSelected = _selectedAccountIndex == index;

          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAccountIndex = index;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF236830) // Active green border
                        : const Color(0xFFE2EDE4),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Leading Square Icon Badge
                    Container(
                      width: 38.h,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: acc.isMobileMoney
                            ? const Color(0xFF236830) // Solid Green for MoMo
                            : const Color(0xFFF1F5F2), // Soft Grey for Bank
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        acc.isMobileMoney
                            ? Icons.phone_android_rounded
                            : Icons.account_balance_rounded,
                        color: acc.isMobileMoney
                            ? Colors.white
                            : const Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Middle Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                acc.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E2D24),
                                ),
                              ),
                              if (acc.isDefault) ...[
                                SizedBox(width: 5.w),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF236830),
                                  size: 14,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            acc.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: const Color(0xFF7A8C80),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            acc.owner,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF236830),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Trailing Action (Edit > or Select pill)
                    if (isSelected)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Edit",
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: const Color(0xFF7A8C80),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: Color(0xFF7A8C80),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "Select",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ====================================================================
  // 5. WITHDRAWAL RULES CARD
  // ====================================================================
  Widget _buildWithdrawalRulesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WITHDRAWAL RULES",
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF7A8C80),
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: 12.h),

          _buildRuleRow(
            badge: Container(
              width: 18.h,
              height: 18.h,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "₦",
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF236830),
                ),
              ),
            ),
            text: "Minimum withdrawal: ₦1,000",
          ),
          SizedBox(height: 8.h),

          _buildRuleRow(
            badge: Container(
              width: 18.h,
              height: 18.h,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "%",
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF236830),
                ),
              ),
            ),
            text: "Service fee: 0.0% (capped at ₦200)",
          ),
          SizedBox(height: 8.h),

          _buildRuleRow(
            badge: Container(
              width: 18.h,
              height: 18.h,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8E1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.bolt_rounded,
                color: Color(0xFFFFA000),
                size: 12,
              ),
            ),
            text: "Mobile Money: arrives in 5–30 min",
          ),
          SizedBox(height: 8.h),

          _buildRuleRow(
            badge: Container(
              width: 18.h,
              height: 18.h,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F0FE),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.account_balance_rounded,
                color: Color(0xFF1E88E5),
                size: 11,
              ),
            ),
            text: "Bank transfer: 1–2 business days",
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow({required Widget badge, required String text}) {
    return Row(
      children: [
        badge,
        SizedBox(width: 10.w),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFF2D3748),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ====================================================================
  // 6. SECURITY NOTICE CARD
  // ====================================================================
  Widget _buildSecurityNoticeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8F4),
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(color: const Color(0xFFD6E8DA), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: Color(0xFF236830),
            size: 16,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Your withdrawal is ",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  TextSpan(
                    text: "encrypted and secure",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  TextSpan(
                    text: ". You can cancel within 2 minutes of requesting.",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF4A5568),
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

  // ====================================================================
  // 7. BOTTOM CONFIRMATION ACTION BAR
  // ====================================================================
  Widget _buildBottomConfirmationBar(PayoutAccount selectedAccount) {
    final hasAmount = _enteredAmount > 0;
    final isEnabled = _isValidAmount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16.w,
        10.h,
        16.w,
        MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 6.h
            : 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2EDE4).withValues(alpha: 0.8),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Prompt above button (Screen 2: "Sending ₦14,800 to MTN MoMo...")
          if (hasAmount) ...[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Sending ",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF7A8C80),
                    ),
                  ),
                  TextSpan(
                    text: "₦${_formatAmount(_netAmount)} ",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  TextSpan(
                    text: "to ${selectedAccount.title} ${selectedAccount.subtitle}",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF7A8C80),
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
          ],

          // Confirm Withdrawal Button (Properly centered, no text clipping)
          GestureDetector(
            onTap: isEnabled ? _confirmWithdrawal : null,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: isEnabled
                    ? const Color(0xFF236830) // Solid dark green
                    : const Color(0xFFE8EEF5), // Disabled soft grey
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: const Color(0xFF236830).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 19.sp,
                    color: isEnabled
                        ? Colors.white
                        : const Color(0xFF8C9B92),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Confirm Withdrawal",
                    style: GoogleFonts.inter(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isEnabled
                          ? Colors.white
                          : const Color(0xFF8C9B92),
                      height: 1.1,
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

  // ====================================================================
  // ADD ACCOUNT MODAL SHEET
  // ====================================================================
  Widget _buildAddAccountModal(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        18.h,
        20.w,
        MediaQuery.of(ctx).viewInsets.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Add Payout Method",
            style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2D24),
            ),
          ),
          SizedBox(height: 14.h),
          ListTile(
            leading: const Icon(Icons.phone_android_rounded, color: Color(0xFF236830)),
            title: const Text("Mobile Money (MTN MoMo, Airtel Money)"),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(ctx);
              AppSnackBar.info("Mobile Money account linking coming soon.");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_balance_rounded, color: Color(0xFF236830)),
            title: const Text("Bank Account (NUBAN Instant Transfer)"),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(ctx);
              AppSnackBar.info("Bank account linking coming soon.");
            },
          ),
        ],
      ),
    );
  }
}
