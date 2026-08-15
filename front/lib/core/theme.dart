import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryGreenLight = Color(0xFF81C784);
  static const Color primaryGreenDark = Color(0xFF388E3C);

  static const Color secondaryOrange = Color(0xFFFFA726);
  static const Color secondaryOrangeLight = Color(0xFFFFCC80);

  static const Color background = Color(0xFFF5F5F5);
  static const Color softBackground = Color(0xFFE8F5E9);
  static const Color cardBackground = Colors.white;

  static const Color textDark = Color(0xFF212121);
  static const Color textPrimary = Color(0xFF2E3A2E);
  static const Color textSecondary = Color(0xFF757575);

  static const Color inputStroke = Color(0xFFBDBDBD);
  static const Color muted = Color(0xFF9E9E9E);

  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowDark = Color(0x33000000);

  static const Color deepTeal = Color(0xFF0E4B49);
  static const Color teal = Color(0xFF12665F);
  static const Color tealLight = Color(0xFF2E9188);
  static const Color tealSoft = Color(0xFFE4F1EE);

  static const Color gold = Color(0xFFD9A653);
  static const Color goldLight = Color(0xFFF0D8AC);

  static const Color cream = Color(0xFFFAF6EF);
  static const Color ivory = Color(0xFFFFFDF9);
  static const Color beige = Color(0xFFEFE7D8);
  static const Color sand = Color(0xFFE9DFC9);

  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color hairline = Color(0xFFEDE7DA);

  static const List<Color> heroGradient = [
    Color(0xFF0B3D3B),
    Color(0xFF14675F),
    Color(0xFF2E9188),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFE6BE7E),
    Color(0xFFD9A653),
  ];

  /// Semantic status colors — used consistently for stock / availability /
  /// order & appointment states across the whole app.
  static const Color success = Color(0xFF1FAE5B);
  static const Color successSoft = Color(0xFFE3F5EA);
  static const Color danger = Color(0xFFE0503A);
  static const Color dangerSoft = Color(0xFFFBE9E6);
}

/// Shared spacing scale so paddings/margins stay consistent across every
/// redesigned screen instead of ad-hoc magic numbers.
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
}

/// Shared corner-radius scale matching the premium, softly-rounded language
/// established on the home screen (ivory cards, 20–24px radii).
class AppRadii {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}

/// Reusable elevation/shadow presets so every card in the app casts the same
/// soft, premium shadow as the home screen's product & category cards.
class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> raised = [
    BoxShadow(
      color: AppColors.deepTeal.withOpacity(0.14),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];
}
