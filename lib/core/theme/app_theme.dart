import 'package:flutter/material.dart';

class AppColors {
  // Web brand colors (from Mono LMS web backend)
  static const Color primary = Color(0xFF344C3D); // Sage Evergreen (theme primary)
  static const Color primaryDark = Color(0xFF25372C); // Hover / pressed state
  static const Color secondary = Color(0xFF738A6E); // Sage Moss
  static const Color dark = Color(0xFF08131E);
  static const Color warning = Color(0xFFFFC107);
  static const Color success = Color(0xFF03C95A);

  // Full web sage palette
  static const Color sageHint = Color(0xFFDCE7DA);
  static const Color sageMint = Color(0xFFBFCFBB);
  static const Color sage = Color(0xFF8EA58C);
  static const Color sageMoss = Color(0xFF738A6E);
  static const Color sageEvergreen = Color(0xFF344C3D);

  // UI surfaces & text
  static const Color background = Color(0xFFFAFCFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4ECE4);
  static const Color textPrimary = Color(0xFF191919);
  static const Color textSecondary = Color(0xFF6D6D6D);
  static const Color heroBackground = Color(0xFF344C3D);
  static const Color heroSubtitle = Color(0xFFDCE7DA);
  static const Color heroTag = Color(0xFFBFCFBB);
  static const Color footerBackground = Color(0xFF1F3025);
  static const Color accentPink = Color(0xFFFFB1C1);
  static const Color badgePink = Color(0xFFBD284C);
  static const Color cartBadge = Color(0xFFB92549);
  static const Color selectedTab = Color(0xFFE6EFE5); // soft sage pill
  static const Color benefitBg = Color(0xFFF2F7F2); // soft sage container
  static const Color instructorBg = Color(0xFFEFF5F0); // soft mint container

  // ---- Web home surfaces (mirrors pages/home.blade.php) ----
  static const Color heroTop = Color(0xFFF8FAFB); // hero gradient start
  static const Color heroMid = Color(0xFFFBFCFE);
  static const Color hairline = Color(0xFFE9ECEF); // web card border
  static const Color slateBody = Color(0xFF475569); // meta text on white
  static const Color sageInk = Color(0xFF4A5F48); // moss text, AA on white
  static const Color cardShadow = Color(0x14137547); // rgba(19,117,71,.08)

  // Accent set used by the web stat ribbon / showcase blocks
  static const Color accentPurple = Color(0xFF5625E8);
  static const Color accentAmber = Color(0xFFFFC107);
  static const Color accentCyan = Color(0xFF0DCAF0);
  static const Color accentGreen = Color(0xFF03C95A);

  // Readable ink variants of the accents (vivid hues fail contrast as text)
  static const Color inkPurple = Color(0xFF4517C4);
  static const Color inkAmber = Color(0xFF8A5A00);
  static const Color inkCyan = Color(0xFF0A6B80);
  static const Color inkGreen = Color(0xFF067A38);

  static const Color categoryGreen = Color(0xFF137547); // web category pill
  static const Color enrollFrom = Color(0xFF178546);
  static const Color enrollTo = Color(0xFF0F6834);
  static const Color bannerDark = Color(0xFF192A20); // "Transform access" banner
  static const Color navy = Color(0xFF071136); // accelerate / testimonial world
  static const Color waveMint = Color(0xFFBBF2D2); // card image wave
  static const Color starGold = Color(0xFFF59E0B);
  static const Color ratingBg = Color(0xFFE8F7EE);
}

/// Small colour utilities so a single vivid brand hue can stay decorative
/// while the text and glyphs sitting on it remain legible.
extension WebColorUtils on Color {
  bool get isPale => computeLuminance() > 0.42;

  /// Darkened partner for glyphs / numbers on white.
  Color get deep => isPale ? (Color.lerp(this, Colors.black, 0.5)!): this;

  /// Foreground to place on a solid fill of this colour.
  Color get foregroundOn => isPale ? AppColors.textPrimary : Colors.white;

  Color tint(double alpha) => withValues(alpha: alpha);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: const Color(0xFFB92549),
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
          displayMedium: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
          displaySmall: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
          headlineLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
          headlineMedium: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
          headlineSmall: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
          titleLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
          titleMedium: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
          titleSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
          bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary),
          bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary),
          bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary),
        ),
      );
}
