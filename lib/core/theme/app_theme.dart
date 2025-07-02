import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';

/// Main app theme configuration
/// Combines all design system components into Material Design themes
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: lightColorScheme,
      primarySwatch: AppColors.primarySwatch,
      
      // Typography
      textTheme: AppTypography.textTheme,
      fontFamily: AppTypography.fontFamily,
      
      // App bar theme
      appBarTheme: _lightAppBarTheme,
      
      // Button themes
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      filledButtonTheme: _filledButtonTheme,
      
      // Input decoration theme
      inputDecorationTheme: _inputDecorationTheme,
      
      // Card theme
      cardTheme: _cardTheme,
      
      // Bottom navigation theme
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      
      // Dialog theme
      dialogTheme: _dialogTheme,
      
      // Bottom sheet theme
      bottomSheetTheme: _bottomSheetTheme,
      
      // Snackbar theme
      snackBarTheme: _snackBarTheme,
      
      // Chip theme
      chipTheme: _chipTheme,
      
      // Floating action button theme
      floatingActionButtonTheme: _floatingActionButtonTheme,
      
      // List tile theme
      listTileTheme: _listTileTheme,
      
      // Divider theme
      dividerTheme: _dividerTheme,
      
      // Progress indicator theme
      progressIndicatorTheme: _progressIndicatorTheme,
      
      // Switch theme
      switchTheme: _switchTheme,
      
      // Checkbox theme
      checkboxTheme: _checkboxTheme,
      
      // Radio theme
      radioTheme: _radioTheme,
      
      // Slider theme
      sliderTheme: _sliderTheme,
      
      // Tab bar theme
      tabBarTheme: _tabBarTheme,
      
      // Navigation rail theme
      navigationRailTheme: _navigationRailTheme,
      
      // Tooltip theme
      tooltipTheme: _tooltipTheme,
      
      // Banner theme
      bannerTheme: _bannerTheme,
      
      // Scaffold background color
      scaffoldBackgroundColor: AppColors.background,
      
      // Default transition
      pageTransitionsTheme: _pageTransitionsTheme,
      
      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Platform brightness
      brightness: Brightness.light,
      
      // Splash factory
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// Dark theme configuration (for future dark mode support)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// Light color scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.background,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.surface,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: AppColors.surfaceVariant,
    onSecondaryContainer: AppColors.textPrimary,
    tertiary: AppColors.info,
    onTertiary: AppColors.background,
    tertiaryContainer: AppColors.info,
    onTertiaryContainer: AppColors.background,
    error: AppColors.error,
    onError: AppColors.background,
    errorContainer: Color(0x1ADC3545), // Error color with opacity
    onErrorContainer: AppColors.error,
    background: AppColors.background,
    onBackground: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.borderLight,
    shadow: AppColors.shadow,
    scrim: AppColors.overlay,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.background,
    inversePrimary: AppColors.primaryLight,
  );

  /// Dark color scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.darkBackground,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.darkTextPrimary,
    secondary: AppColors.darkSurface,
    onSecondary: AppColors.darkTextPrimary,
    secondaryContainer: AppColors.darkSurface,
    onSecondaryContainer: AppColors.darkTextPrimary,
    tertiary: AppColors.info,
    onTertiary: AppColors.darkBackground,
    tertiaryContainer: AppColors.info,
    onTertiaryContainer: AppColors.darkBackground,
    error: AppColors.error,
    onError: AppColors.darkBackground,
    errorContainer: AppColors.error,
    onErrorContainer: AppColors.darkBackground,
    background: AppColors.darkBackground,
    onBackground: AppColors.darkTextPrimary,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceVariant: AppColors.darkSurface,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.borderLight,
    shadow: AppColors.shadow,
    scrim: AppColors.overlay,
    inverseSurface: AppColors.background,
    onInverseSurface: AppColors.textPrimary,
    inversePrimary: AppColors.primaryDark,
  );

  /// App bar theme
  static AppBarTheme get _lightAppBarTheme => AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    elevation: AppSizes.appBarElevation,
    centerTitle: false,
    titleTextStyle: AppTypography.appBarTitle,
    toolbarHeight: AppSizes.appBarHeight,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  /// Elevated button theme
  static ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: AppSizes.buttonElevation,
      padding: AppSpacing.buttonPadding,
      minimumSize: const Size(0, AppSizes.buttonHeightMd),
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.buttonBorderRadius,
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  /// Outlined button theme
  static OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      backgroundColor: Colors.transparent,
      padding: AppSpacing.buttonPadding,
      minimumSize: const Size(0, AppSizes.buttonHeightMd),
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.buttonBorderRadius,
      ),
      side: const BorderSide(
        color: AppColors.primary,
        width: AppSizes.borderNormal,
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  /// Text button theme
  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      backgroundColor: Colors.transparent,
      padding: AppSpacing.buttonPadding,
      minimumSize: const Size(0, AppSizes.buttonHeightMd),
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.buttonBorderRadius,
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  /// Filled button theme
  static FilledButtonThemeData get _filledButtonTheme => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      padding: AppSpacing.buttonPadding,
      minimumSize: const Size(0, AppSizes.buttonHeightMd),
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.buttonBorderRadius,
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  /// Input decoration theme
  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: AppSizes.inputBorderRadius,
      borderSide: const BorderSide(
        color: AppColors.inputBorder,
        width: AppSizes.borderNormal,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSizes.inputBorderRadius,
      borderSide: const BorderSide(
        color: AppColors.inputBorder,
        width: AppSizes.borderNormal,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSizes.inputBorderRadius,
      borderSide: const BorderSide(
        color: AppColors.inputFocused,
        width: AppSizes.borderThick,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppSizes.inputBorderRadius,
      borderSide: const BorderSide(
        color: AppColors.inputError,
        width: AppSizes.borderNormal,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSizes.inputBorderRadius,
      borderSide: const BorderSide(
        color: AppColors.inputError,
        width: AppSizes.borderThick,
      ),
    ),
    labelStyle: AppTypography.inputLabel,
    hintStyle: AppTypography.inputHint,
    errorStyle: AppTypography.inputError,
    helperStyle: AppTypography.inputHelper,
    contentPadding: AppSpacing.formFieldPadding,
  );

  /// Card theme
  static CardThemeData get _cardTheme => CardThemeData(
    color: AppColors.cardBackground,
    shadowColor: AppColors.shadow,
    elevation: AppSizes.cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.cardBorderRadius,
    ),
    margin: AppSpacing.all8,
  );

  /// Bottom navigation bar theme
  static BottomNavigationBarThemeData get _bottomNavigationBarTheme => BottomNavigationBarThemeData(
    backgroundColor: AppColors.background,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: AppSizes.elevationSm,
    selectedLabelStyle: AppTypography.labelSmall,
    unselectedLabelStyle: AppTypography.labelSmall,
  );

  /// Dialog theme
  static DialogThemeData get _dialogTheme => DialogThemeData(
    backgroundColor: AppColors.background,
    elevation: AppSizes.dialogElevation,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.dialogBorderRadius,
    ),
    titleTextStyle: AppTypography.titleLarge,
    contentTextStyle: AppTypography.bodyMedium,
  );

  /// Bottom sheet theme
  static BottomSheetThemeData get _bottomSheetTheme => BottomSheetThemeData(
    backgroundColor: AppColors.background,
    elevation: AppSizes.bottomSheetElevation,
    shape: const RoundedRectangleBorder(
      borderRadius: AppSizes.bottomSheetBorderRadius,
    ),
    modalBackgroundColor: AppColors.background,
    modalElevation: AppSizes.bottomSheetElevation,
  );

  /// Snackbar theme
  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
    backgroundColor: AppColors.textPrimary,
    contentTextStyle: AppTypography.bodyMedium.copyWith(
      color: AppColors.background,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadiusMd,
    ),
  );

  /// Chip theme
  static ChipThemeData get _chipTheme => ChipThemeData(
    backgroundColor: AppColors.surface,
    selectedColor: AppColors.primary,
    disabledColor: AppColors.buttonDisabled,
    deleteIconColor: AppColors.textSecondary,
    labelStyle: AppTypography.labelMedium,
    secondaryLabelStyle: AppTypography.labelMedium,
    padding: AppSpacing.horizontal12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.chipRadius),
    ),
  );

  /// Floating action button theme
  static FloatingActionButtonThemeData get _floatingActionButtonTheme => FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: AppSizes.fabElevation,
    focusElevation: AppSizes.fabElevation + 2,
    hoverElevation: AppSizes.fabElevation + 2,
    highlightElevation: AppSizes.fabElevation + 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
    ),
  );

  /// List tile theme
  static ListTileThemeData get _listTileTheme => ListTileThemeData(
    contentPadding: AppSpacing.listTilePadding,
    titleTextStyle: AppTypography.titleMedium,
    subtitleTextStyle: AppTypography.bodyMedium,
    leadingAndTrailingTextStyle: AppTypography.labelMedium,
  );

  /// Divider theme
  static DividerThemeData get _dividerTheme => const DividerThemeData(
    color: AppColors.border,
    thickness: AppSizes.dividerThickness,
    space: AppSpacing.dividerSpacing,
  );

  /// Progress indicator theme
  static ProgressIndicatorThemeData get _progressIndicatorTheme => const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.surface,
    circularTrackColor: AppColors.surface,
  );

  /// Switch theme
  static SwitchThemeData get _switchTheme => SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return AppColors.textTertiary;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryWithOpacity;
      }
      return AppColors.surface;
    }),
  );

  /// Checkbox theme
  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return AppColors.background;
    }),
    checkColor: MaterialStateProperty.all(AppColors.onPrimary),
    side: const BorderSide(
      color: AppColors.border,
      width: AppSizes.borderNormal,
    ),
  );

  /// Radio theme
  static RadioThemeData get _radioTheme => RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return AppColors.border;
    }),
  );

  /// Slider theme
  static SliderThemeData get _sliderTheme => SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.surface,
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primaryWithOpacity,
    valueIndicatorColor: AppColors.primary,
    valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
      color: AppColors.onPrimary,
    ),
  );

  /// Tab bar theme
  static TabBarThemeData get _tabBarTheme => TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.textSecondary,
    labelStyle: AppTypography.labelLarge,
    unselectedLabelStyle: AppTypography.labelLarge,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppSizes.borderThick,
      ),
    ),
  );

  /// Navigation rail theme
  static NavigationRailThemeData get _navigationRailTheme => NavigationRailThemeData(
    backgroundColor: AppColors.background,
    selectedIconTheme: const IconThemeData(
      color: AppColors.primary,
      size: AppSizes.iconLg,
    ),
    unselectedIconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppSizes.iconLg,
    ),
    selectedLabelTextStyle: AppTypography.labelMedium.copyWith(
      color: AppColors.primary,
    ),
    unselectedLabelTextStyle: AppTypography.labelMedium.copyWith(
      color: AppColors.textSecondary,
    ),
  );

  /// Tooltip theme
  static TooltipThemeData get _tooltipTheme => TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.textPrimary,
      borderRadius: AppSizes.borderRadiusMd,
    ),
    textStyle: AppTypography.bodySmall.copyWith(
      color: AppColors.background,
    ),
    padding: AppSpacing.all8,
    margin: AppSpacing.all8,
  );

  /// Banner theme
  static MaterialBannerThemeData get _bannerTheme => MaterialBannerThemeData(
    backgroundColor: AppColors.surface,
    contentTextStyle: AppTypography.bodyMedium,
    padding: AppSpacing.all16,
  );

  /// Page transitions theme
  static PageTransitionsTheme get _pageTransitionsTheme => const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  /// Get system overlay style for status bar
  static SystemUiOverlayStyle getSystemOverlayStyle({bool isDark = false}) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? AppColors.darkBackground : AppColors.background,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );
  }
} 