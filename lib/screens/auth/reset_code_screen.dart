import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'auth_components.dart';
import 'new_password_screen.dart';

class ResetCodeScreen extends StatefulWidget {
  final String email;

  const ResetCodeScreen({
    super.key,
    this.email = 'studentdemo@example.com',
  });

  @override
  State<ResetCodeScreen> createState() => _ResetCodeScreenState();
}

class _ResetCodeScreenState extends State<ResetCodeScreen> {
  final List<TextEditingController> _digitControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _focusedIndex = 0;

  @override
  void dispose() {
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    final code =
        _digitControllers.map((c) => c.text).join();
    if (code.length < 6) {
      // Demo handoff; replace with repository verification.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the 6-digit code')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NewPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Enter your\nreset code.',
      subtitle: 'We sent a 6-digit code to ${widget.email}.',
      onBack: () => Navigator.maybePop(context),
      useAppBar: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            behavior: HitTestBehavior.opaque,
            child: const Row(
              children: [
                Text(
                  'Wrong email?',
                  style: TextStyle(
                    fontSize: 13,
                    color: AuthColors.inkSoft,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Change it',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final isFocused = _focusedIndex == index;
              return Container(
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  color: AuthColors.fieldFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? AppColors.primary
                        : AuthColors.fieldBorder,
                    width: isFocused ? 1.6 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _digitControllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AuthColors.ink,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onTap: () => setState(() => _focusedIndex = index),
                  onChanged: (val) {
                    if (val.isNotEmpty && index < 5) {
                      _focusNodes[index + 1].requestFocus();
                      setState(() => _focusedIndex = index + 1);
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your code is valid for 10 minutes. Check your spam folder, too.',
            style: TextStyle(
              fontSize: 11.5,
              color: AuthColors.inkFaint,
            ),
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            label: 'Verify reset code',
            onPressed: _verifyCode,
          ),
          const SizedBox(height: 18),
          Center(
            child: Text.rich(
              TextSpan(
                text: 'Didn’t receive a code? ',
                style: const TextStyle(
                  fontSize: 13,
                  color: AuthColors.inkSoft,
                ),
                children: [
                  TextSpan(
                    text: 'Resend in 00:30',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
