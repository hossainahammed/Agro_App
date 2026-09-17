import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProducerSettingsController extends GetxController {
  // Notification Switch States (Observable)
  final RxBool isPushEnabled = true.obs;
  final RxBool isEmailEnabled = true.obs;
  final RxBool isOrderAlertsEnabled = true.obs;

  // Password Input Controllers
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void onInit() {
    super.onInit();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePush(bool val) {
    isPushEnabled.value = val;
  }

  void toggleEmail(bool val) {
    isEmailEnabled.value = val;
  }

  void toggleOrderAlerts(bool val) {
    isOrderAlertsEnabled.value = val;
  }

  // Validate form and change password
  void changePassword() {
    final String oldPass = oldPasswordController.text;
    final String newPass = newPasswordController.text;
    final String confirmPass = confirmPasswordController.text;

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all password fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar(
        'Validation Error',
        'New password and confirm password do not match.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar(
        'Validation Error',
        'New password must be at least 6 characters.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Success
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    Get.back(); // Go back to settings screen
    Get.snackbar(
      'Password Changed',
      'Your account password has been updated successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2D7A3A),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
