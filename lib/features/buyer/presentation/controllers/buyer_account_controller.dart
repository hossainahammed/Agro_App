import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../views/account_creation/buyer_phone_verify_screen.dart';

class BuyerAccountController extends GetxController {
  // Form controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final deliveryAddressController = TextEditingController();
  final businessNameController = TextEditingController();
  final taxIdController = TextEditingController();

  // Search controllers
  final stateSearchController = TextEditingController();
  final businessTypeSearchController = TextEditingController();

  // Observable state
  final RxString selectedCountryCode = '+234'.obs;
  final RxString selectedCountryFlag = '🇳🇬'.obs;
  final RxString selectedCityState = 'FCT – Abuja'.obs;
  final RxString selectedBusinessType = ''.obs;

  final RxBool isBusinessDetailsExpanded = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool agreedToTerms = true.obs;
  final RxBool isLoading = false.obs;

  // Search filtered lists
  final RxList<String> filteredStates = <String>[].obs;
  final RxList<String> filteredBusinessTypes = <String>[].obs;

  // 37 States / Territories in Nigeria as requested
  static const List<String> allStates = [
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

  // Business Types as requested
  static const List<String> allBusinessTypes = [
    'Retail Shop',
    'Restaurant / Food Business',
    'Wholesale Distributor',
    'Hotel / Catering',
    'School / Institution',
    'Processing / Manufacturing',
    'Supermarket / Grocery',
    'NGO / Government',
    'Other',
  ];

  // Country Codes List
  final List<Map<String, String>> countryCodes = const [
    {'flag': '🇳🇬', 'code': '+234', 'name': 'Nigeria'},
    {'flag': '🇨🇮', 'code': '+225', 'name': 'Côte d’Ivoire'},
    {'flag': '🇬🇭', 'code': '+233', 'name': 'Ghana'},
    {'flag': '🇰🇪', 'code': '+254', 'name': 'Kenya'},
    {'flag': '🇿🇦', 'code': '+27', 'name': 'South Africa'},
    {'flag': '🇪🇬', 'code': '+20', 'name': 'Egypt'},
    {'flag': '🇷🇼', 'code': '+250', 'name': 'Rwanda'},
    {'flag': '🇨🇲', 'code': '+237', 'name': 'Cameroon'},
    {'flag': '🇸🇳', 'code': '+221', 'name': 'Senegal'},
    {'flag': '🇺🇬', 'code': '+256', 'name': 'Uganda'},
    {'flag': '🇹🇿', 'code': '+255', 'name': 'Tanzania'},
    {'flag': '🇬🇧', 'code': '+44', 'name': 'United Kingdom'},
    {'flag': '🇺🇸', 'code': '+1', 'name': 'United States'},
    {'flag': '🇨🇦', 'code': '+1', 'name': 'Canada'},
    {'flag': '🇦🇪', 'code': '+971', 'name': 'United Arab Emirates'},
  ];

  @override
  void onInit() {
    super.onInit();
    filteredStates.assignAll(allStates);
    filteredBusinessTypes.assignAll(allBusinessTypes);
  }

  void filterStates(String query) {
    if (query.trim().isEmpty) {
      filteredStates.assignAll(allStates);
    } else {
      filteredStates.assignAll(
        allStates.where(
          (state) => state.toLowerCase().contains(query.trim().toLowerCase()),
        ),
      );
    }
  }

  void filterBusinessTypes(String query) {
    if (query.trim().isEmpty) {
      filteredBusinessTypes.assignAll(allBusinessTypes);
    } else {
      filteredBusinessTypes.assignAll(
        allBusinessTypes.where(
          (type) => type.toLowerCase().contains(query.trim().toLowerCase()),
        ),
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void toggleTermsAgreement() {
    agreedToTerms.value = !agreedToTerms.value;
  }

  void toggleBusinessDetails() {
    isBusinessDetailsExpanded.value = !isBusinessDetailsExpanded.value;
  }

  void selectCityState(String state) {
    selectedCityState.value = state;
  }

  void selectBusinessType(String type) {
    selectedBusinessType.value = type;
  }

  void selectCountry(Map<String, String> country) {
    selectedCountryFlag.value = country['flag'] ?? '🇳🇬';
    selectedCountryCode.value = country['code'] ?? '+234';
  }

  void useCurrentLocation() {
    // Fill in realistic geolocated address
    deliveryAddressController.text =
        "Plot 42, Shehu Shagari Way, Central Business District, Abuja";
    selectedCityState.value = "FCT – Abuja";
    AppSnackBar.success('Current location detected and applied!');
  }

  void handleCreateBuyerAccount() {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final address = deliveryAddressController.text.trim();

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

    if (address.isEmpty) {
      AppSnackBar.error('Please enter your delivery address.');
      return;
    }

    if (selectedCityState.value.isEmpty) {
      AppSnackBar.error('Please select your city or state.');
      return;
    }

    if (!agreedToTerms.value) {
      AppSnackBar.error(
        'You must agree to the Terms & Conditions and Privacy Policy.',
      );
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
          () => BuyerPhoneVerifyScreen(
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
    deliveryAddressController.dispose();
    businessNameController.dispose();
    taxIdController.dispose();
    stateSearchController.dispose();
    businessTypeSearchController.dispose();
    super.onClose();
  }
}
