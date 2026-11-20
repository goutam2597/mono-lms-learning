import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_theme.dart';

/// ---------------------------------------------------------------------------
/// The campus wayfinding world.
///
/// Auth is the student's way in: one flat evergreen enamel ground, one
/// porcelain work panel, and a route line that shows where the student is on
/// the journey. Flat fields only — no gradients, no glow.
/// ---------------------------------------------------------------------------
class AuthColors {
  static const Color enamel = Color(0xFF25372C); // full-bleed ground
  static const Color porcelain = Color(0xFFFBFCFA); // work panel
  static const Color porcelainWarm = Color(0xFFFAF6F2); // drifted warm edge
  static const Color porcelainGreen = Color(0xFFF4FAF5); // drifted green edge
  static const Color fieldFill = Color(0xFFF2F6F1);
  static const Color fieldBorder = Color(0xFFE0E8DF);
  static const Color ink = Color(0xFF1B241D);
  static const Color inkSoft = Color(0xFF5C6B60);
  static const Color inkFaint = Color(0xFF93A096);
  static const Color mint = Color(0xFFBFCFBB);
  static const Color hairline = Color(0xFFE4ECE4);
  static const Color danger = Color(0xFFB23A34);
  static const Color dangerSoft = Color(0xFFFDF4F3);
  static const Color action = Color(0xFF344C3D); // primary action fill
  static const Color actionPressed = Color(0xFF25372C);
}

/// Shared shell: enamel header with the web brand logo above, porcelain
/// panel below carrying the scrollable form. The panel scrolls under the
/// keyboard, so the call to action never clips.
class AuthShell extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  /// Optional back action rendered before the logo (forgot-password flow).
  final VoidCallback? onBack;

  /// Use a standard transparent app bar (with the back button) instead of
  /// the logo header.
  final bool useAppBar;

  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.onBack,
    this.useAppBar = false,
  });

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final head = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0, 0.55, curve: Curves.easeOutCubic),
    );
    final panel = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.25, 1, curve: Curves.easeOutCubic),
    );

    return Scaffold(
      backgroundColor: AuthColors.enamel,
      appBar: widget.useAppBar
          ? AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
        builder: (context, constraints) {
          // The whole screen scrolls as one: the header moves with the panel,
          // and the panel always fills what's left so the porcelain edge sits
          // at the bottom even on tall phones.
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeTransition(
                      opacity: head,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.04),
                          end: Offset.zero,
                        ).animate(head),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            widget.useAppBar ? 2 : 6,
                            24,
                            30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (!widget.useAppBar &&
                                      widget.onBack != null) ...[
                                    _BackButton(onTap: widget.onBack!),
                                    const SizedBox(width: 14),
                                  ],
                                  if (!widget.useAppBar)
                                    Image.asset(
                                      // The web brand logo, verbatim.
                                      'assets/images/logo_white.png',
                                      height: 34,
                                      fit: BoxFit.contain,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  height: 1.12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.subtitle,
                                style: TextStyle(
                                  color:
                                      AuthColors.mint.withValues(alpha: 0.68),
                                  fontSize: 13.5,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FadeTransition(
                        opacity: panel,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(panel),
                          child: Container(
                            width: double.infinity,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              // Porcelain stock: barely drifting warm and
                              // green edges, like printed paper.
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AuthColors.porcelainWarm,
                                  AuthColors.porcelain,
                                  AuthColors.porcelainGreen,
                                ],
                                stops: [0, 0.55, 1],
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(22),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 440),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      widget.child,
                                      if (widget.footer != null) ...[
                                        const SizedBox(height: 22),
                                        widget.footer!,
                                        const SizedBox(height: 14),
                                        const AuthAssurance(),
                                      ],
                                      const SizedBox(height: 18),
                                      // Clear the gesture bar without
                                      // leaving enamel showing below.
                                      SizedBox(
                                        height: MediaQuery.of(context)
                                            .padding
                                            .bottom,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        ),
      ),
    );
  }
}

/// Proper back affordance for flows that need one (forgot password).
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Go back',
      child: SizedBox(
        width: 44,
        height: 44,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Labeled input: no prefix icons, quiet fill, evergreen focus.
class AuthField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? trailing;
  final List<String>? autofillHints;
  final TextCapitalization textCapitalization;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.trailing,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Semantics(
      label: label,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AuthColors.ink,
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            textCapitalization: textCapitalization,
            autocorrect: false,
            enableSuggestions: obscureText || autofillHints == null,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            cursorColor: AppColors.primary,
            cursorWidth: 1.7,
            cursorRadius: const Radius.circular(2),
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: AuthColors.ink,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AuthColors.inkFaint,
              ),
              suffixIcon: trailing,
              filled: true,
              fillColor: hasError ? AuthColors.dangerSoft : AuthColors.fieldFill,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              errorText: errorText,
              errorMaxLines: 2,
              errorStyle: const TextStyle(
                fontSize: 11.5,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: AuthColors.danger,
              ),
              border: _border(AuthColors.fieldBorder),
              enabledBorder: _border(
                hasError ? const Color(0xFFE8B9B5) : AuthColors.fieldBorder,
              ),
              focusedBorder: _border(
                hasError ? AuthColors.danger : AppColors.primary,
                width: 1.6,
              ),
              errorBorder: _border(const Color(0xFFE8B9B5)),
              focusedErrorBorder: _border(AuthColors.danger, width: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// Eye toggle sized to the field's suffix slot.
class AuthEyeToggle extends StatelessWidget {
  final bool obscured;
  final VoidCallback onTap;

  const AuthEyeToggle({super.key, required this.obscured, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: obscured ? 'Show password' : 'Hide password',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Icon(
              obscured
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              key: ValueKey(obscured),
              size: 19,
              color: AuthColors.inkFaint,
            ),
          ),
        ),
      ),
    );
  }
}

/// Solid evergreen call to action. Flat fill, weight does the talking.
class AuthPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;

    return AnimatedScale(
      scale: _pressed && enabled ? 0.985 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: enabled || widget.loading ? 1 : 0.55,
        duration: const Duration(milliseconds: 160),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            height: 54,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _pressed ? AuthColors.actionPressed : AuthColors.action,
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// White secondary action carrying the original Google G mark.
class AuthGoogleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthGoogleButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        splashColor: AuthColors.action.withValues(alpha: 0.05),
        highlightColor: AuthColors.action.withValues(alpha: 0.03),
        child: Container(
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AuthColors.fieldBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/google_g.svg',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 11),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AuthColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  final String label;

  const AuthDivider({super.key, this.label = 'or continue with'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AuthColors.hairline, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AuthColors.inkFaint,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AuthColors.hairline, height: 1)),
      ],
    );
  }
}

class AuthCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const AuthCheckbox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: value ? AuthColors.action : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: value
                ? null
                : Border.all(color: const Color(0xFFC4CFC3), width: 1.2),
          ),
          child: AnimatedScale(
            scale: value ? 1 : 0.4,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: value ? 1 : 0,
              duration: const Duration(milliseconds: 110),
              child: const Icon(
                Icons.check_rounded,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quiet reassurance line pinned under the footer link.
class AuthAssurance extends StatelessWidget {
  final String message;

  const AuthAssurance({
    super.key,
    this.message = 'Your data stays private and encrypted',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.verified_user_outlined,
          size: 13,
          color: AuthColors.inkFaint,
        ),
        const SizedBox(width: 6),
        Text(
          message,
          style: const TextStyle(
            fontSize: 10.5,
            color: AuthColors.inkFaint,
          ),
        ),
      ],
    );
  }
}

/// Footer link between the two auth surfaces.
class AuthFooterLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            question,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AuthColors.inkSoft,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Semantics(
          button: true,
          label: action,
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              action,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Password strength as three enamel line segments.
class AuthStrengthMeter extends StatelessWidget {
  final int strength; // 0 empty, 1 weak, 2 fair, 3 strong

  /// Text shown before the user types; defaults to the rule itself.
  final String emptyLabel;

  const AuthStrengthMeter({
    super.key,
    required this.strength,
    this.emptyLabel = 'At least 8 characters, with a number',
  });

  static const _labels = ['', 'Weak', 'Fair', 'Strong'];
  static const _colors = [
    Color(0xFFE0E8DF),
    Color(0xFFB23A34),
    Color(0xFFB98417),
    Color(0xFF137547),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (index) {
            final active = index < strength;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == 2 ? 0 : 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: 4,
                  decoration: BoxDecoration(
                    color: active ? _colors[strength] : _colors[0],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 7),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            strength == 0 ? emptyLabel : '${_labels[strength]} password',
            key: ValueKey(strength),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: strength == 0 ? AuthColors.inkFaint : _colors[strength],
            ),
          ),
        ),
      ],
    );
  }
}

// NOTE: AuthRouteLine/AuthStop (the progress "route line") were removed at the
// user's request; the shell now carries the journey as copy, not furniture.
