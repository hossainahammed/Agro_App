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
import '../features/delivery/presentation/views/navigation/delivery_navigation_screen.dart';
import '../features/delivery/presentation/views/confirmation/delivery_confirmation_screen.dart';
import '../features/delivery/presentation/views/confirmation/delivery_complete_screen.dart';
import '../features/delivery/presentation/views/jobs/job_history_screen.dart';
import '../features/delivery/presentation/views/jobs/delivered_mission_detail_screen.dart';
import '../features/delivery/presentation/views/earnings/withdraw_earnings_screen.dart';
import '../features/delivery/presentation/views/earnings/withdrawal_requested_screen.dart';
import '../features/delivery/presentation/views/earnings/withdrawal_success_screen.dart';
import '../features/delivery/presentation/views/profile/delivery_edit_profile_screen.dart';
import '../features/delivery/presentation/views/profile/delivery_vehicle_screen.dart';
import '../features/delivery/presentation/views/profile/delivery_documents_screen.dart';
import '../features/delivery/presentation/views/profile/delivery_settings_screen.dart';
import '../features/delivery/presentation/views/profile/delivery_change_password_screen.dart';
import '../features/delivery/presentation/views/profile/delivery_help_support_screen.dart';
import '../features/delivery/presentation/views/profile/delivery_terms_privacy_screen.dart';
import '../features/buyer/presentation/views/account_creation/buyer_account_creation_screen.dart';
import '../features/buyer/presentation/views/account_creation/buyer_phone_verify_screen.dart';

class AppRoute {
  // Auth Section
  static String init = "/";
  static String onBoardingScreen = "/onBoardingScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String buyerAccountCreation = "/buyerAccountCreation";
  static String buyerPhoneVerify = "/buyerPhoneVerify";
  static String deliveryAccountCreation = "/deliveryAccountCreation";
  static String deliveryPhoneVerify = "/deliveryPhoneVerify";
  static String deliveryIdentityVerify = "/deliveryIdentityVerify";
  static String deliveryVehicleDocs = "/deliveryVehicleDocs";
  static String deliveryVerificationPending = "/deliveryVerificationPending";
  static String deliveryMain = "/deliveryMain";
  static String deliveryDashboard = "/deliveryDashboard";
  static String deliveryAvailableJobs = "/deliveryAvailableJobs";
  static String deliveryActiveJob = "/deliveryActiveJob";
  static String deliveryNavigation = "/deliveryNavigation";
  static String deliveryConfirmation = "/deliveryConfirmation";
  static String deliveryComplete = "/deliveryComplete";
  static String deliveryHistory = "/deliveryHistory";
  static String deliveredMissionDetail = "/deliveredMissionDetail";
  static String deliveryWithdraw = "/deliveryWithdraw";
  static String deliveryWithdrawRequested = "/deliveryWithdrawRequested";
  static String deliveryWithdrawSuccess = "/deliveryWithdrawSuccess";
  static String deliveryEditProfile = "/deliveryEditProfile";
  static String deliveryVehicle = "/deliveryVehicle";
  static String deliveryDocuments = "/deliveryDocuments";
  static String deliverySettings = "/deliverySettings";
  static String deliveryChangePassword = "/deliveryChangePassword";
  static String deliveryHelpSupport = "/deliveryHelpSupport";
  static String deliveryTermsPrivacy = "/deliveryTermsPrivacy";

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
      name: buyerAccountCreation,
      page: () => const BuyerAccountCreationScreen(),
    ),
    GetPage(
      name: buyerPhoneVerify,
      page: () => const BuyerPhoneVerifyScreen(),
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
    GetPage(
      name: deliveryNavigation,
      page: () => const DeliveryNavigationScreen(),
    ),
    GetPage(
      name: deliveryConfirmation,
      page: () => const DeliveryConfirmationScreen(),
    ),
    GetPage(
      name: deliveryComplete,
      page: () => const DeliveryCompleteScreen(),
    ),
    GetPage(
      name: deliveryHistory,
      page: () => const JobHistoryScreen(),
    ),
    GetPage(
      name: deliveredMissionDetail,
      page: () => const DeliveredMissionDetailScreen(),
    ),
    GetPage(
      name: deliveryWithdraw,
      page: () => const WithdrawEarningsScreen(),
    ),
    GetPage(
      name: deliveryWithdrawRequested,
      page: () => const WithdrawalRequestedScreen(),
    ),
    GetPage(
      name: deliveryWithdrawSuccess,
      page: () => WithdrawalSuccessScreen(),
    ),
    GetPage(
      name: deliveryEditProfile,
      page: () => const DeliveryEditProfileScreen(),
    ),
    GetPage(
      name: deliveryVehicle,
      page: () => const DeliveryVehicleScreen(),
    ),
    GetPage(
      name: deliveryDocuments,
      page: () => const DeliveryDocumentsScreen(),
    ),
    GetPage(
      name: deliverySettings,
      page: () => const DeliverySettingsScreen(),
    ),
    GetPage(
      name: deliveryChangePassword,
      page: () => const DeliveryChangePasswordScreen(),
    ),
    GetPage(
      name: deliveryHelpSupport,
      page: () => const DeliveryHelpSupportScreen(),
    ),
    GetPage(
      name: deliveryTermsPrivacy,
      page: () => const DeliveryTermsPrivacyScreen(),
    ),
  ];
}
