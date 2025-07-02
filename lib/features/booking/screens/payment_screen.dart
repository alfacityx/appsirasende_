import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_button.dart';
import 'booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final booking = bookingProvider.booking;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Payment Method',
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTotalSection(booking),
                      const SizedBox(height: AppSpacing.space24),
                      _buildPaymentInfo(),
                      const SizedBox(height: AppSpacing.space32),
                      _buildImportantNote(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BookingFloatingButton(
            text: 'Confirm Booking',
            onPressed: _isProcessing ? null : () => _confirmBooking(bookingProvider),
            isLoading: _isProcessing,
          ),
        );
      },
    );
  }

  Widget _buildTotalSection(booking) {
    return Container(
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: AppSizes.cardBorderRadius,
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                '\$${booking.totalAmount.toStringAsFixed(2)}',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTypography.titleLarge,
        ),
        const SizedBox(height: AppSpacing.space16),
        Container(
          padding: AppSpacing.cardPaddingAll,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppSizes.cardBorderRadius,
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.store,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pay at Venue',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      'Payment will be collected at the salon',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImportantNote() {
    return Container(
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: AppSizes.cardBorderRadius,
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
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
          Text(
            '• Please arrive 10 minutes before your appointment',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            '• The salon accepts cash and card payments',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            '• Cancellation must be made at least 2 hours in advance',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmBooking(BookingProvider bookingProvider) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Select payment method
      bookingProvider.selectPaymentMethod('Pay at Venue');

      // Simulate booking confirmation
      await Future.delayed(const Duration(seconds: 2));

      // Confirm booking
      final success = await bookingProvider.confirmBooking();

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BookingConfirmationScreen(),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to confirm booking. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
} 