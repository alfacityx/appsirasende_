import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_button.dart';

import 'booking_confirmation_screen.dart';

class AppointmentSummaryScreen extends StatefulWidget {
  const AppointmentSummaryScreen({super.key});

  @override
  State<AppointmentSummaryScreen> createState() => _AppointmentSummaryScreenState();
}

class _AppointmentSummaryScreenState extends State<AppointmentSummaryScreen> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
                      
                      _buildCustomerNoteSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BookingFloatingButton(
            text: 'Confirm Appointment',
                  onPressed: () => _confirmAppointment(context, bookingProvider),
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

  Widget _buildCustomerNoteSection() {
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.note_add,
                  color: AppColors.primary,
                size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Text(
                'Add a Note (Optional)',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),
          Text(
            'Share any special requests or information with the salon',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.space12),
          TextField(
            controller: _noteController,
            maxLines: 4,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: 'e.g., I have sensitive skin, please use gentle products...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
          ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
              counterStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
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
    // Save customer note if provided
    if (_noteController.text.trim().isNotEmpty) {
      bookingProvider.setSpecialInstructions(_noteController.text.trim());
    }

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