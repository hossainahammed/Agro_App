import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/loading_widgets.dart';
import 'package:project_structure/core/localization/app_texts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/logo_path.dart';
import 'package:project_structure/features/onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const OnboardingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            // Circular Logo Wrapper
            Center(
              child: Image.asset(
                LogoPath.appLogo,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            // Tagline
            const Text(
              AppText.appTagline,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(flex: 3),
            // Loading Dotted Indicator
            const LoadingWidget(size: 40),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
