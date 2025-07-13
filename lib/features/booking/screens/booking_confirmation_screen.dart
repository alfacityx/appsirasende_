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
          body: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.space64),
                _buildSuccessIcon(),
                const SizedBox(height: AppSpacing.space24),
                _buildSuccessMessage(),
                const SizedBox(height: AppSpacing.space32),
                _buildAppointmentDetailsCard(booking),
                const SizedBox(height: AppSpacing.space32),
                _buildActionButtons(context, bookingProvider),
                const SizedBox(height: AppSpacing.space24),
                _buildImportantInfo(),
              ],
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
        color: Colors.white,
        size: 48,
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          'Appointment Confirmed!',
          style: AppTypography.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          'Your appointment has been successfully booked',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppointmentDetailsCard(booking) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Details',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.space20),
          
          _buildDetailRow(
            icon: Icons.business,
            label: 'Salon',
            value: booking.providerName,
          ),
          const SizedBox(height: AppSpacing.space16),
          
          _buildDetailRow(
            icon: Icons.star,
            label: 'Service',
            value: _getServiceNames(booking),
          ),
          const SizedBox(height: AppSpacing.space16),
          
          _buildDetailRow(
            icon: Icons.person,
            label: 'Staff',
            value: booking.selectedStaff?.fullName ?? 'Any Available Specialist',
          ),
          const SizedBox(height: AppSpacing.space16),
          
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Date & Time',
            value: _getDateTimeDetails(booking),
          ),
          
          if (booking.specialInstructions != null && booking.specialInstructions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space16),
          _buildDetailRow(
              icon: Icons.note,
              label: 'Your Note',
              value: booking.specialInstructions!,
          ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.space16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildActionButtons(BuildContext context, BookingProvider bookingProvider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _goHome(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Done',
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportantInfo() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.space8),
          Text(
                'Important Information',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
            Text(
            '• Please arrive 10 minutes before your appointment',
            style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
            '• Payment will be handled at the venue',
            style: AppTypography.bodyMedium,
              ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            '• Changes can be made by contacting the salon directly',
            style: AppTypography.bodyMedium,
            ),
        ],
      ),
    );
  }

  String _getServiceNames(booking) {
    final services = booking.allSelectedServices;
    if (services.isEmpty) {
      return booking.selectedService?.name ?? 'Service';
    }
    return services.map((s) => s.name).join(', ');
  }

  String _getDateTimeDetails(booking) {
    final date = booking.selectedDate;
    final timeSlot = booking.selectedTimeSlot;
    
    if (date == null || timeSlot == null) {
      return 'To be confirmed';
    }
    
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final weekdays = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    
    final dayName = weekdays[date.weekday - 1];
    final monthName = months[date.month - 1];
    final dateStr = '$dayName, $monthName ${date.day}, ${date.year}';
    
    return '$dateStr at $timeSlot';
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _bookAnother(BuildContext context, BookingProvider bookingProvider) {
    bookingProvider.resetBooking();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
} 
