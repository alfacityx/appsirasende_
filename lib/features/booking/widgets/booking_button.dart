import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

enum BookingButtonType {
  primary,
  secondary,
  outline,
}

enum BookingButtonSize {
  small,
  medium,
  large,
}

class BookingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BookingButtonType type;
  final BookingButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final bool fullWidth;

  const BookingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = BookingButtonType.primary,
    this.size = BookingButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || isLoading || onPressed == null;
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(isDisabled),
          foregroundColor: _getForegroundColor(isDisabled),
          elevation: _getElevation(),
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.buttonBorderRadius,
            side: _getBorderSide(isDisabled),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getForegroundColor(false),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppSpacing.space8),
          Text(
            text,
            style: _getTextStyle(),
          ),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle(),
    );
  }

  double _getHeight() {
    switch (size) {
      case BookingButtonSize.small:
        return AppSizes.buttonHeightSm;
      case BookingButtonSize.medium:
        return AppSizes.buttonHeightMd;
      case BookingButtonSize.large:
        return AppSizes.buttonHeightLg;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case BookingButtonSize.small:
        return AppSpacing.buttonPaddingSmall;
      case BookingButtonSize.medium:
        return AppSpacing.buttonPadding;
      case BookingButtonSize.large:
        return AppSpacing.buttonPaddingLarge;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = switch (size) {
      BookingButtonSize.small => AppTypography.buttonSmall,
      BookingButtonSize.medium => AppTypography.buttonMedium,
      BookingButtonSize.large => AppTypography.buttonLarge,
    };

    return baseStyle.copyWith(
      color: _getForegroundColor(false),
    );
  }

  double _getIconSize() {
    switch (size) {
      case BookingButtonSize.small:
        return AppSizes.iconSm;
      case BookingButtonSize.medium:
        return AppSizes.iconMd;
      case BookingButtonSize.large:
        return AppSizes.iconLg;
    }
  }

  Color _getBackgroundColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.buttonDisabled;
    }

    switch (type) {
      case BookingButtonType.primary:
        return AppColors.buttonPrimary;
      case BookingButtonType.secondary:
        return AppColors.buttonSecondary;
      case BookingButtonType.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.textDisabled;
    }

    switch (type) {
      case BookingButtonType.primary:
        return AppColors.onPrimary;
      case BookingButtonType.secondary:
        return AppColors.textPrimary;
      case BookingButtonType.outline:
        return AppColors.primary;
    }
  }

  double _getElevation() {
    switch (type) {
      case BookingButtonType.primary:
        return AppSizes.buttonElevation;
      case BookingButtonType.secondary:
        return AppSizes.elevationXs;
      case BookingButtonType.outline:
        return AppSizes.elevationNone;
    }
  }

  BorderSide _getBorderSide(bool isDisabled) {
    if (type == BookingButtonType.outline) {
      return BorderSide(
        color: isDisabled ? AppColors.borderLight : AppColors.primary,
        width: AppSizes.borderNormal,
      );
    }
    return BorderSide.none;
  }
}

class BookingFloatingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  const BookingFloatingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.screenPaddingHorizontal.copyWith(
        bottom: AppSpacing.space16,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BookingButton(
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          isEnabled: isEnabled,
          size: BookingButtonSize.large,
        ),
      ),
    );
  }
} 