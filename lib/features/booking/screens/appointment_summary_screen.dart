import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';

import 'booking_confirmation_screen.dart';

class AppointmentSummaryScreen extends StatelessWidget {
  const AppointmentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final booking = bookingProvider.booking;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Review Appointment',
          ),
          body: Column(
            children: [
              BookingProgressIndicator(
                currentStep: 3,
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

                      
                      _buildSummaryCard(context, booking),
                      const SizedBox(height: AppSpacing.space24),
                      
                      _buildImportantInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () => _confirmAppointment(context, bookingProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirm Appointment',
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, booking) {
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
            'Appointment Summary',
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
          
          const Divider(height: 32),
          
          _buildDetailRow(
            context: context,
            icon: Icons.star,
            label: 'Service',
            value: _getServiceNames(booking),
          ),
          
          const Divider(height: 32),
          
          _buildDetailRow(
            context: context,
            icon: Icons.person,
            label: 'Staff',
            value: booking.selectedStaff?.fullName ?? 'Any Available Specialist',
          ),
          
          const Divider(height: 32),
          
          _buildDetailRow(
            context: context,
            icon: Icons.calendar_today,
            label: 'Date & Time',
            value: _getDateTimeDetails(booking),
          ),
          
          const Divider(height: 32),
          
          _buildDetailRow(
            icon: Icons.location_on,
            label: 'Address',
            value: booking.providerAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    BuildContext? context,
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

  Widget _buildImportantInfo() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.space8),
              Text(
                'Before You Confirm',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.warning,
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



  Future<void> _confirmAppointment(BuildContext context, BookingProvider bookingProvider) async {
    // Show loading state
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Confirm the booking
    final success = await bookingProvider.confirmBooking();
    
    if (context.mounted) {
      Navigator.of(context).pop(); // Remove loading dialog
      
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BookingConfirmationScreen(),
          ),
        );
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Booking Failed'),
            content: const Text('Sorry, we couldn\'t confirm your appointment. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
} 