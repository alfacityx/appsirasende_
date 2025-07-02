import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_button.dart';
import '../models/service.dart';
import 'staff_selection_screen.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final selectedService = bookingProvider.booking.selectedService;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Services',
            showBackButton: true,
          ),
          body: Column(
            children: [
              BookingProgressIndicator(
                currentStep: 0,
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
                      _buildProviderInfo(bookingProvider),
                      const SizedBox(height: AppSpacing.space24),
                      _buildServicesByCategory(bookingProvider),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: selectedService != null
              ? BookingFloatingButton(
                  text: 'Continue',
                  onPressed: () => _navigateToStaffSelection(context),
                )
              : null,
        );
      },
    );
  }

  Widget _buildProviderInfo(BookingProvider bookingProvider) {
    final booking = bookingProvider.booking;
    
    return Container(
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.cardBorderRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Icon(
              Icons.business,
              color: AppColors.background,
              size: AppSizes.iconLg,
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.providerName,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  booking.providerAddress,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesByCategory(BookingProvider bookingProvider) {
    final services = bookingProvider.availableServices;
    final selectedService = bookingProvider.booking.selectedService;
    
    // Group services by category
    final servicesByCategory = <String, List<Service>>{};
    for (final service in services) {
      if (!servicesByCategory.containsKey(service.category)) {
        servicesByCategory[service.category] = [];
      }
      servicesByCategory[service.category]!.add(service);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: servicesByCategory.entries.map((entry) {
        return _buildServiceCategory(
          entry.key,
          entry.value,
          selectedService,
          bookingProvider,
        );
      }).toList(),
    );
  }

  Widget _buildServiceCategory(
    String categoryName,
    List<Service> services,
    Service? selectedService,
    BookingProvider bookingProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: AppTypography.titleLarge,
        ),
        const SizedBox(height: AppSpacing.space16),
        ...services.map((service) {
          final isSelected = selectedService?.id == service.id;
          return ServiceCard(
            name: service.name,
            duration: _formatDuration(service.duration),
            price: service.price,
            isPopular: service.isPopular,
            isSelected: isSelected,
            onTap: () => bookingProvider.selectService(service),
          );
        }),
        const SizedBox(height: AppSpacing.space24),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${hours}h ${minutes}min';
      } else {
        return '${hours}h';
      }
    } else {
      return '${duration.inMinutes}min';
    }
  }

  void _navigateToStaffSelection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StaffSelectionScreen(),
      ),
    );
  }
} 
