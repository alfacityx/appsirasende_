import 'package:flutter/material.dart';

/// App color palette following the light and minimal design philosophy
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFFF8C42); // Orange accent
  static const Color primaryLight = Color(0xFFFFB366);
  static const Color primaryDark = Color(0xFFE5791F);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // Pure white
  static const Color surface = Color(0xFFF8F9FA); // Light gray
  static const Color surfaceVariant = Color(0xFFF1F3F4);

  // Text Colors
  static const Color textPrimary = Color(0xFF212529); // Dark gray
  static const Color textSecondary = Color(0xFF6C757D); // Medium gray
  static const Color textTertiary = Color(0xFF9CA3AF); // Light gray
  static const Color textDisabled = Color(0xFFCED4DA);

  // Status Colors
  static const Color success = Color(0xFF28A745); // Green
  static const Color warning = Color(0xFFE97D36); // Orange-yellow
  static const Color error = Color(0xFFDC3545); // Red
  static const Color info = Color(0xFF17A2B8); // Blue

  // Interactive Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFFF8F9FA);
  static const Color buttonDisabled = Color(0xFFE9ECEF);

  // Border Colors
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFD1D5DB);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color shadowLight = Color(0x0D000000); // 5% black

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black

  // Card Colors
  static const Color cardBackground = background;
  static const Color cardElevated = surface;

  // Input Colors
  static const Color inputFill = surface;
  static const Color inputBorder = border;
  static const Color inputFocused = primary;
  static const Color inputError = error;

  // Rating Colors
  static const Color star = Color(0xFFFFB400); // Gold
  static const Color starEmpty = Color(0xFFE5E5E5);

  // Availability Colors
  static const Color available = success;
  static const Color unavailable = error;
  static const Color busy = warning;

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFFF8C42),
    Color(0xFFFFB366),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFFAFBFC),
  ];

  // Material Color Swatch for primary color
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFFF8C42,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF8C42),
      600: Color(0xFFFF7043),
      700: Color(0xFFFF5722),
      800: Color(0xFFE64A19),
      900: Color(0xFFBF360C),
    },
  );

  // Dark Theme Colors (for future dark mode support)
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);

  // Semantic color getters
  static Color get onPrimary => background;
  static Color get onSurface => textPrimary;
  static Color get onBackground => textPrimary;
  static Color get onError => background;
  static Color get onSuccess => background;
  static Color get onWarning => background;

  // Opacity variants
  static Color get primaryWithOpacity => primary.withOpacity(0.1);
  static Color get successWithOpacity => success.withOpacity(0.1);
  static Color get errorWithOpacity => error.withOpacity(0.1);
  static Color get warningWithOpacity => warning.withOpacity(0.1);

  // Helper method to get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
} 