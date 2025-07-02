# Theme System - Design Consistency

This folder contains the complete design system for the Appointment Tracking App, ensuring visual consistency across all components and screens.

## 🎨 Design Philosophy

Our theme system follows these core principles:

- **Light & Minimal**: Clean aesthetics with ample white space
- **Consistent**: Unified design language throughout the app
- **Accessible**: WCAG 2.1 AA compliant color contrasts and touch targets
- **Scalable**: Flexible system that grows with the app

## 📁 File Structure

### `app_colors.dart`
Comprehensive color palette including:
- **Primary Colors**: Orange accent (#FF8C42) with variations
- **Background Colors**: Pure white with light gray surfaces
- **Text Colors**: Dark to light gray hierarchy
- **Status Colors**: Success (green), warning (orange), error (red)
- **Interactive Colors**: Button states and availability indicators
- **Semantic Colors**: Card backgrounds, borders, shadows

### `app_typography.dart`
Complete typography system based on Inter font:
- **Display Styles**: Large headers (32px, 28px, 24px)
- **Headlines**: Section headers (24px, 20px, 18px)
- **Titles**: Component titles (18px, 16px, 14px)
- **Body Text**: Regular content (16px, 14px, 12px)
- **Labels**: UI labels and captions
- **Button Text**: Action button typography
- **Input Text**: Form field typography

### `app_spacing.dart`
Spacing system based on 16px base unit:
- **Base Scale**: xs(4px), sm(8px), md(16px), lg(24px), xl(32px), xxl(48px)
- **Component Spacing**: Cards, buttons, forms, lists
- **Layout Spacing**: Screen margins, content padding, sections
- **EdgeInsets**: Pre-defined padding and margin combinations
- **Responsive Helpers**: Adaptive spacing for different screen sizes

### `app_sizes.dart`
Size constants and dimensions:
- **Touch Targets**: Minimum 44pt for accessibility
- **Icons**: XS(12px) to XXL(48px) sizes
- **Avatars**: From 24px to 120px
- **Border Radius**: 4px (inputs) to 16px (dialogs)
- **Component Heights**: Buttons, inputs, list items
- **Breakpoints**: Mobile, tablet, desktop thresholds
- **Constraints**: Box constraints for responsive layouts

### `app_theme.dart`
Complete Material Design theme configuration:
- **Color Schemes**: Light and dark theme support
- **Component Themes**: Buttons, inputs, cards, dialogs
- **Typography Mapping**: Material Design text styles
- **System Integration**: Status bar, navigation bar styling

### `theme.dart`
Convenience export file for easy importing:
```dart
import 'package:your_app/core/theme/theme.dart';
```

## 🚀 Usage Examples

### Importing the Theme System
```dart
// Import all theme components
import 'package:your_app/core/theme/theme.dart';

// Or import specific components
import 'package:your_app/core/theme/app_colors.dart';
import 'package:your_app/core/theme/app_typography.dart';
```

### Using Colors
```dart
Container(
  color: AppColors.primary,              // Orange accent
  child: Text(
    'Book Appointment',
    style: TextStyle(color: AppColors.onPrimary), // White text
  ),
)

// Status colors
Container(color: AppColors.success)     // Green
Container(color: AppColors.warning)     // Orange-yellow
Container(color: AppColors.error)       // Red

// Background colors
Scaffold(backgroundColor: AppColors.background)  // Pure white
Card(color: AppColors.surface)                   // Light gray
```

### Using Typography
```dart
Text(
  'Appointment Details',
  style: AppTypography.headlineMedium,    // 20px, bold
)

Text(
  'Service description text',
  style: AppTypography.bodyLarge,        // 16px, regular
)

Text(
  'Price: \$45.00',
  style: AppTypography.price,            // 16px, bold, orange
)

// Button text
ElevatedButton(
  child: Text(
    'Confirm',
    style: AppTypography.buttonMedium,   // 14px, semibold
  ),
)
```

### Using Spacing
```dart
Padding(
  padding: AppSpacing.all16,             // 16px all sides
  child: Column(
    children: [
      // Content with consistent spacing
    ],
  ),
)

Container(
  margin: AppSpacing.cardPaddingAll,     // 16px card padding
  padding: AppSpacing.horizontal16,      // 16px horizontal only
)

// Responsive spacing
Padding(
  padding: AppSpacing.responsiveScreenPadding(context),
)
```

### Using Sizes
```dart
Container(
  height: AppSizes.buttonHeightMd,       // 40px button height
  decoration: BoxDecoration(
    borderRadius: AppSizes.buttonBorderRadius, // 8px radius
  ),
)

Icon(
  Icons.star,
  size: AppSizes.iconLg,                 // 24px icon
)

// Responsive sizing
Container(
  constraints: AppSizes.contentConstraints(context),
  child: Content(),
)
```

### Applying the Complete Theme
```dart
// In main.dart
MaterialApp(
  title: 'Appointment Tracker',
  theme: AppTheme.lightTheme,           // Apply complete theme
  darkTheme: AppTheme.darkTheme,        // Dark mode support
  home: HomeScreen(),
)
```

## 🎯 Design Tokens

### Color Usage Guidelines

**Primary Color (#FF8C42)**
- Use for: Primary buttons, links, selected states, progress indicators
- Don't use for: Large background areas, body text

**Background Colors**
- `background` (#FFFFFF): Main app background, card backgrounds
- `surface` (#F8F9FA): Elevated surfaces, input backgrounds
- `surfaceVariant` (#F1F3F4): Alternative surface color

**Text Colors**
- `textPrimary` (#212529): Headlines, important text
- `textSecondary` (#6C757D): Body text, descriptions
- `textTertiary` (#9CA3AF): Captions, helper text

### Typography Scale
Based on Inter font family with optimal line heights and letter spacing:

| Style | Size | Weight | Usage |
|-------|------|---------|-------|
| Display Large | 32px | Bold | Page titles |
| Headline Medium | 20px | Bold | Section headers |
| Title Large | 18px | SemiBold | Card titles |
| Body Large | 16px | Regular | Main content |
| Label Medium | 12px | Medium | UI labels |

### Spacing Scale
All spacing values are multiples of 4px for pixel-perfect designs:

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Tight spacing |
| sm | 8px | Small gaps |
| md | 16px | Base unit |
| lg | 24px | Section spacing |
| xl | 32px | Large sections |
| xxl | 48px | Page sections |

## 📱 Component Examples

### Service Card
```dart
Card(
  margin: AppSpacing.all8,
  child: Padding(
    padding: AppSpacing.serviceCardPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Haircut & Style',
          style: AppTypography.cardTitle,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          '45 minutes',
          style: AppTypography.cardSubtitle,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          '\$45.00',
          style: AppTypography.price,
        ),
      ],
    ),
  ),
)
```

### Primary Button
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    padding: AppSpacing.buttonPadding,
    shape: RoundedRectangleBorder(
      borderRadius: AppSizes.buttonBorderRadius,
    ),
  ),
  child: Text(
    'Book Appointment',
    style: AppTypography.buttonMedium,
  ),
)
```

### Form Input
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Full Name',
    hintText: 'Enter your full name',
    filled: true,
    fillColor: AppColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: AppSizes.inputBorderRadius,
    ),
  ),
  style: AppTypography.inputText,
)
```

## 🔧 Customization

### Adding New Colors
```dart
// In app_colors.dart
static const Color customColor = Color(0xFF123456);
static Color get customColorWithOpacity => customColor.withOpacity(0.1);
```

### Adding New Text Styles
```dart
// In app_typography.dart
static const TextStyle customStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 18,
  fontWeight: semiBold,
  color: AppColors.textPrimary,
);
```

### Adding New Spacing Values
```dart
// In app_spacing.dart
static const double customSpacing = 20.0;
static const EdgeInsets customPadding = EdgeInsets.all(20.0);
```

## 📐 Responsive Design

The theme system includes responsive helpers for different screen sizes:

```dart
// Responsive spacing
double horizontalPadding = AppSpacing.responsiveHorizontalPadding(context);

// Responsive sizing
bool isMobile = AppSizes.isMobile(context);
bool isTablet = AppSizes.isTablet(context);
bool isDesktop = AppSizes.isDesktop(context);

// Responsive values
double width = AppSizes.responsiveWidth(
  context,
  mobile: 100,
  tablet: 150,
  desktop: 200,
);
```

## ✅ Best Practices

1. **Always use theme constants** instead of hardcoded values
2. **Test on different screen sizes** using responsive helpers
3. **Maintain accessibility** with sufficient color contrast
4. **Use semantic color names** (success, warning, error) over specific colors
5. **Keep spacing consistent** using the defined scale
6. **Follow typography hierarchy** for better readability
7. **Test dark mode** even if not immediately implemented

## 🎨 Design System Integration

This theme system is designed to work seamlessly with:
- **Figma Design Files**: Tokens match design specifications
- **Component Library**: All custom widgets use these themes
- **Firebase Integration**: Colors work well with status indicators
- **Accessibility Tools**: High contrast ratios and touch targets

The theme system ensures that every pixel in the app follows the established design language, creating a cohesive and professional user experience.

---

**Last Updated**: December 2024  
**Version**: 1.0  
**Status**: Ready for Implementation 