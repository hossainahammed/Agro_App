import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../views/buyer_main_screen.dart';

class BuyerPhoneVerifyController extends GetxController {
  final String rawPhoneNumber;
  final String countryCode;

  BuyerPhoneVerifyController({
    this.rawPhoneNumber = '8000000000',
    this.countryCode = '+234',
  });

  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final RxInt remainingSeconds = 17.obs;
  final RxBool isResendClickable = false.obs;
  final RxBool isLoading = false.obs;
  final RxString currentOtp = ''.obs;

  Timer? _timer;

  static const String demoOtp = '482810';

  @override
  void onInit() {
    super.onInit();
    startCountdown(17);
  }

  void startCountdown([int seconds = 17]) {
    _timer?.cancel();
    remainingSeconds.value = seconds;
    isResendClickable.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 1) {
        remainingSeconds.value--;
      } else {
        remainingSeconds.value = 0;
        isResendClickable.value = true;
        timer.cancel();
      }
    });
  }

  String get countdownText {
    final s = remainingSeconds.value;
    final minutes = (s ~/ 60).toString().padLeft(2, '0');
    final seconds = (s % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get maskedPhoneNumber {
    final clean = rawPhoneNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.length >= 7) {
      final prefix = clean.substring(0, 3);
      final suffix = clean.substring(clean.length - 4);
      return '$countryCode $prefix •••• $suffix';
    }
    return '$countryCode $rawPhoneNumber';
  }

  void onOtpChanged(String value) {
    currentOtp.value = value;
  }

  void applyDemoCode() {
    otpController.text = demoOtp;
    currentOtp.value = demoOtp;
    verifyPhone();
  }

  void resendCode() {
    if (!isResendClickable.value) return;

    otpController.clear();
    currentOtp.value = '';
    startCountdown(17);

    AppSnackBar.success('A new verification code has been sent!');
  }

  void verifyPhone() {
    final enteredOtp = otpController.text.trim();

    if (enteredOtp.length < 6) {
      AppSnackBar.error('Please enter the full 6-digit code.');
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoading.value = false;

      if (enteredOtp == demoOtp || enteredOtp.length == 6) {
        AppSnackBar.success('Phone verified! Welcome to AgroConnect.');
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAll(() => const BuyerMainScreen());
        });
      } else {
        AppSnackBar.error('Invalid code. Please enter the demo code: $demoOtp');
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
