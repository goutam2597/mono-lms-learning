import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'auth_components.dart';
import 'login_screen.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'You’re back\nin control.',
      subtitle: 'A fresh password. The same possibilities.',
      onBack: () => Navigator.maybePop(context),
      useAppBar: true,
      footer: const Text(
        'Ready for your next chapter?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: AuthColors.inkSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE4F5EC),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: Color(0xFF137547),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Center(
            child: Text(
              'Password updated.',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AuthColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Your new password is ready to use.\nLog in to pick up where you left off.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AuthColors.inkSoft,
              ),
            ),
          ),
          const SizedBox(height: 28),
          AuthPrimaryButton(
            label: 'Back to login',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.benefitBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: const [
                Text(
                  'A little peace of mind.',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.sageInk,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Keep your password private and use a unique password for every account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.sageMoss,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
