import 'package:flutter/material.dart';

/// Size constants for consistent component dimensions
class AppSizes {
  AppSizes._();

  // Touch targets (minimum 44pt for accessibility)
  static const double minTouchTarget = 44.0;
  static const double touchTarget = 48.0;
  static const double touchTargetLarge = 56.0;

  // Icon sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;

  // Avatar sizes
  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 80.0;
  static const double avatarXxl = 120.0;

  // Border radius values
  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 24.0;
  static const double radiusRound = 50.0;

  // Border radius for specific components
  static const double buttonRadius = 8.0;
  static const double cardRadius = 12.0;
  static const double inputRadius = 8.0;
  static const double dialogRadius = 16.0;
  static const double bottomSheetRadius = 16.0;
  static const double chipRadius = 16.0;

  // Border width
  static const double borderThin = 0.5;
  static const double borderNormal = 1.0;
  static const double borderThick = 2.0;
  static const double borderThicker = 4.0;

  // Elevation values
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 6.0;
  static const double elevationXl = 8.0;
  static const double elevationXxl = 12.0;

  // Component specific elevations
  static const double cardElevation = 2.0;
  static const double buttonElevation = 2.0;
  static const double dialogElevation = 8.0;
  static const double bottomSheetElevation = 4.0;
  static const double appBarElevation = 0.0; // Flat design
  static const double fabElevation = 6.0;

  // Button heights
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double buttonHeightXl = 56.0;

  // Input field heights
  static const double inputHeightSm = 36.0;
  static const double inputHeightMd = 44.0;
  static const double inputHeightLg = 52.0;

  // App bar heights
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;
  static const double tabBarHeight = 48.0;

  // Bottom navigation
  static const double bottomNavHeight = 60.0;
  static const double bottomNavIconSize = 24.0;

  // List item heights
  static const double listItemHeightSm = 48.0;
  static const double listItemHeightMd = 56.0;
  static const double listItemHeightLg = 72.0;

  // Card dimensions
  static const double cardMinHeight = 80.0;
  static const double cardMaxWidth = 400.0;

  // Dialog dimensions
  static const double dialogMinWidth = 280.0;
  static const double dialogMaxWidth = 400.0;
  static const double dialogMaxHeight = 0.8; // 80% of screen height

  // Bottom sheet dimensions
  static const double bottomSheetMaxHeight = 0.9; // 90% of screen height
  static const double bottomSheetMinHeight = 200.0;

  // Snackbar dimensions
  static const double snackbarHeight = 48.0;
  static const double snackbarMaxWidth = 600.0;

  // Progress indicators
  static const double progressIndicatorSm = 16.0;
  static const double progressIndicatorMd = 20.0;
  static const double progressIndicatorLg = 24.0;

  // Divider thickness
  static const double dividerThickness = 1.0;

  // Screen breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Content width constraints
  static const double maxContentWidth = 400.0;
  static const double maxContentWidthLarge = 600.0;

  // Appointment specific sizes
  static const double appointmentCardHeight = 120.0;
  static const double appointmentCardMinHeight = 80.0;

  // Service card sizes
  static const double serviceCardHeight = 100.0;
  static const double serviceCardMinHeight = 80.0;

  // Staff card sizes
  static const double staffCardHeight = 120.0;
  static const double staffCardImageSize = 60.0;

  // Calendar sizes
  static const double calendarCellSize = 40.0;
  static const double calendarCellMinSize = 32.0;

  // Time slot sizes
  static const double timeSlotHeight = 48.0;
  static const double timeSlotMinWidth = 80.0;

  // Rating star size
  static const double starSize = 16.0;
  static const double starSizeLarge = 20.0;

  // Floating action button sizes
  static const double fabSize = 56.0;
  static const double fabMiniSize = 40.0;

  // Chip sizes
  static const double chipHeight = 32.0;
  static const double chipHeightSmall = 24.0;

  // Badge sizes
  static const double badgeSize = 16.0;
  static const double badgeSizeSmall = 12.0;

  // Border radius objects for reuse
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));

  // Component specific border radius
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(buttonRadius));
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(cardRadius));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(inputRadius));
  static const BorderRadius dialogBorderRadius = BorderRadius.all(Radius.circular(dialogRadius));

  // Top-only border radius for bottom sheets
  static const BorderRadius bottomSheetBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(bottomSheetRadius),
    topRight: Radius.circular(bottomSheetRadius),
  );

  // Helper methods
  static BorderRadius borderRadius(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  static BorderRadius borderRadiusTop(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  static BorderRadius borderRadiusBottom(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  static BorderRadius borderRadiusLeft(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    );
  }

  static BorderRadius borderRadiusRight(double radius) {
    return BorderRadius.only(
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  // Responsive helper methods
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static double responsiveWidth(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  static double responsiveHeight(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  // Box constraints
  static const BoxConstraints buttonConstraints = BoxConstraints(
    minHeight: buttonHeightMd,
    maxHeight: buttonHeightXl,
  );

  static const BoxConstraints inputConstraints = BoxConstraints(
    minHeight: inputHeightMd,
    maxHeight: inputHeightLg,
  );

  static const BoxConstraints cardConstraints = BoxConstraints(
    minHeight: cardMinHeight,
    maxWidth: cardMaxWidth,
  );

  static const BoxConstraints dialogConstraints = BoxConstraints(
    minWidth: dialogMinWidth,
    maxWidth: dialogMaxWidth,
  );

  // Content constraints for different screen sizes
  static BoxConstraints contentConstraints(BuildContext context) {
    if (isDesktop(context)) {
      return const BoxConstraints(maxWidth: maxContentWidthLarge);
    }
    return const BoxConstraints(maxWidth: maxContentWidth);
  }
} 