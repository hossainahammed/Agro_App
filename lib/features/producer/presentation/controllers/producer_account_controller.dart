import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/icon_path.dart';
import 'package:project_structure/features/authentication/presentation/widgets/sign_up_confirmation_dialog.dart';
import 'package:project_structure/features/producer/presentation/views/producer_main_screen.dart';

class ProducerAccountController extends GetxController {
  // Navigation
  final RxInt currentStep = 1.obs;
  final RxInt totalSteps = 3.obs; // Always 3 steps in total

  // Step 1: Personal Info
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Step 2: Activity details
  final RxString accountType = 'Private'.obs; // 'Private' or 'Company'
  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController rccmController = TextEditingController();
  final TextEditingController sirenController = TextEditingController();
  final TextEditingController agriculturalAreaController = TextEditingController(text: '5');
  final TextEditingController farmLocationController = TextEditingController();

  // Step 3: Documents (Paths & Names)
  final RxString cniFileName = ''.obs;
  final RxString landProofFileName = ''.obs;
  final RxString farmPhotoFileName = ''.obs;

  final ImagePicker _picker = ImagePicker();

  void setAccountType(String type) {
    accountType.value = type;
  }

  void nextStep() {
    if (validateCurrentStep()) {
      if (currentStep.value < 3) {
        currentStep.value++;
      } else {
        submit();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  bool validateCurrentStep() {
    if (currentStep.value == 1) {
      if (phoneController.text.trim().isEmpty) {
        AppSnackBar.error('Please enter your phone number.');
        return false;
      }
      if (cityController.text.trim().isEmpty) {
        AppSnackBar.error('Please select or type your city.');
        return false;
      }
      if (regionController.text.trim().isEmpty) {
        AppSnackBar.error('Please select or type your region.');
        return false;
      }
      if (addressController.text.trim().isEmpty) {
        AppSnackBar.error('Please enter your full address.');
        return false;
      }
    } else if (currentStep.value == 2) {
      if (farmNameController.text.trim().isEmpty) {
        AppSnackBar.error('Please enter the name of the farm/holding.');
        return false;
      }
      if (agriculturalAreaController.text.trim().isEmpty) {
        AppSnackBar.error('Please enter the agricultural area.');
        return false;
      }
      if (farmLocationController.text.trim().isEmpty) {
        AppSnackBar.error('Please enter the location of the farm.');
        return false;
      }
      
      // Dynamic validation for Company
      if (accountType.value == 'Company') {
        if (companyNameController.text.trim().isEmpty) {
          AppSnackBar.error('Please enter the company name.');
          return false;
        }
        if (rccmController.text.trim().isEmpty) {
          AppSnackBar.error('Please enter the RCCM number.');
          return false;
        }
        if (sirenController.text.trim().isEmpty) {
          AppSnackBar.error('Please enter the SIREN number.');
          return false;
        }
      }
    }
    return true;
  }

  Future<void> pickDocument(String type) async {
    // Show a picker modal offering Camera, Gallery, and Simulated PDF
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Document Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Get.back();
                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  _setFileName(type, photo.name);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Get.back();
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  _setFileName(type, image.name);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Simulate PDF Upload'),
              onTap: () {
                Get.back();
                _setFileName(type, '${type.toUpperCase()}_Document.pdf');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setFileName(String type, String name) {
    if (type == 'cni') {
      cniFileName.value = name;
    } else if (type == 'land') {
      landProofFileName.value = name;
    } else if (type == 'photo') {
      farmPhotoFileName.value = name;
    }
  }

  void removeDocument(String type) {
    if (type == 'cni') {
      cniFileName.value = '';
    } else if (type == 'land') {
      landProofFileName.value = '';
    } else if (type == 'photo') {
      farmPhotoFileName.value = '';
    }
  }

  void submit() {
    if (cniFileName.value.isEmpty) {
      AppSnackBar.error('Please upload your National Identity Card (CNI).');
      return;
    }
    if (landProofFileName.value.isEmpty) {
      AppSnackBar.error('Please upload your Land proof certificate.');
      return;
    }

    // Show confirmation dialog and navigate to NavBar dashboard screen
    showSignupConfirmationDialog(
      image: IconPath.success,
      title: 'Success',
      subTitle: 'Your producer account has been successfully created.',
      butonText: 'Go Dashboard',
      onTap: () {
        Get.offAll(() => const ProducerMainScreen());
      },
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    cityController.dispose();
    regionController.dispose();
    addressController.dispose();
    farmNameController.dispose();
    companyNameController.dispose();
    rccmController.dispose();
    sirenController.dispose();
    agriculturalAreaController.dispose();
    farmLocationController.dispose();
    super.onClose();
  }
}
