import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class BookingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;

  const BookingAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTypography.appBarTitle,
      ),
      centerTitle: centerTitle,
      backgroundColor: AppColors.background,
      elevation: AppSizes.appBarElevation,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: AppSizes.iconMd,
                color: AppColors.textPrimary,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.borderLight,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight + 1);
}

class BookingProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const BookingProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepTitles = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.screenPaddingHorizontal.copyWith(
        top: AppSpacing.space16,
        bottom: AppSpacing.space8,
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isLast = index == totalSteps - 1;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? AppColors.primary
                              : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (!isLast)
                      const SizedBox(width: AppSpacing.space4),
                  ],
                ),
              );
            }),
          ),
          if (stepTitles.isNotEmpty && currentStep < stepTitles.length) ...[
            const SizedBox(height: AppSpacing.space8),
            Text(
              stepTitles[currentStep],
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 