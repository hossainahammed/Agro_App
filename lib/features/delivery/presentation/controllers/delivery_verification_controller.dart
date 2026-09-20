import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../views/verification/delivery_vehicle_docs_screen.dart';
import '../views/verification/delivery_verification_pending_screen.dart';

class DeliveryVerificationController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // ========================================================
  // STEP 1: IDENTITY DOCUMENTS
  // ========================================================
  final RxnString nationalIdFront = RxnString();
  final RxnString nationalIdFrontName = RxnString();
  final RxnString nationalIdBack = RxnString();
  final RxnString nationalIdBackName = RxnString();

  final RxnString licenseFront = RxnString();
  final RxnString licenseFrontName = RxnString();
  final RxnString licenseBack = RxnString();
  final RxnString licenseBackName = RxnString();

  // Returns number of uploaded identity documents (max 2: ID + License)
  int get identityUploadedCount {
    int count = 0;
    if (nationalIdFront.value != null || nationalIdBack.value != null) count++;
    if (licenseFront.value != null || licenseBack.value != null) count++;
    return count;
  }

  int get identityRemainingCount => 2 - identityUploadedCount;

  bool get isStep1Complete => identityUploadedCount >= 2;

  // ========================================================
  // STEP 2: VEHICLE & LEGAL DOCUMENTS
  // ========================================================
  final RxnString vehicleRegistration = RxnString();
  final RxnString vehicleRegistrationName = RxnString();

  final RxnString insuranceCertificate = RxnString();
  final RxnString insuranceCertificateName = RxnString();

  final RxnString policeClearance = RxnString();
  final RxnString policeClearanceName = RxnString();

  // Returns number of uploaded vehicle & legal documents (max 3)
  int get vehicleDocsUploadedCount {
    int count = 0;
    if (vehicleRegistration.value != null) count++;
    if (insuranceCertificate.value != null) count++;
    if (policeClearance.value != null) count++;
    return count;
  }

  int get vehicleDocsRemainingCount => 3 - vehicleDocsUploadedCount;

  bool get isStep2Complete => vehicleDocsUploadedCount >= 3;

  // ========================================================
  // SUBMISSION STATE
  // ========================================================
  final RxBool isSubmitting = false.obs;
  final RxString submissionTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    submissionTime.value = DateFormat('h:mm a').format(DateTime.now());
  }

  // ========================================================
  // DOCUMENT PICKING LOGIC
  // ========================================================
  Future<void> pickDocument({
    required BuildContext context,
    required Function(String path, String fileName) onSelected,
  }) async {
    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DFD8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose Upload Method",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2D24),
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF236830)),
              title: const Text("Take a photo with Camera"),
              onTap: () async {
                Get.back();
                try {
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    onSelected(photo.path, photo.name);
                  }
                } catch (e) {
                  // Fallback for demo on emulator
                  onSelected("demo_photo.jpg", "document_photo.jpg");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF236830)),
              title: const Text("Upload from Gallery / Files"),
              onTap: () async {
                Get.back();
                try {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    onSelected(image.path, image.name);
                  }
                } catch (e) {
                  // Fallback for demo on emulator
                  onSelected("demo_file.jpg", "document_file.jpg");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_outlined, color: Color(0xFF236830)),
              title: const Text("Use Sample Demo Document"),
              subtitle: const Text("Instantly loads sample preview for testing"),
              onTap: () {
                Get.back();
                onSelected(
                  "demo_sample.jpg",
                  "cheerful-young-sportswoman-yellow-id.jpg",
                );
              },
            ),
          ],
        ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Pre-fills all documents for rapid demo testing
  void prefillAllDemoDocuments() {
    nationalIdFront.value = "demo_id_front.jpg";
    nationalIdFrontName.value = "cheerful-young-sportswoman-yellow-id.jpg";
    nationalIdBack.value = "demo_id_back.jpg";
    nationalIdBackName.value = "national-id-back-scan.png";

    licenseFront.value = "demo_license_front.jpg";
    licenseFrontName.value = "driver-license-front-card.jpg";
    licenseBack.value = "demo_license_back.jpg";
    licenseBackName.value = "driver-license-back-details.png";

    vehicleRegistration.value = "demo_registration.pdf";
    vehicleRegistrationName.value = "vehicle-carte-grise-official.pdf";

    insuranceCertificate.value = "demo_insurance.pdf";
    insuranceCertificateName.value = "leadway-insurance-policy-2026.pdf";

    policeClearance.value = "demo_clearance.pdf";
    policeClearanceName.value = "npf-police-character-clearance.pdf";

    AppSnackBar.success("Demo documents loaded successfully.");
  }

  // ========================================================
  // NAVIGATION HANDLERS
  // ========================================================
  void proceedToVehicleDocs() {
    if (nationalIdFront.value == null && licenseFront.value == null) {
      // Prompt user or allow demo load
      AppSnackBar.info("Tip: You can tap 'Use Sample Demo Document' or upload an ID.");
    }
    Get.to(() => const DeliveryVehicleDocsScreen());
  }

  void submitAllDocumentsForReview() {
    isSubmitting.value = true;
    submissionTime.value = DateFormat('h:mm a').format(DateTime.now());

    Future.delayed(const Duration(milliseconds: 1400), () {
      isSubmitting.value = false;
      AppSnackBar.success("All documents submitted for review.");
      Get.off(() => const DeliveryVerificationPendingScreen());
    });
  }
}
