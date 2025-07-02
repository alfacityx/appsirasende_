import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../models/salon_detail.dart';

class ServicesTab extends StatelessWidget {
  final List<SalonService> services;

  const ServicesTab({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: Row(
            children: [
              Text(
                'Our Services',
                style: AppTypography.titleLarge,
              ),
              const Spacer(),
              Text(
                'See All',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        Expanded(
          child: ListView.builder(
            padding: AppSpacing.screenPaddingHorizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space16),
                child: _buildServiceItem(service),
              );
            },
          ),
        ),
        const SizedBox(height: 100), // Space for bottom button
      ],
    );
  }

  Widget _buildServiceItem(SalonService service) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSizes.cardBorderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              service.name,
              style: AppTypography.titleMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Text(
            '${service.typeCount} types',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.space8),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: AppSizes.iconSm,
          ),
        ],
      ),
    );
  }
} 