import 'package:flutter/material.dart';

/// Spacing and sizing constants for consistent layout design
/// Based on 16px base unit for the appointment tracking app
class AppSpacing {
  AppSpacing._();

  // Base spacing unit
  static const double base = 16.0;

  // Spacing scale
  static const double xs = 4.0;   // Extra small
  static const double sm = 8.0;   // Small
  static const double md = 16.0;  // Medium (base)
  static const double lg = 24.0;  // Large
  static const double xl = 32.0;  // Extra large
  static const double xxl = 48.0; // Extra extra large
  static const double xxxl = 64.0; // Extra extra extra large

  // Specific spacing values
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space28 = 28.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;

  // Screen margins
  static const double screenHorizontal = 16.0;
  static const double screenVertical = 16.0;
  static const double screenHorizontalLarge = 24.0;

  // Content spacing
  static const double contentPadding = 16.0;
  static const double contentMargin = 16.0;
  static const double sectionSpacing = 32.0;
  static const double itemSpacing = 16.0;
  static const double listItemSpacing = 8.0;

  // Card spacing
  static const double cardPadding = 16.0;
  static const double cardMargin = 8.0;
  static const double cardSpacing = 16.0;

  // Button spacing
  static const double buttonPaddingHorizontal = 24.0;
  static const double buttonPaddingVertical = 12.0;
  static const double buttonSpacing = 16.0;

  // Form spacing
  static const double formFieldSpacing = 16.0;
  static const double formSectionSpacing = 24.0;
  static const double formPadding = 16.0;

  // Icon spacing
  static const double iconSpacing = 8.0;
  static const double iconPadding = 12.0;

  // List spacing
  static const double listPadding = 16.0;
  static const double listItemPadding = 16.0;
  static const double listItemMargin = 8.0;

  // Dialog spacing
  static const double dialogPadding = 24.0;
  static const double dialogMargin = 40.0;

  // Toolbar spacing
  static const double toolbarPadding = 16.0;
  static const double toolbarHeight = 56.0;

  // Bottom navigation spacing
  static const double bottomNavHeight = 60.0;
  static const double bottomNavPadding = 8.0;

  // AppBar spacing
  static const double appBarHeight = 56.0;
  static const double appBarPadding = 16.0;

  // Floating action button
  static const double fabMargin = 16.0;
  static const double fabSize = 56.0;
  static const double fabMiniSize = 40.0;

  // Divider spacing
  static const double dividerSpacing = 16.0;
  static const double dividerThickness = 1.0;

  // Safe area additions
  static const double safeAreaPadding = 8.0;

  // Edge insets commonly used
  static const EdgeInsets all4 = EdgeInsets.all(4.0);
  static const EdgeInsets all8 = EdgeInsets.all(8.0);
  static const EdgeInsets all12 = EdgeInsets.all(12.0);
  static const EdgeInsets all16 = EdgeInsets.all(16.0);
  static const EdgeInsets all20 = EdgeInsets.all(20.0);
  static const EdgeInsets all24 = EdgeInsets.all(24.0);
  static const EdgeInsets all32 = EdgeInsets.all(32.0);

  static const EdgeInsets horizontal8 = EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets horizontal12 = EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets horizontal24 = EdgeInsets.symmetric(horizontal: 24.0);

  static const EdgeInsets vertical8 = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets vertical12 = EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets vertical20 = EdgeInsets.symmetric(vertical: 20.0);
  static const EdgeInsets vertical24 = EdgeInsets.symmetric(vertical: 24.0);

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: 16.0);

  // Card padding
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets cardPaddingVertical = EdgeInsets.symmetric(vertical: 12.0);

  // Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 12.0,
  );
  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: 32.0,
    vertical: 16.0,
  );
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );

  // Form field padding
  static const EdgeInsets formFieldPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // List tile padding
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );

  // Dialog padding
  static const EdgeInsets dialogPaddingAll = EdgeInsets.all(24.0);
  static const EdgeInsets dialogContentPadding = EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0);

  // Snackbar padding
  static const EdgeInsets snackbarPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Custom spacing for specific components
  static const EdgeInsets appointmentCardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets serviceCardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets staffCardPadding = EdgeInsets.all(12.0);

  // Booking flow specific spacing
  static const EdgeInsets bookingStepPadding = EdgeInsets.all(16.0);
  static const EdgeInsets bookingContentPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 24.0,
  );

  // Calendar spacing
  static const double calendarCellSize = 40.0;
  static const double calendarPadding = 16.0;
  static const EdgeInsets calendarCellPadding = EdgeInsets.all(8.0);

  // Time slot spacing
  static const double timeSlotHeight = 48.0;
  static const double timeSlotSpacing = 8.0;
  static const EdgeInsets timeSlotPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Bottom sheet spacing
  static const EdgeInsets bottomSheetPadding = EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0);
  static const double bottomSheetHandleWidth = 40.0;
  static const double bottomSheetHandleHeight = 4.0;

  // Helper methods for dynamic spacing
  static EdgeInsets symmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
      vertical: vertical ?? 0,
    );
  }

  static EdgeInsets only({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left ?? 0,
      top: top ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0,
    );
  }

  // Responsive spacing (for tablets/larger screens)
  static double responsiveHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return screenHorizontalLarge;
    }
    return screenHorizontal;
  }

  static EdgeInsets responsiveScreenPadding(BuildContext context) {
    final horizontalPadding = responsiveHorizontalPadding(context);
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: screenVertical,
    );
  }

  // Helper method for safe padding calculation
  static EdgeInsets safePadding(BuildContext context, {
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }
    
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? responsiveHorizontalPadding(context),
      vertical: vertical ?? screenVertical,
    );
  }
} 