import 'package:flutter/material.dart';
import 'email_verify_screen.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String email;
  final String verifyType;
  const VerifyCodeScreen({super.key, required this.email, required this.verifyType});

  @override
  Widget build(BuildContext context) {
    return EmailVerifyScreen(
      email: email,
      verifyType: verifyType,
    );
  }
}
