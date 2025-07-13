import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_button.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/booking_card.dart' show TimeSlotCard;
import 'appointment_summary_screen.dart';

class DateTimeSelectionScreen extends StatefulWidget {
  const DateTimeSelectionScreen({super.key});

  @override
  State<DateTimeSelectionScreen> createState() => _DateTimeSelectionScreenState();
}

class _DateTimeSelectionScreenState extends State<DateTimeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final selectedDate = bookingProvider.booking.selectedDate;
        final selectedTimeSlot = bookingProvider.booking.selectedTimeSlot;
        final canContinue = selectedDate != null && selectedTimeSlot != null;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Select Date & Time',
          ),
          body: Column(
            children: [
              BookingProgressIndicator(
                currentStep: 2,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNextAvailableOption(bookingProvider),
                      const Divider(height: 32, color: AppColors.borderLight),
                      _buildDateSelection(bookingProvider),
                      if (selectedDate != null) ...[
                        const Divider(height: 32, color: AppColors.borderLight),
                        _buildTimeSelection(bookingProvider, selectedDate),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: canContinue
              ? BookingFloatingButton(
                  text: 'Review Appointment',
                  onPressed: () => _navigateToSummary(context),
                )
              : null,
        );
      },
    );
  }

  Widget _buildNextAvailableOption(BookingProvider bookingProvider) {
    final nextAvailable = bookingProvider.getNextAvailableDateTime();
    
    return Container(
      margin: AppSpacing.screenPaddingHorizontal,
      child: BookingCard(
        onTap: nextAvailable != null ? () => _selectNextAvailable(bookingProvider, nextAvailable) : null,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const Icon(
                Icons.flash_on,
                color: AppColors.success,
                size: AppSizes.iconLg,
              ),
            ),
            const SizedBox(width: AppSpacing.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Available',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    nextAvailable != null
                        ? _formatNextAvailable(nextAvailable)
                        : 'No availability',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space16),
            Container(
              padding: AppSpacing.buttonPaddingSmall,
              decoration: BoxDecoration(
                color: AppColors.buttonSecondary,
                borderRadius: AppSizes.buttonBorderRadius,
              ),
              child: Text(
                'Select',
                style: AppTypography.buttonSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection(BookingProvider bookingProvider) {
    return Container(
      margin: AppSpacing.screenPaddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Date',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.space16),
          CalendarWidget(
            selectedDate: bookingProvider.booking.selectedDate,
            onDateSelected: (date) => bookingProvider.selectDate(date),
            availableDates: bookingProvider.getAvailableDates(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelection(BookingProvider bookingProvider, DateTime selectedDate) {
    final availableTimeSlots = bookingProvider.availableTimeSlots;
    final selectedTimeSlot = bookingProvider.booking.selectedTimeSlot;
    final selectedStaff = bookingProvider.booking.selectedStaff;

    // Demo: If Mike Rodriguez and Monday, show full message and no slots
    if (selectedStaff != null &&
        selectedStaff.fullName == 'Mike Rodriguez' &&
        selectedDate.weekday == DateTime.monday) {
      return Container(
        margin: AppSpacing.screenPaddingHorizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Times for  ${_formatSelectedDate(selectedDate)}',
              style: AppTypography.titleLarge,
            ),
            const SizedBox(height: AppSpacing.space16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.busy),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All appointments are full for this staff member on Mondays. Please select another day.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.busy),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
          ],
        ),
      );
    }

    return Container(
      margin: AppSpacing.screenPaddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Times for  ${_formatSelectedDate(selectedDate)}',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.space16),
          SizedBox(
            height: AppSizes.timeSlotHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = availableTimeSlots[index];
                final isSelected = selectedTimeSlot == timeSlot;
                // Mark time slots after 12:00 PM as unavailable for demonstration
                final isAvailable = _isTimeSlotAvailable(timeSlot);
                return TimeSlotCard(
                  time: timeSlot,
                  isSelected: isSelected,
                  isAvailable: isAvailable,
                  onTap: () => bookingProvider.selectTimeSlot(timeSlot),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
        ],
      ),
    );
  }

  // Helper to determine if a time slot is available (demo: after 12:00 PM is unavailable)
  bool _isTimeSlotAvailable(String timeSlot) {
    if (timeSlot.contains('PM')) {
      final hour = int.tryParse(timeSlot.split(':')[0]) ?? 0;
      if (hour > 12 || hour == 12) {
        return false;
      }
    }
    return true;
  }

  String _formatNextAvailable(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    
    String dayText;
    if (_isSameDay(dateTime, now)) {
      dayText = 'Today';
    } else if (_isSameDay(dateTime, tomorrow)) {
      dayText = 'Tomorrow';
    } else {
      dayText = _formatSelectedDate(dateTime);
    }
    
    final timeText = _formatTime(dateTime);
    return '$dayText at $timeText';
  }

  String _formatSelectedDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final minuteStr = minute == 0 ? '' : ':${minute.toString().padLeft(2, '0')}';
    return '$displayHour$minuteStr $period';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void _selectNextAvailable(BookingProvider bookingProvider, DateTime nextAvailable) {
    final selectedStaff = bookingProvider.booking.selectedStaff;
    DateTime date = DateTime(nextAvailable.year, nextAvailable.month, nextAvailable.day);
    String timeSlot = _formatTime(nextAvailable);

    // For Mike Rodriguez, skip Mondays
    if (selectedStaff != null && selectedStaff.fullName == 'Mike Rodriguez') {
      // Find the next non-Monday date
      final availableDates = bookingProvider.getAvailableDates();
      for (final d in availableDates) {
        if (d.weekday != DateTime.monday) {
          date = d;
          break;
        }
      }
      // Use the first available time slot
      if (bookingProvider.availableTimeSlots.isNotEmpty) {
        timeSlot = bookingProvider.availableTimeSlots.first;
      }
    }

    bookingProvider.selectDate(date);
    bookingProvider.selectTimeSlot(timeSlot);
  }

  void _navigateToSummary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AppointmentSummaryScreen(),
      ),
    );
  }
} 
