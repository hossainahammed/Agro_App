import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../views/account_creation/delivery_phone_verify_screen.dart';

class DeliveryAccountController extends GetxController {
  // Form controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable state
  final RxString selectedCountryCode = '+234'.obs;
  final RxString selectedCountryFlag = '🇳🇬'.obs;
  final RxString selectedVehicleType = 'Motorbike'.obs;
  final RxString selectedCityState = 'FCT – Abuja'.obs;

  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool agreedToTerms = true.obs;
  final RxBool isLoading = false.obs;

  // Options
  final List<Map<String, String>> countryCodes = const [
    {'flag': '🇳🇬', 'code': '+234', 'name': 'Nigeria'},
    {'flag': '🇬🇭', 'code': '+233', 'name': 'Ghana'},
    {'flag': '🇰🇪', 'code': '+254', 'name': 'Kenya'},
    {'flag': '🇿🇦', 'code': '+27', 'name': 'South Africa'},
    {'flag': '🇪🇬', 'code': '+20', 'name': 'Egypt'},
    {'flag': '🇷🇼', 'code': '+250', 'name': 'Rwanda'},
    {'flag': '🇨🇲', 'code': '+237', 'name': 'Cameroon'},
    {'flag': '🇨🇮', 'code': '+225', 'name': 'Côte d’Ivoire'},
    {'flag': '🇸🇳', 'code': '+221', 'name': 'Senegal'},
    {'flag': '🇺🇬', 'code': '+256', 'name': 'Uganda'},
    {'flag': '🇹🇿', 'code': '+255', 'name': 'Tanzania'},
    {'flag': '🇬🇧', 'code': '+44', 'name': 'United Kingdom'},
    {'flag': '🇺🇸', 'code': '+1', 'name': 'United States'},
    {'flag': '🇨🇦', 'code': '+1', 'name': 'Canada'},
    {'flag': '🇦🇪', 'code': '+971', 'name': 'United Arab Emirates'},
  ];

  final List<String> vehicleTypes = const [
    'Motorbike',
    'Tricycle',
    'Van',
    'Truck',
    'Other',
  ];

  final List<String> citiesStates = const [
    'FCT – Abuja',
    'Lagos',
    'Kano',
    'Kaduna',
    'Enugu',
    'Rivers',
    'Oyo',
    'Delta',
    'Anambra',
    'Katsina',
    'Ogun',
    'Imo',
    'Borno',
    'Niger',
    'Kwara',
    'Bauchi',
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Bayelsa',
    'Benue',
    'Cross River',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Gombe',
    'Jigawa',
    'Kebbi',
    'Kogi',
    'Nasarawa',
    'Ondo',
    'Osun',
    'Plateau',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara',
  ];

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void toggleTermsAgreement() {
    agreedToTerms.value = !agreedToTerms.value;
  }

  void selectVehicleType(String type) {
    selectedVehicleType.value = type;
  }

  void selectCityState(String cityState) {
    selectedCityState.value = cityState;
  }

  void selectCountry(Map<String, String> country) {
    selectedCountryFlag.value = country['flag'] ?? '🇳🇬';
    selectedCountryCode.value = country['code'] ?? '+234';
  }

  void handleCreateDriverAccount() {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (fullName.isEmpty) {
      AppSnackBar.error('Please enter your full name.');
      return;
    }

    if (phone.isEmpty) {
      AppSnackBar.error('Please enter your phone number.');
      return;
    }

    if (phone.length < 8) {
      AppSnackBar.error('Please enter a valid phone number.');
      return;
    }

    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      AppSnackBar.error('Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      AppSnackBar.error('Please enter your password.');
      return;
    }

    if (password.length < 8) {
      AppSnackBar.error('Password must be at least 8 characters long.');
      return;
    }

    if (password != confirmPassword) {
      AppSnackBar.error('Passwords do not match.');
      return;
    }

    if (selectedVehicleType.value.isEmpty) {
      AppSnackBar.error('Please select your vehicle type.');
      return;
    }

    if (selectedCityState.value.isEmpty) {
      AppSnackBar.error('Please select your city or state.');
      return;
    }

    if (!agreedToTerms.value) {
      AppSnackBar.error('You must agree to the Terms & Conditions and Privacy Policy.');
      return;
    }

    // Simulate account creation & send OTP
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoading.value = false;
      AppSnackBar.success('Verification code sent to your phone!');
      
      // Navigate to phone verification screen
      Future.delayed(const Duration(milliseconds: 600), () {
        Get.to(
          () => DeliveryPhoneVerifyScreen(
            phoneNumber: phone,
            countryCode: selectedCountryCode.value,
          ),
        );
      });
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
