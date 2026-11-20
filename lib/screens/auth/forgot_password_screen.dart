import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'auth_components.dart';
import 'login_screen.dart';
import 'reset_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Demo prefill; replace with an empty field once auth is wired up.
  final _emailController =
      TextEditingController(text: 'studentdemo@example.com');

  String? _emailError;

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetCode() {
    final email = _emailController.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? 'Enter your email address'
          : !_emailPattern.hasMatch(email)
              ? 'Enter a valid email address'
              : null;
    });
    if (_emailError != null) return;

    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetCodeScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Forgotten your\npassword?',
      subtitle: 'Enter the email you use for Mono LMS and we’ll send a reset code.',
      onBack: () => Navigator.maybePop(context),
      useAppBar: true,
      footer: AuthFooterLink(
        question: 'Remembered it after all?',
        action: 'Back to login',
        onTap: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        ),
      ),
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              label: 'Email address',
              hint: 'you@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              errorText: _emailError,
              onSubmitted: (_) => _sendResetCode(),
              onChanged: (_) {
                if (_emailError != null) setState(() => _emailError = null);
              },
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: 'Send reset code',
              onPressed: _sendResetCode,
            ),
            const SizedBox(height: 26),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: AppColors.benefitBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Can’t access your email? Contact support.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.sageInk,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
