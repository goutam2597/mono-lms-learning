import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../main_shell.dart';
import 'auth_components.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// UI-kit demo handoff: both sign-in methods go straight to the app shell.
  /// Replace with the auth repository call once real auth is wired up.
  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    Future<void>.delayed(const Duration(milliseconds: 700)).then((_) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 480),
          pageBuilder: (_, _, _) => const MainShell(),
          transitionsBuilder: (_, animation, _, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: child,
          ),
        ),
        (route) => false,
      );
    });
  }

  void _openForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  void _openCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Your way back\nto learning.',
      subtitle: 'Sign in to pick up right where you left off.',
      footer: AuthFooterLink(
        question: 'New to Mono LMS?',
        action: 'Create an account',
        onTap: _openCreateAccount,
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
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 16),
            AuthField(
              label: 'Password',
              hint: 'Enter your password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _submit(),
              trailing: AuthEyeToggle(
                obscured: _obscurePassword,
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                AuthCheckbox(
                  value: _rememberMe,
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    behavior: HitTestBehavior.opaque,
                    child: const Text(
                      'Remember me',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AuthColors.inkSoft,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _openForgotPassword,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Forgot password?',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: 'Sign in',
              loading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
            const SizedBox(height: 20),
            const AuthDivider(),
            const SizedBox(height: 20),
            AuthGoogleButton(
              label: 'Continue with Google',
              onPressed: _submitting ? () {} : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
