import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final booking = bookingProvider.booking;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Confirmation',
            showBackButton: false,
          ),
          body: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.space32),
                _buildSuccessIcon(),
                const SizedBox(height: AppSpacing.space24),
                _buildSuccessMessage(),
                const SizedBox(height: AppSpacing.space32),
                _buildBookingDetailsCard(booking),
                const SizedBox(height: AppSpacing.space32),
                _buildActionButtons(),
                const SizedBox(height: AppSpacing.space24),
                _buildNextSteps(booking),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: AppSpacing.screenPaddingHorizontal.copyWith(
              bottom: AppSpacing.space16,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BookingButton(
                    text: 'View Appointment',
                    onPressed: () => _viewAppointment(context),
                    type: BookingButtonType.primary,
                  ),
                  const SizedBox(height: AppSpacing.space12),
                  BookingButton(
                    text: 'Book Another',
                    onPressed: () => _bookAnother(context, bookingProvider),
                    type: BookingButtonType.secondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: AppColors.background,
        size: 48,
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          'Booking Confirmed',
          style: AppTypography.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          'Your appointment is scheduled!',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBookingDetailsCard(booking) {
    return Container(
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSizes.cardBorderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking ${booking.bookingReference}',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          _buildDetailRow('Provider', booking.providerName),
          _buildDetailRow('Service', _getServiceDetails(booking)),
          _buildDetailRow('Date & Time', _getDateTimeDetails(booking)),
          _buildDetailRow('Duration', booking.getFormattedDuration()),
          _buildDetailRow('Customer', booking.customerInfo?.fullName ?? ''),
          _buildDetailRow('Location', booking.providerAddress),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.calendar_today,
            label: 'Add to\nCalendar',
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share,
            label: 'Share',
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.phone,
            label: 'Call\nVenue',
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.chat,
            label: 'Chat\nSupport',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.space12,
          horizontal: AppSpacing.space8,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSizes.cardBorderRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: AppSizes.iconLg,
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              label,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextSteps(booking) {
    return Container(
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.cardBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Steps:',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.space12),
          _buildNextStepItem('• Confirmation sent via SMS'),
          _buildNextStepItem('• Arrive 10 minutes early'),
          _buildNextStepItem('• Bring valid ID'),
          if (_hasSpecialInstructions(booking)) ...[
            const SizedBox(height: AppSpacing.space8),
            Text(
              'Special Instructions:',
              style: AppTypography.labelMedium,
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              booking.customerInfo?.specialInstructions ?? '',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNextStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Text(
        text,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  bool _hasSpecialInstructions(booking) {
    final instructions = booking.customerInfo?.specialInstructions;
    return instructions != null && instructions.isNotEmpty;
  }

  String _getServiceDetails(booking) {
    final serviceName = booking.selectedService?.name ?? 'Service';
    final staffName = booking.selectedStaff?.fullName ?? 'Any Available Specialist';
    return '$serviceName\nwith $staffName';
  }

  String _getDateTimeDetails(booking) {
    final dateStr = booking.getFormattedDate();
    final startTime = booking.selectedTimeSlot ?? '';
    final endTime = booking.getFormattedEndTime();
    
    if (dateStr.isEmpty || startTime.isEmpty) {
      return 'Date and time to be confirmed';
    }
    
    if (endTime.isNotEmpty) {
      return '$dateStr\n$startTime - $endTime';
    } else {
      return '$dateStr\n$startTime';
    }
  }

  void _viewAppointment(BuildContext context) {
    // Navigate back to home screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _bookAnother(BuildContext context, BookingProvider bookingProvider) {
    bookingProvider.resetBooking();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
} 
