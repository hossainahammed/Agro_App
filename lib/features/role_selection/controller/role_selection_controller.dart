import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../../producer/presentation/views/account_creation/producer_account_creation_screen.dart';

class RoleSelectionController extends GetxController {
  // Available roles: 'producer', 'buyer', 'delivery'
  final RxString selectedRole = 'producer'.obs;

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void handleContinue() {
    if (selectedRole.value == 'producer') {
      Get.to(() => const ProducerAccountCreationScreen());
    } else {
      AppSnackBar.error(
        'Onboarding for ${selectedRole.value == "delivery" ? "Delivery Person" : "Buyer"} is coming soon!',
      );
    }
  }
}
