import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../../controllers/producer_wallet_controller.dart';
import '../../../../data/models/payout_method_model.dart';

class AddPayoutMethodBottomSheet extends StatefulWidget {
  const AddPayoutMethodBottomSheet({super.key});

  @override
  State<AddPayoutMethodBottomSheet> createState() => _AddPayoutMethodBottomSheetState();
}

class _AddPayoutMethodBottomSheetState extends State<AddPayoutMethodBottomSheet> {
  final walletController = Get.find<ProducerWalletController>();

  // State flow variables
  int _step = 1; // 1 = Select Provider, 2 = Form Details
  String _selectedType = 'bank_account'; // 'bank_account' or 'mobile_money'
  Map<String, dynamic>? _selectedProvider;

  // Controllers
  final _numberController = TextEditingController();
  final _nameController = TextEditingController(text: 'Samuel Adeyemi');

  // Error state
  String? _numberError;

  // Lists of Banks and Providers
  final List<Map<String, dynamic>> _banks = [
    {'name': 'First Bank', 'code': 'FI', 'color': const Color(0xFF1B6A2F)},
    {'name': 'UBA', 'code': 'UB', 'color': const Color(0xFFD32F2F)},
    {'name': 'Zenith Bank', 'code': 'ZE', 'color': const Color(0xFF37474F)},
    {'name': 'Fidelity Bank', 'code': 'FI', 'color': const Color(0xFF0D47A1)},
    {'name': 'FCMB', 'code': 'FC', 'color': const Color(0xFF5E35B1)},
    {'name': 'Stanbic IBTC', 'code': 'ST', 'color': const Color(0xFF0288D1)},
  ];

  final List<Map<String, dynamic>> _mobileMoneyProviders = [
    {'name': 'MTN MoMo', 'code': 'MM', 'color': const Color(0xFFFFB300)},
    {'name': 'Airtel Money', 'code': 'AI', 'color': const Color(0xFFE53935)},
    {'name': 'OPay', 'code': 'OP', 'color': const Color(0xFF00B0FF)},
    {'name': 'PalmPay', 'code': 'PA', 'color': const Color(0xFF4CAF50)},
    {'name': 'Kuda', 'code': 'KU', 'color': const Color(0xFF4A148C)},
  ];

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onProviderSelected(Map<String, dynamic> provider) {
    setState(() {
      _selectedProvider = provider;
      _numberController.clear();
      _numberError = null;
      _step = 2;
    });
  }

  void _savePayoutMethod() {
    final numberText = _numberController.text.trim();
    final nameText = _nameController.text.trim();

    if (numberText.isEmpty) {
      setState(() {
        _numberError = _selectedType == 'bank_account' 
            ? 'Account number is required' 
            : 'Phone number is required';
      });
      return;
    }

    if (_selectedType == 'bank_account' && numberText.length < 10) {
      setState(() {
        _numberError = 'Account number must be 10 digits';
      });
      return;
    }

    if (_selectedType == 'mobile_money' && numberText.length < 7) {
      setState(() {
        _numberError = 'Please enter a valid phone number';
      });
      return;
    }

    // Success - add the new method
    final isFirst = walletController.payoutMethods.isEmpty;
    final formattedNumber = _selectedType == 'bank_account'
        ? numberText
        : '+234 $numberText';

    final newMethod = PayoutMethodModel(
      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
      providerName: _selectedProvider!['name'],
      type: _selectedType,
      accountNumber: formattedNumber,
      accountName: nameText.isEmpty ? 'Samuel Adeyemi' : nameText,
      addedDate: DateTime.now(),
      isDefault: isFirst,
    );

    walletController.addPayoutMethod(newMethod);
    Get.back();

    Get.snackbar(
      'Success',
      '${newMethod.providerName} added successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2D7A3A),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, MediaQuery.of(context).viewInsets.bottom + 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5ECE8),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          if (_step == 1)
            _buildSelectionStep()
          else
            _buildDetailsStep(),
        ],
      ),
    );
  }

  Widget _buildSelectionStep() {
    final providers = _selectedType == 'bank_account' ? _banks : _mobileMoneyProviders;
    final sectionTitle = _selectedType == 'bank_account' ? 'SELECT BANK' : 'SELECT PROVIDER';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add Payout Method',
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
        SizedBox(height: 20.h),

        // Custom Tab Switcher (Bank Account vs Mobile Money)
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8F6),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              // Bank Account Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = 'bank_account';
                    });
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: _selectedType == 'bank_account' ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: _selectedType == 'bank_account'
                          ? [
                              BoxShadow(
                                color: Colors.black.withAlpha(13),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_outlined,
                          size: 16.sp,
                          color: _selectedType == 'bank_account' ? AppColors.primary : AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Bank Account',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: _selectedType == 'bank_account' ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Mobile Money Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = 'mobile_money';
                    });
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: _selectedType == 'mobile_money' ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: _selectedType == 'mobile_money'
                          ? [
                              BoxShadow(
                                color: Colors.black.withAlpha(13),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone_android_outlined,
                          size: 16.sp,
                          color: _selectedType == 'mobile_money' ? AppColors.primary : AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Mobile Money',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: _selectedType == 'mobile_money' ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Selection Grid Label
        Text(
          sectionTitle,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 12.h),

        // Selection Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 2.2,
          ),
          itemCount: providers.length,
          itemBuilder: (context, index) {
            final prov = providers[index];
            return GestureDetector(
              onTap: () => _onProviderSelected(prov),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE5ECE8),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    // Grey Initial Circle Badge
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: const Color(0xFF758291).withAlpha(64),
                      child: Text(
                        prov['code'],
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5E6A75),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Provider Name
                    Expanded(
                      child: Text(
                        prov['name'],
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    final titleText = _selectedType == 'bank_account' ? 'Bank Account Details' : 'Mobile Money Details';
    final numberLabel = _selectedType == 'bank_account' ? 'Account Number' : 'Phone Number';
    final numberPlaceholder = _selectedType == 'bank_account' ? '0123456789' : '8001234567';
    final saveButtonText = _selectedType == 'bank_account' ? 'Save Bank Account' : 'Save Mobile Money';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with Back Button
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _step = 1;
                });
              },
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: const Color(0xFFF4F8F6),
                child: Icon(Icons.arrow_back_rounded, size: 16.sp, color: AppColors.textSecondary),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              titleText,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Selected Provider Highlight Card (with green border and light green bg)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF7EE), // light green bg
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFC6E8C7), // green border
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Circle Avatar with brand color and code
              CircleAvatar(
                radius: 20.r,
                backgroundColor: _selectedProvider!['color'],
                child: Text(
                  _selectedProvider!['code'],
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Provider Name
              Text(
                _selectedProvider!['name'],
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Input 1: Account / Phone Number
        Row(
          children: [
            Text(
              numberLabel,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              ' *',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8F6),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: _numberError != null ? Colors.red : const Color(0xFFE0ECE8),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (_selectedType == 'mobile_money') ...[
                Text(
                  '+234 ',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 4.w),
              ],
              Expanded(
                child: TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: numberPlaceholder,
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textSecondary.withAlpha(128),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (_) {
                    if (_numberError != null) {
                      setState(() {
                        _numberError = null;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        if (_numberError != null) ...[
          SizedBox(height: 4.h),
          Text(
            _numberError!,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        SizedBox(height: 18.h),

        // Input 2: Account Name
        Text(
          'Account Name',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),

        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8F6),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: const Color(0xFFE0ECE8),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Samuel Adeyemi',
              hintStyle: GoogleFonts.inter(
                color: AppColors.textSecondary.withAlpha(128),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        SizedBox(height: 24.h),

        // Save Button
        ElevatedButton(
          onPressed: _savePayoutMethod,
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
            saveButtonText,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
