import 'package:get/get.dart';

import '../../features/dashboard/controllers/dashboard_controller.dart';
import '../../features/nav_bar/controllers/nav_bar_controller.dart';
import '../../features/profile/controller/profile_controller.dart';


class ControllerBinder extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<NavBarController>( () => NavBarController(),fenix: true,);
     Get.lazyPut<DashboardController>(() => DashboardController(),fenix: true,);
    Get.lazyPut<ProfileController>(() => ProfileController(),fenix: true,);
  }
}
