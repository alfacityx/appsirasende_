import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../models/service.dart';
import '../models/staff_member.dart';
import '../models/customer_info.dart';

class BookingProvider with ChangeNotifier {
  Booking _booking = const Booking(
    providerId: 'barbarella_inova',
    providerName: 'Barbarella Inova',
    providerAddress: '6993 Meadow Valley Terrace, New York',
  );

  Booking get booking => _booking;

  // Mock data
  final List<Service> _availableServices = [
    const Service(
      id: 'haircut_style',
      name: 'Haircut & Style',
      description: 'Professional haircut with styling',
      duration: Duration(minutes: 45),
      price: 45.0,
      category: 'Hair Services',
      isPopular: false,
    ),
    const Service(
      id: 'hair_coloring',
      name: 'Hair Coloring',
      description: 'Full hair coloring service',
      duration: Duration(minutes: 150),
      price: 120.0,
      category: 'Hair Services',
      isPopular: true,
    ),
    const Service(
      id: 'highlights',
      name: 'Highlights',
      description: 'Hair highlighting service',
      duration: Duration(minutes: 120),
      price: 90.0,
      category: 'Hair Services',
    ),
    const Service(
      id: 'blowout',
      name: 'Blowout',
      description: 'Professional hair styling and blowout',
      duration: Duration(minutes: 30),
      price: 35.0,
      category: 'Hair Services',
    ),
  ];

  final List<StaffMember> _availableStaff = [
    const StaffMember(
      id: 'sarah_johnson',
      firstName: 'Sarah',
      lastName: 'Johnson',
      title: 'Hair Stylist',
      bio: 'Expert stylist with 8 years of experience',
      rating: 4.9,
      reviewCount: 127,
      specialties: ['Haircuts', 'Styling', 'Color'],
      isAvailable: true,
    ),
    const StaffMember(
      id: 'mike_rodriguez',
      firstName: 'Mike',
      lastName: 'Rodriguez',
      title: 'Sr. Barber',
      bio: 'Senior barber specializing in classic cuts',
      rating: 4.8,
      reviewCount: 95,
      specialties: ['Haircuts', 'Beard Trimming'],
      isAvailable: false,
    ),
    const StaffMember(
      id: 'any_available',
      firstName: 'Any Available',
      lastName: 'Specialist',
      title: 'Fastest booking option',
      bio: 'Get matched with the next available specialist',
      rating: 4.7,
      reviewCount: 0,
      specialties: [],
      isAvailable: true,
    ),
  ];

  final List<String> _availableTimeSlots = [
    '9:00 AM',
    '10:30 AM',
    '12:00 PM',
    '2:00 PM',
    '3:30 PM',
    '5:00 PM',
  ];

  // Getters
  List<Service> get availableServices => _availableServices;
  List<StaffMember> get availableStaff => _availableStaff;
  List<String> get availableTimeSlots => _availableTimeSlots;

  // Service selection
  void selectService(Service service) {
    _booking = _booking.copyWith(selectedService: service);
    _calculateTotals();
    notifyListeners();
  }

  // Multiple services selection
  void selectServices(List<Service> services) {
    _booking = _booking.copyWith(selectedServices: services);
    _calculateTotals();
    notifyListeners();
  }

  // Add a service to the list
  void addService(Service service) {
    final currentServices = List<Service>.from(_booking.selectedServices);
    currentServices.add(service);
    _booking = _booking.copyWith(selectedServices: currentServices);
    _calculateTotals();
    notifyListeners();
  }

  // Remove a service from the list
  void removeService(Service service) {
    final currentServices = List<Service>.from(_booking.selectedServices);
    currentServices.removeWhere((s) => s.id == service.id);
    _booking = _booking.copyWith(selectedServices: currentServices);
    _calculateTotals();
    notifyListeners();
  }

  // Staff selection
  void selectStaff(StaffMember staff) {
    _booking = _booking.copyWith(selectedStaff: staff);
    notifyListeners();
  }

  // Date selection
  void selectDate(DateTime date) {
    _booking = _booking.copyWith(selectedDate: date);
    notifyListeners();
  }

  // Time slot selection
  void selectTimeSlot(String timeSlot) {
    _booking = _booking.copyWith(selectedTimeSlot: timeSlot);
    notifyListeners();
  }

  // Customer info
  void updateCustomerInfo(CustomerInfo customerInfo) {
    _booking = _booking.copyWith(customerInfo: customerInfo);
    notifyListeners();
  }

  // Set salon info (for when booking from different salons)
  void setSalonInfo({
    required String providerId,
    required String providerName,
    required String providerAddress,
    String? providerImageUrl,
  }) {
    _booking = _booking.copyWith(
      providerId: providerId,
      providerName: providerName,
      providerAddress: providerAddress,
      providerImageUrl: providerImageUrl,
    );
    notifyListeners();
  }

  // Payment method selection
  void selectPaymentMethod(String paymentMethod) {
    _booking = _booking.copyWith(paymentMethod: paymentMethod);
    notifyListeners();
  }

  // Confirm booking
  Future<bool> confirmBooking() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      _booking = _booking.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        status: BookingStatus.confirmed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Reset booking but preserve salon info
  void resetBooking() {
    final currentProviderInfo = _booking;
    _booking = Booking(
      providerId: currentProviderInfo.providerId,
      providerName: currentProviderInfo.providerName,
      providerAddress: currentProviderInfo.providerAddress,
      providerImageUrl: currentProviderInfo.providerImageUrl,
    );
    notifyListeners();
  }

  // Get available dates (next 30 days excluding Sundays for demo)
  List<DateTime> getAvailableDates() {
    final availableDates = <DateTime>[];
    final now = DateTime.now();
    
    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      // Skip Sundays for demo purposes
      if (date.weekday != DateTime.sunday) {
        availableDates.add(date);
      }
    }
    
    return availableDates;
  }

  // Get next available date and time
  DateTime? getNextAvailableDateTime() {
    final availableDates = getAvailableDates();
    if (availableDates.isNotEmpty && _availableTimeSlots.isNotEmpty) {
      final date = availableDates.first;
      final timeSlot = _availableTimeSlots.first;

      // Parse time slot to create full DateTime
    try {
      final timeStr = timeSlot.trim().replaceAll(' ', '');
      final isPM = timeStr.toLowerCase().contains('pm');
      final cleanTime = timeStr.replaceAll(RegExp(r'[apm]', caseSensitive: false), '');
      final parts = cleanTime.split(':');
      
        if (parts.length == 2) {
          int hour = int.tryParse(parts[0]) ?? 9;
      final minute = int.tryParse(parts[1]) ?? 0;
      
      if (isPM && hour != 12) {
        hour += 12;
      } else if (!isPM && hour == 12) {
        hour = 0;
      }
      
          return DateTime(date.year, date.month, date.day, hour, minute);
        }
      } catch (e) {
        // Fall back to default time if parsing fails
      }
    }
    return null;
  }

  // Calculate totals
  void _calculateTotals() {
    final services = _booking.allSelectedServices;
    double serviceAmount = 0.0;
    
    for (final service in services) {
      serviceAmount += service.price;
    }
    
    final taxAmount = serviceAmount * 0.08; // 8% tax
    final totalAmount = serviceAmount + taxAmount;
    
    _booking = _booking.copyWith(
      serviceAmount: serviceAmount,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
    );
      }
      
  // Validation helpers
  bool get canProceedToStaffSelection {
    final services = _booking.allSelectedServices;
    return services.isNotEmpty;
  }
  
  bool get canProceedToDateTime => _booking.selectedStaff != null;
  
  bool get canConfirmBooking => 
      _booking.selectedDate != null && _booking.selectedTimeSlot != null;
      
  bool get canProceedToSummary => 
      _booking.customerInfo != null && _booking.customerInfo!.isComplete;
      
  bool get canProceedToPayment => _booking.isComplete;

  // Update special instructions
  void updateSpecialInstructions(String instructions) {
    _booking = _booking.copyWith(specialInstructions: instructions);
    notifyListeners();
  }
} 
