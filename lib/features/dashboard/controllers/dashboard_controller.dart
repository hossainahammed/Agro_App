import 'package:get/get.dart';

class DashboardController extends GetxController {
  // final RxBool isBibleLoading = false.obs;
  // final dashboardFeatureModel = Rxn<DashboardFeatureModel>();
  // Future<void> fetchDashboardFeature() async {
  //   try {
  //     isBibleLoading(true);
  //     final response = await NetworkCaller().getRequest(
  //       AppUrls.login,
  //       token: "Bearer ${AuthService.token}",
  //     );
  //     if (response.isSuccess) {
  //       dashboardFeatureModel.value = DashboardFeatureModel.fromJson(
  //         response.responseData,
  //       );
  //       AppLoggerHelper.debug(response.responseData);
  //     }
  //   } catch (e) {
  //     AppLoggerHelper.error("Error : ${e.toString()}");
  //     AppSnackBar.error("Something went wrong. Try again later.");
  //   } finally {
  //     isBibleLoading(false);
  //   }
  // }
}
