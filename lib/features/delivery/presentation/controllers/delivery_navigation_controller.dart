import 'package:get/get.dart';

class DeliveryNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxInt unreadMessages = 2.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
