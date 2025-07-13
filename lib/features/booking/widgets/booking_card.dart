import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class BookingCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool isSelected;
  final bool isEnabled;

  const BookingCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.isSelected = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space8),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: AppSizes.cardBorderRadius,
        elevation: AppSizes.cardElevation,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: AppSizes.cardBorderRadius,
          child: Container(
            padding: padding ?? AppSpacing.cardPaddingAll,
            decoration: BoxDecoration(
              borderRadius: AppSizes.cardBorderRadius,
              border: isSelected
                  ? Border.all(
                      color: AppColors.primary,
                      width: AppSizes.borderThick,
                    )
                  : Border.all(
                      color: AppColors.border,
                      width: AppSizes.borderNormal,
                    ),
            ),
            child: DefaultTextStyle(
              style: AppTypography.bodyMedium.copyWith(
                color: isEnabled ? AppColors.textPrimary : AppColors.textDisabled,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String name;
  final String duration;
  final double price;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.name,
    required this.duration,
    required this.price,
    this.isPopular = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BookingCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTypography.titleMedium,
                      ),
                    ),
                    if (isPopular)
                      Container(
                        padding: AppSpacing.horizontal8.copyWith(
                          top: AppSpacing.space4,
                          bottom: AppSpacing.space4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Text(
                          'Popular',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.background,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  duration,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${price.toStringAsFixed(0)}',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.space8),
              Container(
                padding: AppSpacing.buttonPaddingSmall,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.buttonSecondary,
                  borderRadius: AppSizes.buttonBorderRadius,
                ),
                child: Text(
                  'Select',
                  style: AppTypography.buttonSmall.copyWith(
                    color: isSelected ? AppColors.background : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final String name;
  final String title;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? busyLabel;

  const StaffCard({
    super.key,
    required this.name,
    required this.title,
    required this.rating,
    required this.reviewCount,
    this.isAvailable = true,
    this.isSelected = false,
    this.onTap,
    this.busyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return BookingCard(
      isSelected: isSelected,
      isEnabled: true,
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.avatarMd / 2,
            backgroundColor: AppColors.primary,
            child: Text(
              name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase(),
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.background,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  title,
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.space4),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: AppSizes.starSize,
                          color: AppColors.star,
                        ),
                        const SizedBox(width: AppSpacing.space4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(width: AppSpacing.space8),
                        Text(
                          '($reviewCount)',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                busyLabel ?? 'Available',
                style: AppTypography.bodySmall.copyWith(
                  color: busyLabel != null ? AppColors.busy : AppColors.available,
                ),
              ),
              const SizedBox(height: AppSpacing.space8),
              Container(
                padding: AppSpacing.buttonPaddingSmall,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.buttonSecondary,
                  borderRadius: AppSizes.buttonBorderRadius,
                ),
                child: Text(
                  'Select',
                  style: AppTypography.buttonSmall.copyWith(
                    color: isSelected ? AppColors.background : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeSlotCard extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const TimeSlotCard({
    super.key,
    required this.time,
    this.isSelected = false,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        width: AppSizes.timeSlotMinWidth,
        height: AppSizes.timeSlotHeight,
        margin: const EdgeInsets.only(right: AppSpacing.space8),
        decoration: BoxDecoration(
          color: !isAvailable
              ? AppColors.surfaceVariant
              : isSelected
                  ? AppColors.primary
                  : AppColors.surface,
          borderRadius: AppSizes.borderRadiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? AppSizes.borderThick : AppSizes.borderNormal,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: time.split(' ').map((part) {
            return Text(
              part,
              style: AppTypography.bodySmall.copyWith(
                color: !isAvailable
                    ? AppColors.textDisabled
                    : isSelected
                        ? AppColors.background
                        : AppColors.textPrimary,
                fontWeight: part.contains('AM') || part.contains('PM')
                    ? FontWeight.normal
                    : FontWeight.w600,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
} 
