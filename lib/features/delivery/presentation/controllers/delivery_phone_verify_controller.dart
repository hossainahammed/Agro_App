import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../views/verification/delivery_identity_verify_screen.dart';

class DeliveryPhoneVerifyController extends GetxController {
  final String rawPhoneNumber;
  final String countryCode;

  DeliveryPhoneVerifyController({
    this.rawPhoneNumber = '8030000477',
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
      final suffix = clean.substring(clean.length - 3);
      return '$countryCode $prefix *** *$suffix';
    }
    return '$countryCode 803 *** *477';
  }

  void onOtpChanged(String value) {
    currentOtp.value = value;
  }

  void applyDemoCode() {
    otpController.text = demoOtp;
    currentOtp.value = demoOtp;
    AppSnackBar.info('Demo code $demoOtp applied.');
  }

  void resendCode() {
    if (!isResendClickable.value) return;
    startCountdown(30);
    AppSnackBar.success('Verification code resent to $maskedPhoneNumber');
  }

  void verifyPhone() {
    final code = otpController.text.trim();
    if (code.length < 6) {
      AppSnackBar.error('Please enter the complete 6-digit verification code.');
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoading.value = false;
      AppSnackBar.success('Phone verified successfully! Please upload your documents.');
      
      Future.delayed(const Duration(milliseconds: 600), () {
        Get.off(() => const DeliveryIdentityVerifyScreen());
      });
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
