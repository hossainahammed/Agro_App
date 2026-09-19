import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import '../../delivery/presentation/views/account_creation/delivery_account_creation_screen.dart';
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
    } else if (selectedRole.value == 'delivery') {
      Get.to(() => const DeliveryAccountCreationScreen());
    } else {
      AppSnackBar.error(
        'Onboarding for Buyer is coming soon!',
      );
    }
  }
}
