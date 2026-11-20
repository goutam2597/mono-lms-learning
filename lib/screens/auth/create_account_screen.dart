import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../main_shell.dart';
import 'auth_components.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _termsAgreed = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// UI-kit demo handoff: both sign-up methods go straight to the app shell.
  /// Replace with the auth repository call once real auth is wired up.
  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    Future<void>.delayed(const Duration(milliseconds: 700)).then((_) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Create your\naccount.',
      subtitle: 'New skills. New possibilities — in a few minutes.',
      footer: AuthFooterLink(
        question: 'Already have an account?',
        action: 'Log in',
        onTap: () => Navigator.maybePop(context),
      ),
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              label: 'Full name',
              hint: 'Your full name',
              controller: _nameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
            ),
            const SizedBox(height: 15),
            AuthField(
              label: 'Email address',
              hint: 'you@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.newUsername],
            ),
            const SizedBox(height: 15),
            AuthField(
              label: 'Password',
              hint: 'Create a strong password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              trailing: AuthEyeToggle(
                obscured: _obscurePassword,
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 15),
            AuthField(
              label: 'Confirm password',
              hint: 'Re-enter your password',
              controller: _confirmController,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onSubmitted: (_) => _submit(),
              trailing: AuthEyeToggle(
                obscured: _obscureConfirm,
                onTap: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => setState(() => _termsAgreed = !_termsAgreed),
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: AuthCheckbox(
                      value: _termsAgreed,
                      onTap: () => setState(() => _termsAgreed = !_termsAgreed),
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.5,
                          color: AuthColors.inkSoft,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: 'Create account',
              loading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
            const SizedBox(height: 18),
            const AuthDivider(label: 'or sign up with'),
            const SizedBox(height: 18),
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
