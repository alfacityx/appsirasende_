import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_button.dart';
import 'payment_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final booking = bookingProvider.booking;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Booking Summary',
          ),
          body: Column(
            children: [
              BookingProgressIndicator(
                currentStep: 4,
                totalSteps: 5,
                stepTitles: const [
                  'Select Service',
                  'Choose Staff',
                  'Pick Date & Time',
                  'Your Details',
                  'Confirm Booking',
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProviderSection(context, booking),
                      const SizedBox(height: AppSpacing.space16),
                      _buildServiceSection(context, booking),
                      const SizedBox(height: AppSpacing.space16),
                      _buildStaffSection(context, booking),
                      const SizedBox(height: AppSpacing.space16),
                      _buildDateTimeSection(context, booking),
                      const SizedBox(height: AppSpacing.space16),
                      _buildCustomerSection(context, booking),
                      const SizedBox(height: AppSpacing.space24),
                      _buildPricingSection(booking),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BookingFloatingButton(
            text: 'Proceed to Payment',
            onPressed: () => _proceedToPayment(context),
          ),
        );
      },
    );
  }

  Widget _buildProviderSection(BuildContext context, dynamic booking) {
    return _buildSummaryCard(
      context,
      'Location',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.providerName,
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            booking.providerAddress,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSection(BuildContext context, dynamic booking) {
    return _buildSummaryCard(
      context,
      'Service',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.selectedService?.name ?? 'No service selected',
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            'Duration: ${booking.getFormattedDuration()}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffSection(BuildContext context, dynamic booking) {
    return _buildSummaryCard(
      context,
      'Staff',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.selectedStaff?.fullName ?? 'Any Available Specialist',
            style: AppTypography.bodyLarge,
          ),
          if (booking.selectedStaff != null) ...[
            const SizedBox(height: AppSpacing.space4),
            Text(
              booking.selectedStaff!.title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateTimeSection(BuildContext context, dynamic booking) {
    return _buildSummaryCard(
      context,
      'Date & Time',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.getFormattedDate(),
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            _getTimeRange(booking),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(BuildContext context, dynamic booking) {
    return _buildSummaryCard(
      context,
      'Customer',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.customerInfo?.fullName ?? 'No customer info',
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            booking.customerInfo?.formattedPhoneNumber ?? '',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (booking.customerInfo?.email?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.space4),
            Text(
              booking.customerInfo!.email!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingSection(dynamic booking) {
    return Container(
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.cardBorderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.space16),
          _buildPriceRow(
            'Service Fee',
            '\$${booking.serviceAmount.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.space8),
          _buildPriceRow(
            'Tax',
            '\$${booking.taxAmount.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.space16),
          Container(
            height: 1,
            color: AppColors.border,
          ),
          const SizedBox(height: AppSpacing.space16),
          _buildPriceRow(
            'Total',
            '\$${booking.totalAmount.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, Widget content) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.titleMedium,
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Edit',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
          content,
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal 
              ? AppTypography.titleMedium 
              : AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          amount,
          style: isTotal 
              ? AppTypography.titleMedium 
              : AppTypography.bodyMedium,
        ),
      ],
    );
  }

  String _getTimeRange(dynamic booking) {
    final startTime = booking.selectedTimeSlot ?? '';
    final endTime = booking.getFormattedEndTime();
    
    if (startTime.isEmpty) return 'Time to be confirmed';
    if (endTime.isEmpty) return startTime;
    
    return '$startTime - $endTime';
  }

  void _proceedToPayment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaymentScreen(),
      ),
    );
  }
}
