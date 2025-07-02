import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../models/staff_member_detail.dart';

class SpecialistCard extends StatelessWidget {
  final StaffMemberDetail specialist;

  const SpecialistCard({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 32,
                    ),
                  ),
                ),
              ),
              if (!specialist.isAvailable)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            specialist.name,
            style: AppTypography.titleSmall,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            specialist.title,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.space4),
          Container(
            height: 2,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
} 