import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProducerProfileController extends GetxController {
  // Profile State Variables (Observable)
  final RxString name = 'Samuel Adeyemi'.obs;
  final RxString phone = '(+225) 803 221 4477'.obs;
  final RxString email = 'samuel.adeyemi@agroconnect.ng'.obs;
  final RxString businessName = 'Adeyemi Green Farms'.obs;
  final RxString address = '14 Farm Road, Zaria, Kaduna'.obs;
  final RxString stateRegion = 'Kaduna'.obs;
  final RxString bio = 'Certified organic farmer growing fresh vegetables, grains, and spices. Supplying quality produce to markets across Northern Nigeria.'.obs;
  final RxString avatarUrl = 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400'.obs;
  
  // Read-only profile data
  final String agroConnectId = 'AGP-00834';
  final double rating = 4.8;
  final int reviewCount = 124;
  final int productsCount = 24;
  final int ordersCount = 412;
  final String revenue = '₦1.2M';
  final String sinceDate = 'Since March 2024';

  // Form Text Editing Controllers
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController businessNameController;
  late TextEditingController addressController;
  late TextEditingController bioController;

  @override
  void onInit() {
    super.onInit();
    // Initialize form controllers
    nameController = TextEditingController(text: name.value);
    phoneController = TextEditingController(text: phone.value);
    emailController = TextEditingController(text: email.value);
    businessNameController = TextEditingController(text: businessName.value);
    addressController = TextEditingController(text: address.value);
    bioController = TextEditingController(text: bio.value);
  }

  @override
  void onClose() {
    // Clean up controllers
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    businessNameController.dispose();
    addressController.dispose();
    bioController.dispose();
    super.onClose();
  }

  // Load current profile state into form controllers
  void loadFormValues() {
    nameController.text = name.value;
    phoneController.text = phone.value;
    emailController.text = email.value;
    businessNameController.text = businessName.value;
    addressController.text = address.value;
    bioController.text = bio.value;
  }

  // Save changes from form controllers to profile state
  void saveProfile() {
    name.value = nameController.text.trim();
    phone.value = phoneController.text.trim();
    email.value = emailController.text.trim();
    businessName.value = businessNameController.text.trim();
    address.value = addressController.text.trim();
    bio.value = bioController.text.trim();
    
    Get.back(); // Return to profile screen
    Get.snackbar(
      'Profile Updated',
      'Your profile changes have been saved successfully.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2D7A3A),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // Helper method to clear form fields
  void clearField(TextEditingController controller) {
    controller.clear();
  }
}
