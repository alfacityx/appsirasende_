import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../models/service.dart';
import 'staff_selection_screen.dart';

class SelectedServicesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedServices;
  final String salonName;
  final String salonAddress;
  final String? salonImageUrl;
  final bool isGroupAppointment;

  const SelectedServicesScreen({
    super.key,
    required this.selectedServices,
    required this.salonName,
    required this.salonAddress,
    this.salonImageUrl,
    this.isGroupAppointment = false,
  });

  @override
  State<SelectedServicesScreen> createState() => _SelectedServicesScreenState();
}

class _SelectedServicesScreenState extends State<SelectedServicesScreen> {
  late List<Map<String, dynamic>> _services;

  @override
  void initState() {
    super.initState();
    // Initialize services with quantity = 1 for each selected service
    _services = widget.selectedServices.map((service) {
      final serviceWithQuantity = Map<String, dynamic>.from(service);
      serviceWithQuantity['quantity'] = 1;
      return serviceWithQuantity;
    }).toList();
  }

  void _updateQuantity(int index, int change) {
    if (change < 0 && _services[index]['quantity'] == 1) {
      // Show confirmation dialog when trying to decrease from 1
      _confirmDeleteService(index).then((confirmed) {
        if (confirmed) {
          _removeService(index);
        }
      });
    } else {
      setState(() {
        final currentQuantity = _services[index]['quantity'] as int;
        final newQuantity = (currentQuantity + change).clamp(1, 10);
        _services[index]['quantity'] = newQuantity;
      });
    }
  }

  void _removeService(int index) {
    setState(() {
      _services.removeAt(index);
    });
  }

  Future<bool> _confirmDeleteService(int index) async {
    final serviceName = _services[index]['name'] as String;
    
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Service',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "$serviceName" from your appointment?',
            style: AppTypography.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Remove',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _proceedToStaffSelection(BuildContext context) {
    // Update booking provider with all selected services
    if (_services.isNotEmpty) {
      final services = _services.map((serviceData) {
        return Service(
          id: serviceData['id'] ?? 'default_service_${DateTime.now().millisecondsSinceEpoch}',
          name: serviceData['name'] ?? '',
          description: serviceData['description'] ?? '',
          duration: _parseDuration(serviceData['duration'] ?? '30 min'),
          price: _parsePrice(serviceData['price'] ?? '0'),
          category: serviceData['category'] ?? 'Hair Services',
        );
      }).toList();
      
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      
      // Set the salon information in the booking provider
      bookingProvider.setSalonInfo(
        providerId: widget.salonName.toLowerCase().replaceAll(' ', '_'),
        providerName: widget.salonName,
        providerAddress: widget.salonAddress,
        providerImageUrl: widget.salonImageUrl,
      );
      
      // Set the selected services
      bookingProvider.selectServices(services);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StaffSelectionScreen(),
        ),
      );
    }
  }

  double _parsePrice(dynamic priceValue) {
    // Handle different price formats like "from $40", "$25", etc.
    try {
      if (priceValue is double) {
        return priceValue;
      }
      if (priceValue is int) {
        return priceValue.toDouble();
      }
      if (priceValue is String) {
        // Extract numeric value from strings like "from $40", "$25", etc.
        RegExp regex = RegExp(r'\$(\d+(?:\.\d{2})?)');
        Match? match = regex.firstMatch(priceValue);
        if (match != null) {
          return double.parse(match.group(1)!);
        }
        // Try to parse as a plain number string
        return double.tryParse(priceValue) ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Duration _parseDuration(String durationStr) {
    // Parse duration string like "45 min", "1h 30min", etc.
    try {
      final cleanStr = durationStr.toLowerCase().replaceAll(' ', '');
      
      if (cleanStr.contains('h')) {
        if (cleanStr.contains('min')) {
          // Format like "1h30min"
          final parts = cleanStr.split('h');
          final hours = int.tryParse(parts[0]) ?? 0;
          final minPart = parts[1].replaceAll('min', '');
          final minutes = int.tryParse(minPart) ?? 0;
          return Duration(hours: hours, minutes: minutes);
        } else {
          // Format like "1h"
          final hours = int.tryParse(cleanStr.replaceAll('h', '')) ?? 0;
          return Duration(hours: hours);
        }
      } else if (cleanStr.contains('min')) {
        // Format like "45min"
        final minutes = int.tryParse(cleanStr.replaceAll('min', '')) ?? 30;
        return Duration(minutes: minutes);
      } else {
        // Try to parse as just a number (assume minutes)
        final minutes = int.tryParse(cleanStr) ?? 30;
        return Duration(minutes: minutes);
      }
    } catch (e) {
      // Default to 30 minutes if parsing fails
      return const Duration(minutes: 30);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Services',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.only(left: 8),
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  'Select Service',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Salon info card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.salonName,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.isGroupAppointment) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Group',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.salonAddress,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Services list
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Selected Services (${_services.length})',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                if (_services.isEmpty)
                Expanded(
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                            Icons.content_cut,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No services selected',
                              style: AppTypography.titleMedium.copyWith(
                              color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Go back to select services',
                              style: AppTypography.bodyMedium.copyWith(
                              color: Colors.grey[400],
                              ),
                            ),
                          ],
                      ),
                        ),
                      )
                else
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _services.length,
                        itemBuilder: (context, index) {
                          final service = _services[index];
                          final quantity = service['quantity'] as int;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            ),
                          child: widget.isGroupAppointment 
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  // Service name and duration - aligned to left
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service['name'],
                                        style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      Text(
                                        service['duration'],
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Quantity controls on the right (only for group appointments)
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _updateQuantity(index, -1),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: quantity > 1 
                                                ? AppColors.textSecondary 
                                                : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            color: quantity > 1 ? Colors.white : Colors.grey[500],
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          quantity.toString(),
                                          style: AppTypography.titleMedium.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _updateQuantity(index, 1),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service['name'],
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    service['duration'],
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Bottom continue button
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: _services.isNotEmpty ? () => _proceedToStaffSelection(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _services.isNotEmpty ? AppColors.primary : Colors.grey[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                _services.isEmpty 
                    ? 'No services selected'
                    : 'Continue',
                style: AppTypography.titleSmall.copyWith(
                  color: _services.isNotEmpty ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
