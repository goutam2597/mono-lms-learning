import 'package:flutter/material.dart';

import 'auth_components.dart';
import 'password_updated_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _newError;
  String? _confirmError;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _newPasswordController.text.length >= 8;
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_newPasswordController.text);

  /// 0 = empty, 1 = weak, 2 = fair, 3 = strong.
  int get _strength {
    if (_newPasswordController.text.isEmpty) return 0;
    final score = [
      _hasMinLength,
      _hasNumber,
      RegExp(r'[A-Z]|[^A-Za-z0-9]').hasMatch(_newPasswordController.text),
    ].where((met) => met).length;
    return score.clamp(1, 3);
  }

  void _resetPassword() {
    setState(() {
      _newError = !_hasMinLength
          ? 'Use at least 8 characters'
          : !_hasNumber
              ? 'Include at least one number'
              : null;
      _confirmError = _confirmPasswordController.text.isEmpty
          ? 'Confirm your password'
          : _confirmPasswordController.text != _newPasswordController.text
              ? 'Passwords do not match'
              : null;
    });
    if (_newError != null || _confirmError != null) return;

    FocusScope.of(context).unfocus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const PasswordUpdatedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Set a new\npassword.',
      subtitle: 'Make it different from the one you used before.',
      onBack: () => Navigator.maybePop(context),
      useAppBar: true,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              label: 'New password',
              hint: 'Create a strong password',
              controller: _newPasswordController,
              obscureText: _obscureNew,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              errorText: _newError,
              onChanged: (_) => setState(() {
                _newError = null;
                if (_confirmError != null) _confirmError = null;
              }),
              trailing: AuthEyeToggle(
                obscured: _obscureNew,
                onTap: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            const SizedBox(height: 10),
            AuthStrengthMeter(
              strength: _strength,
              emptyLabel: 'Password strength',
            ),
            const SizedBox(height: 8),
            _RequirementRow(
              met: _hasMinLength,
              label: 'At least 8 characters',
            ),
            const SizedBox(height: 6),
            _RequirementRow(
              met: _hasNumber,
              label: 'Includes a number',
            ),
            const SizedBox(height: 15),
            AuthField(
              label: 'Confirm new password',
              hint: 'Re-enter your password',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              errorText: _confirmError,
              onSubmitted: (_) => _resetPassword(),
              onChanged: (_) {
                if (_confirmError != null) setState(() => _confirmError = null);
              },
              trailing: AuthEyeToggle(
                obscured: _obscureConfirm,
                onTap: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: 'Reset password',
              onPressed: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final bool met;
  final String label;

  const _RequirementRow({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: met ? const Color(0xFF137547) : Colors.transparent,
            border: met
                ? null
                : Border.all(color: const Color(0xFFC4CFC3), width: 1.2),
          ),
          child: AnimatedOpacity(
            opacity: met ? 1 : 0,
            duration: const Duration(milliseconds: 140),
            child: const Icon(
              Icons.check_rounded,
              size: 10,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: met ? FontWeight.w600 : FontWeight.w400,
            color: met ? const Color(0xFF137547) : AuthColors.inkFaint,
          ),
        ),
      ],
    );
  }
}
