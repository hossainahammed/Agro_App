import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/wallet_transaction_model.dart';
import '../../data/models/payout_method_model.dart';

class ProducerWalletController extends GetxController {
  // Wallet State
  final RxDouble availableBalance = 184800.0.obs;
  final RxDouble pendingClearance = 20400.0.obs;
  final RxDouble totalWithdrawn = 230000.0.obs;
  final String walletId = 'AGW-00834';
  
  final RxBool isBalanceHidden = false.obs;
  final RxString selectedFilter = 'All'.obs;

  // Payout Methods State
  final RxList<PayoutMethodModel> payoutMethods = <PayoutMethodModel>[].obs;

  // Transactions list
  final RxList<WalletTransactionModel> allTransactions = <WalletTransactionModel>[].obs;
  final RxList<WalletTransactionModel> filteredTransactions = <WalletTransactionModel>[].obs;

  // Withdrawal Bottom Sheet Flow State
  final RxDouble withdrawAmount = 0.0.obs;
  final RxInt withdrawalStep = 1.obs; // 1 = Enter Amount, 2 = Confirm

  @override
  void onInit() {
    super.onInit();
    _loadMockPayoutMethods();
    _loadMockTransactions();
    _updateFilteredTransactions();
  }

  void _loadMockPayoutMethods() {
    payoutMethods.assignAll([
      PayoutMethodModel(
        id: 'pm1',
        providerName: 'MTN MoMo',
        type: 'mobile_money',
        accountNumber: '+234 803 123 4477',
        accountName: 'Samuel Adeyemi',
        addedDate: DateTime(2026, 6, 1),
        isDefault: true,
      ),
      PayoutMethodModel(
        id: 'pm2',
        providerName: 'GTBank',
        type: 'bank_account',
        accountNumber: '0123454412',
        accountName: 'Samuel Adeyemi',
        addedDate: DateTime(2024, 3, 12),
        isDefault: false,
      ),
      PayoutMethodModel(
        id: 'pm3',
        providerName: 'Access Bank',
        type: 'bank_account',
        accountNumber: '0123458830',
        accountName: 'Adeyemi Green Farms',
        addedDate: DateTime(2025, 1, 5),
        isDefault: false,
      ),
      PayoutMethodModel(
        id: 'pm4',
        providerName: 'First Bank',
        type: 'bank_account',
        accountNumber: '0123455345',
        accountName: 'sgdfgh',
        addedDate: DateTime(2026, 6, 22),
        isDefault: false,
      ),
      PayoutMethodModel(
        id: 'pm5',
        providerName: 'OPay',
        type: 'mobile_money',
        accountNumber: '+234 445 123 4445',
        accountName: 'jmnhnfghgf',
        addedDate: DateTime(2026, 6, 22),
        isDefault: false,
      ),
    ]);
  }

  void addPayoutMethod(PayoutMethodModel method) {
    if (method.isDefault) {
      for (int i = 0; i < payoutMethods.length; i++) {
        payoutMethods[i] = payoutMethods[i].copyWith(isDefault: false);
      }
    }
    payoutMethods.add(method);
    payoutMethods.refresh();
  }

  void deletePayoutMethod(String id) {
    final int index = payoutMethods.indexWhere((m) => m.id == id);
    if (index != -1) {
      final wasDefault = payoutMethods[index].isDefault;
      payoutMethods.removeAt(index);
      if (wasDefault && payoutMethods.isNotEmpty) {
        payoutMethods[0] = payoutMethods[0].copyWith(isDefault: true);
      }
      payoutMethods.refresh();
    }
  }

  void setDefaultPayoutMethod(String id) {
    for (int i = 0; i < payoutMethods.length; i++) {
      if (payoutMethods[i].id == id) {
        payoutMethods[i] = payoutMethods[i].copyWith(isDefault: true);
      } else {
        payoutMethods[i] = payoutMethods[i].copyWith(isDefault: false);
      }
    }
    payoutMethods.refresh();
  }

  PayoutMethodModel? get defaultPayoutMethod {
    return payoutMethods.firstWhereOrNull((m) => m.isDefault);
  }

  void _loadMockTransactions() {
    allTransactions.assignAll([
      // TODAY
      WalletTransactionModel(
        id: 't1',
        title: 'Order Payment',
        subtitle: 'Aisha Musa · AGC-2841',
        amount: 27000.0,
        time: '9:14 AM',
        dateGroup: 'TODAY',
        type: 'credit',
        isPending: false,
      ),
      WalletTransactionModel(
        id: 't2',
        title: 'Order Payment',
        subtitle: 'Chukwudi Eze · AGC-2839',
        amount: 22000.0,
        time: '8:50 AM',
        dateGroup: 'TODAY',
        type: 'credit',
        isPending: false,
      ),
      WalletTransactionModel(
        id: 't3',
        title: 'Bank Withdrawal',
        subtitle: 'GTB ****4412',
        amount: 50000.0,
        time: '7:30 AM',
        dateGroup: 'TODAY',
        type: 'debit',
        isPending: false,
      ),
 
      // YESTERDAY
      WalletTransactionModel(
        id: 't4',
        title: 'Order Payment',
        subtitle: 'Fatima Bello · AGC-2830',
        amount: 20400.0,
        time: '11:30 AM',
        dateGroup: 'YESTERDAY',
        type: 'pending',
        isPending: true,
      ),
      WalletTransactionModel(
        id: 't5',
        title: 'Order Payment',
        subtitle: 'Emeka Okonkwo · AGC-2821',
        amount: 54000.0,
        time: '8:55 AM',
        dateGroup: 'YESTERDAY',
        type: 'credit',
        isPending: false,
      ),
      WalletTransactionModel(
        id: 't6',
        title: 'Referral Bonus',
        subtitle: 'Yusuf Garba referral',
        amount: 1500.0,
        time: '6:00 AM',
        dateGroup: 'YESTERDAY',
        type: 'credit',
        isPending: false,
      ),
 
      // JUN 17, 2026
      WalletTransactionModel(
        id: 't7',
        title: 'Bank Withdrawal',
        subtitle: 'GTB ****4412',
        amount: 100000.0,
        time: '3:00 PM',
        dateGroup: 'JUN 17, 2026',
        type: 'debit',
        isPending: false,
      ),
      WalletTransactionModel(
        id: 't8',
        title: 'Order Payment',
        subtitle: 'Ngozi Adaeze · AGC-2798',
        amount: 62000.0,
        time: '10:22 AM',
        dateGroup: 'JUN 17, 2026',
        type: 'credit',
        isPending: false,
      ),
    ]);
  }

  // Toggle visible/hidden balance
  void toggleBalanceVisibility() {
    isBalanceHidden.value = !isBalanceHidden.value;
  }

  // Set filter and refresh list
  void setFilter(String filter) {
    selectedFilter.value = filter;
    _updateFilteredTransactions();
  }

  void _updateFilteredTransactions() {
    if (selectedFilter.value == 'All') {
      filteredTransactions.assignAll(allTransactions);
    } else if (selectedFilter.value == 'Credits') {
      filteredTransactions.assignAll(allTransactions.where((t) => t.type == 'credit').toList());
    } else if (selectedFilter.value == 'Withdrawals') {
      filteredTransactions.assignAll(allTransactions.where((t) => t.type == 'debit').toList());
    } else if (selectedFilter.value == 'Pending') {
      filteredTransactions.assignAll(allTransactions.where((t) => t.isPending).toList());
    }
  }

  // Calculate Net Sum of transactions for a specific date group (only cleared credits and debits)
  double getNetSumForDate(String dateGroup) {
    double sum = 0.0;
    final dayTransactions = allTransactions.where((t) => t.dateGroup == dateGroup);
    
    for (var t in dayTransactions) {
      if (t.type == 'credit') {
        sum += t.amount;
      } else if (t.type == 'debit') {
        sum -= t.amount;
      }
    }
    return sum;
  }

  // Set withdrawal amount from bottom sheet
  void setWithdrawAmount(double amount) {
    withdrawAmount.value = amount;
  }

  // Reset withdrawal sheet state
  void resetWithdrawalFlow() {
    withdrawAmount.value = 0.0;
    withdrawalStep.value = 1;
  }

  // Go to confirm step
  void goToConfirmStep() {
    if (withdrawAmount.value >= 500 && withdrawAmount.value <= availableBalance.value) {
      withdrawalStep.value = 2;
    }
  }

  // Go back to input step
  void goToEnterAmountStep() {
    withdrawalStep.value = 1;
  }

  // Execute withdrawal
  void executeWithdrawal() {
    final double amountToWithdraw = withdrawAmount.value;
    if (amountToWithdraw < 500 || amountToWithdraw > availableBalance.value) return;

    // Deduct from available balance
    availableBalance.value -= amountToWithdraw;
    // Add to total withdrawn
    totalWithdrawn.value += amountToWithdraw;

    // Get current default payout method details
    final defMethod = defaultPayoutMethod;
    String methodSubtitle = 'Bank Withdrawal';
    if (defMethod != null) {
      final String suffix = defMethod.accountNumber.length > 4 
          ? defMethod.accountNumber.substring(defMethod.accountNumber.length - 4) 
          : defMethod.accountNumber;
      methodSubtitle = '${defMethod.providerName} · ****$suffix';
    }

    // Create a new Bank Withdrawal transaction log
    final now = DateTime.now();
    final String timeStr = _formatTime(now);

    final newTransaction = WalletTransactionModel(
      id: 'tx_with_${now.millisecondsSinceEpoch}',
      title: 'Bank Withdrawal',
      subtitle: methodSubtitle,
      amount: amountToWithdraw,
      time: timeStr,
      dateGroup: 'TODAY',
      type: 'debit',
      isPending: false,
    );

    // Add to transaction list
    allTransactions.insert(0, newTransaction);
    
    // Refresh filter list
    _updateFilteredTransactions();

    // Close bottom sheet
    Get.back();
    resetWithdrawalFlow();

    // Success snackbar
    Get.snackbar(
      'Withdrawal Successful',
      '₦${amountToWithdraw.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} has been sent to your account.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2D7A3A),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    final int minute = date.minute;
    final String ampm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;
    final String minuteStr = minute < 10 ? '0$minute' : '$minute';
    return '$hour:$minuteStr $ampm';
  }
}
