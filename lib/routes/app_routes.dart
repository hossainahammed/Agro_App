import 'package:get/get.dart';
import 'package:project_structure/features/authentication/presentation/screens/email_verify_screen.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/sing_up_screen.dart';
import 'package:project_structure/features/authentication/presentation/screens/forgot_password_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/splash_screen/presentation/screens/splash_screen.dart';
import '../features/notification/presentation/bindings/notification_binding.dart';
import '../features/notification/presentation/views/notification_screen.dart';
import '../features/chat/presentation/bindings/chat_binding.dart';
import '../features/chat/presentation/views/chat_list_screen.dart';
import '../features/chat/presentation/views/chat_detail_screen.dart';
import '../features/producer/presentation/views/profile/producer_edit_profile_screen.dart';
import '../features/producer/presentation/views/profile/my_wallet_screen.dart';
import '../features/producer/presentation/views/profile/payout_methods_screen.dart';
import '../features/producer/presentation/views/profile/producer_settings_screen.dart';
import '../features/producer/presentation/views/profile/producer_change_password_screen.dart';
import '../features/producer/presentation/views/profile/producer_help_support_screen.dart';
import '../features/producer/presentation/views/profile/producer_terms_privacy_screen.dart';
import '../features/producer/presentation/views/orders/producer_delivered_order_screen.dart';
import '../features/delivery/presentation/views/account_creation/delivery_account_creation_screen.dart';
import '../features/delivery/presentation/views/account_creation/delivery_phone_verify_screen.dart';
import '../features/delivery/presentation/views/verification/delivery_identity_verify_screen.dart';
import '../features/delivery/presentation/views/verification/delivery_vehicle_docs_screen.dart';
import '../features/delivery/presentation/views/verification/delivery_verification_pending_screen.dart';
import '../features/delivery/presentation/views/delivery_main_screen.dart';
import '../features/delivery/presentation/views/delivery_dashboard_screen.dart';
import '../features/delivery/presentation/views/jobs/available_jobs_screen.dart';
import '../features/delivery/presentation/views/jobs/active_job_screen.dart';

class AppRoute {
  // Auth Section
  static String init = "/";
  static String onBoardingScreen = "/onBoardingScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String deliveryAccountCreation = "/deliveryAccountCreation";
  static String deliveryPhoneVerify = "/deliveryPhoneVerify";
  static String deliveryIdentityVerify = "/deliveryIdentityVerify";
  static String deliveryVehicleDocs = "/deliveryVehicleDocs";
  static String deliveryVerificationPending = "/deliveryVerificationPending";
  static String deliveryMain = "/deliveryMain";
  static String deliveryDashboard = "/deliveryDashboard";
  static String deliveryAvailableJobs = "/deliveryAvailableJobs";
  static String deliveryActiveJob = "/deliveryActiveJob";

  static String homeScreen = "/homeScreen";

  static String emailVerifyScreen = "/emailVerifyScreen";
  static String changePasswordScreen = "/resetPasswordScreen";
  static String personalInformationScreen = "/verifyCodeScreen";
  static String resetPasswordScreen = "/resetPasswordScreen";
  static String verifyCodeScreen = "/verifyCodeScreen";
  static String forgotPasswordScreen = "/forgotPasswordScreen";
  static String notification = "/notification";
  static String chatList = "/chatList";
  static String chatDetail = "/chatDetail";
  static String editProfile = "/editProfile";
  static String myWallet = "/myWallet";
  static String payoutMethods = "/payoutMethods";
  static String settings = "/settings";
  static String changePassword = "/changePassword";
  static String helpSupport = "/helpSupport";
  static String termsPrivacy = "/termsPrivacy";
  static String deliveredOrderDetail = "/deliveredOrderDetail";

  static List<GetPage> routes = [
    GetPage(name: init, page: () => const SplashScreen()),
    GetPage(name: onBoardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: emailVerifyScreen, page: () => EmailVerifyScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(
      name: notification,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: chatList,
      page: () => const ChatListScreen(),
      binding: ChatBinding(),
    ),
    GetPage(name: chatDetail, page: () => const ChatDetailScreen()),
    GetPage(name: editProfile, page: () => const ProducerEditProfileScreen()),
    GetPage(name: myWallet, page: () => const MyWalletScreen()),
    GetPage(name: payoutMethods, page: () => const PayoutMethodsScreen()),
    GetPage(name: settings, page: () => const ProducerSettingsScreen()),
    GetPage(
      name: changePassword,
      page: () => const ProducerChangePasswordScreen(),
    ),
    GetPage(name: helpSupport, page: () => const ProducerHelpSupportScreen()),
    GetPage(name: termsPrivacy, page: () => const ProducerTermsPrivacyScreen()),
    GetPage(
      name: deliveredOrderDetail,
      page: () => const ProducerDeliveredOrderDetailScreen(),
    ),
    GetPage(
      name: deliveryAccountCreation,
      page: () => const DeliveryAccountCreationScreen(),
    ),
    GetPage(
      name: deliveryPhoneVerify,
      page: () => const DeliveryPhoneVerifyScreen(),
    ),
    GetPage(
      name: deliveryIdentityVerify,
      page: () => const DeliveryIdentityVerifyScreen(),
    ),
    GetPage(
      name: deliveryVehicleDocs,
      page: () => const DeliveryVehicleDocsScreen(),
    ),
    GetPage(
      name: deliveryVerificationPending,
      page: () => const DeliveryVerificationPendingScreen(),
    ),
    GetPage(
      name: deliveryMain,
      page: () => const DeliveryMainScreen(),
    ),
    GetPage(
      name: deliveryDashboard,
      page: () => const DeliveryDashboardScreen(),
    ),
    GetPage(
      name: deliveryAvailableJobs,
      page: () => const AvailableJobsScreen(),
    ),
    GetPage(
      name: deliveryActiveJob,
      page: () => const ActiveJobScreen(),
    ),
  ];
}
