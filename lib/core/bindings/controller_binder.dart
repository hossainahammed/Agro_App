import 'package:get/get.dart';
import '../../features/profile/controller/profile_controller.dart';


class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(),fenix: true,);
  }
}
