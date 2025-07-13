import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_button.dart';
import '../widgets/booking_card.dart';
import 'date_time_selection_screen.dart';

class StaffSelectionScreen extends StatelessWidget {
  const StaffSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final selectedStaff = bookingProvider.booking.selectedStaff;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Select Specialist',
          ),
          body: Column(
            children: [
              BookingProgressIndicator(
                currentStep: 1,
                totalSteps: 4,
                stepTitles: const [
                  'Select Service',
                  'Choose Staff',
                  'Pick Date & Time',
                  'Confirm Booking',
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnyAvailableOption(bookingProvider),
                      const SizedBox(height: AppSpacing.space24),
                      // Replacing with direct rendering of team members
                      ...bookingProvider.availableStaff
                          .where((staff) => staff.id != 'any_available')
                          .map((staff) {
                        final selectedStaff = bookingProvider.booking.selectedStaff;
                        final isSelected = selectedStaff?.id == staff.id;
                        final selectedDate = bookingProvider.booking.selectedDate;
                        final isBusy = isStaffFullyBookedForDate(staff, selectedDate);
                        return StaffCard(
                          name: staff.fullName,
                          title: staff.displayTitle,
                          rating: staff.rating,
                          reviewCount: staff.reviewCount,
                          isAvailable: true,
                          isSelected: isSelected,
                          onTap: () => bookingProvider.selectStaff(staff),
                          busyLabel: isBusy ? 'Busy' : null,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: selectedStaff != null
              ? BookingFloatingButton(
                  text: 'Continue',
                  onPressed: () => _navigateToDateTime(context),
                )
              : null,
        );
      },
    );
  }

  Widget _buildAnyAvailableOption(BookingProvider bookingProvider) {
    final anyAvailableStaff = bookingProvider.availableStaff
        .where((staff) => staff.id == 'any_available')
        .first;
    final isSelected = bookingProvider.booking.selectedStaff?.id == 'any_available';

    return BookingCard(
      isSelected: isSelected,
      onTap: () => bookingProvider.selectStaff(anyAvailableStaff),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Icon(
              Icons.person_add,
              color: AppColors.primary,
              size: AppSizes.iconXl,
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Any Available Specialist',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  'Fastest booking option',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
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
    );
  }

  void _navigateToDateTime(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DateTimeSelectionScreen(),
      ),
    );
  }
} 

bool isStaffFullyBookedForDate(staff, DateTime? date) {
  if (staff.fullName == 'Mike Rodriguez' && date != null && date.weekday == DateTime.monday) {
    // Demo: Mike is fully booked on Mondays
    return true;
  }
  // For real data, check booked slots here
  return false;
} 
